from django.conf import settings
from django.db import models


class DiagnosisRequest(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="diagnosis_requests"
    )
    image = models.ImageField(upload_to="diagnostics/")
    culture = models.CharField(max_length=120, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    # Réponse du moteur IA (stockée pour historique)
    result_json = models.JSONField(blank=True, null=True)
    status = models.CharField(max_length=30, default="pending")  # pending|done|error
    error_message = models.TextField(blank=True)

    def __str__(self) -> str:
        return f"DiagnosisRequest({self.id})"


class ChatSession(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="chat_sessions")
    created_at = models.DateTimeField(auto_now_add=True)


class ChatMessage(models.Model):
    class Role(models.TextChoices):
        USER = "user", "User"
        ASSISTANT = "assistant", "Assistant"

    session = models.ForeignKey(ChatSession, on_delete=models.CASCADE, related_name="messages")
    role = models.CharField(max_length=20, choices=Role.choices)
    content = models.TextField(blank=True)
    attachment = models.FileField(upload_to="chat_attachments/", blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
