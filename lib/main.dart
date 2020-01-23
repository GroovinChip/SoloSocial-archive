import 'package:solo_social/library.dart';

void main() => runApp(SoloSocialApp());

class SoloSocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: PostFeed(),
      debugShowCheckedModeBanner: false,
    );
  }
}
