/// Model untuk Lampu 1 (on/off)
class Lamp1Model {
  final bool status;

  const Lamp1Model({required this.status});

  factory Lamp1Model.fromMap(Map<dynamic, dynamic> map) {
    return Lamp1Model(status: map['status'] == true);
  }

  Map<String, dynamic> toMap() => {'status': status};

  factory Lamp1Model.defaultValue() => const Lamp1Model(status: false);

  Lamp1Model copyWith({bool? status}) =>
      Lamp1Model(status: status ?? this.status);
}

/// Model untuk Lampu 2 (on/off)
class Lamp2Model {
  final bool status;

  const Lamp2Model({required this.status});

  factory Lamp2Model.fromMap(Map<dynamic, dynamic> map) {
    return Lamp2Model(status: map['status'] == true);
  }

  Map<String, dynamic> toMap() => {'status': status};

  factory Lamp2Model.defaultValue() => const Lamp2Model(status: false);

  Lamp2Model copyWith({bool? status}) =>
      Lamp2Model(status: status ?? this.status);
}
