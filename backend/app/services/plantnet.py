"""Cliente de Pl@ntNet: identificación de plantas por imagen.

Documentación: https://my.plantnet.org/doc/openapi
Endpoint usado: POST {base}/v2/identify/{project}   (project = "all")
"""

from __future__ import annotations

import httpx
from fastapi import HTTPException

from ..config import get_settings

# Órganos que entiende Pl@ntNet. "auto" deja que la API decida.
ORGANOS_VALIDOS = {"leaf", "flower", "fruit", "bark", "habit", "auto"}


async def identificar_planta(
    imagen: bytes,
    nombre_archivo: str = "planta.jpg",
    organo: str = "auto",
) -> dict:
    """Envía una foto a Pl@ntNet y devuelve el resultado ya normalizado.

    Lanza HTTPException con un mensaje legible si algo falla.
    """
    settings = get_settings()

    if not settings.plantnet_configurado:
        raise HTTPException(
            status_code=500,
            detail="El backend no tiene configurada la clave de Pl@ntNet (PLANTNET_API_KEY).",
        )

    organo = (organo or "auto").lower()
    if organo not in ORGANOS_VALIDOS:
        organo = "auto"

    url = f"{settings.plantnet_base_url}/v2/identify/all"
    params = {"api-key": settings.plantnet_api_key}
    # Pl@ntNet espera un valor de "organs" por cada imagen enviada.
    data = {"organs": organo}
    files = {"images": (nombre_archivo or "planta.jpg", imagen, "image/jpeg")}

    try:
        async with httpx.AsyncClient(timeout=settings.request_timeout) as client:
            respuesta = await client.post(url, params=params, data=data, files=files)
    except httpx.TimeoutException as error:
        raise HTTPException(
            status_code=504, detail="Pl@ntNet tardó demasiado en responder."
        ) from error
    except httpx.HTTPError as error:
        raise HTTPException(
            status_code=502, detail=f"No se pudo contactar con Pl@ntNet: {error}"
        ) from error

    if respuesta.status_code == 404:
        # Pl@ntNet responde 404 cuando no encuentra ninguna coincidencia.
        raise HTTPException(
            status_code=404,
            detail="No se pudo identificar la planta en la foto. Prueba con otra imagen.",
        )
    if respuesta.status_code in (401, 403):
        raise HTTPException(
            status_code=502, detail="La clave de Pl@ntNet es inválida o fue rechazada."
        )
    if respuesta.status_code == 429:
        raise HTTPException(
            status_code=429,
            detail="Se agotó la cuota diaria de Pl@ntNet. Inténtalo más tarde.",
        )
    if respuesta.status_code != 200:
        raise HTTPException(
            status_code=502,
            detail=f"Pl@ntNet respondió con un error ({respuesta.status_code}).",
        )

    return _normalizar(respuesta.json())


def _normalizar(payload: dict) -> dict:
    """Traduce la respuesta cruda de Pl@ntNet a nuestro contrato."""
    candidatos: list[dict] = []

    for item in payload.get("results") or []:
        especie = item.get("species") or {}
        genero = (especie.get("genus") or {}).get("scientificNameWithoutAuthor")
        familia = (especie.get("family") or {}).get("scientificNameWithoutAuthor")
        comunes = especie.get("commonNames") or []

        imagenes: list[dict] = []
        for imagen in item.get("images") or []:
            urls = imagen.get("url") or {}
            imagenes.append(
                {
                    "organo": imagen.get("organ"),
                    "url": urls.get("o") or urls.get("m") or urls.get("s"),
                    "autor": imagen.get("author"),
                    "licencia": imagen.get("license"),
                }
            )

        candidatos.append(
            {
                "nombreComun": comunes[0] if comunes else None,
                "nombreCientifico": especie.get("scientificNameWithoutAuthor")
                or especie.get("scientificName")
                or "",
                "familia": familia,
                "genero": genero,
                "score": float(item.get("score") or 0.0),
                "imagenes": imagenes,
                "gbifId": (item.get("gbif") or {}).get("id"),
            }
        )

    return {
        "mejor": candidatos[0] if candidatos else None,
        "candidatos": candidatos,
        "restantes": payload.get("remainingIdentificationRequests"),
        "version": payload.get("version"),
        "fuente": "Pl@ntNet",
    }
