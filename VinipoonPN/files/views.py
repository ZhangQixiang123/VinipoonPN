from django.http import HttpResponse
from django.shortcuts import get_object_or_404, render, redirect
from .models import UploadedFile
from .forms import UploadFileForm
# from .serializers import UploadedFileSerializer
# from rest_framework.views import APIView
# from rest_framework.response import Response
# from rest_framework import status
# from django.http import FileResponse

def upload_file(request):
    if request.method == 'POST':
        form = UploadFileForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('upload_file')
    else:
        form = UploadFileForm()
    files = UploadedFile.objects.all()
    return render(request, 'upload_file.html', {'form': form, 'files': files})

def download_file(request, file_id):
    uploaded_file = UploadedFile.objects.get(pk=file_id)
    response = HttpResponse(uploaded_file.file, content_type='application/force-download')
    response['Content-Disposition'] = f'attachment; filename="{uploaded_file.file.name}"'
    return response

def delete_file(request, file_id):
    uploaded_file = get_object_or_404(UploadedFile, pk=file_id)
    if request.method == 'POST':
        uploaded_file.delete()
    return redirect('upload_file')

# class UploadFileAPIView(APIView):
#     def get(self, request):
#         files = UploadedFile.objects.all()
#         serializer = UploadedFileSerializer(files, many=True)
#         return Response(serializer.data, status=status.HTTP_200_OK)

#     def post(self, request):
#         serializer = UploadedFileSerializer(data=request.data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response(serializer.data, status=status.HTTP_201_CREATED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# class DownloadFileAPIView(APIView):
#     def get(self, request, file_id):
#         uploaded_file = get_object_or_404(UploadedFile, pk=file_id)
#         response = FileResponse(uploaded_file.file, content_type='application/force-download')
#         response['Content-Disposition'] = f'attachment; filename="{uploaded_file.file.name}"'
#         return response