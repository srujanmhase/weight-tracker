import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/constants/font_styles.dart';
import 'package:weight_tracker/stores/app_store.dart';

class TimeSettingsSection extends StatelessWidget {
  const TimeSettingsSection({
    super.key,
    this.foregroundColor = Colors.white,
  });

  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final store = context.read<AppStore>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Observer(
            builder: (context) => Text(
              'I\'ll remind you everyday @ ${store.time.value} to record your weight.',
              style: context.paragraph.copyWith(
                color: foregroundColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                store.setNotifications(picked);
              }
            },
            child: Text(
              'Not quite right?',
              style: context.paragraph.copyWith(
                color: foregroundColor,
                decoration: TextDecoration.underline,
                decorationColor: foregroundColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
