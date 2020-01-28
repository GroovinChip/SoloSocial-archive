import 'package:solo_social/library.dart';

class PostFeed extends StatefulWidget {
  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  final CollectionReference _users = Firestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    final _userBloc = Provider.of<UserBloc>(context);
    return StreamBuilder<FirebaseUser>(
        stream: _userBloc.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final _user = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).canvasColor,
                title: Text(
                  'Posts',
                  style: GoogleFonts.openSans(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: _users.document(_user.uid).collection('Posts').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final _posts = snapshot.data.documents;
                    if (_posts.length == 0 || _posts == null) {
                      return Center(
                        child: Text(
                          'No Posts',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          final _post = _posts[index];
                          var _tags;
                          if (_post['Tags'] != null) {
                            _tags = (jsonDecode(_post['Tags']) as List).cast<String>();
                          }
                          return PostCard(
                            user: _user,
                            postId: _post.documentID,
                            username: _post['Username'],
                            postText: _post['PostText'],
                            tags: _tags == null || _tags.length == 0 ? [] : _tags,
                          );
                        },
                      );
                    }
                  }
                },
              ),
              floatingActionButton: ComposeFab(),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                color: Theme.of(context).primaryColor,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                            ),
                          ),
                          backgroundColor: Theme.of(context).canvasColor,
                          builder: (_) => MainMenuSheet(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => showSearch(
                          context: context,
                          delegate: PostSearch(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
