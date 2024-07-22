import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

import '../../infrastructure/config/app_config.dart';

typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);

class NetworkApi {
  NetworkApi.instance();

  static String baseUrl = Environment().config.baseUrl;

  // Post data to server
  static Future<http.Response> postData(String postUrl, Map<String, dynamic> body) async {
    var headers = {'Content-Type': 'application/json'};
    var uri = Uri.parse("$baseUrl$postUrl");

    var response = await http.post(uri, body: jsonEncode(body), headers: headers).timeout(const Duration(seconds: 60));
    if (response.statusCode != 200 && response.statusCode != 201) {
      var jsonData = jsonDecode(response.body);

      throw (jsonData['message'] ?? "Error while getting response, try again");
    }

    return response;
  }

  // Get data from API
  static Future<http.Response> getDataApi(String getUrl, {bool isTimeStamp = false, bool isLogin = true, Map<String, String>? head}) async {
    var header = await _getHeader();
    if (head != null && head.isNotEmpty) {
      header.addAll(head);
    }
    var url = Uri.parse("$baseUrl$getUrl");
    var response = await http.get(url, headers: header).timeout(const Duration(seconds: 60));
    if (response.statusCode == 401 || response.statusCode == 403) {
      //TODO: LOGOUT
    }
    return response;
  }

  /// Get header's for all API
  static Future<Map<String, String>> _getHeader({String? contentType}) async {
    Map<String, String> header = {
      'Content-Type': contentType ?? 'application/json',
    };
    return header;
  }

  static Future<http.Response> putFileApi(String putUrl, List<int> fileBytes, String fileType) async {
    Map<String, String> header = await _getHeader(contentType: fileType);
    var response = await http.put(Uri.parse(putUrl), body: fileBytes, headers: header).timeout(const Duration(seconds: 60));
    return response;
  }

  static Future<String?> getFileUrlToUpload(String path) async {
    File file = File(path);
    String fileName = file.path.split("/").last;
    List<int> imgBy = await file.readAsBytes();
    var map = {'file_name': fileName, 'mime_type': getMimeTypeFromFileName(fileName)};
    //
    http.Response imgUrlRes = await postData("upload-document", map);
    if (imgUrlRes.statusCode != 200) {
      return null;
    }
    List<dynamic> putResponse = jsonDecode(imgUrlRes.body)['data'];
    String putUrl = putResponse.first['url'];
    String readUrl = putResponse.first['file_url'];
    http.Response imagePutRes = await putFileApi(putUrl, imgBy, getMimeTypeFromFileName(fileName));

    if (imagePutRes.statusCode != 200) {
      return null;
    }
    return readUrl;
  }

  static String getMimeTypeFromFileName(String fileName) {
    return mime(fileName) ?? "";
  }
}
