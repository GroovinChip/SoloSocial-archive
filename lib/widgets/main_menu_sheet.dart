import 'package:solo_social/library.dart';

class MainMenuSheet extends StatelessWidget {
  const MainMenuSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(

      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: ModalDrawerHandle(),
            ),
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text('Download Posts'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.alternate_email),
              title: Text('Contact Developer'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('App Info'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
