"""GET /plants/{nombre} -> ficha botánica de la especie (Trefle)."""

from __future__ import annotations

from fastapi import APIRouter, HTTPException

from ..schemas import DetallePlanta
from ..services import trefle

router = APIRouter(tags=["plantas"])


@router.get("/plants/{nombre}", response_model=DetallePlanta)
async def obtener_planta(nombre: str) -> DetallePlanta:
    """Devuelve la ficha botánica de una especie por su nombre científico."""
    detalle = await trefle.detalle_planta(nombre)
    if detalle is None:
        raise HTTPException(
            status_code=404,
            detail=f"Trefle no tiene información de '{nombre}'.",
        )
    return DetallePlanta(**detalle)
