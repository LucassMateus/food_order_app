class AddressModel {
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double distance;

  const AddressModel({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.distance,
  });

  String get fullAddress => '$address, $city, $state, $zipCode';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.name == name &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.zipCode == zipCode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode ^
        zipCode.hashCode;
  }
}
