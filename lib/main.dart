import 'package:provider/provider.dart';
import 'package:solo_social/library.dart';

void main() => runApp(SoloSocialApp());

class SoloSocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => UserBloc(),
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
        home: Introduction(),
        routes: <String, WidgetBuilder>{
          '/PostFeed': (BuildContext context) => PostFeed(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
