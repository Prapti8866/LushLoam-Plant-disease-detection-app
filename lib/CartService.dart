import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final CollectionReference cartCollection =
  FirebaseFirestore.instance.collection('cart');

  Future<void> addToCart(String name, String price, String imageURL) async {
    await cartCollection.add({
      'name': name,
      'price': price,
      'imageURL': imageURL,
    });
  }

  Future<void> removeFromCart(String cartItemId) async {
    await cartCollection.doc(cartItemId).delete();
  }

  Stream<QuerySnapshot> getCartItems() {
    return cartCollection.snapshots();
  }
}
