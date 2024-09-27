import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/controllers/OrderController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Requestplace extends StatelessWidget {

  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  final _orderController = Get.put(OrderController());

  Requestplace({
    super.key,
  });

  void _validateAndPlaceRequest() {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields.',
        backgroundColor: Color.fromARGB(160, 255, 0, 0),
        colorText: Colors.white,
      );
      return;
    }

    // Handle the request submission logic here
    _orderController.placeRequest(
      title: _titleController.text,
      message: _messageController.text,
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
          'Request Place',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 25),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _orderController.isPlacingOrder.value
                          ? null
                          : _validateAndPlaceRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: _orderController.isPlacingOrder.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: ColorTheme.primaryColor))
                          : Text("Submit Request",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
