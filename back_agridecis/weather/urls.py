from django.urls import path

from .views import ForecastView, AlertsView, CurrentWeatherView

urlpatterns = [
    path("weather/forecast/", ForecastView.as_view(), name="weather-forecast"),
    path("weather/alerts/", AlertsView.as_view(), name="weather-alerts"),
    path("weather/current/", CurrentWeatherView.as_view(), name="weather-current"),
]

