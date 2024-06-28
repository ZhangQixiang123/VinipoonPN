from django.urls import path
# from .views import UploadFileAPIView, DownloadFileAPIView

# urlpatterns = [
#     path('upload/', UploadFileAPIView.as_view(), name='upload_file'),
#     path('download/<int:file_id>/', DownloadFileAPIView.as_view(), name='download_file'),
# ]

from . import views

urlpatterns = [
    path('upload/', views.upload_file, name='home'),
    path('download/<int:file_id>/', views.download_file, name='download_file'),
    path('delete/<int:file_id>/', views.delete_file, name='delete_file'),
]