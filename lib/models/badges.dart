class Badges {
  String? badgeID;
  String? badgeName;
  String? badgeType;
  String? badgeImagePath;
  String? category;

  Badges({
    this.badgeID,
    this.badgeName,
    this.badgeType,
    this.badgeImagePath,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return{
      'badgeID': badgeID,
      'badgeName': badgeName,
      'badgeType': badgeType,
      'badgeImagePath': badgeImagePath,
      'category': category
    };
  }

  factory Badges.fromJson(Map<String, dynamic> fromJson) {
    return Badges(
      badgeID: fromJson['badgeID'],
      badgeName: fromJson['badgeName'],
      badgeType: fromJson['badgeType'],
      badgeImagePath: fromJson['badgeImagePath'],
      category: fromJson['category'],
    );
  }
}