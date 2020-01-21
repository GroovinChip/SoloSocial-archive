import 'package:solo_social/library.dart';

class PostFeed extends StatefulWidget {
  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        //todo: get posts from firestore
        itemCount: 2,
        padding: EdgeInsets.only(left: 8, right: 8),
        itemBuilder: (context, index) {
          return PostCard(
            username: 'Reuben Turner',
            postText: 'Test post',
            tags: [],
          );
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
}
