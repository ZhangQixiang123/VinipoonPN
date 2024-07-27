from django.test import TestCase
from .models import VpnConfig
from .serializers import VpnConfigSerializer

class VpnConfigSerializerTestCase(TestCase):
    def setUp(self):
        self.config = VpnConfig.objects.create(
            name='Test VPN',
            ip_address='192.168.1.1',
            port=8080
        )
        self.serializer = VpnConfigSerializer(instance=self.config)

    def test_serializer_fields(self):
        data = self.serializer.data
        self.assertEqual(data['name'], 'Test VPN')
        self.assertEqual(data['ip_address'], '192.168.1.1')
        self.assertEqual(data['port'], 8080)
