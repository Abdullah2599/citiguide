import 'package:CityNavigator/controllers/OrderController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrderForm extends StatelessWidget {
  final String eventId;
  final String eventName;
  final double pricePerTicket;

  final _orderController = Get.put(OrderController());
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  OrderForm({required this.eventId, required this.eventName, required this.pricePerTicket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Address"),
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Quantity: ${_orderController.quantity.value}"),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _orderController.decrementQuantity,
                          icon: Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed: _orderController.incrementQuantity,
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: _orderController.isPlacingOrder.value
                      ? null
                      : () {
                          _orderController.placeOrder(
                            eventId: eventId,
                            eventName: eventName,
                            pricePerTicket: pricePerTicket,
                            userName: _nameController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                          );
                        },
                  child: _orderController.isPlacingOrder.value
                      ? CircularProgressIndicator()
                      : Text('Place Order'),
                )),
          ],
        ),
      ),
    );
  }
}
