"""
Services pour le module IA - Intégration API Oxlo
"""
import base64
import logging
import requests
import json
from django.conf import settings
from django.core.files.base import ContentFile
from io import BytesIO

logger = logging.getLogger(__name__)

class OxloAIService:
    """
    Service pour communiquer avec l'API Oxlo
    """
    
    def __init__(self):
        self.api_key = settings.OXLO_API_KEY
        self.base_url = settings.OXLO_BASE_URL
        self.headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
    
    def detect_plant_disease(self, image_file, confidence_threshold=0.5):
        """
        Détecte les maladies des plantes avec YOLO-v11
        
        Args:
            image_file: Fichier image à analyser
            confidence_threshold: Seuil de confiance (0.0-1.0)
            
        Returns:
            dict: Résultats de détection
        """
        try:
            # Encoder l'image en base64
            image_bytes = image_file.read()
            image_b64 = base64.b64encode(image_bytes).decode()
            
            # Préparer la requête
            payload = {
                "model": "yolo-v11",
                "image": image_b64,
                "confidence": confidence_threshold
            }
            
            # Appel API
            response = requests.post(
                f"{self.base_url}/detect",
                headers=self.headers,
                json=payload,
                timeout=30
            )
            
            response.raise_for_status()
            result = response.json()
            
            logger.info(f"Detection successful: {len(result.get('detections', []))} objects found")
            
            return {
                'success': True,
                'detections': result.get('detections', []),
                'total_detections': len(result.get('detections', []))
            }
            
        except requests.exceptions.RequestException as e:
            logger.error(f"API request failed: {e}")
            return {
                'success': False,
                'error': f"Erreur de communication avec l'API: {str(e)}"
            }
        except Exception as e:
            logger.error(f"Detection failed: {e}")
            return {
                'success': False,
                'error': f"Erreur lors de la détection: {str(e)}"
            }
    
    def transcribe_audio(self, audio_file):
        """
        Transcrit un fichier audio avec Whisper
        
        Args:
            audio_file: Fichier audio à transcrire
            
        Returns:
            dict: Résultat de transcription
        """
        try:
            # Préparer le fichier pour l'upload
            files = {"file": audio_file}
            data = {"model": "whisper-large-v3"}
            
            headers = {"Authorization": f"Bearer {self.api_key}"}
            
            # Appel API
            response = requests.post(
                f"{self.base_url}/audio/transcriptions",
                headers=headers,
                files=files,
                data=data,
                timeout=60
            )
            
            response.raise_for_status()
            result = response.json()
            
            logger.info(f"Audio transcription successful: {len(result.get('text', ''))} characters")
            
            return {
                'success': True,
                'text': result.get('text', ''),
                'language': result.get('language', 'unknown')
            }
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Audio transcription API request failed: {e}")
            return {
                'success': False,
                'error': f"Erreur de communication avec l'API: {str(e)}"
            }
        except Exception as e:
            logger.error(f"Audio transcription failed: {e}")
            return {
                'success': False,
                'error': f"Erreur lors de la transcription: {str(e)}"
            }
    
    def chat_completion(self, messages, max_tokens=512, model="llama-3.2-3b"):
        """
        Génère une réponse de chat avec Llama-3.2-3b
        
        Args:
            messages: Liste de messages [{"role": "user", "content": "..."}]
            max_tokens: Nombre maximum de tokens
            model: Modèle à utiliser
            
        Returns:
            dict: Réponse du chat
        """
        try:
            payload = {
                "model": model,
                "messages": messages,
                "max_tokens": max_tokens
            }
            
            # Appel API
            response = requests.post(
                f"{self.base_url}/chat/completions",
                headers=self.headers,
                json=payload,
                timeout=30
            )
            
            response.raise_for_status()
            result = response.json()
            
            # Extraire la réponse
            content = result.get('choices', [{}])[0].get('message', {}).get('content', '')
            
            logger.info(f"Chat completion successful: {len(content)} characters generated")
            
            return {
                'success': True,
                'content': content,
                'model': model,
                'usage': result.get('usage', {})
            }
            
        except requests.exceptions.RequestException as e:
            logger.error(f"Chat completion API request failed: {e}")
            return {
                'success': False,
                'error': f"Erreur de communication avec l'API: {str(e)}"
            }
        except Exception as e:
            logger.error(f"Chat completion failed: {e}")
            return {
                'success': False,
                'error': f"Erreur lors de la génération de réponse: {str(e)}"
            }
    
    def get_agricultural_advice(self, user_question, context=None):
        """
        Génère des conseils agricoles personnalisés
        
        Args:
            user_question: Question de l'utilisateur
            context: Contexte additionnel (type de culture, localisation, etc.)
            
        Returns:
            dict: Conseil agricole généré
        """
        # Prompt système pour les conseils agricoles
        system_prompt = """Tu es un expert agricole spécialisé dans l'agriculture africaine. 
        Ton rôle est de fournir des conseils pratiques et adaptés au contexte local.
        Sois précis, utile et donne des recommandations actionnables.
        Considère les défis climatiques et les réalités agricoles de la région."""
        
        # Ajouter le contexte si disponible
        if context:
            context_info = f"\nContexte: {context}"
            user_question = f"{user_question}{context_info}"
        
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_question}
        ]
        
        return self.chat_completion(messages, max_tokens=800)

# Instance globale du service
oxlo_service = OxloAIService()
