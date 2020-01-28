import 'package:solo_social/library.dart';

class ComposePost extends StatefulWidget {
  @override
  _ComposePostState createState() => _ComposePostState();
}

class _ComposePostState extends State<ComposePost> {
  TextEditingController _postTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<String> _tags = [];
  bool _postTagSelected = false;
  bool _commentTagSelected = false;
  bool _facebookTagSelected = false;
  bool _instagramTagSelected = false;
  bool _twitterTagSelected = false;
  bool _redditTagSelected = false;

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
                      if (value == true) {
                        if (_postTextController.text.isNotEmpty) {
                          DateTime _timeCreated = DateTime.now();
                          try {
                            _posts.add({
                              'Username':_user.displayName,
                              'PostText':_postTextController.text,
                              'TimeCreated':_timeCreated.toIso8601String(),
                            });
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
                                    _posts.add({
                                      'Username':_user.displayName,
                                      'PostText':_postTextController.text,
                                      'TimeCreated':_timeCreated.toIso8601String(),
                                    });
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
                        //todo: adapt avatar based on user type
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ChoiceChip(
                          avatar: Icon(Icons.add),
                          label: Text('Add Your Own'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        ChoiceChip(
                          label: Text('Post'),
                          selected: _postTagSelected,
                          selectedColor: Theme.of(context).accentColor,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _tags.add('Post');
                                _postTagSelected = true;
                                print(_tags);
                              });
                            } else {
                              setState(() {
                                _postTagSelected = false;
                                _tags.remove('Post');
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text('Comment'),
                          selected: _commentTagSelected,
                          selectedColor: Theme.of(context).accentColor,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _tags.add('Comment');
                                _commentTagSelected = true;
                                print(_tags);
                              });
                            } else {
                              setState(() {
                                _commentTagSelected = false;
                                _tags.remove('Comment');
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ChoiceChip(
                          label: Text('Facebook'),
                          selected: _facebookTagSelected,
                          selectedColor: Theme.of(context).accentColor,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _tags.add('Facebook');
                                _facebookTagSelected = true;
                                print(_tags);
                              });
                            } else {
                              setState(() {
                                _facebookTagSelected = false;
                                _tags.remove('Facebook');
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text('Instagram'),
                          selected: _instagramTagSelected,
                          selectedColor: Theme.of(context).accentColor,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _tags.add('Instagram');
                                _instagramTagSelected = true;
                                print(_tags);
                              });
                            } else {
                              setState(() {
                                _instagramTagSelected = false;
                                _tags.remove('Instagram');
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text('Twitter'),
                          selected: _twitterTagSelected,
                          selectedColor: Theme.of(context).accentColor,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _tags.add('Twitter');
                                _twitterTagSelected = true;
                                print(_tags);
                              });
                            } else {
                              setState(() {
                                _twitterTagSelected = false;
                                _tags.remove('Twitter');
                              });
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text('Reddit'),
                          selected: _redditTagSelected,
                          selectedColor: Theme.of(context).accentColor,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _tags.add('Reddit');
                                _redditTagSelected = true;
                                print(_tags);
                              });
                            } else {
                              setState(() {
                                _redditTagSelected = false;
                                _tags.remove('Reddit');
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      children: <Widget>[
                        FlatButton.icon(
                          icon: Icon(Icons.attach_file),
                          label: Text('Attachments'),
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
                                        label: Text('Finish'),
                                        backgroundColor: Theme.of(context).accentColor,
                                        selected: false,
                                        onSelected: (value) {},
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
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
