from django.urls import path
from .views import VpnConfigCreateView, VpnConfigListView, VpnConfigDetailView

urlpatterns = [
    path('api/', VpnConfigCreateView.as_view(), name='vpn-config-create'),
    path('api/all/', VpnConfigListView.as_view(), name='vpn-config-names'),
    path('api/<str:name>/', VpnConfigDetailView.as_view(), name='vpn-config-detail'),
]