import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/constants/colors.dart';
import 'package:weight_tracker/constants/font_styles.dart';
import 'package:weight_tracker/stores/preferences_store.dart';
import 'package:weight_tracker/ui/components/time_settings.dart';

class SetPreferencesPage extends StatelessWidget {
  const SetPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PreferencesStore(),
      child: const _Scaffold(),
    );
  }
}

class _Scaffold extends StatefulWidget {
  const _Scaffold();

  @override
  State<_Scaffold> createState() => __ScaffoldState();
}

class __ScaffoldState extends State<_Scaffold> {
  PreferencesStore get _store => context.read<PreferencesStore>();

  late final TextEditingController _nameController;
  late final TextEditingController _goalsController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _goalsController = TextEditingController();

    _store.onNameUpdate = (v) {
      setState(() {
        _nameController.text = v ?? '';
      });
    };

    _store.onGoalsUpdate = (v) {
      setState(() {
        _goalsController.text = v ?? '';
      });
    };

    _store.onPop = () => Navigator.of(context).pop();

    _store.init();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => PopScope(
        canPop: _store.canPop.value,
        child: Scaffold(
          backgroundColor: themeGrey,
          floatingActionButton: IconButton(
            onPressed: _store.finalize,
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 48,
              color: _store.isValidState.value ? Colors.white : Colors.grey,
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
                  controller: _nameController,
                  onChanged: (value) => _store.setName(value),
                  style: context.paragraph.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Name *',
                    hintStyle: context.paragraph,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _goalsController,
                  onChanged: (value) => _store.setGoal(value),
                  style: context.paragraph.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Goal (Kgs) *',
                    hintStyle: context.paragraph,
                  ),
                ),
              ),
              const TimeSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
