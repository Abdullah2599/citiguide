// import 'package:flutter/material.dart';
// import 'boxrotationmodel.dart';

// class BoxRotation extends StatefulWidget {
//   const BoxRotation({Key? key}) : super(key: key);

//   @override
//   _BoxRotationState createState() => _BoxRotationState();
// }

// class _BoxRotationState extends State<BoxRotation>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();

//     if (!BoxRotationModel.isInitialized) {
//       BoxRotationModel.boxRotationController = AnimationController(
//         vsync: this,
//         duration: Duration(seconds: 2),
//       );

//       BoxRotationModel.initializeAnimations();

//       // Start the animation immediately
//       BoxRotationModel.boxRotationController.forward();

//       BoxRotationModel.boxRotationController.addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           BoxRotationModel.boxRotationController.repeat();
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     if (BoxRotationModel.isInitialized) {
//       BoxRotationModel.boxRotationController.dispose();
//       BoxRotationModel.isInitialized = false;
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//         animation: BoxRotationModel.boxRotationController,
//         builder: (context, child) {
//           print('First Rotate: ${BoxRotationModel.firstRotateAnimation.value}');
//           print(
//               'Second Rotate: ${BoxRotationModel.secondRotateAnimation.value}');
//           print('Third Rotate: ${BoxRotationModel.thirdRotateAnimation.value}');
//           return Transform.rotate(
//             angle: BoxRotationModel.firstRotateAnimation.value,
//             child: Transform.rotate(
//               angle: BoxRotationModel.secondRotateAnimation.value,
//               child: Transform.rotate(
//                 angle: BoxRotationModel.thirdRotateAnimation.value,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       width: 81,
//                       height: 81,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 4,
//                         ),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     BoxRotationBuilder(
//                       color: Color.fromARGB(255, 0, 255, 234),
//                       offset: BoxRotationModel.greenCubeAnimation,
//                     ),
//                     BoxRotationBuilder(
//                       color: Color.fromARGB(255, 119, 255, 221),
//                       offset: BoxRotationModel.yellowCubeAnimation,
//                     ),
//                     BoxRotationBuilder(
//                       color: Color.fromARGB(255, 201, 255, 251),
//                       offset: BoxRotationModel.orangeCubeAnimation,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class BoxRotationBuilder extends StatelessWidget {
//   final Color color;
//   final Animation<Offset> offset;

//   const BoxRotationBuilder({
//     required this.color,
//     required this.offset,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: BoxRotationModel.boxRotationController,
//       child: RoundedCubeShape(
//         color: color,
//       ),
//       builder: (context, child) => Transform.translate(
//         offset: offset.value,
//         child: child,
//       ),
//     );
//   }
// }

// class RoundedCubeShape extends StatelessWidget {
//   final Color color;

//   const RoundedCubeShape({
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 30,
//       height: 30,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.rectangle,
//         borderRadius: BorderRadius.circular(4),
//       ),
//     );
//   }
// }
