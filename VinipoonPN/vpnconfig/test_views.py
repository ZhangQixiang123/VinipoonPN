from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from .models import VpnConfig
import uuid

class VpnConfigViewTests(APITestCase):
    def setUp(self):
        self.vpn_config = VpnConfig.objects.create(
            name='TestConfig',
            country_code='us',
            ip_address='192.168.1.1',
            port=8080,
            id=uuid.uuid4()
        )
        self.vpn_config_data = {
            'name': 'NewConfig',
            'country_code': 'sg',
            'ip_address': '10.0.0.1',
            'port': 9090,
            'id': str(uuid.uuid4())
        }

    def test_create_vpn_config(self):
        url = reverse('vpnconfig-create')
        response = self.client.post(url, self.vpn_config_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(VpnConfig.objects.count(), 2)
        self.assertEqual(VpnConfig.objects.get(name='NewConfig').name, 'NewConfig')

    def test_create_vpn_config_missing_fields(self):
        url = reverse('vpnconfig-create')
        data = self.vpn_config_data.copy()
        del data['ip_address']
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('ip_address', response.data)

    def test_create_vpn_config_invalid_country_code(self):
        url = reverse('vpnconfig-create')
        data = self.vpn_config_data.copy()
        data['country_code'] = 'USA'
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('country_code', response.data)

    def test_create_vpn_config_invalid_ip_address(self):
        url = reverse('vpnconfig-create')
        data = self.vpn_config_data.copy()
        data['ip_address'] = '999.999.999.999'
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('ip_address', response.data)

    def test_list_vpn_config(self):
        url = reverse('vpnconfig-list')
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['name'], 'TestConfig')

    def test_detail_vpn_config(self):
        url = reverse('vpnconfig-detail', args=[self.vpn_config.name])
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['name'], 'TestConfig')


