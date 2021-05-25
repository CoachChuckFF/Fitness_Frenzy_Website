/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';

class LogButtonAlt extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function onTap;
  final double width;
  final bool checked;
  final Color textColor;

  LogButtonAlt({this.color, this.icon, this.text, this.onTap, this.width, this.checked = false, this.textColor});

  @override
  Widget build(BuildContext context) {
    Color _textColor = textColor;
    if(textColor == null) _textColor = FoodFrenzyColors.tertiary;

    return Expanded(
      child: GestureDetector(
        onTap: (){
          HapticFeedback.heavyImpact();
          onTap();
        },
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: CommonAssets.shadow,
          ),
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(width: 21,),
              Center(
                child: Icon(
                (checked) ? Icons.check_box : icon, 
                  color: _textColor,
                ), 
              ),
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: AST(
                      text,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      color: _textColor,
                    ),
                  ),
                )
              ),
            ]
          )
        ),
      ),
    );
  }
}

class LogButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function onTap;
  final Function onDoubleTap;
  final Function onLongPress;
  final double width;
  final bool checked;
  final bool disabled;
  final Color textColor;
  final double bottomMargin;

  LogButton({this.color, this.icon, this.text, this.onTap, this.onDoubleTap, this.onLongPress, this.width, this.checked = false, this.textColor, this.bottomMargin = 10, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    Color _color = color;
    Color _textColor = textColor;
    if(textColor == null) _textColor = FoodFrenzyColors.tertiary;
    if(disabled){
      _color = FoodFrenzyColors.secondary;
      _textColor = FoodFrenzyColors.tertiary.withAlpha(100);
    }

    return Container(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          boxShadow: CommonAssets.shadow,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(bottom: bottomMargin),
        child: GestureDetector(
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          child: FlatButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            padding: EdgeInsets.all(21),
            color: _color,
            icon: Icon(
              (checked) ? Icons.check_box : icon, 
              color: _textColor,
            ), 
            textColor: _textColor,
            label: (text == null) ? Expanded(child: Container(),) : Expanded(
              child: AST(
                text,
                maxLines: 1,
                textAlign: TextAlign.center,
                color: _textColor,
                )
              ),
            onPressed: (){
              HapticFeedback.heavyImpact();
              if(!disabled)
                onTap();
            },
          ),
        ),
      ),
    );
  }
}

class LogSplitButton extends StatelessWidget {
  final Color colorLeft;
  final Color colorRight;
  final IconData iconLeft;
  final IconData iconRight;
  final Function onTapLeft;
  final Function onTapRight;
  final Function onLongPressRight;
  final double width;

  LogSplitButton({
    this.colorLeft, 
    this.colorRight, 
    this.iconLeft, 
    this.iconRight, 
    this.onTapLeft, 
    this.onTapRight, 
    this.onLongPressRight,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: CommonAssets.shadow,
              ),
              width: (width/2) - 5,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ) 
                ),
                padding: EdgeInsets.all(21),
                color: colorLeft,
                child: Icon(
                  iconLeft,
                  color: FoodFrenzyColors.tertiary,
                ), 
                textColor: FoodFrenzyColors.tertiary,
                onPressed: (){
                  HapticFeedback.heavyImpact();
                  onTapLeft();
                },
              ),
            ),
            Container(width: 10,),
            Container(
              width: (width/2) - 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: CommonAssets.shadow,
              ),
              child: (onLongPressRight != null) ?
              GestureDetector(
                onLongPress: (){
                  HapticFeedback.heavyImpact();
                  onLongPressRight();
                },
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  padding: EdgeInsets.all(21),
                  color: colorRight,
                  child: Icon(
                    iconRight,
                    color: FoodFrenzyColors.tertiary,
                  ),
                  textColor: FoodFrenzyColors.tertiary,
                  onPressed: (){
                    HapticFeedback.heavyImpact();
                    onTapRight();
                  },
                ),
              ) :
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                padding: EdgeInsets.all(21),
                color: colorRight,
                child: Icon(
                  iconRight,
                  color: FoodFrenzyColors.tertiary,
                ),
                textColor: FoodFrenzyColors.tertiary,
                onPressed: (){
                  HapticFeedback.heavyImpact();
                  onTapRight();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}