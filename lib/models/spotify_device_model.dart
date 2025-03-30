class SpotifyDeviceModel {
  final String id;
  final String name;
  final String type;
  final bool isActive;
  final bool isRestricted;
  final int volumePercent;

  SpotifyDeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.isRestricted,
    required this.volumePercent,
  });

  factory SpotifyDeviceModel.fromJson(Map<String, dynamic> json) {
    return SpotifyDeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      isActive: json['is_active'] as bool,
      isRestricted: json['is_restricted'] as bool,
      volumePercent: json['volume_percent'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_active': isActive,
      'is_restricted': isRestricted,
      'volume_percent': volumePercent,
    };
  }
}