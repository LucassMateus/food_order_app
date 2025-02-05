import 'package:flutter/material.dart';
import 'package:food_order_app/domain/models/address_model.dart';

class ShippingOption extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final void Function(AddressModel? value)? onChanged;

  const ShippingOption({
    super.key,
    required this.address,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<AddressModel>(
      title: Text(address.name),
      subtitle: Text(address.fullAddress),
      value: address,
      groupValue: isSelected ? address : null,
      onChanged: onChanged,
    );
  }
}
