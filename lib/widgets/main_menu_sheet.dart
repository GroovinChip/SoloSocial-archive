import 'package:solo_social/library.dart';

// ignore: must_be_immutable
class MainMenuSheet extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user;

  MainMenuSheet({
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: ModalDrawerHandle(),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              title: Text(user.displayName),
              subtitle: Text(user.email),
              trailing: FlatButton(
                child: Text('Sign Out'),
                onPressed: () {
                  _auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Users').document(user.uid).collection('Posts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  final _posts = snapshot.data.documents;
                  return ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text('Download Posts'),
                    onTap: () {
                      /*for (DocumentSnapshot post in _posts) {

                      }*/
                    },
                  );
                }
              },
            ),
            /*ListTile(
              leading: Icon(Icons.alternate_email),
              title: Text('Contact Developer'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('App Info'),
              onTap: () {},
            ),*/
          ],
        ),
      ),
    );
  }
}
