import 'package:sentry/sentry.dart';
import 'package:solo_social/widgets/delete_all_posts_dialog.dart';
import 'package:solo_social/library.dart';
import 'package:path/path.dart' as p;
import 'package:csv/csv.dart' as csv;
import 'package:solo_social/utilities/firestore_control.dart';

// ignore: must_be_immutable
class MainMenuSheet extends StatefulWidget {
  final FirebaseUser user;
  final GlobalKey<ScaffoldState> scaffoldKey;

  MainMenuSheet({
    @required this.user,
    this.scaffoldKey,
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
    for (final DocumentSnapshot post in posts.documents) {
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
    final _packageInfo = Provider.of<PackageInfo>(context);
    final _sentry = Provider.of<SentryClient>(context);
    final _firestoreControl = FirestoreControl(
      userId: widget.user.uid,
      context: context,
    );
    _firestoreControl.getPosts();
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreControl.posts.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final _posts = snapshot.data.documents;
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                  _posts.length > 0 ? ListTile(
                    leading: Icon(MdiIcons.cloudDownloadOutline),
                    title: Text('Download Posts'),
                    onTap: () {
                      _exportPosts(snapshot.data).catchError((error) async {
                        await _sentry.captureException(exception: error);
                      });
                      shareFile();
                    },
                  ) : Container(),
                  _posts.length > 0 ? ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete All Posts'),
                    onTap: () async {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => DeleteAllPostsDialog(
                          firestoreControl: _firestoreControl,
                          posts: _posts,
                        ),
                      );
                    },
                  ) : Container(),
                  ListTile(
                    leading: Icon(MdiIcons.sendOutline),
                    title: Text('Send Feedback'),
                    onTap: () {
                      Navigator.pop(context);
                      Snapfeed.of(context).startFeedback();
                    },
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(MdiIcons.informationVariant),
                    title: Text(_packageInfo.appName),
                    subtitle: Text('Version ' + _packageInfo.version),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
