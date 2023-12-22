import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String price;

  PaymentPage({required this.price});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentOption = '';
  bool orderPlaced = false;

  Future<void> _showOrderPlacedDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Placed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'order_placed_animation',
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              Text('Your order has been successfully placed!'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Options'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.teal, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Price: ${widget.price}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        'UPI Payment',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      leading: Radio(
                        value: 'UPI',
                        groupValue: selectedPaymentOption,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentOption = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Cash on Delivery',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      leading: Radio(
                        value: 'COD',
                        groupValue: selectedPaymentOption,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentOption = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Credit Card Payment',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      leading: Radio(
                        value: 'Credit Card',
                        groupValue: selectedPaymentOption,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentOption = value.toString();
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedPaymentOption.isNotEmpty) {
                          // Simulate a delay to show the order placed dialog with animation.
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              orderPlaced = true;
                            });
                            _showOrderPlacedDialog();
                          });
                        } else {
                          print('Please select a payment option');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Place Order',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (orderPlaced)
                Hero(
                  tag: 'order_placed_animation',
                  child: Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
