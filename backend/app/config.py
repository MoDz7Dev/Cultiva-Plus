"""Configuración central del backend de Cultiva+.

Las claves de las APIs se leen desde `backend/.env` (nunca se suben al repo).
"""

from __future__ import annotations

import os
from functools import lru_cache
from pathlib import Path

from dotenv import load_dotenv

# backend/  (una carpeta por encima de app/)
BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")


def _a_lista(valor: str) -> list[str]:
    """Convierte 'a,b,c' en ['a', 'b', 'c']."""
    return [item.strip() for item in valor.split(",") if item.strip()]


def _valor_real(valor: str) -> str:
    """Devuelve '' si el valor está vacío o sigue siendo un marcador de ejemplo."""
    limpio = valor.strip()
    if limpio.upper().startswith("PON_AQUI"):
        return ""
    return limpio


class Settings:
    """Ajustes leídos del entorno. Se cachea con get_settings()."""

    def __init__(self) -> None:
        self.plantnet_api_key: str = _valor_real(os.getenv("PLANTNET_API_KEY", ""))
        self.trefle_token: str = _valor_real(os.getenv("TREFLE_TOKEN", ""))

        self.plantnet_base_url: str = os.getenv(
            "PLANTNET_BASE_URL", "https://my-api.plantnet.org"
        ).rstrip("/")
        self.trefle_base_url: str = os.getenv(
            "TREFLE_BASE_URL", "https://trefle.io"
        ).rstrip("/")

        self.request_timeout: float = float(os.getenv("REQUEST_TIMEOUT", "30"))
        self.max_upload_mb: int = int(os.getenv("MAX_UPLOAD_MB", "50"))

        self.allowed_origins: list[str] = _a_lista(
            os.getenv("ALLOWED_ORIGINS", "*")
        ) or ["*"]

    @property
    def plantnet_configurado(self) -> bool:
        return bool(self.plantnet_api_key)

    @property
    def trefle_configurado(self) -> bool:
        return bool(self.trefle_token)


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    """Devuelve una única instancia de Settings durante toda la ejecución."""
    return Settings()
