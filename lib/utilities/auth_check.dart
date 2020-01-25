import 'package:solo_social/library.dart';

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  SharedPreferences _prefs;
  bool _isFirstLaunch;

  /// Check for first launch; is true by default
  void _checkForFirstLaunch() async {
    _prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = _prefs.getBool('isFirstLaunch') ?? true;
    print(_isFirstLaunch);
  }

  @override
  void initState() {
    _checkForFirstLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo: firebase auth and auth check
    if (_isFirstLaunch == true) {
      return Introduction();
    } else {
      return PostFeed();
    }
  }
}
