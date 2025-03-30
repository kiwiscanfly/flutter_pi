import 'dart:convert';
import 'package:flutter_pi/services/spotify_token_service.dart';
import 'package:flutter_pi/models/spotify_device_model.dart';
import 'package:http/http.dart' show Client;

class SpotifyPlayService {
  final String _baseUrl = 'https://api.spotify.com/v1/me/player';
  final Client client = Client();

  SpotifyPlayService();

  Future<String> _getAccessToken() async {
    final tokenService = SpotifyTokenService();
    return await tokenService.getAccessToken();
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAccessToken();
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<void> _makeRequest(String endpoint, String method, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = await _getHeaders();
    final encodedBody = body != null ? jsonEncode(body) : null;

    print('Making $method request to $url with headers: $headers and body: $encodedBody');
    final response = method == 'PUT'
        ? await client.put(url, headers: headers, body: encodedBody)
        : await client.post(url, headers: headers, body: encodedBody);

    if (response.statusCode == 200) {
      print('$endpoint request succeeded.');
    } else {
      print('Failed $endpoint request: ${response.statusCode} - ${response.body}');
      throw Exception('Error during $endpoint request');
    }
  }

  Future<void> playTrack(String? trackUri) async {
    await _makeRequest('play', 'PUT', body: trackUri == null ? null : {'uris': [trackUri]});
  }

  Future<void> pauseTrack() async {
    await _makeRequest('pause', 'PUT');
  }

  Future<void> resumeTrack() async {
    await _makeRequest('play', 'PUT');
  }

  Future<void> nextTrack() async {
    await _makeRequest('next', 'POST');
  }
  
  Future<void> previousTrack() async {
    await _makeRequest('previous', 'POST');
  }

  Future<List<SpotifyDeviceModel>> getDevices() async {
    final url = Uri.parse('$_baseUrl/devices');
    final headers = await _getHeaders();
    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> devicesJson = jsonDecode(response.body)['devices'];
      return devicesJson.map((device) => SpotifyDeviceModel.fromJson(device)).toList();
    } else {
      print('Failed to fetch devices: ${response.statusCode} - ${response.body}');
      throw Exception('Error fetching devices');
    }
  }

  Future<void> transferPlayback(String deviceId) async {
    final url = Uri.parse(_baseUrl);
    print('Transferring playback to device ID: $deviceId / URL: $url');
    final headers = await _getHeaders();
    final response = await client.put(
      url,
      headers: headers, 
      body: jsonEncode({'device_ids': [deviceId], 'play': true}),
    );
    print(response.body);
    if (response.statusCode == 204) {
      print('Playback transferred successfully.');
    } else {
      print('Failed to transfer playback: ${response.statusCode} - ${response.body}');
      throw Exception('Error transferring playback');
    }
  }
}