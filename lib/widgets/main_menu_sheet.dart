import 'package:solo_social/library.dart';
import 'package:path/path.dart' as p;
import 'package:csv/csv.dart' as csv;

// ignore: must_be_immutable
class MainMenuSheet extends StatefulWidget {
  final FirebaseUser user;

  MainMenuSheet({
    @required this.user,
  });

  @override
  _MainMenuSheetState createState() => _MainMenuSheetState();
}

class _MainMenuSheetState extends State<MainMenuSheet> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DateFormat dateFormat = DateFormat.yMd().add_jm();
  List<StorageInfo> _storageInfo = [];

  Future<void> _getStorageInfo() async {
    List<StorageInfo> storageInfo;
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}

    if (!mounted) return;

    setState(() {
      _storageInfo = storageInfo;
    });
  }

  Future<String> get _localPath async {
    final externalDir = _storageInfo[0];
    final dataDir = Directory(p.join(externalDir.rootDir, 'SoloSocial'));
    await dataDir.create(recursive: true);
    return dataDir.path;
  }

  Future<File> get _localFile {
    return _localPath.then((path) => File(p.join(path, 'SoloSocial Post Records.csv')));
  }

  /// Export user's posts to a readable CSV file
  Future<void> _exportPosts(QuerySnapshot posts) async {
    // Headers
    List<List<String>> data = [
      ['Username', 'Time Created', 'Post Text', 'Tags', 'Source Link'],
    ];

    // Add post record to data
    for(final DocumentSnapshot post in posts.documents) {
      data.add([
        post['Username'],
        dateFormat.format((post['TimeCreated'] as Timestamp).toDate()),
        post['PostText'],
        post['Tags'],
        post['SourceLink'],
      ]);
    }
    final file = await _localFile;

    // Convert data to csv format
    final csvData = csv.ListToCsvConverter().convert(data);

    // Write csv to internal storage
    await file.writeAsString(csvData, flush: true);
  }

  void shareFile() async {
    File postRecords = await _localFile;
    Navigator.pop(context);
    ShareExtend.share(postRecords.path, 'file');
  }

  @override
  void initState() {
    _getStorageInfo();
    super.initState();
  }

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
              child: ModalDrawerHandle(
                /*handleWidth: 50,
                handleHeight: 2,*/
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(widget.user.photoUrl),
              ),
              title: Text(widget.user.displayName),
              subtitle: Text(widget.user.email),
              trailing: OutlineButton(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
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
              stream: Firestore.instance.collection('Users').document(widget.user.uid).collection('Posts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return ListTile(
                    leading: Icon(MdiIcons.cloudDownloadOutline),
                    title: Text('Download Posts'),
                    onTap: () {
                      _exportPosts(snapshot.data);
                      shareFile();
                    },
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Delete All Posts'),
              onTap: () async {
                CollectionReference _postsRef = Firestore.instance.collection('Users').document(widget.user.uid).collection('Posts');
                QuerySnapshot _posts = await _postsRef.getDocuments();

                if (_posts.documents.length > 0) {
                  for (int i = 0; i < _posts.documents.length; i++) {
                    DocumentReference _postRef = _posts.documents[i].reference;
                    _postRef.delete();
                  }
                  Navigator.pop(context);
                } else {
                  // snackbar
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
