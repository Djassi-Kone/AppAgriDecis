"""
URLs pour le module IA
"""
from django.urls import path
from . import views

app_name = 'ai'

urlpatterns = [
    # Diagnostic d'images
    path('diagnosis/', views.DiagnosisImageView.as_view(), name='diagnosis-list'),
    path('diagnosis/<int:diagnosis_id>/', views.DiagnosisDetailView.as_view(), name='diagnosis-detail'),
    
    # Chat IA
    path('chat/', views.ChatSessionView.as_view(), name='chat-sessions'),
    path('chat/<int:session_id>/', views.ChatMessageView.as_view(), name='chat-messages'),
    path('chat/history/', views.chat_history, name='chat-history'),
]
