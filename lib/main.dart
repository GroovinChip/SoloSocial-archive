import 'package:solo_social/library.dart';
import 'package:sentry/sentry.dart';

void main() => runApp(SoloSocialApp());

class SoloSocialApp extends StatelessWidget {
  final sentry = SentryClient(dsn: 'https://9dfb88b691594bfbbbf1bf5fe33a751a@sentry.io/2043262');

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserBloc>(create: (_) => UserBloc(),),
        Provider<SentryClient>(create: (_) => sentry),
      ],
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
        ),
        home: AuthCheck(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
