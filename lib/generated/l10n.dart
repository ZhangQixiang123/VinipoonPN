// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get str_home {
    return Intl.message(
      'Home',
      name: 'str_home',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get str_lang {
    return Intl.message(
      'Language',
      name: 'str_lang',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get str_setting {
    return Intl.message(
      'Setting',
      name: 'str_setting',
      desc: '',
      args: [],
    );
  }

  /// `About us`
  String get str_about_us {
    return Intl.message(
      'About us',
      name: 'str_about_us',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get str_about {
    return Intl.message(
      'About',
      name: 'str_about',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get str_profile {
    return Intl.message(
      'Profile',
      name: 'str_profile',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get str_sign_in {
    return Intl.message(
      'Sign In',
      name: 'str_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get str_sign_up {
    return Intl.message(
      'Sign Up',
      name: 'str_sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get str_logout {
    return Intl.message(
      'Logout',
      name: 'str_logout',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get str_no_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'str_no_account',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get str_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'str_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get str_email {
    return Intl.message(
      'Email',
      name: 'str_email',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get str_username {
    return Intl.message(
      'Username',
      name: 'str_username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get str_password {
    return Intl.message(
      'Password',
      name: 'str_password',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get str_password1 {
    return Intl.message(
      'Password',
      name: 'str_password1',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get str_password2 {
    return Intl.message(
      'Confirm Password',
      name: 'str_password2',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get str_connect {
    return Intl.message(
      'Connect',
      name: 'str_connect',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get str_disconnect {
    return Intl.message(
      'Disconnect',
      name: 'str_disconnect',
      desc: '',
      args: [],
    );
  }

  /// `Select a VPN Server`
  String get str_select_server {
    return Intl.message(
      'Select a VPN Server',
      name: 'str_select_server',
      desc: '',
      args: [],
    );
  }

  /// `Server name already exists!`
  String get str_server_exists {
    return Intl.message(
      'Server name already exists!',
      name: 'str_server_exists',
      desc: '',
      args: [],
    );
  }

  /// `Listen on Port`
  String get str_listening_port {
    return Intl.message(
      'Listen on Port',
      name: 'str_listening_port',
      desc: '',
      args: [],
    );
  }

  /// `Add Server`
  String get str_add_server {
    return Intl.message(
      'Add Server',
      name: 'str_add_server',
      desc: '',
      args: [],
    );
  }

  /// `Server Name`
  String get str_server_name {
    return Intl.message(
      'Server Name',
      name: 'str_server_name',
      desc: '',
      args: [],
    );
  }

  /// `Server Configuration (JSON) (v2ray only now)`
  String get str_server_configuration {
    return Intl.message(
      'Server Configuration (JSON) (v2ray only now)',
      name: 'str_server_configuration',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get str_save {
    return Intl.message(
      'Save',
      name: 'str_save',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out all fields`
  String get str_fill_blank {
    return Intl.message(
      'Please fill out all fields',
      name: 'str_fill_blank',
      desc: '',
      args: [],
    );
  }

  /// `Please disconnect first!`
  String get str_please_disconnect {
    return Intl.message(
      'Please disconnect first!',
      name: 'str_please_disconnect',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get str_select_lang {
    return Intl.message(
      'Select Language',
      name: 'str_select_lang',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get str_error {
    return Intl.message(
      'Error',
      name: 'str_error',
      desc: '',
      args: [],
    );
  }

  /// `Logout failed!`
  String get str_logout_fail {
    return Intl.message(
      'Logout failed!',
      name: 'str_logout_fail',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed!`
  String get str_registration_fail {
    return Intl.message(
      'Registration failed!',
      name: 'str_registration_fail',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get str_ok {
    return Intl.message(
      'OK',
      name: 'str_ok',
      desc: '',
      args: [],
    );
  }

  /// `No Username Found`
  String get str_no_username_found {
    return Intl.message(
      'No Username Found',
      name: 'str_no_username_found',
      desc: '',
      args: [],
    );
  }

  /// `VinipooPN is a secure and reliable VPN service designed to protect your online privacy and ensure a fast and stable connection. Our servers are located around the globe, providing you with the best possible speeds and security.`
  String get str_app_about {
    return Intl.message(
      'VinipooPN is a secure and reliable VPN service designed to protect your online privacy and ensure a fast and stable connection. Our servers are located around the globe, providing you with the best possible speeds and security.',
      name: 'str_app_about',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
