import 'package:solo_social/library.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String postText;
  final List<String> tags;

  const PostCard({
    Key key,
    this.username,
    this.postText,
    this.tags
  }) : super(key: key);

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
            /// if google user, CircleAvatar. Else, AvataaarImage
            /*leading: AvataaarImage(
              errorImage: CircleAvatar(
                child: Text('ERR'),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              avatar: Avataaar(
                style: Style.circle,
                skin: Skin.pale,
                top: Top.shortHairShortWaved(),
                mouth: Mouth.smile,
                clothes: Clothes.blazerShirt,
              ),
            ),*/
            leading: CircleAvatar( //todo: GoogleUser avatar
              backgroundColor: Theme.of(context).accentColor,
              child: Text('U'),
            ),
            title: Text(
              username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '2 min ago',
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
                ),
              ],
              onSelected: (value) {},
            ),
          ),
          ListTile(
            title: Text(
              postText,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          tags.length > 0 ? Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(tags[index]),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                  );
                },
              ),
            ),
          ) : Container(),
          tags.length > 0 ? SizedBox(height: 12) : Container(),
        ],
      ),
    );
  }
}
