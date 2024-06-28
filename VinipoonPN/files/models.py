from django.db import models
from django.db.models.signals import post_delete
from django.dispatch import receiver

class UploadedFile(models.Model):
    file = models.FileField(upload_to='uploads/')
    uploaded_at = models.DateTimeField(auto_now_add=True)

@receiver(post_delete, sender=UploadedFile)
def delete_file(sender, instance, **kwargs):
    if instance.file:
        instance.file.delete(False)
