import 'package:flutter/material.dart';
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
          Text(
            'I\'ll remind you everyday @ 4PM to record your weight.',
            style: context.paragraph.copyWith(
              color: foregroundColor,
            ),
          ),
          GestureDetector(
            onTap: store.setPreferencesPage,
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
