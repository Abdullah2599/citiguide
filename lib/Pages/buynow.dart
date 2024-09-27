import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/controllers/OrderController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderForm extends StatelessWidget {
  final String eventId;
  final String eventName;
  final  pricePerTicket;

  final _orderController = Get.put(OrderController());
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  OrderForm({
    required this.eventId,
    required this.eventName,
    required this.pricePerTicket,
  });

  void _validateAndPlaceOrder() {
    if (_nameController.text.isEmpty || 
        _phoneController.text.isEmpty || 
        _addressController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields.',
        backgroundColor: Color.fromARGB(160, 255, 0, 0),
        colorText: Colors.white,
      );
      return;
    }

    
    

    _orderController.placeOrder(
      eventId: eventId,
      eventName: eventName,
      pricePerTicket: pricePerTicket,
      userName: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 249, 245),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorTheme.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Place Order',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                eventName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
              SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                 decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Phone',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              ),
              SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                maxLines: 3,
                controller: _addressController,
                decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Address',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              ),
              SizedBox(height: 20),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Quantity: ${_orderController.quantity.value}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _orderController.decrementQuantity,
                        icon: Icon(Icons.remove, size: 20, color: ColorTheme.primaryColor,),
                      ),
                      IconButton(
                        onPressed: _orderController.incrementQuantity,
                        icon: Icon(Icons.add,  size: 20, color: ColorTheme.primaryColor,),
                      ),
                    ],
                  ),
                ],
              )),
              SizedBox(height: 20),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _orderController.isPlacingOrder.value ? null : _validateAndPlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: _orderController.isPlacingOrder.value
                      ? SizedBox( height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 1, color: ColorTheme.primaryColor))
                      : Text("Place Order", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
