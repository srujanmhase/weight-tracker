import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManageWeightDialogBox extends StatefulWidget {
  const ManageWeightDialogBox({super.key});

  @override
  State<ManageWeightDialogBox> createState() => _ManageWeightDialogBoxState();
}

class _ManageWeightDialogBoxState extends State<ManageWeightDialogBox> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Weight'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Enter weight',
            hintText: 'e.g. 70.5',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            final double? doubleValue = double.tryParse(value);
            if (doubleValue == null) {
              return 'Enter a valid number';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final double? weight = double.tryParse(_controller.text);
              if (weight != null) {
                Navigator.of(context).pop(weight); // Add with value
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
