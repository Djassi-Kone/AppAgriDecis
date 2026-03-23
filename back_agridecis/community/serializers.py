from django.contrib.contenttypes.models import ContentType
from rest_framework import serializers

from .models import Advice, Comment, Content, Question, Report


class ContentSerializer(serializers.ModelSerializer):
    created_by = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Content
        fields = [
            "id",
            "created_by",
            "title",
            "description",
            "kind",
            "text",
            "media_file",
            "is_public",
            "culture",
            "created_at",
        ]
        read_only_fields = ["id", "created_by", "created_at"]


class QuestionSerializer(serializers.ModelSerializer):
    author = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Question
        fields = ["id", "author", "title", "body", "image", "created_at"]
        read_only_fields = ["id", "author", "created_at"]


class CommentSerializer(serializers.ModelSerializer):
    author = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Comment
        fields = ["id", "author", "question", "body", "created_at"]
        read_only_fields = ["id", "author", "created_at"]


class ReportSerializer(serializers.ModelSerializer):
    reporter = serializers.StringRelatedField(read_only=True)
    target_content_type = serializers.SlugRelatedField(slug_field="model", queryset=ContentType.objects.all())

    class Meta:
        model = Report
        fields = [
            "id",
            "reporter",
            "reason",
            "created_at",
            "resolved",
            "target_content_type",
            "target_object_id",
        ]
        read_only_fields = ["id", "reporter", "created_at"]


class AdviceSerializer(serializers.ModelSerializer):
    created_by = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Advice
        fields = ["id", "created_by", "title", "body", "culture", "status", "created_at"]
        read_only_fields = ["id", "created_by", "created_at"]
