from rest_framework.test import APITestCase


class WeatherApiTests(APITestCase):
    def test_forecast_requires_lat_lon(self):
        res = self.client.get("/api/weather/forecast/")
        self.assertEqual(res.status_code, 400)

