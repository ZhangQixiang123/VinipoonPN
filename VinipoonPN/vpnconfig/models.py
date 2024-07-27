from django.db import models
import uuid

class VpnConfig(models.Model):
    name = models.CharField(max_length=200)
    country_code = models.CharField(max_length=20)
    ip_address = models.GenericIPAddressField()
    port = models.IntegerField()
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    