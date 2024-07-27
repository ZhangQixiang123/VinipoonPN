from rest_framework import generics
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