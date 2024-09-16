import 'package:cached_network_image/cached_network_image.dart';
import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/components/reusable/reusableicons.dart';
import 'package:CityNavigator/controllers/FavoritesController.dart';
import 'package:CityNavigator/controllers/ReviewsController.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class TilesDetails extends StatefulWidget {
  final dynamic placeData;
  final String placeId;

  const TilesDetails(
      {super.key, required this.placeData, required this.placeId});

  @override
  // ignore: library_private_types_in_public_api
  _TilesDetailsState createState() => _TilesDetailsState();
}

class _TilesDetailsState extends State<TilesDetails> {
  final ReviewController reviewController = Get.put(ReviewController());
  final FavoritesController favoritesController =
      Get.put(FavoritesController());

  double _userRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reviewController.fetchReviews(widget.placeId);
    favoritesController.checkLikeStatus(widget.placeId);
    //pass the placeId to fetchReviews and setup listener
    reviewController.sortOrder.listen((_) {
      if (mounted) {
        reviewController.fetchReviews(widget.placeId);
      }
    });
  }

  @override
  void dispose() {
    reviewController.sortOrder.close();
    FirebaseDatabase.instance
        .ref('data/${widget.placeId}/likes')
        .onValue
        .listen((event) {})
        .cancel();
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_userRating > 0 && _reviewController.text.isNotEmpty) {
      reviewController.addReview(
        widget.placeId,
        _userRating,
        _reviewController.text,
      );

      setState(() {
        _userRating = 0;
        _reviewController.clear();
      });

      Navigator.of(context).pop();
    } else {
      Get.snackbar('Error', 'Please provide a rating and a comment',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.put(FavoritesController());
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 700,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: widget.placeData["imageurl"].toString(),
              height: double.infinity,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 30, color: Color.fromARGB(255, 157, 255, 239)),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                bool newLikeStatus = !favoritesController.like.value;
                favoritesController.likeOrUnlike(widget.placeId, newLikeStatus);
              },
              child: Obx(() => Icon(
                    favoritesController.like.value
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    size: 30,
                    color: Colors.red,
                  )),
            ),
          ),
          scrollDetails(),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                launchUrl(Uri.parse(widget.placeData["location"].toString()),
                    mode: LaunchMode.externalApplication);
              },
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: ColorTheme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 8.0),
              ),
              child: const Text(
                "Get Direction",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget scrollDetails() {
    return DraggableScrollableSheet(
      builder: (context, scrollcontroller) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 250, 252, 253),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollcontroller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.placeData["title"].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.placeData["city"].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          launchUrl(
                              Uri.parse(widget.placeData["contact"].toString()),
                              mode: LaunchMode.inAppBrowserView);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: ColorTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text(
                          'Contact Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 45,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "What They Offer",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var offer in widget.placeData['offer'])
                        iconContainer(
                          icon: getIconForOffer(offer),
                          icontext: offer,
                          color: ColorTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.placeData["desc"].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                        ),
                        child: Row(
                          children: [
                            const Text(
                              "User Reviews",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 32,
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        backgroundColor: Colors.white,
                                        title: const Text('Submit Your Review'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Obx(
                                              () => Text(
                                                "Logged in as: ${reviewController.userName.value}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                _userRating = rating;
                                              },
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: _reviewController,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 6,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Write your review',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 5,
                                              backgroundColor:
                                                  ColorTheme.primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4,
                                                horizontal: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            onPressed: _submitReview,
                                            child: const Text(
                                              'Submit Review',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.add_comment_outlined),
                              ),
                            ),
                            // Sorting button
                            SizedBox(
                              width: 26,
                              child: IconButton(
                                onPressed: reviewController.toggleSortOrder,
                                icon: const Icon(Icons.swap_vert),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 236, 249, 245),
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(10, 10))),
                        height: 350, // Adjust this height as needed
                        child: Obx(() {
                          if (reviewController.reviews.isEmpty) {
                            return const Center(
                              child: Text('No reviews available'),
                            );
                          } else {
                            return ListView(
                              controller: scrollcontroller,
                              children: reviewController.reviews.map((review) {
                                return Card(
                                  elevation: 2,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    tileColor:
                                        const Color.fromARGB(62, 40, 250, 194),
                                    leading: review.profilePic != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                review.profilePic!),
                                          )
                                        : const CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                    title: Text(review.reviewer.toString()),
                                    subtitle: Text(review.text.toString()),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          review.rating.toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const Icon(Icons.star,
                                            size: 16, color: Colors.amber),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget iconContainer({
    required IconData icon,
    required String icontext,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.all(6),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1.5),
          ),
        ],
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: Colors.white),
          const SizedBox(height: 5),
          Text(
            icontext,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
