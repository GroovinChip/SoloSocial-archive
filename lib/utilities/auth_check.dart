import 'package:solo_social/library.dart';

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  SharedPreferences _prefs;
  bool _isFirstLaunch;
  FirebaseUser _user;

  /// Check for first launch; is true by default
  void _checkForFirstLaunch() async {
    _prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = _prefs.getBool('isFirstLaunch') ?? true;
  }

  /// Check for cached user
  void _checkForCachedUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    _checkForFirstLaunch();
    _checkForCachedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userBloc = Provider.of<UserBloc>(context);
    if (_isFirstLaunch && _user == null) {
      return Introduction();
    } else {
      if (!_isFirstLaunch && _user != null) {
        _userBloc.user.add(_user);
        return PostFeed();
      } else {
        return Container();
      }
    }
  }
}
