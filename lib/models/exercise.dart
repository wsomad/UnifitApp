class Exercise {
  String? id;
  String? name;
  String? force;
  String? level;
  double? met;
  String? mechanic;
  String? equipment;
  List<String>? primaryMuscles;
  List<String>? secondaryMuscles;
  List<String>? instructions;
  String? category;
  List<String>? images;

  Exercise({
    this.id,
    this.name,
    this.force,
    this.level,
    this.met,
    this.mechanic,
    this.equipment,
    this.primaryMuscles,
    this.secondaryMuscles,
    this.instructions,
    this.category,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'force': force,
      'level': level,
      'met': met,
      'mechanic': mechanic,
      'equipment': equipment,
      'primaryMuscles': primaryMuscles,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
      'category': category,
      'images': images,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> fromJson) {
    return Exercise(
      id: fromJson['id'],
      name: fromJson['name'],
      force: fromJson['force'] ?? 'No force',
      level: fromJson['level'] ?? 'No level',
      met: (fromJson['met'] is List)
          ? (fromJson['met'] as List).isNotEmpty
              ? (fromJson['met'][0] as num).toDouble()
              : 1.0
          : 1.0,
      mechanic: fromJson['mechanic'] ?? 'No mechanic',
      equipment: fromJson['equipment'] ?? 'Body only',
      primaryMuscles: fromJson['primaryMuscles'] != null
          ? List<String>.from(fromJson['primaryMuscles'])
          : <String>['-'],
      secondaryMuscles: fromJson['secondaryMuscles'] != null
          ? List<String>.from(fromJson['secondaryMuscles'])
          : <String>['-'],
      instructions: fromJson['instructions'] != null
          ? List<String>.from(fromJson['instructions'])
          : <String>['-'],
      category: fromJson['category'] ?? 'No category',
      images: fromJson['images'] != null
          ? List<String>.from(fromJson['images'])
          : <String>['-'],
    );
  }
}
