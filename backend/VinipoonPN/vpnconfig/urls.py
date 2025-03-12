from django.urls import path
from .views import VpnConfigCreateView, VpnConfigListView, VpnConfigDetailView, VpnConfigDeleteView

urlpatterns = [
    path('api/', VpnConfigCreateView.as_view(), name='vpnconfig-create'),
    path('api/all/', VpnConfigListView.as_view(), name='vpnconfig-list'),
    path('api/<str:name>/', VpnConfigDetailView.as_view(), name='vpnconfig-detail'),
    path('api/delete/<str:name>/', VpnConfigDeleteView.as_view(), name='vpnconfig-delete')
]