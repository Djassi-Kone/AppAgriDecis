from rest_framework import serializers

from .models import User


class AdminSerializer(serializers.ModelSerializer):
    actif = serializers.BooleanField(source="is_active", read_only=True)

    class Meta:
        model = User
        fields = [
            "id",
            "nom",
            "prenom",
            "email",
            "telephone",
            "role",
            "localisation",
            "typeCulture",
            "specialite",
            "profile_photo",
            "actif",
            "is_active",
            "dateCreation",
        ]
        read_only_fields = ["id", "role", "dateCreation", "actif"]


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)
    actif = serializers.BooleanField(source="is_active", read_only=True)

    class Meta:
        model = User
        fields = [
            "id",
            "nom",
            "prenom",
            "email",
            "password",
            "telephone",
            "role",
            "localisation",
            "typeCulture",
            "specialite",
            "profile_photo",
            "actif",
            "is_active",
        ]
        read_only_fields = ["id", "actif", "is_active"]

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user