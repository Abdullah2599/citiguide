// import 'package:citiguide/Pages/cityscreen.dart';
// import 'package:citiguide/Pages/homepage.dart';
// import 'package:citiguide/Theme/color.dart';
// import 'package:citiguide/components/reusable/reusableicons.dart';
// import 'package:citiguide/controllers/DataController.dart';
// import 'package:citiguide/controllers/FavoritesController.dart';
// import 'package:citiguide/Pages/Favorites/LIkeDataController.dart';
// import 'package:citiguide/controllers/ReviewsController.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:get/get.dart';

// class LikedDetails extends StatefulWidget {
//   final dynamic placeData;
//   final String placeId;

//   const LikedDetails(
//       {super.key, required this.placeData, required this.placeId});

//   @override
//   _LikedDetailsstate createState() => _LikedDetailsstate();
// }

// class _LikedDetailsstate extends State<LikedDetails> {
//   final ReviewController reviewController = Get.put(ReviewController());
//   // final Likedatacontroller dataController = Get.find();
//   final FavoritesController favoritesController = Get.find();

//   double _userRating = 0;
//   final TextEditingController _reviewController = TextEditingController();

//   late bool like = false;
//   checklike() {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user = auth.currentUser;
//     var likes = widget.placeData["likes"];

//     if (likes != null) {
//       like = likes.contains(user!.email.toString());
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     reviewController.fetchReviews(widget.placeId);
//     checklike();
//     //pass the placeId to fetchReviews and setup listener
//     reviewController.sortOrder.listen((_) {
//       reviewController.fetchReviews(widget.placeId);
//     });

//     FirebaseDatabase.instance
//         .ref('data/${widget.placeId}/likes')
//         .onValue
//         .listen((event) {
//       if (event.snapshot.exists) {
//         var likes = event.snapshot.value as List<dynamic>;
//         setState(() {
//           like = likes.contains(FirebaseAuth.instance.currentUser!.email);
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _reviewController.dispose();
//     super.dispose();
//   }

//   void _submitReview() {
//     if (_userRating > 0 && _reviewController.text.isNotEmpty) {
//       reviewController.addReview(
//         widget.placeId,
//         _userRating,
//         _reviewController.text,
//       );

//       setState(() {
//         _userRating = 0;
//         _reviewController.clear();
//       });

//       Navigator.of(context).pop();
//     } else {
//       Get.snackbar('Error', 'Please provide a rating and a comment');
//     }
//   }

//   Future<void> likeOrUnlike(String placeId, bool isLiked) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user = auth.currentUser;

//     if (user == null) {
//       print("User is not logged in.");
//       return;
//     }

//     String email = user.email!;
//     DatabaseReference placeRef =
//         FirebaseDatabase.instance.ref('data/$placeId/likes');

//     // Fetch the current likes
//     DataSnapshot snapshot = await placeRef.get();

//     List<String> likes = [];
//     if (snapshot.exists && snapshot.value is List) {
//       likes = List<String>.from(snapshot.value as List);
//     } else if (snapshot.exists && snapshot.value is Map) {
//       likes = List<String>.from((snapshot.value as Map).values);
//     }

//     if (isLiked) {
//       // Add email to the likes if not already present
//       if (!likes.contains(email)) {
//         likes.add(email);
//         Get.snackbar("Message", "You liked this place");
//       }
//     } else {
//       // Remove email from the likes if present
//       if (likes.contains(email)) {
//         likes.remove(email);
//         Get.snackbar("Message", "You unliked this place");
//       }
//     }

//     // Update the likes array in Realtime Database
//     await placeRef.set(likes);

//     favoritesController.fetchLikedPlaces();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SizedBox(
//             height: 700,
//             width: double.infinity,
//             child: Image.network(
//               widget.placeData["imageurl"].toString(),
//               height: double.infinity,
//               fit: BoxFit.fitHeight,
//             ),
//           ),
//           Positioned(
//             top: 50,
//             left: 20,
//             child: GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: Icon(Icons.arrow_back_ios_new,
//                   size: 30, color: ColorTheme.primaryColor),
//             ),
//           ),
//           Positioned(
//             top: 50,
//             right: 20,
//             child: GestureDetector(
//               onTap: () {
//                 like = !like;
//                 setState(() {});
//                 likeOrUnlike(widget.placeId, like);
//                 // Get.back();
//               },
//               child: Icon(
//                   like ? Icons.favorite : Icons.favorite_border_outlined,
//                   size: 30,
//                   color: ColorTheme.primaryColor),
//             ),
//           ),
//           scrollDetails(),
//           Positioned(
//             bottom: 10,
//             left: 10,
//             right: 10,
//             child: ElevatedButton(
//               onPressed: () {
//                 launchUrl(Uri.parse(widget.placeData["location"].toString()),
//                     mode: LaunchMode.externalApplication);
//               },
//               style: ElevatedButton.styleFrom(
//                 elevation: 5,
//                 backgroundColor: ColorTheme.primaryColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 8.0),
//               ),
//               child: const Text(
//                 "Get Direction",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget scrollDetails() {
//     return DraggableScrollableSheet(
//       builder: (context, scrollcontroller) {
//         return Container(
//           clipBehavior: Clip.hardEdge,
//           decoration: const BoxDecoration(
//             color: Color.fromARGB(255, 250, 252, 253),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: SingleChildScrollView(
//             controller: scrollcontroller,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, bottom: 25),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 5,
//                         width: 35,
//                         color: Colors.black26,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.placeData["title"].toString(),
//                               style: const TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               widget.placeData["city"].toString(),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           launchUrl(
//                               Uri.parse(widget.placeData["contact"].toString()),
//                               mode: LaunchMode.inAppBrowserView);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           elevation: 5,
//                           backgroundColor: ColorTheme.primaryColor,
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 12,
//                             horizontal: 24,
//                           ),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                         ),
//                         child: const Text(
//                           'Contact Now',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 45,
//                   child: Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       "What They Offer",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 100,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       for (var offer in widget.placeData['offer'])
//                         iconContainer(
//                           icon: getIconForOffer(offer),
//                           icontext: offer,
//                           color: ColorTheme.primaryColor,
//                         ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Description",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         widget.placeData["desc"].toString(),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12.0,
//                         ),
//                         child: Row(
//                           children: [
//                             const Text(
//                               "User Reviews",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             Spacer(),
//                             SizedBox(
//                               width: 32,
//                               child: IconButton(
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       return AlertDialog(
//                                         backgroundColor: Colors.white,
//                                         title: const Text('Submit Your Review'),
//                                         content: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Obx(
//                                               () => Text(
//                                                 "Logged in as: ${reviewController.userName.value}",
//                                                 style: TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.black87,
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 8),
//                                             RatingBar.builder(
//                                               initialRating: 0,
//                                               minRating: 1,
//                                               direction: Axis.horizontal,
//                                               allowHalfRating: true,
//                                               itemCount: 5,
//                                               itemPadding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2.0),
//                                               itemBuilder: (context, _) =>
//                                                   const Icon(
//                                                 Icons.star,
//                                                 color: Colors.amber,
//                                               ),
//                                               onRatingUpdate: (rating) {
//                                                 _userRating = rating;
//                                               },
//                                             ),
//                                             const SizedBox(height: 8),
//                                             TextField(
//                                               controller: _reviewController,
//                                               keyboardType:
//                                                   TextInputType.multiline,
//                                               maxLines: 6,
//                                               decoration: const InputDecoration(
//                                                 border: OutlineInputBorder(),
//                                                 filled: true,
//                                                 fillColor: Colors.white,
//                                                 hintText: 'Write your review',
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: const Text(
//                                               'Cancel',
//                                               style: TextStyle(
//                                                   color: Colors.black),
//                                             ),
//                                           ),
//                                           ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                               elevation: 5,
//                                               backgroundColor:
//                                                   ColorTheme.primaryColor,
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                 vertical: 4,
//                                                 horizontal: 16,
//                                               ),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                             ),
//                                             onPressed: _submitReview,
//                                             child: const Text(
//                                               'Submit Review',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 },
//                                 icon: Icon(Icons.add_comment_outlined),
//                               ),
//                             ),
//                             // Sorting button
//                             SizedBox(
//                               width: 26,
//                               child: IconButton(
//                                 onPressed: reviewController.toggleSortOrder,
//                                 icon: Icon(Icons.swap_vert),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Container(
//                         padding: EdgeInsets.all(8.0),
//                         decoration: BoxDecoration(
//                             color: Color.fromARGB(255, 236, 249, 245),
//                             borderRadius:
//                                 BorderRadius.all(Radius.elliptical(10, 10))),
//                         height: 350, // Adjust this height as needed
//                         child: Obx(
//                           () => ListView(
//                             controller: scrollcontroller,
//                             children: reviewController.reviews.map((review) {
//                               return Card(
//                                 elevation: 2,
//                                 margin: const EdgeInsets.symmetric(vertical: 4),
//                                 child: ListTile(
//                                   shape: BeveledRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0))),
//                                   tileColor: Color.fromARGB(62, 40, 250, 194),
//                                   leading: review.profilePic != null
//                                       ? CircleAvatar(
//                                           backgroundImage:
//                                               NetworkImage(review.profilePic!),
//                                         )
//                                       : const CircleAvatar(
//                                           child: Icon(Icons.person),
//                                         ),
//                                   title: Text(review.reviewer.toString()),
//                                   subtitle: Text(review.text.toString()),
//                                   trailing: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(
//                                         review.rating.toString(),
//                                         style: TextStyle(fontSize: 15),
//                                       ),
//                                       const Icon(Icons.star,
//                                           size: 16, color: Colors.amber),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 80),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget iconContainer({
//     required IconData icon,
//     required String icontext,
//     required Color color,
//   }) {
//     return Container(
//         margin: const EdgeInsets.all(6),
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//           color: color,
//           borderRadius: const BorderRadius.all(Radius.circular(6)),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 26, color: Colors.white),
//             const SizedBox(height: 5),
//             Text(
//               icontext,
//               style: const TextStyle(color: Colors.white, fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ));
//   }
// }
