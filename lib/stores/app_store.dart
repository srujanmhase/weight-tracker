class AppStore {
  AppDelegate? delegate;

  void setPreferencesPage() => delegate?.navigateToPreferences();
}

abstract class AppDelegate {
  void navigateToPreferences();
}
