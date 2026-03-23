from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .views import (
    AdminProfileView,
    CreateUserView,
    DeleteUserView,
    MeView,
    ProfileView,
    RegisterView,
    ToggleUserActiveView,
    UserListView,
)

urlpatterns = [
    # Auth (mobile + admin client)
    path('auth/register/', RegisterView.as_view(), name='auth-register'),
    path('auth/login/', TokenObtainPairView.as_view(), name='auth-login'),
    path('auth/token/refresh/', TokenRefreshView.as_view(), name='auth-token-refresh'),
    path('auth/me/', MeView.as_view(), name='auth-me'),
    path('profile/', ProfileView.as_view(), name='profile'),

    path('admin/profile/', AdminProfileView.as_view(), name='admin-profile'),
    path('admin/users/', UserListView.as_view(), name='admin-users-list'),
    path('admin/users/toggle/<int:user_id>/', ToggleUserActiveView.as_view(), name='toggle-user'),
    path('admin/users/delete/<int:user_id>/', DeleteUserView.as_view(), name='delete-user'),
    # Legacy (à déprécier)
    path('users/create/', CreateUserView.as_view(), name='user-create'),
    

]
