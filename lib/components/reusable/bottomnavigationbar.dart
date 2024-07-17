import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String label;
  final bool citySelected; // Add citySelected to check if city is selected

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.label,
    required this.citySelected,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<IconData> listOfIcons = [
    Icons.place,
    Icons.home,
    Icons.favorite,
    Icons.person_rounded,
  ];

  final List<String> listOfStrings = [
    'Cities',
    'Home',
    'Favorites',
    'Account',
  ];

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return Container(
      height: displayWidth * .180,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          return InkWell(
            onTap: () {
              if (index == 1 && !widget.citySelected) {
                Get.snackbar('Select City', 'Please select a city first.');
                return;
              }
              widget.onTap(index);
              HapticFeedback.lightImpact();
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == widget.currentIndex
                          ? displayWidth * .32
                          : displayWidth * .18,
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: index == widget.currentIndex
                            ? displayWidth * .15
                            : 0,
                        width: index == widget.currentIndex
                            ? displayWidth * .32
                            : 0,
                        decoration: BoxDecoration(
                          color: index == widget.currentIndex
                              ? Colors.blueAccent.withOpacity(.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == widget.currentIndex
                          ? displayWidth * .31
                          : displayWidth * .18,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            listOfIcons[index],
                            size: displayWidth * .075,
                            color: index == widget.currentIndex
                                ? Colors.blueAccent
                                : Colors.black26,
                          ),
                          AnimatedOpacity(
                            opacity: index == widget.currentIndex ? 1 : 0,
                            duration: Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Text(
                              index == widget.currentIndex
                                  ? '${listOfStrings[index]}'
                                  : '',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}














// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   final int currentIndex;
//   final Function(int) onTap;
//   final String label;
//   final bool citySelected; // Add citySelected to check if city is selected

//   const CustomBottomNavigationBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//     required this.label,
//     required this.citySelected,
//   }) : super(key: key);

//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   final List<IconData> listOfIcons = [
//     Icons.place,
//     Icons.home,
//     Icons.favorite,
//     Icons.person_rounded,
//   ];

//   final List<String> listOfStrings = [
//     'Cities',
//     'Home',
//     'Favorites',
//     'Account',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     double displayWidth = MediaQuery.of(context).size.width;

//     return Container(
//       margin: EdgeInsets.all(displayWidth * .02),
//       height: displayWidth * .155,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.1),
//             blurRadius: 30,
//             offset: Offset(0, 10),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(7),
//       ),
//       child: ListView.builder(
//         itemCount: 4, // Change itemCount to 4 for four items
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
//         itemBuilder: (context, index) {
//           // Handle tapping logic
//           return InkWell(
//             onTap: () {
//               if (index == 1 && !widget.citySelected) {
//                 print('Select a city first');
//                 return;
//               }
//               setState(() {
//                 widget.onTap(index);
//                 HapticFeedback.lightImpact();
//               });
//             },
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: Stack(
//               children: [
//                 AnimatedContainer(
//                   duration: Duration(seconds: 1),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   width: index == widget.currentIndex
//                       ? displayWidth * .32
//                       : displayWidth * .18,
//                   alignment: Alignment.center,
//                   child: AnimatedContainer(
//                     duration: Duration(seconds: 1),
//                     curve: Curves.fastLinearToSlowEaseIn,
//                     height:
//                         index == widget.currentIndex ? displayWidth * .12 : 0,
//                     width:
//                         index == widget.currentIndex ? displayWidth * .32 : 0,
//                     decoration: BoxDecoration(
//                       color: index == widget.currentIndex
//                           ? Colors.blueAccent.withOpacity(.2)
//                           : Colors.transparent,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                 ),
//                 AnimatedContainer(
//                   duration: Duration(seconds: 1),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   width: index == widget.currentIndex
//                       ? displayWidth * .31
//                       : displayWidth * .18,
//                   alignment: Alignment.center,
//                   child: Stack(
//                     children: [
//                       Row(
//                         children: [
//                           AnimatedContainer(
//                             duration: Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             width: index == widget.currentIndex
//                                 ? displayWidth * .13
//                                 : 0,
//                           ),
//                           AnimatedOpacity(
//                             opacity: index == widget.currentIndex ? 1 : 0,
//                             duration: Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             child: Text(
//                               index == widget.currentIndex
//                                   ? '${listOfStrings[index]}'
//                                   : '',
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           AnimatedContainer(
//                             duration: Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             width: index == widget.currentIndex
//                                 ? displayWidth * .03
//                                 : 20,
//                           ),
//                           Icon(
//                             listOfIcons[index],
//                             size: displayWidth * .076,
//                             color: index == widget.currentIndex
//                                 ? Colors.blueAccent
//                                 : Colors.black26,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }