from rest_framework import mixins, viewsets
from rest_framework.permissions import AllowAny, IsAuthenticated

from users.permissions import IsAdminUserRole, IsAgriculteur, IsAgronome

from .models import Advice, Comment, Content, Question, Report
from .serializers import AdviceSerializer, CommentSerializer, ContentSerializer, QuestionSerializer, ReportSerializer


class ContentViewSet(viewsets.ModelViewSet):
    serializer_class = ContentSerializer

    def get_queryset(self):
        qs = Content.objects.all().order_by("-created_at")
        user = getattr(self.request, "user", None)
        if user and user.is_authenticated and getattr(user, "role", None) in {"admin", "agronome"}:
            return qs
        return qs.filter(is_public=True)

    def get_permissions(self):
        if self.action in {"list", "retrieve"}:
            return [AllowAny()]
        return [IsAuthenticated(), (IsAdminUserRole() if getattr(self.request.user, "role", None) == "admin" else IsAgronome())]

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class QuestionViewSet(viewsets.ModelViewSet):
    serializer_class = QuestionSerializer
    queryset = Question.objects.all().order_by("-created_at")

    def get_permissions(self):
        if self.action in {"list", "retrieve"}:
            return [AllowAny()]
        if self.action == "create":
            return [IsAuthenticated(), IsAgriculteur()]
        return [IsAuthenticated()]

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)


class CommentViewSet(viewsets.ModelViewSet):
    serializer_class = CommentSerializer
    queryset = Comment.objects.all().order_by("-created_at")
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)


class ReportViewSet(
    mixins.CreateModelMixin,
    mixins.ListModelMixin,
    mixins.UpdateModelMixin,
    viewsets.GenericViewSet,
):
    serializer_class = ReportSerializer
    queryset = Report.objects.select_related("reporter", "target_content_type").all().order_by("-created_at")

    def get_permissions(self):
        if self.action == "create":
            return [IsAuthenticated()]
        return [IsAuthenticated(), IsAdminUserRole()]

    def perform_create(self, serializer):
        serializer.save(reporter=self.request.user)


class AdviceViewSet(viewsets.ModelViewSet):
    serializer_class = AdviceSerializer

    def get_queryset(self):
        qs = Advice.objects.all().order_by("-created_at")
        user = getattr(self.request, "user", None)
        if user and user.is_authenticated and getattr(user, "role", None) in {"admin", "agronome"}:
            return qs
        return qs.filter(status=Advice.Status.VALIDATED)

    def get_permissions(self):
        if self.action in {"list", "retrieve"}:
            return [AllowAny()]
        if getattr(self.request.user, "role", None) == "admin":
            return [IsAuthenticated(), IsAdminUserRole()]
        return [IsAuthenticated(), IsAgronome()]

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)
