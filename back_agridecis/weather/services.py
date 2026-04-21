from __future__ import annotations

from typing import Any, Dict

import requests


def get_forecast(latitude: float, longitude: float) -> Dict[str, Any]:
    """
    Appel à Open-Meteo pour les prévisions météo complètes.
    lien vers https://open-meteo.com/
    """
    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "hourly": "temperature_2m,relativehumidity_2m,precipitation,cloudcover,windspeed_10m,winddirection_10m,soil_temperature_0cm,soil_moisture_0_to_1cm",
        "daily": "temperature_2m_max,temperature_2m_min,precipitation_sum,windspeed_10m_max,winddirection_10m_dominant,et0_fao_evapotranspiration",
        "current": "temperature_2m,relativehumidity_2m,windspeed_10m,winddirection_10m,weather_code,cloud_cover",
        "timezone": "auto",
        "forecast_days": 7,
        "past_days": 0,
    }
    resp = requests.get(url, params=params, timeout=20)
    resp.raise_for_status()
    
    data = resp.json()
    
    # Ajouter des indicateurs agricoles
    _add_agricultural_indicators(data)
    
    return data

def _add_agricultural_indicators(data: Dict[str, Any]) -> None:
    """Ajoute des indicateurs utiles pour l'agriculture"""
    
    # Calculer l'indice de stress thermique
    if 'hourly' in data and 'temperature_2m' in data['hourly']:
        temps = data['hourly']['temperature_2m']
        humidity = data['hourly'].get('relativehumidity_2m', [50] * len(temps))
        
        stress_indices = []
        for temp, hum in zip(temps, humidity):
            # Indice de stress basé sur température et humidité
            if temp > 35:
                stress = "Élevé"
            elif temp > 30:
                stress = "Modéré"
            elif temp > 25:
                stress = "Faible"
            else:
                stress = "Minimal"
            
            stress_indices.append(stress)
        
        data['hourly']['thermal_stress'] = stress_indices
    
    # Ajouter des recommandations d'irrigation
    if 'daily' in data and 'et0_fao_evapotranspiration' in data['daily']:
        et_values = data['daily']['et0_fao_evapotranspiration']
        irrigation_needs = []
        
        for et in et_values:
            if et > 6.0:
                need = "Élevée"
            elif et > 4.0:
                need = "Modérée"
            elif et > 2.0:
                need = "Faible"
            else:
                need = "Minimale"
            
            irrigation_needs.append(need)
        
        data['daily']['irrigation_need'] = irrigation_needs

def get_weather_alerts(latitude: float, longitude: float) -> Dict[str, Any]:
    """
    Récupère les alertes météo pour une zone géographique
    """
    # Open-Meteo n'a pas d'API d'alertes directe, mais on peut simuler
    # basé sur les conditions actuelles et prévisions
    forecast = get_forecast(latitude, longitude)
    
    alerts = []
    
    # Vérifier les conditions extrêmes
    if 'daily' in forecast and 'temperature_2m_max' in forecast['daily']:
        max_temps = forecast['daily']['temperature_2m_max']
        
        if any(temp > 40 for temp in max_temps):
            alerts.append({
                'type': 'canicule',
                'severity': 'Élevé',
                'message': 'Températures extrêmes prévues - Risque pour les cultures',
                'recommendation': 'Irrigation accrue et ombrage si possible'
            })
        elif any(temp < 10 for temp in max_temps):
            alerts.append({
                'type': 'froid',
                'severity': 'Modéré',
                'message': 'Températures basses prévues',
                'recommendation': 'Protection des cultures sensibles'
            })
    
    if 'daily' in forecast and 'precipitation_sum' in forecast['daily']:
        precipitations = forecast['daily']['precipitation_sum']
        
        if any(p > 50 for p in precipitations):
            alerts.append({
                'type': 'fortes_pluies',
                'severity': 'Élevé',
                'message': 'Fortes précipitations prévues',
                'recommendation': 'Drainage et protection contre lérosion'
            })
    
    return {
        'alerts': alerts,
        'has_alerts': len(alerts) > 0
    }
