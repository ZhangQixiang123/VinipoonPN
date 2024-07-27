from rest_framework import serializers
from .models import VpnConfig

class VpnConfigSerializer(serializers.ModelSerializer):
    class Meta:
        model = VpnConfig
        fields = ['name', 'ip_address', 'port', 'id']
