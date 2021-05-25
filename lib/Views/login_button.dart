/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';


class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;
  final double width;

  LoginButton({this.color, this.icon, this.text, this.loginMethod, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        boxShadow: CommonAssets.shadow,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        padding: EdgeInsets.all(21),
        color: color,
        icon: Icon(icon, color: FoodFrenzyColors.jjWhite,), 
        textColor: FoodFrenzyColors.jjWhite,
        label: Expanded(
          child: AST(
            text,
            color: FoodFrenzyColors.tertiary,
            textAlign: TextAlign.center
          )
        ),
        onPressed: loginMethod
      ),
    );
  }
}