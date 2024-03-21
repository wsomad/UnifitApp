class Badges {
  String? badgeID;
  String? badgeName;
  String? badgeType;
  String? badgeImagePath;

  Badges({
    this.badgeID,
    this.badgeName,
    this.badgeType,
    this.badgeImagePath
  });

  Map<String, dynamic> toJson() {
    return{
      'badgeID': badgeID,
      'badgeName': badgeName,
      'badgeType': badgeType,
      'badgeImagePath': badgeImagePath
    };
  }

  factory Badges.fromJson(Map<String, dynamic> fromJson) {
    return Badges(
      badgeID: fromJson['badgeID'],
      badgeName: fromJson['badgeName'],
      badgeType: fromJson['badgeType'],
      badgeImagePath: fromJson['badgeImagePath']
    );
  }
}