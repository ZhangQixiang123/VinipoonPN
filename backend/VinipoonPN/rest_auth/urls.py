from django.urls import path as url

from rest_auth.views import (
    LoginView, LogoutView, UserDetailsView, PasswordChangeView,
    PasswordResetView, PasswordResetConfirmView
)

urlpatterns = [
    # URLs that do not require a session or valid token
    url('password/reset/', PasswordResetView.as_view(),
        name='rest_password_reset'),
    url('password/reset/confirm/', PasswordResetConfirmView.as_view(),
        name='rest_password_reset_confirm'),
    url('login/', LoginView.as_view(), name='rest_login'),
    # URLs that require a user to be logged in with a valid session / token.
    url('logout/', LogoutView.as_view(), name='rest_logout'),
    url('user/', UserDetailsView.as_view(), name='rest_user_details'),
    url('password/change/', PasswordChangeView.as_view(),
        name='rest_password_change'),
]
