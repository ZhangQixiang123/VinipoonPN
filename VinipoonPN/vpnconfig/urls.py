from django.urls import path
from .views import VpnConfigCreateView, VpnConfigListView, VpnConfigDetailView

urlpatterns = [
    path('api/', VpnConfigCreateView.as_view(), name='vpnconfig-create'),
    path('api/all/', VpnConfigListView.as_view(), name='vpnconfig-list'),
    path('api/<str:name>/', VpnConfigDetailView.as_view(), name='vpnconfig-detail'),
]