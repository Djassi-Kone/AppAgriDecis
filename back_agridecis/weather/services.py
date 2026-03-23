from __future__ import annotations

from typing import Any, Dict

import requests


def get_forecast(latitude: float, longitude: float) -> Dict[str, Any]:
    """
    Appel simple à Open‑Meteo pour les prévisions.
    Voir https://open-meteo.com/ pour plus de paramètres si besoin.
    """
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "hourly": "temperature_2m,relativehumidity_2m,precipitation,cloudcover",
        "daily": "temperature_2m_max,temperature_2m_min,precipitation_sum",
        "timezone": "auto",
    }
    resp = requests.get(url, params=params, timeout=20)
    resp.raise_for_status()
    return resp.json()

