<<<<<<< HEAD
class DisplayData {
  final String title;
  final int price;
  final String description;
  final String imageUrl;
  final String email;

  DisplayData({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.email,
  });

  factory DisplayData.fromDocumentSnapshot(doc) {
    final data = doc.data()!;
    return DisplayData(
      title: data['title'].toString(),
      price: (data['price']),
      description: data['description'].toString(),
      imageUrl: data['downloadUrl'].toString(),
      email: data['email'].toString(),
    );
  }
}
=======
class DisplayData {
  final String title;
  final int price;
  final String description;
  final String imageUrl;
  final String email;

  DisplayData({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.email,
  });

  factory DisplayData.fromDocumentSnapshot(doc) {
    final data = doc.data()!;
    return DisplayData(
      title: data['title'].toString(),
      price: (data['price']),
      description: data['description'].toString(),
      imageUrl: data['downloadUrl'].toString(),
      email: data['email'].toString(),
    );
  }
}
>>>>>>> 8ddb56bed4ea68597595ff99aef8608671358442
