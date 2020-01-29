import 'package:solo_social/library.dart';

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
    final _userBloc = Provider.of<UserBloc>(context);
    return StreamBuilder<FirebaseUser>(
      stream: _userBloc.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final _user = snapshot.data;
          final CollectionReference _posts = Firestore.instance.collection('Users').document(_user.uid).collection('Posts');
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
                      _makePost(value, _posts, _user, context);
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
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              hintText: 'What\'s on your mind?',
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
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
                    ChipsChoice<String>.multiple(
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
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context).primaryColor,
                                      hintText: 'Tag Name',
                                      border: InputBorder.none,
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
                        AttachmentsButton(sourceLinkController: _sourceLinkController),
                      ],
                    ),
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
  void _addPostToFirestore(CollectionReference _posts, FirebaseUser _user, DateTime _timeCreated) {
    _posts.add({
      'Username':_user.displayName,
      'PostText':_postTextController.text,
      'TimeCreated':_timeCreated.toIso8601String(),
      'Tags':jsonEncode(_tags),
      'SourceLink':_sourceLinkController.text,
    });
  }
}

class AttachmentsButton extends StatelessWidget {
  const AttachmentsButton({
    Key key,
    @required TextEditingController sourceLinkController,
  }) : _sourceLinkController = sourceLinkController, super(key: key);

  final TextEditingController _sourceLinkController;

  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      icon: Icon(Icons.attach_file),
      label: Text('Attachments'),
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
              'Attachments',
              style: GoogleFonts.openSans(),
            ),
            contentPadding: EdgeInsets.all(16),
            children: <Widget>[
              TextField(
                controller: _sourceLinkController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  hintText: 'Source link',
                  border: InputBorder.none,
                ),
              ),
              Row(
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('Screenshot(s)'),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ChoiceChip(
                    label: Text('Complete'),
                    backgroundColor: Theme.of(context).accentColor,
                    selected: false,
                    onSelected: (value) {
                      //todo: consider auto-adding tags to indicate attachments
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
