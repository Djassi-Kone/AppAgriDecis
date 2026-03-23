from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import AdviceViewSet, CommentViewSet, ContentViewSet, QuestionViewSet, ReportViewSet

router = DefaultRouter()
router.register(r"contents", ContentViewSet, basename="content")
router.register(r"questions", QuestionViewSet, basename="question")
router.register(r"comments", CommentViewSet, basename="comment")
router.register(r"reports", ReportViewSet, basename="report")
router.register(r"advices", AdviceViewSet, basename="advice")

urlpatterns = [
    path("", include(router.urls)),
]
