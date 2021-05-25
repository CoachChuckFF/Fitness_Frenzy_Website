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
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

import 'package:flutter/cupertino.dart';

class SprinklesDrawer extends StatefulWidget {
  final double screenWidth;
  final double screenTopPadding;
  final double sideDrawerWidth;
  final double sideDrawerHeight;
  final double topButtonBarHeight;
  final bool visable;
  final Function onClose;

  SprinklesDrawer({
    this.screenWidth,
    this.screenTopPadding,
    this.sideDrawerHeight,
    this.sideDrawerWidth,
    this.topButtonBarHeight,
    this.visable,
    this.onClose,
    Key key
  }) : super(key: key);

  @override
  _SprinklesDrawerState createState() => _SprinklesDrawerState();
}

class _SprinklesDrawerState extends State<SprinklesDrawer> {

  @override
  void initState() { 
    super.initState();

  }
  
  @override
  void dispose(){

    super.dispose();
  }

  Widget _tableEntry(IconData icon, String data, String message, {double padding = 13, Color color}){
    return Tooltip(
      message: message,
      preferBelow: false,
      child: GestureDetector(
        onTap: (){
          CommonAssets.showSnackbar(context, message);
        },
        child: Container(
          color: FoodFrenzyColors.jjTransparent,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: padding),
                child: Icon(
                  icon,
                  color: color ?? FoodFrenzyColors.secondary,
                  // textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: padding),
                  child: AST(
                    data,
                    textAlign: TextAlign.right,
                    color: FoodFrenzyColors.secondary,
                    isBold: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomLeftDrawer(
      title: "Sprinkles Shop",
      screenWidth: widget.screenWidth,
      topPadding: widget.screenTopPadding,
      width: widget.sideDrawerWidth,
      height: widget.sideDrawerHeight,
      buttonHeight: widget.topButtonBarHeight,
      child: UserPointsStreamView(
        (points){
          List<double> pointInfo = points.getPointModifiers();

          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 13,
                  right: 13,
                ),
                child: PointsNumber(points.points)
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.camera, "+${TextHelpers.numberToShort(pointInfo[UserPoints.lpIndex])}", "Log Photo Points", padding: 8)
                          ),
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.weight, "+${TextHelpers.numberToShort(pointInfo[UserPoints.lwIndex])}", "Log Weight Points", padding: 8)
                          ),
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.utensilsAlt, "+${TextHelpers.numberToShort(pointInfo[UserPoints.lfIndex])}", "Log Food Points", padding: 8)
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.dumbbell, "+${TextHelpers.numberToShort(pointInfo[UserPoints.wrkIndex])}", "Log Workout Points")
                          ),
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.smileBeam, "+${TextHelpers.numberToShort(pointInfo[UserPoints.habIndex])}", "Log Moral Points")
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.gem, "x${TextHelpers.numberToShort(pointInfo[UserPoints.stkIndex])}", "Max Streak Multiplier", color: FoodFrenzyColors.jjOrange)
                          ),
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.gem, "${TextHelpers.numberToShort(pointInfo[UserPoints.ffbIndex])}%", "Food Frenzy Bonus", color: FoodFrenzyColors.jjRed)
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.gem, "+${TextHelpers.numberToShort(pointInfo[UserPoints.pdIndex])}", "Perfect Day Bonus", color: FoodFrenzyColors.jj7)
                          ),
                          Expanded(
                            child: _tableEntry(FontAwesomeIcons.gem, "+${TextHelpers.numberToShort(pointInfo[UserPoints.mpdIndex])}", "Max Points Per Day", color: FoodFrenzyColors.jj8)
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
              Divider(),
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SprinklesList()
                ),
              ),
            ]
          );
        }, onLoading: (){
          return Center(child: Loader(size: 55),);
        },
      ),
      visable: widget.visable,
      onExit: (){

        //UserState.firebase.update(_state.toMap());
        widget.onClose();
      },
    );
  }
}
       
