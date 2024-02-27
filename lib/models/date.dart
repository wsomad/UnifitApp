class Date {

  int? day;
  int? month;
  int? year;

  Date({
    this.day,
    this.month,
    this.year
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory Date.fromJson(Map<String, dynamic> fromJson) {
    return Date(
      day: fromJson['day'] ?? 1,
      month: fromJson['month'] ?? 1,
      year: fromJson['year'] ?? 2000,
    );
  }

}