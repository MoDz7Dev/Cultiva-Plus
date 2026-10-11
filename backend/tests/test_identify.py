"""Pruebas de los endpoints /health y /identify.

No llaman a las APIs reales: se reemplazan los servicios por dobles.
Ejecuta con:  pytest
"""

from __future__ import annotations

from unittest.mock import AsyncMock, patch

from fastapi.testclient import TestClient

from app.main import app

cliente = TestClient(app)


def test_health_responde_ok() -> None:
    respuesta = cliente.get("/health")
    assert respuesta.status_code == 200
    assert respuesta.json()["estado"] == "ok"


def test_identify_devuelve_la_mejor_coincidencia() -> None:
    falso = {
        "mejor": {
            "nombreComun": "Monstera",
            "nombreCientifico": "Monstera deliciosa",
            "familia": "Araceae",
            "genero": "Monstera",
            "score": 0.87,
            "imagenes": [],
            "gbifId": "2869212",
        },
        "candidatos": [
            {
                "nombreComun": "Monstera",
                "nombreCientifico": "Monstera deliciosa",
                "familia": "Araceae",
                "genero": "Monstera",
                "score": 0.87,
                "imagenes": [],
                "gbifId": "2869212",
            }
        ],
        "restantes": 499,
        "version": "2024-01-01",
        "fuente": "Pl@ntNet",
    }

    with patch(
        "app.routers.identify.plantnet.identificar_planta",
        new=AsyncMock(return_value=falso),
    ):
        respuesta = cliente.post(
            "/identify",
            files={"image": ("foto.jpg", b"contenido-falso", "image/jpeg")},
            data={"organ": "leaf"},
        )

    assert respuesta.status_code == 200
    cuerpo = respuesta.json()
    assert cuerpo["mejor"]["nombreCientifico"] == "Monstera deliciosa"
    assert cuerpo["restantes"] == 499


def test_identify_rechaza_imagen_vacia() -> None:
    respuesta = cliente.post(
        "/identify",
        files={"image": ("foto.jpg", b"", "image/jpeg")},
    )
    assert respuesta.status_code == 400


def test_plants_devuelve_404_si_trefle_no_conoce_la_especie() -> None:
    with patch(
        "app.routers.plants.trefle.detalle_planta",
        new=AsyncMock(return_value=None),
    ):
        respuesta = cliente.get("/plants/Especie inexistente")

    assert respuesta.status_code == 404
