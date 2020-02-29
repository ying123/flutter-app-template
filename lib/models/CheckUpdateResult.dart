class CheckUpdateResult {
  String appVersion;
  String downloadUrl;
  String updateInfo;

  CheckUpdateResult.fromJson(Map<String, dynamic> json)
      : appVersion = json['appVersion'],
        downloadUrl = json['downloadUrl'],
        updateInfo = json['updateInfo'];
}