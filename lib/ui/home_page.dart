import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/constants/colors.dart';
import 'package:weight_tracker/stores/app_store.dart';
import 'package:weight_tracker/ui/components/days_list.dart';
import 'package:weight_tracker/ui/components/details_section.dart';
import 'package:weight_tracker/ui/components/header.dart';
import 'package:weight_tracker/ui/components/time_settings.dart';
import 'package:weight_tracker/ui/set_preferences_page.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    implements AppDelegate {
  AppStore get _store => context.read<AppStore>();

  @override
  void initState() {
    super.initState();
    _store.delegate = this;
  }

  @override
  void dispose() {
    _store.delegate = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomePageHeader(),
            DaysListDisplay(),
            DetailsSection(),
            TimeSettingsSection(foregroundColor: themeGrey),
          ],
        ),
      ),
    );
  }

  @override
  void navigateToPreferences() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SetPreferencesPage(),
      ),
    );
  }
}
