import 'dart:convert';

class JWT {
  static String decodeJwt(String token) {
    final parts = token.split('.');
    if(parts.length != 3) {
      throw Exception('Invalid JWT Token');
    }

    final payload = parts[1];
    final normalized = base64.normalize(payload);
    final decodedBytes = base64.decode(normalized);
    final decodedString = utf8.decode(decodedBytes);

    return decodedString;
  }

  static Map<String, dynamic>? processJwt(String accessToken) {
    try {
      final decodedPayload = decodeJwt(accessToken);
      final payloadMap = json.decode(decodedPayload);

      // print("Decoded Payload: $payloadMap");
      // print("Expiration: ${payloadMap['exp']}");
      // print("Subject: ${payloadMap['sub']}");
      return payloadMap;
    } catch (e) {
      print("Error decoding JWT: $e");
    }
    return null;
  }
}