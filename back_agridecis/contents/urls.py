"""
URLs pour le module de gestion des contenus
"""
from django.urls import path
from . import views

app_name = 'contents'

urlpatterns = [
    # Contenus
    path('', views.ContentListCreateView.as_view(), name='content-list'),
    path('<int:pk>/', views.ContentDetailView.as_view(), name='content-detail'),
    path('my-contents/', views.MyContentView.as_view(), name='my-contents'),
    path('my-contents/analytics/', views.my_content_analytics, name='my-content-analytics'),
    
    # Commentaires
    path('<int:content_id>/comments/', views.CommentListCreateView.as_view(), name='comment-list'),
    path('comments/<int:pk>/', views.CommentDetailView.as_view(), name='comment-detail'),
    
    # Interactions
    path('<int:content_id>/like/', views.toggle_content_like, name='toggle-like'),
    path('<int:content_id>/view/', views.track_content_view, name='track-view'),
    
    # Admin
    path('admin/all/', views.admin_content_list, name='admin-content-list'),
    path('admin/<int:content_id>/delete/', views.admin_delete_content, name='admin-delete-content'),
]
