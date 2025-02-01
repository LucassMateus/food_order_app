import 'package:flutter/material.dart';
import 'package:food_order_app/ui/core/styles/colors_app.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';

class PromoCodeField extends StatefulWidget {
  const PromoCodeField({this.onApply, this.initialValue, super.key});

  final Function(String)? onApply;
  final String? initialValue;

  @override
  State<PromoCodeField> createState() => _PromoCodeFieldState();
}

class _PromoCodeFieldState extends State<PromoCodeField> {
  final promoCodeEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    promoCodeEC.text = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: promoCodeEC,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.local_offer),
                hintText: 'Enter Promo Code',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => widget.onApply?.call(promoCodeEC.text),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Apply',
              style: context.textStyles.textButtonLabel
                  .copyWith(color: context.colors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
