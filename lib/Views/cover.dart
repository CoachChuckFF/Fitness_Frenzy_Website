/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/

//Internal
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class Cover extends StatelessWidget {
  final Color color;

  const Cover({this.color = Colors.transparent, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    double screenWidth = query.size.width;
    double screenHeight = query.size.height;

    return IgnorePointer(
      child: Container(
        color: color,
        width: screenWidth,
        height: screenHeight,
      ),
    );
  }
}
