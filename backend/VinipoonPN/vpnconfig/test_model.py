from django.test import TestCase
from .models import VpnConfig
from .serializers import VpnConfigSerializer
import uuid

class VpnConfigSerializerTest(TestCase):
    def setUp(self):
        self.valid_vpn_config = VpnConfig.objects.create(
            name='TestConfig',
            country_code='us',
            ip_address='192.168.1.1',
            port=8080,
            id=uuid.uuid4()
        )
        self.serializer = VpnConfigSerializer(instance=self.valid_vpn_config)

    def test_contains_expected_fields(self):
        data = self.serializer.data
        self.assertCountEqual(data.keys(), ['name', 'ip_address', 'country_code', 'port', 'id'])

    def test_field_content(self):
        data = self.serializer.data
        self.assertEqual(data['name'], 'TestConfig')
        self.assertEqual(data['country_code'], 'us')
        self.assertEqual(data['ip_address'], '192.168.1.1')
        self.assertEqual(data['port'], 8080)

    def test_missing_field(self):
        data = {'name': 'NewConfig', 'country_code': 'sg', 'port': 9090}
        serializer = VpnConfigSerializer(data=data)
        self.assertFalse(serializer.is_valid())
        self.assertIn('ip_address', serializer.errors)

    def test_invalid_country_code(self):
        data = {'name': 'NewConfig', 'country_code': 'USA', 'ip_address': '10.0.0.1', 'port': 9090}
        serializer = VpnConfigSerializer(data=data)
        self.assertFalse(serializer.is_valid())
        self.assertIn('country_code', serializer.errors)

    def test_invalid_ip_address(self):
        data = {'name': 'NewConfig', 'country_code': 'sg', 'ip_address': '999.999.999.999', 'port': 9090}
        serializer = VpnConfigSerializer(data=data)
        self.assertFalse(serializer.is_valid())
        self.assertIn('ip_address', serializer.errors)

