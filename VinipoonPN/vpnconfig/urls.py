from django.urls import path
from .views import VpnConfigCreateView, VpnConfigListView, VpnConfigDetailView

urlpatterns = [
    path('api/vpn-config/', VpnConfigCreateView.as_view(), name='vpn-config-create'),
    path('api/vpn-config/names/', VpnConfigListView.as_view(), name='vpn-config-names'),
    path('api/vpn-config/<str:name>/', VpnConfigDetailView.as_view(), name='vpn-config-detail'),
]