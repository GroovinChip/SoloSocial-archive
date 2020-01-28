import 'package:solo_social/library.dart';

class PostCard extends StatefulWidget {
  final FirebaseUser user;
  final String postId;
  final String username;
  final String postText;
  final List<String> tags;

  const PostCard({
    Key key,
    this.user,
    this.postId,
    this.username,
    this.postText,
    this.tags,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void _handleMenuSelection(String selection) {
    switch (selection) {
      case 'GoToSource':
        break;
      case 'Share':
        break;
      case 'Delete':
        final CollectionReference _posts = Firestore.instance.collection('Users').document(widget.user.uid).collection('Posts');
        setState(() {
          _posts.document(widget.postId).delete();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoUrl),
            ),
            title: Text(
              widget.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '2 min ago', //todo: use timeago package to determine
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: PopupMenuButton(
              child: Ink(
                child: Icon(Icons.keyboard_arrow_down),
                width: 50,
                height: 50,
              ),
              color: Colors.indigo[700],
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Row(
                    children: <Widget>[
                      Icon(MdiIcons.exitRun),
                      SizedBox(width: 8),
                      Text(
                        'Go to source',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  value: 'GoToSource',
                ),
                PopupMenuItem(
                  child: Row(
                    children: <Widget>[
                      Icon(MdiIcons.share),
                      SizedBox(width: 8),
                      Text(
                        'Share',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  value: 'Share',
                ),
                PopupMenuItem(
                  child: Row(
                    children: <Widget>[
                      Icon(MdiIcons.delete),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  value: 'Delete',
                ),
              ],
              onSelected: _handleMenuSelection,
            ),
          ),
          ListTile(
            title: Text(
              widget.postText,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          widget.tags.length > 0 ? Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.tags.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(widget.tags[index]),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                  );
                },
              ),
            ),
          ) : Container(),
          widget.tags.length > 0 ? SizedBox(height: 12) : Container(),
        ],
      ),
    );
  }
}
