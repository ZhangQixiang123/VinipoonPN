from django.db import models
import uuid

class VpnConfig(models.Model):
    name = models.CharField(max_length=200)
    country_code = models.CharField(max_length=2, default='sg')
    ip_address = models.GenericIPAddressField()
    port = models.IntegerField()
    userid = models.CharField(max_length=1000, default='')
    