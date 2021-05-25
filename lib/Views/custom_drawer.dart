/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/

// Used Packages
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:flutter/material.dart';
// import 'package:/Users/christian/Programs/flutter/packages/flutter/lib/src/material/constants.dart';

class CustomDrawerDefines{
  static int duration = 233;
}

class CustomLeftDrawer extends StatefulWidget {
  final double screenWidth;
  final double width;
  final double height;
  final double topPadding;
  final double buttonHeight;
  final Function onExit;
  final Widget child;
  final String title;
  final bool visable;

  CustomLeftDrawer(
    {
      this.width, 
      this.screenWidth,
      this.height, 
      this.topPadding, 
      this.buttonHeight, 
      this.child, 
      this.title, 
      this.onExit, 
      this.visable
    }
  );

  @override
  _CustomLeftDrawerState createState() => _CustomLeftDrawerState();
}

class _CustomLeftDrawerState extends State<CustomLeftDrawer> with SingleTickerProviderStateMixin{
  Animation<double> slideAnimation;
  Animation<double> fadeAnimation;
  
  AnimationController controller;
  Duration duration = Duration(milliseconds: CustomDrawerDefines.duration);
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    slideAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 200
    ).animate(controller)..addListener((){
      _moving = true;
      setState((){
      });
    })..addStatusListener((status){
      switch(status){
        case AnimationStatus.completed:
        break;
        case AnimationStatus.dismissed:
          _moving = false;
          widget.onExit();
      break;
        case AnimationStatus.forward:
        break;
        case AnimationStatus.reverse:
        break;
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  _handleSwipeLeft(DragEndDetails details){
    CommonAssets.handleSwipe(
      details,
      onLeft: (){
        controller.reverse();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    
    if(!widget.visable && !_moving){
      return Container();
    } else if(!widget.visable){
      controller.reverse();
    }else if(!_moving){
      controller.forward();
    }

    return Positioned(
      left: -widget.width + (slideAnimation.value * widget.width),
      child: Row(
        children: <Widget>[
          Container(
            color: FoodFrenzyColors.tertiary,
            padding: EdgeInsets.only(bottom: (kBottomNavigationBarHeight)),
            width: widget.width,
            height: widget.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(height: widget.topPadding),
                GestureDetector(
                  onHorizontalDragEnd: _handleSwipeLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 13, right: 13),
                    color: FoodFrenzyColors.jjTransparent,
                    height: widget.buttonHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(child: Container()),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: AST(
                              widget.title, 
                              color: FoodFrenzyColors.secondary,
                              size: 21,
                              isBold: true,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.angleLeft, 
                              color: FoodFrenzyColors.secondary,
                            ),
                            alignment: Alignment.centerRight,
                            onPressed: (){
                              controller.reverse();
                            }
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 13, right: 13),
                    child: widget.child,
                  )
                ),
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              height: widget.height,
              width: widget.screenWidth,
              color: FoodFrenzyColors.jjBlack.withAlpha(fadeAnimation.value.toInt())
            ),
            onHorizontalDragEnd: _handleSwipeLeft,
            onTap: (){
              controller.reverse();
            },
          )
        ],
      )
    );
  }
}

class CustomRightDrawer extends StatefulWidget {
  final double width;
  final double height;
  final double screenWidth;
  final double topPadding;
  final double buttonHeight;
  final Function onExit;
  final Widget child;
  final String title;
  final bool visable;

  CustomRightDrawer(
    {
      this.width, 
      this.screenWidth,
      this.topPadding,
      this.height, 
      this.buttonHeight, 
      this.child, 
      this.title, 
      this.onExit, 
      this.visable
      }
    );

  @override
  _CustomRightDrawerState createState() => _CustomRightDrawerState();
}

class _CustomRightDrawerState extends State<CustomRightDrawer> with SingleTickerProviderStateMixin{
  Animation<double> slideAnimation;
  Animation<double> fadeAnimation;
  AnimationController controller;
  Duration duration = Duration(milliseconds: CustomDrawerDefines.duration);
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    slideAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 200
    ).animate(controller)..addListener((){
      _moving = true;
      setState((){
      });
    })..addStatusListener((status){
      switch(status){
        case AnimationStatus.completed:
        break;
        case AnimationStatus.dismissed:
          _moving = false;
          widget.onExit();
      break;
        case AnimationStatus.forward:
        break;
        case AnimationStatus.reverse:
        break;
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  _handleSwipeRight(DragEndDetails details){
    CommonAssets.handleSwipe(
      details,
      onRight: (){
        controller.reverse();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.visable && !_moving){
      return Container();
    } else if(!widget.visable){
      controller.reverse();
    }else if(!_moving){
      controller.forward();
    }

    return Positioned(
      left: 0 - (slideAnimation.value * widget.width),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Container(
              height: widget.height,
              width: widget.screenWidth,
              color: FoodFrenzyColors.jjBlack.withAlpha(fadeAnimation.value.toInt())
            ),
            onTap: (){
              controller.reverse();
            },
            onHorizontalDragEnd: _handleSwipeRight,
          ),
          Container(
            color: FoodFrenzyColors.tertiary,
            padding: EdgeInsets.only(bottom: (kBottomNavigationBarHeight)),
            width: widget.width,
            height: widget.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(height: widget.topPadding),
                GestureDetector(
                  onHorizontalDragEnd: _handleSwipeRight,
                  child: Container(
                    padding: EdgeInsets.only(left: 13, right: 13),
                    height: widget.buttonHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.angleRight, 
                              color: FoodFrenzyColors.secondary
                            ),
                            alignment: Alignment.centerLeft,
                            onPressed: (){
                              controller.reverse();
                            }
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: AST(
                              widget.title, 
                              isBold: true,
                              size: 21,
                              color: FoodFrenzyColors.secondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: (){},
                            alignment: Alignment.centerRight,
                            icon: Icon(
                              FontAwesomeIcons.infoCircle,
                              color: FoodFrenzyColors.secondary.withAlpha(0),
                            ),
                          ),
                        )
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 13, right: 13),
                    child: widget.child
                  )
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class CustomBottomDrawer extends StatefulWidget {
  final double width;
  final double height;
  final double screenHeight;
  final double buttonHeight;
  final Function onExit;
  final Widget child;
  final bool visable;

  CustomBottomDrawer(
    {
      this.width, 
      this.height, 
      this.screenHeight,
      this.buttonHeight, 
      this.child, 
      this.onExit, 
      this.visable
    }
  );

  @override
  _CustomBottomDrawerState createState() => _CustomBottomDrawerState();
}

class _CustomBottomDrawerState extends State<CustomBottomDrawer> with SingleTickerProviderStateMixin{
  Animation<double> slideAnimation;
  Animation<double> fadeAnimation;
  AnimationController controller;
  Duration duration = Duration(milliseconds: CustomDrawerDefines.duration);
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    slideAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 200
    ).animate(controller)..addListener((){
      _moving = true;
      setState((){
      });
    })..addStatusListener((status){
      switch(status){
        case AnimationStatus.completed:
        break;
        case AnimationStatus.dismissed:
          _moving = false;
          widget.onExit();
      break;
        case AnimationStatus.forward:
        break;
        case AnimationStatus.reverse:
        break;
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  _handleSwipeDown(DragEndDetails details){
    CommonAssets.handleSwipe(
      details,
      onDown: (){
        controller.reverse();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    
    if(!widget.visable && !_moving){
      return Container();
    } else if(!widget.visable){
      controller.reverse();
    }else if(!_moving){
      controller.forward();
    }

    return Positioned(
      bottom: (-1*widget.height) + (slideAnimation.value * widget.height),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              height: widget.screenHeight,
              width: widget.width,
              color: FoodFrenzyColors.jjBlack.withAlpha(fadeAnimation.value.toInt())
            ),
            onVerticalDragEnd: _handleSwipeDown,
            onTap: (){
              controller.reverse();
            },
          ),
          Container(
            color: FoodFrenzyColors.jjBlack.withAlpha(fadeAnimation.value.toInt()),
            child: Container(
              decoration: BoxDecoration(
                color: FoodFrenzyColors.tertiary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                )
              ),
              padding: EdgeInsets.only(left: 13, right: 13, bottom: 13),
              width: widget.width,
              height: widget.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      controller.reverse();
                    },
                    onVerticalDragEnd: _handleSwipeDown,
                    child: Container(
                      color: FoodFrenzyColors.jjTransparent,
                      height: widget.buttonHeight,
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.angleDown, 
                          color: FoodFrenzyColors.secondary
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: widget.child
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}