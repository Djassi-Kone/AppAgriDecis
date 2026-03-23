from django.urls import path

from .views import ChatHistoryView, ChatView, DiagnosisHistoryView, DiagnosisView

urlpatterns = [
    path("diagnostic/", DiagnosisView.as_view(), name="diagnostic"),
    path("diagnostic/history/", DiagnosisHistoryView.as_view(), name="diagnostic-history"),
    path("ai/chat/", ChatView.as_view(), name="ai-chat"),
    path("ai/chat/history/", ChatHistoryView.as_view(), name="ai-chat-history"),
]

