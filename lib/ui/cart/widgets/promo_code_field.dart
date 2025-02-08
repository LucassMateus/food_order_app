import 'package:flutter/material.dart';
import 'package:food_order_app/ui/core/styles/colors_app.dart';
import 'package:food_order_app/ui/core/styles/text_styles.dart';

class PromoCodeField extends StatefulWidget {
  const PromoCodeField({
    this.onApply,
    this.initialValue,
    this.errorMessage,
    this.isRunning = false,
    super.key,
  });

  final Function(String)? onApply;
  final String? initialValue;
  final String? errorMessage;
  final bool isRunning;

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
      // height: 64,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                errorText: widget.errorMessage,
              ),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 84,
            height: 54,
            child: ElevatedButton(
              onPressed: () => widget.onApply?.call(promoCodeEC.text),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: widget.isRunning
                  ? CircularProgressIndicator(color: context.colors.secondary)
                  : Text(
                      'Apply',
                      style: context.textStyles.textButtonLabel.copyWith(
                        color: context.colors.secondary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
