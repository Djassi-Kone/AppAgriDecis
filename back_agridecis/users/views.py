from rest_framework import status
from rest_framework.parsers import FormParser, MultiPartParser
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import User
from .serializers import AdminSerializer, UserSerializer
from .permissions import IsAdminUserRole


class MeView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response(UserSerializer(request.user).data)


class ProfileView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def get(self, request):
        return Response(UserSerializer(request.user).data)

    def patch(self, request):
        serializer = UserSerializer(request.user, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)


class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        data = request.data.copy()
        role = data.get("role")
        if role not in ["agronome", "agriculteur"]:
            return Response({"detail": "Rôle invalide"}, status=status.HTTP_400_BAD_REQUEST)

        serializer = UserSerializer(data=data)
        serializer.is_valid(raise_exception=True)

        user = User.objects.create_user(
            nom=serializer.validated_data.get("nom", ""),
            prenom=serializer.validated_data.get("prenom", ""),
            telephone=serializer.validated_data.get("telephone", ""),
            email=serializer.validated_data["email"],
            password=serializer.validated_data["password"],
            role=role,
            specialite=serializer.validated_data.get("specialite", "") if role == "agronome" else "",
            localisation=serializer.validated_data.get("localisation", "") if role == "agriculteur" else "",
            typeCulture=serializer.validated_data.get("typeCulture", "") if role == "agriculteur" else "",
            is_active=True,
        )
        return Response(UserSerializer(user).data, status=status.HTTP_201_CREATED)

class AdminProfileView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserRole]

    def get(self, request):
        serializer = AdminSerializer(request.user)
        return Response(serializer.data)

    def put(self, request):
        serializer = AdminSerializer(request.user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Lister tous les utilisateurs
class UserListView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserRole]

    def get(self, request):
        users = User.objects.exclude(role="admin")  # ignore admin
        serializer = AdminSerializer(users, many=True)
        return Response(serializer.data)

# Activer / désactiver utilisateur
class ToggleUserActiveView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserRole]

    def post(self, request, user_id):
        try:
            user = User.objects.get(id=user_id)
            user.is_active = not user.is_active
            user.save()
            return Response({"is_active": user.is_active, "actif": user.is_active})
        except User.DoesNotExist:
            return Response({"detail": "Utilisateur non trouvé"}, status=status.HTTP_404_NOT_FOUND)

# Supprimer utilisateur
class DeleteUserView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUserRole]

    def delete(self, request, user_id):
        try:
            user = User.objects.get(id=user_id)
            user.delete()
            return Response({"detail": "Utilisateur supprimé"})
        except User.DoesNotExist:
            return Response({"detail": "Utilisateur non trouvé"}, status=status.HTTP_404_NOT_FOUND)


class CreateUserView(APIView):
    def post(self, request):
        data = request.data.copy()
        role = data.get("role")

        if role not in ["agronome", "agriculteur"]:
            return Response(
                {"detail": "Rôle invalide"},
                status=status.HTTP_400_BAD_REQUEST
            )

        serializer = UserSerializer(data=data)

        if serializer.is_valid():
            user = User.objects.create_user(
                nom=serializer.validated_data.get("nom", ""),
                prenom=serializer.validated_data.get("prenom", ""),
                telephone=serializer.validated_data.get("telephone", ""),
                email=serializer.validated_data["email"],
                password=serializer.validated_data["password"],
                role=role,
                specialite=serializer.validated_data.get("specialite", "") if role == "agronome" else "",
                localisation=serializer.validated_data.get("localisation", "") if role == "agriculteur" else "",
                typeCulture=serializer.validated_data.get("typeCulture", "") if role == "agriculteur" else "",
                is_active=True,
            )

            return Response(
                UserSerializer(user).data,
                status=status.HTTP_201_CREATED
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)