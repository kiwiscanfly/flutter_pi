import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart'
    show Client;
import 'package:flutter_pi/models/token_file_model.dart';

class SpotifyTokenService {
  Client client = Client();
  
  TokenFileModel getTokenFileContents() {
    // Directory.current.path is the path of the flutter executable on the Pi
    // This does not work on the mac so we need to create an alternative solution
    final filename = '${Directory.current.path}/express/token.json';
    print('Token file path: $filename');
    final file = File(filename);
    if (!file.existsSync()) {
      throw Exception('Token file not found: $filename');
    }
    final contents = file.readAsStringSync();
    if (contents.isEmpty) {
      throw Exception('Token file is empty: $filename');
    }
    return TokenFileModel.fromJson(jsonDecode(contents));
  }

  Future<String> getAccessToken() {
    final tokenFile = getTokenFileContents();
    final now = DateTime.now();
    if (tokenFile.expiresAt.isBefore(now)) {
      // Token has expired, refresh it
      return refreshAccessToken(tokenFile.refreshToken);
    } else {
      // Token is still valid, return it
      return Future.value(tokenFile.accessToken);
    }
  }

  Future<String> refreshAccessToken(String refreshToken) async {
    final response = await client.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': dotenv.env['SPOTIFY_CLIENT_ID'],
        'client_secret': dotenv.env['SPOTIFY_CLIENT_SECRET'],
      },
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to refresh access token');
    }
  }

  Future<String> getRefreshToken() {
    final tokenFile = getTokenFileContents();
    return Future.value(tokenFile.refreshToken);
  }
}