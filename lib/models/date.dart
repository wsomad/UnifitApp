class Date {

  int? day;
  int? week;
  int? month;
  int? year;

  Date({
    this.day,
    this.week,
    this.month,
    this.year
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'week': week,
      'month': month,
      'year': year,
    };
  }

  factory Date.fromJson(Map<String, dynamic> fromJson) {
    return Date(
      day: fromJson['day'] ?? DateTime.now().day,
      week: fromJson['week'] ?? 1,
      month: fromJson['month'] ?? DateTime.now().month,
      year: fromJson['year'] ?? DateTime.now().year,
    );
  }

}