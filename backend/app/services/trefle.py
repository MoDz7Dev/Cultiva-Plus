"""Cliente de Trefle: ficha botánica de una especie.

Documentación: https://trefle.io/docs
Endpoints usados:
  GET {base}/api/v1/species/search?q={nombre}   (búsqueda principal)
  GET {base}/api/v1/plants/search?q={nombre}    (respaldo)
"""

from __future__ import annotations

import httpx
from fastapi import HTTPException

from ..config import get_settings


def _etiqueta_luz(valor: float | int | None) -> str | None:
    """Convierte la escala 0-10 de Trefle en un texto entendible."""
    if valor is None:
        return None
    if valor <= 3:
        return "Sombra"
    if valor <= 6:
        return "Luz media"
    if valor <= 8:
        return "Luz alta"
    return "Pleno sol"


def _etiqueta_humedad(valor: float | int | None) -> str | None:
    """Convierte la escala 0-10 de humedad ambiental en un texto."""
    if valor is None:
        return None
    if valor <= 3:
        return "Ambiente seco"
    if valor <= 6:
        return "Humedad media"
    if valor <= 8:
        return "Humedad alta"
    return "Muy húmedo"


async def detalle_planta(nombre_cientifico: str) -> dict | None:
    """Busca la ficha de `nombre_cientifico` en Trefle.

    Devuelve None si Trefle no conoce la especie (no es un error).
    """
    settings = get_settings()

    if not settings.trefle_configurado:
        raise HTTPException(
            status_code=500,
            detail="El backend no tiene configurado el token de Trefle (TREFLE_TOKEN).",
        )

    async with httpx.AsyncClient(timeout=settings.request_timeout) as client:
        # 1) Intentamos la búsqueda de especies (trae más datos).
        registro = await _buscar(
            client, settings, "/api/v1/species/search", nombre_cientifico
        )
        # 2) Si no hay resultados, probamos con la búsqueda de plantas.
        if registro is None:
            registro = await _buscar(
                client, settings, "/api/v1/plants/search", nombre_cientifico
            )

    if registro is None:
        return None

    crecimiento = registro.get("growth") or {}
    resumen = crecimiento.get("description") or registro.get("bibliography")

    return {
        "nombreCientifico": registro.get("scientific_name") or nombre_cientifico,
        "nombreComun": registro.get("common_name"),
        "familia": registro.get("family"),
        "genero": registro.get("genus"),
        "anio": registro.get("year"),
        "imagen": registro.get("image_url"),
        "resumen": resumen,
        "luz": _etiqueta_luz(crecimiento.get("light")),
        "humedad": _etiqueta_humedad(crecimiento.get("atmospheric_humidity")),
        "fuente": "Trefle (CC-BY-4.0)",
    }


async def _buscar(
    client: httpx.AsyncClient, settings, ruta: str, consulta: str
) -> dict | None:
    """Hace una búsqueda en Trefle y devuelve el primer resultado (o None)."""
    url = f"{settings.trefle_base_url}{ruta}"
    params = {"token": settings.trefle_token, "q": consulta, "limit": 1}

    try:
        respuesta = await client.get(url, params=params)
    except httpx.TimeoutException as error:
        raise HTTPException(
            status_code=504, detail="Trefle tardó demasiado en responder."
        ) from error
    except httpx.HTTPError as error:
        raise HTTPException(
            status_code=502, detail=f"No se pudo contactar con Trefle: {error}"
        ) from error

    if respuesta.status_code == 429:
        raise HTTPException(
            status_code=429,
            detail="Se agotó el límite de peticiones de Trefle. Inténtalo más tarde.",
        )
    if respuesta.status_code in (401, 403):
        raise HTTPException(
            status_code=502, detail="El token de Trefle es inválido o fue rechazado."
        )
    if respuesta.status_code != 200:
        raise HTTPException(
            status_code=502,
            detail=f"Trefle respondió con un error ({respuesta.status_code}).",
        )

    datos = (respuesta.json() or {}).get("data") or []
    return datos[0] if datos else None
