import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/repositories/di.dart';
import 'package:weight_tracker/stores/app_store.dart';
import 'package:weight_tracker/stores/days_list_store.dart';
import 'package:weight_tracker/stores/details_store.dart';
import 'package:weight_tracker/ui/home_page.dart';

void main() {
  setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AppStore()),
        ProxyProvider<AppStore, DaysListStore>(
          create: (context) => DaysListStore(context.read<AppStore>()),
          update: (context, value, previous) => DaysListStore(value),
        ),
        ProxyProvider2<AppStore, DaysListStore, DetailsStore>(
          create: (context) => DetailsStore(
            appStore: context.read<AppStore>(),
            daysListStore: context.read<DaysListStore>(),
          ),
          update: (context, appStore, daysListStore, previous) => DetailsStore(
            appStore: appStore,
            daysListStore: daysListStore,
          ),
        ),
      ],
      child: const MaterialApp(
        home: HomePageScreen(),
      ),
    );
  }
}
