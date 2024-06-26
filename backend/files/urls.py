from django.urls import path
from .views import UploadFileAPIView, DownloadFileAPIView

urlpatterns = [
    path('upload/', UploadFileAPIView.as_view(), name='upload_file'),
    path('download/<int:file_id>/', DownloadFileAPIView.as_view(), name='download_file'),
]