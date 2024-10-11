import 'package:flutter/material.dart';
import 'package:weight_tracker/constants/colors.dart';
import 'package:weight_tracker/constants/font_styles.dart';
import 'package:weight_tracker/ui/components/time_settings.dart';

class SetPreferencesPage extends StatelessWidget {
  const SetPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeGrey,
      floatingActionButton: IconButton(
        onPressed: Navigator.of(context).pop,
        icon: const Icon(
          Icons.arrow_forward_ios,
          size: 48,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'hello',
              style: context.title.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'I just need a few things',
              style: context.paragraph.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Name *',
                hintStyle: context.paragraph,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Goal (Kgs)',
                hintStyle: context.paragraph,
              ),
            ),
          ),
          const TimeSettingsSection(),
        ],
      ),
    );
  }
}
