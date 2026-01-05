import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_mobile/globals/globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

class ApiService {
  // final String baseUrl = "http://10.0.2.2:9071/api";
  // final String baseUrl = "http://192.168.0.6:9071/api";
  // final String baseUrl = "https://api-fmworker-ind.u-clo.com/AlphabitEcommerce.0.1/api";

  Future<String?> getAccessToken() async {
    final tokens = await storage.read(key: "jwt");
    return tokens;
  }

  String getApiLink()  {
    final apiLink = Globals.API_BASE_URL;
    return apiLink;
  }

  Future<Map<String, String>> getHeaders() async {
    final accessToken = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Origin': Globals.ORIGIN,
      if(accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final baseUrl = await getApiLink();
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final headers = await getHeaders();
      final response = await http.get(uri, headers: headers);
      return _processResponse(response);
    }
    catch (e, stackTrace) {
      throw Error.throwWithStackTrace(Exception('Error fetching data: $e'), stackTrace);
    }
  }

  Future<dynamic> post(String endpoint, String body) async {
    final baseUrl = await getApiLink();
    final uri = Uri.parse('$baseUrl$endpoint');
    print(uri);
    try {
      final headers = await getHeaders();
      final response = await http.post(
          uri, headers: headers, body: body);
      print(response.body);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error posting data: $e');
    }
  }

  Future<dynamic> multipartPost(String endpoint, Map<String, dynamic> fields, Map<String, File>? files) async {
    final baseUrl = await getApiLink();
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      var request = http.MultipartRequest('POST', uri);
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (files != null) {
        for (final entry in files.entries) {
          final fieldName = entry.key;
          final file = entry.value;
          request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));
        }
      }

      request.headers.addAll(await getHeaders());

      //want to add images as files

      var response = await request.send();
      return response;

    } catch(e) {
      throw Exception('Error posting data: $e');
    }
  }

  Future<dynamic> put(String endpoint, String body) async {
    final baseUrl = await getApiLink();
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final headers = await getHeaders();
      final response = await http.put(
          uri, headers: headers, body: body);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error updating data: $e');
    }
  }

  Future<dynamic> multipartPut(String endpoint, Map<String, dynamic> body, List<dynamic> files) async {
    final baseUrl = await getApiLink();
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      var request = http.MultipartRequest('PUT', uri);
      body.forEach((key, value) {
        request.fields[key] = value;
      });
      request.headers.addAll(await getHeaders());


      //want to add images as files

      var response = await request.send();
      return response;

    } catch(e) {
      throw Exception('Error updating data: $e');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final baseUrl = await getApiLink();
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final headers = await getHeaders();
      final response = await http.delete(uri, headers: headers);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized request');
      case 500:
      default:
        throw Exception('Server error: ${response.body}');
    }
  }

}