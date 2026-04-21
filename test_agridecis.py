#!/usr/bin/env python3
"""
Script de test complet pour l'application AgriDecis
Teste tous les endpoints et fonctionnalités principales
"""

import requests
import json
import time
from datetime import datetime

# Configuration
BASE_URL = "http://127.0.0.1:8000"
TEST_COORDS = {"lat": "14.7", "lon": "-17.5"}  # Dakar

# Comptes de test
USERS = {
    "admin": {"email": "admin@agridecis.com", "password": "Admin123!"},
    "agronome": {"email": "agronome@agridecis.com", "password": "Agronome123!"},
    "agriculteur": {"email": "agriculteur@agridecis.com", "password": "Agriculteur123!"}
}

class AgriDecisTester:
    def __init__(self):
        self.session = requests.Session()
        self.tokens = {}
        self.results = []
    
    def log(self, test_name, success, message=""):
        """Log un résultat de test"""
        status = "SUCCESS" if success else "FAILED"
        print(f"[{status}] {test_name}: {message}")
        self.results.append({
            "test": test_name,
            "success": success,
            "message": message,
            "timestamp": datetime.now().isoformat()
        })
    
    def test_health_check(self):
        """Test le health check du backend"""
        try:
            response = self.session.get(f"{BASE_URL}/api/health/")
            success = response.status_code == 200
            self.log("Health Check", success, f"Status: {response.status_code}")
            return success
        except Exception as e:
            self.log("Health Check", False, str(e))
            return False
    
    def test_api_info(self):
        """Test l'info API"""
        try:
            response = self.session.get(f"{BASE_URL}/api/")
            success = response.status_code == 200
            if success:
                data = response.json()
                self.log("API Info", True, f"API: {data.get('name')}")
            else:
                self.log("API Info", False, f"Status: {response.status_code}")
            return success
        except Exception as e:
            self.log("API Info", False, str(e))
            return False
    
    def login_user(self, user_type):
        """Connecte un utilisateur et stocke le token"""
        if user_type not in USERS:
            self.log(f"Login {user_type}", False, "Type d'utilisateur inconnu")
            return False
        
        try:
            user_data = USERS[user_type]
            response = self.session.post(
                f"{BASE_URL}/api/users/auth/login/",
                json=user_data,
                headers={"Content-Type": "application/json"}
            )
            
            if response.status_code == 200:
                data = response.json()
                # JWT tokens retournés directement par SimpleJWT
                if "access" in data and "refresh" in data:
                    token = data.get("access")
                    refresh_token = data.get("refresh")
                    
                    self.tokens[user_type] = {
                        "access": token,
                        "refresh": refresh_token
                    }
                    
                    # Mettre à jour les headers de la session
                    self.session.headers.update({
                        "Authorization": f"Bearer {token}"
                    })
                    
                    self.log(f"Login {user_type}", True, f"Connecté: {user_data['email']}")
                    return True
                else:
                    self.log(f"Login {user_type}", False, "Tokens non trouvés dans la réponse")
                    return False
            else:
                self.log(f"Login {user_type}", False, f"Status: {response.status_code}")
                return False
                
        except Exception as e:
            self.log(f"Login {user_type}", False, str(e))
            return False
    
    def test_weather_api(self):
        """Test l'API météo"""
        try:
            response = self.session.get(
                f"{BASE_URL}/api/weather/weather/forecast/",
                params=TEST_COORDS
            )
            
            success = response.status_code == 200
            if success:
                data = response.json()
                if data.get("success"):
                    forecast_data = data["data"]
                    self.log("Weather Forecast", True, 
                           f"Lat: {forecast_data.get('latitude')}, "
                           f"Lon: {forecast_data.get('longitude')}")
                else:
                    self.log("Weather Forecast", False, "Réponse API invalide")
            else:
                self.log("Weather Forecast", False, f"Status: {response.status_code}")
            
            return success
            
        except Exception as e:
            self.log("Weather Forecast", False, str(e))
            return False
    
    def test_weather_alerts(self):
        """Test les alertes météo"""
        try:
            response = self.session.get(
                f"{BASE_URL}/api/weather/weather/alerts/",
                params=TEST_COORDS
            )
            
            success = response.status_code == 200
            if success:
                data = response.json()
                if data.get("success"):
                    alerts = data["data"].get("alerts", [])
                    self.log("Weather Alerts", True, f"Alertes: {len(alerts)}")
                else:
                    self.log("Weather Alerts", False, "Réponse API invalide")
            else:
                self.log("Weather Alerts", False, f"Status: {response.status_code}")
            
            return success
            
        except Exception as e:
            self.log("Weather Alerts", False, str(e))
            return False
    
    def test_contents_api(self):
        """Test l'API des contenus"""
        try:
            # Test liste des contenus
            response = self.session.get(f"{BASE_URL}/api/contents/")
            
            success = response.status_code == 200
            if success:
                data = response.json()
                if data.get("success"):
                    contents = data["data"]
                    self.log("Contents List", True, f"Contenus: {len(contents) if isinstance(contents, list) else 'N/A'}")
                    
                    # Détails du premier contenu si disponible
                    if isinstance(contents, list) and len(contents) > 0:
                        first_content = contents[0]
                        content_id = first_content.get("id")
                        if content_id:
                            self.test_content_detail(content_id)
                else:
                    self.log("Contents List", False, "Réponse API invalide")
            else:
                self.log("Contents List", False, f"Status: {response.status_code}")
            
            return success
            
        except Exception as e:
            self.log("Contents List", False, str(e))
            return False
    
    def test_content_detail(self, content_id):
        """Test les détails d'un contenu"""
        try:
            response = self.session.get(f"{BASE_URL}/api/contents/{content_id}/")
            
            success = response.status_code == 200
            if success:
                data = response.json()
                if data.get("success"):
                    content = data["data"]
                    self.log("Content Detail", True, 
                           f"Titre: {content.get('title', 'N/A')}")
                else:
                    self.log("Content Detail", False, "Réponse API invalide")
            else:
                self.log("Content Detail", False, f"Status: {response.status_code}")
            
            return success
            
        except Exception as e:
            self.log("Content Detail", False, str(e))
            return False
    
    def test_user_profile(self):
        """Test le profil utilisateur"""
        try:
            response = self.session.get(f"{BASE_URL}/api/users/auth/me/")
            
            success = response.status_code == 200
            if success:
                data = response.json()
                # Profile data retourné directement
                if "email" in data:
                    user = data
                    self.log("User Profile", True, 
                           f"Utilisateur: {user.get('email')}, "
                           f"Rôle: {user.get('role')}")
                else:
                    self.log("User Profile", False, "Format de profil invalide")
            else:
                self.log("User Profile", False, f"Status: {response.status_code}")
            
            return success
            
        except Exception as e:
            self.log("User Profile", False, str(e))
            return False
    
    def run_all_tests(self):
        """Exécute tous les tests"""
        print("=== DÉBUT DES TESTS AGRIDECIS ===\n")
        
        # Tests sans authentification
        self.test_health_check()
        self.test_api_info()
        self.test_weather_api()
        self.test_weather_alerts()
        
        print("\n--- Tests avec authentification ---")
        
        # Tests avec chaque type d'utilisateur
        for user_type in ["admin", "agronome", "agriculteur"]:
            print(f"\n### Tests avec {user_type.upper()} ###")
            
            # Login
            if self.login_user(user_type):
                # Tests authentifiés
                self.test_user_profile()
                self.test_contents_api()
                
                # Reset headers pour le prochain utilisateur
                self.session.headers.pop("Authorization", None)
        
        # Résumé
        self.print_summary()
    
    def print_summary(self):
        """Affiche le résumé des tests"""
        print("\n=== RÉSUMÉ DES TESTS ===")
        
        total_tests = len(self.results)
        successful_tests = sum(1 for r in self.results if r["success"])
        failed_tests = total_tests - successful_tests
        
        print(f"Total: {total_tests}")
        print(f"Success: {successful_tests}")
        print(f"Failed: {failed_tests}")
        print(f"Success Rate: {(successful_tests/total_tests)*100:.1f}%")
        
        if failed_tests > 0:
            print("\n--- Tests échoués ---")
            for result in self.results:
                if not result["success"]:
                    print(f"- {result['test']}: {result['message']}")
        
        # Sauvegarder les résultats
        with open("test_results.json", "w", encoding="utf-8") as f:
            json.dump({
                "summary": {
                    "total": total_tests,
                    "successful": successful_tests,
                    "failed": failed_tests,
                    "success_rate": (successful_tests/total_tests)*100
                },
                "results": self.results
            }, f, indent=2, ensure_ascii=False)
        
        print(f"\nRésultats détaillés sauvegardés dans: test_results.json")

if __name__ == "__main__":
    tester = AgriDecisTester()
    tester.run_all_tests()
