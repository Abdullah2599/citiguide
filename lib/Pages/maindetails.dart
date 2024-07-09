import 'dart:ui';
import 'package:citiguide/Theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/link.dart';
import 'package:citiguide/components/reusable/reusableicons.dart';
import 'package:url_launcher/url_launcher.dart';

// Define Review class (similar to previous)
class Review {
  final String reviewer;
  final double rating;
  final String text;

  Review({required this.reviewer, required this.rating, required this.text});
}

class TilesDetails extends StatefulWidget {
  final dynamic placeData;

  const TilesDetails({super.key, required this.placeData});

  @override
  _TilesDetailsState createState() => _TilesDetailsState();
}

class _TilesDetailsState extends State<TilesDetails> {
  // Sample reviews (replace with your actual data handling logic)
  List<Review> reviews = [
    Review(reviewer: "John Doe", rating: 4.5, text: "Great food and ambiance!"),
    Review(reviewer: "Rose Joe", rating: 5.0, text: "Highly recommended!"),
  ];

  // User input controllers
  double _userRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  // Function to submit a new review
  void _submitReview() {
    String reviewer = "User"; // Replace with actual user info if available
    double rating = _userRating;
    String text = _reviewController.text;

    // Create a new Review object
    Review newReview = Review(reviewer: reviewer, rating: rating, text: text);

    // Update state with new review
    setState(() {
      reviews.add(newReview);
      _userRating = 0;
      _reviewController.clear();
    });

    // Show a snackbar or any other feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review submitted!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 700,
            width: double.infinity,
            child: Image.network(
              widget.placeData["imageurl"].toString(),
              height: double.infinity,
              fit: BoxFit.fitHeight,
            ),
          ),
          buttonArrow(context),
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
                backgroundColor: Colors.blue,
                shape: const StadiumBorder(),
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
                          backgroundColor:
                              const Color.fromARGB(255, 14, 175, 175),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
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
                // SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var offer in widget.placeData['offer'])
                        iconContainer(
                          icon: getIconForOffer(offer),
                          icontext: offer, // Show the offer text here
                          color: ColorTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
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
                      SizedBox(height: 4),
                      Text(
                        widget.placeData["desc"].toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(185, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Write a Review"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingBar.builder(
                                    initialRating: _userRating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 30,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _userRating = rating;
                                      });
                                    },
                                  ),
                                  TextField(
                                    controller: _reviewController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      labelText: 'Write your review here',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _submitReview();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Submit"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_comment_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ...reviews.map((review) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  review.reviewer,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < review.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(review.text),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 100),
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
      height: 60,
      width: 80,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(height: 5),
          Text(
            icontext,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
//   Widget iconContainer(
//       {required IconData icon, required String icontext, Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: 80,
//         width: 80,
//         child: Card(
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 2,
//                 ),
//                 Icon(
//                   icon,
//                   size: 30,
//                   color: color ??
//                       Colors.black54, // Default to black54 if color is null
//                 ),
//                 SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   icontext,
//                   style: const TextStyle(color: Colors.black54, fontSize: 10),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

  Widget buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
