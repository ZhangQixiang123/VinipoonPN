from requests import Response
from rest_framework import generics, status
from .models import VpnConfig
from .serializers import VpnConfigSerializer

class VpnConfigCreateView(generics.CreateAPIView):
    queryset = VpnConfig.objects.all()
    serializer_class = VpnConfigSerializer

class VpnConfigListView(generics.ListAPIView):
    queryset = VpnConfig.objects.all()
    serializer_class = VpnConfigSerializer
    # def get_queryset(self):
    #     # Override the queryset to only include the 'name' field
    #     print(VpnConfig.objects.values('name'))
    #     return VpnConfig.objects.values('name')

class VpnConfigDetailView(generics.RetrieveAPIView):
    queryset = VpnConfig.objects.all()
    serializer_class = VpnConfigSerializer
    lookup_field = 'name'
    def get_object(self):
        name = self.kwargs.get('name')
        return VpnConfig.objects.get(name=name)
    
class VpnConfigDeleteView(generics.DestroyAPIView):
    queryset = VpnConfig.objects.all()
    serializer_class = VpnConfigSerializer
    lookup_field = 'name'
    
    def delete(self, request, *args, **kwargs):
        name = self.kwargs.get('name')
        try:
            instance = VpnConfig.objects.get(name=name)
            self.perform_destroy(instance)
            return Response(status=status.HTTP_204_NO_CONTENT)
        except VpnConfig.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)