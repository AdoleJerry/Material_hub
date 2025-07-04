abstract class Database {}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid.isNotEmpty);
  final String uid;
}
