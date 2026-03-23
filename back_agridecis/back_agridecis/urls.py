"""
URL configuration for back_agridecis project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.http import HttpResponse
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
from django.http import HttpResponse
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

# Page d'accueil
def home(request):
    return HttpResponse("API Agridecis fonctionne correctement !")


urlpatterns = [
    path('', home),

    path('admin/', admin.site.urls),

    # JWT AUTH endpoints
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # Routes app users
    path('api/', include('users.urls')),
    path('api/', include('community.urls')),
    path('api/', include('ai.urls')),
    path('api/', include('reports.urls')),
    path('api/', include('weather.urls')),
]

# fichiers media
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)