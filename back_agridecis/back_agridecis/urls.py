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
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods

@require_http_methods(["GET"])
def health_check(request):
    """Health check endpoint for monitoring"""
    return JsonResponse({
        'status': 'healthy',
        'version': '1.0.0',
        'service': 'back_agridecis'
    })

@require_http_methods(["GET"])
def api_info(request):
    """API information endpoint"""
    return JsonResponse({
        'name': 'AgriDecis API',
        'version': '1.0.0',
        'description': 'API pour l\'application agricole d\'aide à la décision',
        'endpoints': {
            'auth': '/api/auth/',
            'users': '/api/users/',
            'weather': '/api/weather/',
            'reports': '/api/reports/',
            'ai': '/api/ai/',
        }
    })

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/health/', health_check, name='health-check'),
    path('api/', api_info, name='api-info'),
    
    # App URLs
    path('api/users/', include('users.urls')),
    path('api/weather/', include('weather.urls')),
    path('api/reports/', include('reports.urls')),
    path('api/ai/', include('ai.urls')),
    path('api/contents/', include('contents.urls')),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

# Custom admin site configuration
admin.site.site_header = 'Administration AgriDecis'
admin.site.site_title = 'AgriDecis Admin'
admin.site.index_title = 'Bienvenue dans l\'administration AgriDecis'
