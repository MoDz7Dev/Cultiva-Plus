"""Modelos de datos que expone la API de Cultiva+."""

from __future__ import annotations

from pydantic import BaseModel, Field


class ImagenReferencia(BaseModel):
    """Imagen de referencia de la especie devuelta por Pl@ntNet."""

    organo: str | None = None
    url: str | None = None
    autor: str | None = None
    licencia: str | None = None


class CandidatoPlanta(BaseModel):
    """Una posible especie identificada."""

    nombreComun: str | None = None
    nombreCientifico: str
    familia: str | None = None
    genero: str | None = None
    score: float = 0.0
    imagenes: list[ImagenReferencia] = Field(default_factory=list)
    gbifId: str | None = None


class IdentificacionRespuesta(BaseModel):
    """Respuesta de POST /identify."""

    mejor: CandidatoPlanta | None = None
    candidatos: list[CandidatoPlanta] = Field(default_factory=list)
    restantes: int | None = None
    version: str | None = None
    fuente: str = "Pl@ntNet"


class DetallePlanta(BaseModel):
    """Ficha botánica de GET /plants/{nombre}."""

    nombreCientifico: str
    nombreComun: str | None = None
    familia: str | None = None
    genero: str | None = None
    anio: int | None = None
    imagen: str | None = None
    resumen: str | None = None
    luz: str | None = None
    humedad: str | None = None
    fuente: str = "Trefle (CC-BY-4.0)"
