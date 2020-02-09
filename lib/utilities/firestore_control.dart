import 'package:solo_social/library.dart';

class FirestoreControl {
  final CollectionReference users = Firestore.instance.collection('Users');
  final String userId;
  CollectionReference posts;

  FirestoreControl(
    this.userId,
  );

  void getPosts() {
    posts = users.document(userId).collection('Posts');
  }
}
