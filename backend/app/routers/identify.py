"""POST /identify -> identifica la planta de una foto con Pl@ntNet."""

from __future__ import annotations

from fastapi import APIRouter, File, Form, HTTPException, UploadFile

from ..config import get_settings
from ..schemas import IdentificacionRespuesta
from ..services import plantnet

router = APIRouter(tags=["identificación"])


@router.post("/identify", response_model=IdentificacionRespuesta)
async def identificar(
    image: UploadFile = File(..., description="Foto de la planta a identificar"),
    organ: str = Form(
        "auto", description="Parte de la planta: auto | leaf | flower | fruit | bark | habit"
    ),
) -> IdentificacionRespuesta:
    """Recibe una imagen y devuelve las especies más probables."""
    settings = get_settings()

    contenido = await image.read()
    if not contenido:
        raise HTTPException(status_code=400, detail="La imagen está vacía.")

    limite = settings.max_upload_mb * 1024 * 1024
    if len(contenido) > limite:
        raise HTTPException(
            status_code=413,
            detail=f"La imagen supera el máximo de {settings.max_upload_mb} MB.",
        )

    resultado = await plantnet.identificar_planta(
        imagen=contenido,
        nombre_archivo=image.filename or "planta.jpg",
        organo=organ,
    )
    return IdentificacionRespuesta(**resultado)
