import 'package:CityNavigator/Pages/eventsdetails.dart';
import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/controllers/OrderHistoryController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class OrderDetailsView extends StatelessWidget {
  final orders;
  final orderhistorycontroller = Get.put(Orderhistorycontroller());

  OrderDetailsView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = orders['orderDate'];
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd At kk:mm').format(dateTime);

    // Fetch event details
    orderhistorycontroller.fetchEventDetails(orders['eventId']);

    return Scaffold(
      backgroundColor: ColorTheme.lightColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
         leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 7, 206, 182),
        title: const Text('Order Summary',style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        var event = orderhistorycontroller.eventDetails;
        print(event);
        if (event.isEmpty) {
          return Center(
                child: GFLoader(
                    size: GFSize.LARGE,
                    type: GFLoaderType.square,
                    loaderColorOne: Color.fromARGB(255, 0, 250, 217),
                    loaderColorTwo: Color.fromARGB(255, 123, 255, 237),
                    loaderColorThree: Color.fromARGB(255, 201, 255, 248)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Info and Status
              _buildOrderInfoRow('Order Date:', formattedDate),
              const SizedBox(height: 10),
              _buildOrderInfoRow('Order No.', orders['orderId']),
              
              const SizedBox(height: 10),
              //_buildOrderInfoRow('Status', orders['status']),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: ColorTheme.primaryColor)),
                buildStatusBox(orders['status']),
              ],
            ),
              const Divider(),

              // Events Section
              Text(
                'Event Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Get.to(()=> Eventsdetails(eventData: event,eventId: orders['eventId'],)),
                child: _buildEventItem(event, orders)),

              const Divider(),
              const SizedBox(height: 20),

              // Payment Info
              _buildOrderInfoRow('Total Price', 'Rs. ${orders['totalPrice']}'),
              const SizedBox(height: 10),

              // _buildOrderInfoRow('Payment Method', _getPaymentMethodDisplay(orders['paymentMethod'])),
              const Divider(),

              // Address Info
              const SizedBox(height: 10),
              Text('Shipping Address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: ColorTheme.primaryColor)),
              const SizedBox(height: 10),
              Text(orders['address'], style: const TextStyle(fontSize: 18)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: ColorTheme.primaryColor)),
        Expanded(
          //copyable text
          child: SelectableText (value,
              textAlign: TextAlign.right, style: const TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildEventItem(event, Map<String, dynamic> order) {
    return Card(
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        minLeadingWidth:  10,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: event['imageurl'] ?? "https://via.placeholder.com/150",
            width: 60,
            height: 80,
            fit: BoxFit.cover,
        
            placeholder: (context, url) => SizedBox(height: 30 , width: 30, child:  CircularProgressIndicator(color: ColorTheme.primaryColor,strokeWidth: 0.5,)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(event['title'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorTheme.primaryColor)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('Price: Rs. ${event['price']}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Text('Quantity: ${order['quantity']}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget buildStatusBox(String status) {
    Color backgroundColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = ColorTheme.primaryColor;
        statusText = 'Pending';
        break;
      case 'cancelled':
        backgroundColor = Colors.red;
        statusText = 'Cancelled';
        break;
      case 'completed':
        backgroundColor = Colors.lightGreen;
        statusText = 'Delivered';
        break;
      default:
        backgroundColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white ,
          fontWeight: FontWeight.bold,
        ),
         textAlign: TextAlign.center,
      ),
    );
  }

}
