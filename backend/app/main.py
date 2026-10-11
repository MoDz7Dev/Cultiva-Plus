"""Punto de entrada del backend de Cultiva+.

Arranca con:
    uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
"""

from __future__ import annotations

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import get_settings
from .routers import identify, plants

settings = get_settings()

app = FastAPI(
    title="Cultiva+ API",
    description=(
        "Identificación de plantas con Pl@ntNet y ficha botánica con Trefle. "
        "Las claves de las APIs viven solo en este backend."
    ),
    version="1.0.0",
)

# Permite que la app Flutter (web/escritorio) consuma la API en desarrollo.
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(identify.router)
app.include_router(plants.router)


@app.get("/health", tags=["salud"])
async def health() -> dict:
    """Comprueba que el servicio está vivo y si las claves están puestas."""
    return {
        "estado": "ok",
        "plantnetConfigurado": settings.plantnet_configurado,
        "trefleConfigurado": settings.trefle_configurado,
    }
