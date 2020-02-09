import 'package:solo_social/library.dart';

class FirestoreControl {
  final CollectionReference users = Firestore.instance.collection('Users');
  final String userId;
  final BuildContext context;
  CollectionReference posts;

  FirestoreControl({
    this.userId,
    this.context,
  });

  /// Populate posts collection with post documents
  void getPosts() {
    posts = users.document(userId).collection('Posts');
  }

  /// Delete all post documents from posts collection
  Future deleteAllPosts(QuerySnapshot postsToDelete) async {
    for (int i = 0; i < postsToDelete.documents.length; i++) {
      DocumentReference _postRef = postsToDelete.documents[i].reference;
      _postRef.delete();
    }
  }
}
