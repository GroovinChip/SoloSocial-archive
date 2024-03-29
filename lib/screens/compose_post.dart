import 'package:solo_social/library.dart';
import 'package:solo_social/utilities/firestore_control.dart';

class ComposePost extends StatefulWidget {
  @override
  _ComposePostState createState() => _ComposePostState();
}

class _ComposePostState extends State<ComposePost> {
  TextEditingController _postTextController = TextEditingController();
  TextEditingController _sourceLinkController = TextEditingController();
  TextEditingController _addTagController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _tags = [];
  List<String> _options = [
    'Post', 'Comment', 'Facebook',
    'Instagram', 'Twitter', 'Reddit',
    'Snapchat',
  ];

  @override
  Widget build(BuildContext context) {
    final _userBloc = Provider.of<Bloc>(context);
    return StreamBuilder<FirebaseUser>(
      stream: _userBloc.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final _user = snapshot.data;
          final _firestoreControl = FirestoreControl(
            userId: _user.uid,
            context: context,
          );
          _firestoreControl.getPosts();
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).canvasColor,
              elevation: 0,
              title: Text(
                'Compose',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      'Post',
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                    onSelected: (value) {
                      _makePost(value, _firestoreControl.posts, _user, context);
                    },
                    selected: false,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 134),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(_user.photoUrl),
                            backgroundColor: Theme.of(context).accentColor,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _postTextController,
                            textCapitalization: TextCapitalization.sentences,
                            autocorrect: true,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'What\'s on your mind?',
                            ),
                            maxLines: 5,
                            maxLength: 256,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 30),
                        Text(
                          'Tags',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 3),
                        Expanded(
                          child: ChipsChoice<String>.multiple(
                            value: _tags,
                            itemConfig: ChipsChoiceItemConfig(
                              selectedColor: Colors.white,
                              //unselectedColor: Theme.of(context).primaryColor,
                            ),
                            options: ChipsChoiceOption.listFrom<String, String>(
                              source: _options,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            onChanged: (val) => setState(() => _tags = val),
                            isWrapped: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 18),
                        OutlineButton.icon(
                          label: Text('Add Tag'),
                          icon: Icon(MdiIcons.tagPlusOutline),
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => Theme(
                              data: ThemeData.dark(),
                              child: SimpleDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                backgroundColor: Theme.of(context).canvasColor,
                                title: Text(
                                  'New Tag',
                                  style: GoogleFonts.openSans(),
                                ),
                                contentPadding: EdgeInsets.all(16),
                                children: <Widget>[
                                  TextField(
                                    controller: _addTagController,
                                    textCapitalization: TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      hintText: 'Tag Name',
                                      enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                                      focusedBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                      filled: Theme.of(context).inputDecorationTheme.filled,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      ChoiceChip(
                                        label: Text('Complete'),
                                        backgroundColor: Theme.of(context).accentColor,
                                        selected: false,
                                        onSelected: (value) {
                                          if (value == true && _addTagController.text.isNotEmpty) {
                                            setState(() {
                                              _options.add(_addTagController.text);
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 30),
                        Text(
                          'Other',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 18),
                        OutlineButton.icon(
                          icon: Icon(Icons.link),
                          label: Text('Refer to Source'),
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => Theme(
                              data: ThemeData.dark(),
                              child: SimpleDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                backgroundColor: Theme.of(context).canvasColor,
                                title: Text(
                                  'Source Reference',
                                  style: GoogleFonts.openSans(),
                                ),
                                contentPadding: EdgeInsets.all(16),
                                children: <Widget>[
                                  TextField(
                                    controller: _sourceLinkController,
                                    keyboardType: TextInputType.url,
                                    decoration: InputDecoration(
                                      hintText: 'Paste link here',
                                      enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                                      focusedBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                      filled: Theme.of(context).inputDecorationTheme.filled,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      ChoiceChip(
                                        label: Text('Complete'),
                                        backgroundColor: Theme.of(context).accentColor,
                                        selected: false,
                                        onSelected: (value) {
                                          // add tag indicating source link
                                          // ensure tag only is entered once
                                          if (_sourceLinkController.text.isNotEmpty && !_tags.contains('Source')) {
                                            setState(() {
                                              _options.add('Source');
                                              _tags.add('Source');
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _sourceLinkController.text.isNotEmpty ? Row(
                      children: <Widget>[
                        SizedBox(width: 18),
                        Text(
                          '==> ' + _sourceLinkController.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ): Container(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  /// Data validation prior to adding to Firestore
  void _makePost(bool value, CollectionReference _posts, FirebaseUser _user, BuildContext context) {
    if (value == true) {
      if (_postTextController.text.isNotEmpty) {
        DateTime _timeCreated = DateTime.now();
        try {
          _addPostToFirestore(_posts, _user, _timeCreated);
          Navigator.of(context).pop();
        } catch (e) {
          print(e);
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              'Are you sure you want to post without adding text?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Theme.of(context).accentColor,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Yes',
              textColor: Colors.white,
              onPressed: () {
                DateTime _timeCreated = DateTime.now();
                try {
                  _addPostToFirestore(_posts, _user, _timeCreated);
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
        );
      }
    }
  }

  /// Actually add data to Firestore
  void _addPostToFirestore(CollectionReference _posts, FirebaseUser _user, DateTime _timeCreated) async {
    try {
      _posts.add({
        'Username':_user.displayName,
        'PostText':_postTextController.text,
        'TimeCreated': Timestamp.fromDate(_timeCreated),
        'Tags':jsonEncode(_tags),
        'SourceLink':_sourceLinkController.text,
      });
    } catch (e) {
      print(e);
    }
  }
}
