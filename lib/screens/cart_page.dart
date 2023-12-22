import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_port/screens/mainpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      home: CartPage(),
    );
  }
}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: CartItemList(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Get the list of cart items
            final List<DocumentSnapshot> cartItems = CartItemList.cartItems;

            // Navigate to the CheckoutPage and pass the cart items
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CheckoutPage(cartItems: cartItems),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
          ),
          child: Text('Buy Now'),
        ),
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  static List<DocumentSnapshot> cartItems = [];

  Future<void> removeFromCart(String cartItemId) async {
    await FirebaseFirestore.instance.collection('cart').doc(cartItemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cart').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Your cart is empty.'),
          );
        }

        cartItems = snapshot.data!.docs;

        return ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final cartItem = cartItems[index].data() as Map<String, dynamic>?;

            if (cartItem == null) {
              return SizedBox(); // Handle null cart items gracefully
            }

            final cartItemId = cartItems[index].id;
            final itemName = cartItem['name'] as String? ?? '';
            final itemPrice = (cartItem['price'] as String?) != null
                ? double.parse(cartItem['price'] as String) // Convert to double
                : 0.0;
            final itemImageURL = cartItem['imageURL'] as String? ?? '';

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.network(
                  itemImageURL,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(itemName),
                subtitle: Text('Price: \$${itemPrice.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await removeFromCart(cartItemId);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final List<DocumentSnapshot> cartItems;

  CheckoutPage({required this.cartItems});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double total = 0.0;
  String? selectedPaymentMethod;
  bool orderPlaced = false;

  @override
  void initState() {
    super.initState();
    for (var cartItem in widget.cartItems) {
      final itemPrice = (cartItem['price'] as String) != null
          ? double.parse(cartItem['price'] as String) // Convert to double
          : 0.0;
      total += itemPrice;
    }
  }

  void placeOrder() {
    // Simulate an order placement process
    // You can replace this with your actual logic
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        orderPlaced = true;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Order Placed'),
            content: Text('Your order has been placed successfully.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(),
                        ),
                      );
                    },
                    child: Text('OK')),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total Price: \$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: selectedPaymentMethod,
                items: <String>[
                  'Credit Card',
                  'PayPal',
                  'Apple Pay',
                  'Google Wallet',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? selectedMethod) {
                  setState(() {
                    selectedPaymentMethod = selectedMethod;
                  });
                },
                hint: Text('Select Payment Method'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: orderPlaced ? 0 : 60,
              child: ElevatedButton(
                onPressed: () {
                  placeOrder(); // Trigger the order placement process
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
