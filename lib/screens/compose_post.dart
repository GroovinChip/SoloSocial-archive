import 'package:solo_social/library.dart';

class ComposePost extends StatefulWidget {
  @override
  _ComposePostState createState() => _ComposePostState();
}

class _ComposePostState extends State<ComposePost> {
  TextEditingController _postTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                          _posts.add({
                            'Username':_user.displayName,
                            'PostText':_postTextController.text,
                            'TimeCreated':_timeCreated.toIso8601String(),
                          });
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
                                  _posts.add({
                                    'Username':_user.displayName,
                                    'PostText':_postTextController.text,
                                    'TimeCreated':_timeCreated.toIso8601String(),
                                  });
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
                          selected: false,
                          onSelected: (value) {},
                        ),
                        ChoiceChip(
                          label: Text('Comment'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ChoiceChip(
                          label: Text('Facebook'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        ChoiceChip(
                          label: Text('Instagram'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        ChoiceChip(
                          label: Text('Twitter'),
                          selected: false,
                          onSelected: (value) {},
                        ),
                        ChoiceChip(
                          label: Text('Reddit'),
                          selected: false,
                          onSelected: (value) {},
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
