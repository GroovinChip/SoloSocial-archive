import 'package:sentry/sentry.dart';
import 'package:solo_social/library.dart';
import 'package:solo_social/utilities/firestore_control.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Firebase related initializations
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    final _userBloc = Provider.of<Bloc>(context);
    final _sentry = Provider.of<SentryClient>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                _handleSignIn().then((FirebaseUser user) async {
                  _userBloc.user.add(user);
                  final _firestoreControl = FirestoreControl(user.uid);
                  _firestoreControl.getPosts();
                  if (_firestoreControl.posts.document(user.uid).path.isEmpty) {
                    await _firestoreControl.posts.document(user.uid).setData({});
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => PostFeed(
                        user: user,
                      ),
                    ),
                        (route) => false,
                  );
                }).catchError((exc) async {
                  print('GoogleAuth error: $exc');
                  await _sentry.captureException(exception: exc);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
