import 'package:solo_social/library.dart';
import 'package:sentry/sentry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SoloSocialApp());
}

class SoloSocialApp extends StatefulWidget {
  @override
  _SoloSocialAppState createState() => _SoloSocialAppState();
}

class _SoloSocialAppState extends State<SoloSocialApp> {
  RemoteConfig _remoteConfig;
  SentryClient sentry;
  String snapfeedProjectId;
  String snapfeedSecret;

  PackageInfo _packageInfo;
  String appName;
  String packageName;
  String version;
  String buildNumber;

  /// Retrieve information about this app for display
  void _getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    appName = _packageInfo.appName;
    packageName = _packageInfo.packageName;
    version = _packageInfo.version;
    buildNumber = _packageInfo.buildNumber;
  }

  /// Initialize Remote Config
  void _initRemoteConfig() async {
    _remoteConfig = await RemoteConfig.instance.catchError((error) {
      print(error);
    });

    _remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    await _remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await _remoteConfig.activateFetched();

    setState(() {
      sentry = SentryClient(dsn: _remoteConfig.getString('SentryDsn'));
      snapfeedProjectId = _remoteConfig.getString('SnapfeedProjectId');
      snapfeedSecret = _remoteConfig.getString('SnapfeedSecret');
    });
  }

  @override
  void initState() {
    _getPackageInfo();
    _initRemoteConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Bloc>(create: (_) => Bloc()),
        Provider<SentryClient>(create: (_) => sentry),
        Provider<PackageInfo>(create: (_) => _packageInfo),
      ],
      child: Snapfeed(
        projectId: snapfeedProjectId,
        secret: snapfeedSecret,
        child: MaterialApp(
          title: 'SoloSocial',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            primaryColor: Colors.indigo,
            accentColor: Colors.indigoAccent,
            brightness: Brightness.dark,
            canvasColor: Colors.indigo[800],
            textTheme: GoogleFonts.openSansTextTheme(
              Theme.of(context).textTheme,
            ),
            textSelectionHandleColor: Colors.indigoAccent,
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.indigo,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.indigo,
                ),
              ),
              filled: true,
              fillColor: Colors.indigo,
            ),
          ),
          home: AuthCheck(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
