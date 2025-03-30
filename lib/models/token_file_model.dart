class TokenFileModel {
  String accessToken;
  String refreshToken;
  DateTime expiresAt;
  String tokenType;
  String scope;

  TokenFileModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.tokenType,
    required this.scope,
  });
  factory TokenFileModel.fromJson(Map<String, dynamic> json) {
    return TokenFileModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(json['expires_at'] * 1000),
      tokenType: json['token_type'],
      scope: json['scope'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}