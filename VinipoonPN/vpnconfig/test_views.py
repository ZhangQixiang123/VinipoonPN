from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from .models import VpnConfig

class VpnConfigAPITestCase(APITestCase):
    def setUp(self):
        self.config = VpnConfig.objects.create(
            name='Test VPN',
            ip_address='192.168.1.1',
            port=8080
        )
        self.list_url = reverse('vpn-config-names')
        self.create_url = reverse('vpn-config-create')
        self.detail_url = reverse('vpn-config-detail', kwargs={'name': self.config.name})

    def test_list_vpn_configs(self):
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Check that the response data is a list of names
        self.assertIn('Test VPN', [item['name'] for item in response.data])

    def test_create_vpn_config(self):
        data = {
            'name': 'New VPN',
            'ip_address': '192.168.1.2',
            'port': 9090
        }
        response = self.client.post(self.create_url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # Check that the new config is created
        self.assertEqual(VpnConfig.objects.count(), 2)
        self.assertEqual(VpnConfig.objects.get(name='New VPN').ip_address, '192.168.1.2')

    def test_get_vpn_config_detail(self):
        response = self.client.get(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Check that the response data matches the config
        self.assertEqual(response.data['name'], 'Test VPN')
        self.assertEqual(response.data['ip_address'], '192.168.1.1')
        self.assertEqual(response.data['port'], 8080)
