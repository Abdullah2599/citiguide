import 'package:CityNavigator/Pages/orderdetaikls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:CityNavigator/controllers/OrderHistoryController.dart';

class Orderhistory extends StatelessWidget {
  Orderhistory({super.key});
  final orderhistoryController = Get.put(Orderhistorycontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 206, 182),
        foregroundColor: Colors.white,
        title: const Text('Order History'),
      ),
      body: Obx(() {
        if (orderhistoryController.orderhistory.isEmpty) {
          return const Center(child: Text('Nothing to show'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            orderhistoryController.fetchOrderHistory();
          },
          child: ListView.builder(
            itemCount: orderhistoryController.orderhistory.length,
            itemBuilder: (context, index) {
              var orders = orderhistoryController.orderhistory[index];
          
              return GestureDetector(
                onTap: () {
                  Get.to(() => OrderDetailsView(orders: orders));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(234, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text('Order No.# ${orders['orderId'].substring(0, 6)}...'),
                    subtitle: Text(orders['eventName']),
                    leading: CircleAvatar(
                      child: Icon(Icons.airplane_ticket),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
