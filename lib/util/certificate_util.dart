import 'dart:convert';
import 'dart:developer';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/foundation.dart';

mixin CertificateMixin {
  static List<Map<String, String>> getCertificateProperties() {
    final certificateProperties = [
      {'label': 'Common Name (CN)', 'code': '2.5.4.3'},
      {'label': 'Serial Number', 'code': '2.5.4.5'},
      {'label': 'Country Name (C)', 'code': '2.5.4.6'},
      {'label': 'Locality (L)', 'code': '2.5.4.7'},
    ];
    return certificateProperties;
  }

  static bool validCertificate(X509CertificateData x509Certificate) {
    try {
      return x509Certificate.tbsCertificate!.validity.notAfter
              .isAfter(DateTime.now()) &&
          x509Certificate.tbsCertificate!.validity.notBefore
              .isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  static bool validCertificatFromFile(Uint8List cert) {
    try {
      final x509Certificate =
          X509Utils.x509CertificateFromPem(utf8.decode(cert));
      return x509Certificate.tbsCertificate!.validity.notAfter
          .isAfter(DateTime.now());
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static bool validPrivateKeyFromFile(Uint8List privateKey) {
    try {
      CryptoUtils.rsaPrivateKeyFromPem(utf8.decode(privateKey));
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
