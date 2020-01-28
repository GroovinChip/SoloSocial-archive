import 'package:sentry/sentry.dart';
import 'package:solo_social/library.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Firebase related initializations
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _users = Firestore.instance.collection('Users');

  /// Sign in with Google Auth
  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    UserUpdateInfo _userUpdateInfo = UserUpdateInfo();
    _userUpdateInfo.photoUrl = googleUser.photoUrl;
    _userUpdateInfo.displayName = googleUser.displayName;
    user.updateProfile(_userUpdateInfo);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final _userBloc = Provider.of<UserBloc>(context);
    final _sentry = Provider.of<SentryClient>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                try {
                  _handleSignIn().then((FirebaseUser user) async {
                    _userBloc.user.add(user);
                    if (_users.document(user.uid).path.isEmpty) {
                      await _users.document(user.uid).setData({});
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => PostFeed(),
                      ),
                          (route) => false,
                    );
                  }).catchError((e) => print('GoogleAuth error: $e'));
                } catch (error, stacktrace) {
                  await _sentry.captureException(exception: error, stackTrace: stacktrace);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
