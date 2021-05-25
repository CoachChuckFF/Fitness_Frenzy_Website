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

class CustomPopupDefines{
  static int duration = 133; //133
}

class CustomPopupFull extends StatefulWidget {
  final Widget mainWidget;
  final double middleWidth;
  final bool visable;
  final bool padding;

  final double topButtonBarWidth;
  final double topButtonBarHeight;
  final bool topButtonBarHasShadow;
  final IconData iconLeft;
  final IconData iconRight;
  final bool iconLeftEnable;
  final bool iconRightEnable;
  final String title;
  final String message;
  final Function onLeft;
  final Function onDTLeft;
  final Function onRight;


  CustomPopupFull(
    {
      this.mainWidget,
      this.middleWidth,
      this.visable, 
      this.padding = true,

      @required this.topButtonBarWidth,
      @required this.topButtonBarHeight,
      this.topButtonBarHasShadow = true,
      this.iconLeftEnable = true,
      @required this.iconLeft,
      this.onLeft,
      this.onDTLeft,
      @required this.title,
      @required this.message,
      this.iconRightEnable = true,
      @required this.iconRight,
      this.onRight,
    }
  );

  @override
  _CustomPopupFullState createState() => _CustomPopupFullState();
}

class _CustomPopupFullState extends State<CustomPopupFull> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CommonAssets.topButtonBar(
              topButtonBarWidth: widget.topButtonBarWidth,
              topButtonBarHeight: widget.topButtonBarHeight,
              hasShadow: widget.topButtonBarHasShadow,
              iconLeftEnable: widget.iconLeftEnable,
              iconRightEnable: widget.iconRightEnable,
              iconLeft: widget.iconLeft, 
              title: widget.title,
              message: widget.message, 
              iconRight: widget.iconRight,
              onDTLeft: widget.onDTLeft,
              onLeft: widget.onLeft,
              onRight: widget.onRight,
            ),
            Expanded(
              flex: (widget.padding) ? 21 : 22,
              child: Container(
                width: widget.middleWidth,
                child: widget.mainWidget,
              ),
            ),
            if(widget.padding)
              Expanded(
                flex: 1,
                child: Container()
              )
          ],
        ),
      ),
    );
  }
}

class CustomPopupWhole extends StatefulWidget {
  final Widget mainWidget;
  final String bottomButtonTitle;
  final IconData bottomButtonIcon;
  final Function onExit;
  final Function onDTExit;
  final Function onBottomButtonTap;
  final double middleWidth;
  final double buttonWidth;
  final bool visable;
  final bool disabled;
  final bool shouldAnimate;
  final bool hasButton;

  final double topButtonBarWidth;
  final double topButtonBarHeight;
  final bool topButtonBarHasShadow;
  final IconData iconLeft;
  final IconData iconRight;
  final bool iconLeftEnable;
  final bool iconRightEnable;
  final String title;
  final String message;
  final Function onLeft;
  final Function onDTLeft;
  final Function onRight;

  CustomPopupWhole(
    {
      this.mainWidget,
      this.bottomButtonTitle,
      this.bottomButtonIcon,
      this.onDTExit,
      this.onExit,
      this.onBottomButtonTap,
      this.middleWidth,
      this.buttonWidth,
      this.visable, 
      this.disabled = false,
      this.shouldAnimate = true,
      this.hasButton = true,

      @required this.topButtonBarWidth,
      @required this.topButtonBarHeight,
      this.topButtonBarHasShadow = true,
      this.iconLeftEnable = true,
      @required this.iconLeft,
      this.onLeft,
      this.onDTLeft,
      @required this.title,
      @required this.message,
      this.iconRightEnable = true,
      @required this.iconRight,
      this.onRight,
    }
  );

  @override
  _CustomPopupWholeState createState() => _CustomPopupWholeState();
}

class _CustomPopupWholeState extends State<CustomPopupWhole> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CommonAssets.topButtonBar(
              topButtonBarWidth: widget.topButtonBarWidth,
              topButtonBarHeight: widget.topButtonBarHeight,
              hasShadow: widget.topButtonBarHasShadow,
              iconLeftEnable: widget.iconLeftEnable,
              iconRightEnable: widget.iconRightEnable,
              iconLeft: widget.iconLeft, 
              title: widget.title, 
              message: widget.message, 
              iconRight: widget.iconRight,
              onDTLeft: widget.onDTLeft,
              onLeft: widget.onLeft,
              onRight: widget.onRight,
            ),
            Expanded(
              flex: 17,
              child: Container(
                width: widget.middleWidth,
                child: widget.mainWidget,
              )
            ),
            if(widget.hasButton)
              Expanded(
                flex: 5,
                child: Center(
                  child: LogButton(
                    onDoubleTap: widget.onDTExit,
                    width: widget.buttonWidth,
                    text: widget.bottomButtonTitle,
                    icon: widget.bottomButtonIcon,
                    disabled: widget.disabled,
                    color: FoodFrenzyColors.main,
                    textColor: FoodFrenzyColors.tertiary,
                    onTap: (){
                      if(!widget.disabled && widget.shouldAnimate){
                        controller.reverse();
                      } else {
                        if(widget.onBottomButtonTap != null) widget.onBottomButtonTap();
                      }
                    }
                  ),
                )
              ),
          ],
        ),
      ),
    );
  }
}

class CustomActionPopupWhole extends StatefulWidget {
  final Widget mainWidget;
  final String bottomButtonTitle;
  final IconData bottomButtonIcon;
  final Function onAction;
  final double middleWidth;
  final double buttonWidth;
  final bool visable;

  final double topButtonBarWidth;
  final double topButtonBarHeight;
  final bool topButtonBarHasShadow;
  final IconData iconLeft;
  final IconData iconRight;
  final bool iconLeftEnable;
  final bool iconRightEnable;
  final String title;
  final String message;
  final Function onLeft;
  final Function onDTLeft;
  final Function onRight;

  CustomActionPopupWhole(
    {
      this.mainWidget,
      this.bottomButtonTitle,
      this.bottomButtonIcon,
      this.onAction,
      this.middleWidth,
      this.buttonWidth,
      this.visable, 
      this.topButtonBarHasShadow = true,

      @required this.topButtonBarWidth,
      @required this.topButtonBarHeight,
      this.iconLeftEnable = true,
      @required this.iconLeft,
      this.onLeft,
      this.onDTLeft,
      @required this.title,
      @required this.message,
      this.iconRightEnable = true,
      @required this.iconRight,
      this.onRight,
    }
  );

  @override
  _CustomActionPopupWholeState createState() => _CustomActionPopupWholeState();
}

class _CustomActionPopupWholeState extends State<CustomActionPopupWhole> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
          // widget.onExit();
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CommonAssets.topButtonBar(
              topButtonBarWidth: widget.topButtonBarWidth,
              topButtonBarHeight: widget.topButtonBarHeight,
              hasShadow: widget.topButtonBarHasShadow,
              iconLeftEnable: widget.iconLeftEnable,
              iconRightEnable: widget.iconRightEnable,
              iconLeft: widget.iconLeft, 
              title: widget.title, 
              message: widget.message, 
              iconRight: widget.iconRight,
              onDTLeft: widget.onDTLeft,
              onLeft: widget.onLeft,
              onRight: widget.onRight,
            ),
            Expanded(
              flex: 17,
              child: Container(
                width: widget.middleWidth,
                child: widget.mainWidget,
              )
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: LogButton(
                  width: widget.buttonWidth,
                  text: widget.bottomButtonTitle,
                  icon: widget.bottomButtonIcon,
                  color: FoodFrenzyColors.main,
                  onTap: (){widget.onAction();}
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class CutsomPopupSplitNoButton extends StatefulWidget {
  final Widget topWidget;
  final Widget bottomWidget;
  final double middleWidth;
  final bool visable;
  final bool tutorial;
  final bool active;

  final Widget topButtonBar;

  final double topButtonBarWidth;
  final double topButtonBarHeight;
  final IconData iconLeft;
  final IconData iconRight;
  final bool iconLeftEnable;
  final bool iconRightEnable;
  final String title;
  final String message;
  final Function onLeft;
  final Function onDTLeft;
  final Function onRight;

  CutsomPopupSplitNoButton(
    {
      this.topWidget,
      this.bottomWidget,
      this.middleWidth,
      this.visable, 
      this.tutorial = false,
      this.active = false,

      this.topButtonBar = null,

      this.topButtonBarWidth,
      this.topButtonBarHeight,
      this.iconLeftEnable = true,
      this.iconLeft,
      this.onLeft,
      this.onDTLeft,
      this.title,
      this.message,
      this.iconRightEnable = true,
      this.iconRight,
      this.onRight,
    }
  );

  @override
  _CutsomPopupSplitNoButtonState createState() => _CutsomPopupSplitNoButtonState();
}

class _CutsomPopupSplitNoButtonState extends State<CutsomPopupSplitNoButton> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if(widget.topButtonBar != null)
              widget.topButtonBar,
            if(widget.topButtonBar == null)
              CommonAssets.topButtonBar(
                topButtonBarWidth: widget.topButtonBarWidth,
                topButtonBarHeight: widget.topButtonBarHeight,
                iconLeftEnable: widget.iconLeftEnable,
                iconRightEnable: widget.iconRightEnable,
                iconLeft: widget.iconLeft, 
                title: widget.title, 
                message: widget.message, 
                iconRight: widget.iconRight,
                onDTLeft: widget.onDTLeft,
                onLeft: widget.onLeft,
                onRight: widget.onRight,
              ),
            Expanded(
              flex: 6,
              child: Container(
                width: widget.middleWidth,
                child: widget.topWidget,
              )
            ),
            Expanded(
              flex: 11,
              child: Container(
                width: widget.middleWidth,
                child: widget.bottomWidget
              )
            ),
            Expanded(flex: 3, child: Container(),),
          ],
        ),
      ),
    );
  }
}

class CustomPopupSplit extends StatefulWidget {
  final Widget topWidget;
  final Widget bottomWidget;
  final String bottomButtonTitle;
  final IconData bottomButtonIcon;
  final Function onExit;
  final double middleWidth;
  final double buttonWidth;
  final bool visable;
  final bool tutorial;
  final bool active;

  final Widget topButtonBar;

  final double topButtonBarWidth;
  final double topButtonBarHeight;
  final IconData iconLeft;
  final IconData iconRight;
  final bool iconLeftEnable;
  final bool iconRightEnable;
  final String title;
  final String message;
  final Function onLeft;
  final Function onDTLeft;
  final Function onRight;

  CustomPopupSplit(
    {
      this.topWidget,
      this.bottomWidget,
      this.bottomButtonTitle,
      this.bottomButtonIcon,
      this.onExit,
      this.middleWidth,
      this.buttonWidth,
      this.visable, 
      this.tutorial = false,
      this.active = false,

      this.topButtonBar = null,

      this.topButtonBarWidth,
      this.topButtonBarHeight,
      this.iconLeftEnable = true,
      this.iconLeft,
      this.onLeft,
      this.onDTLeft,
      this.title,
      this.message,
      this.iconRightEnable = true,
      this.iconRight,
      this.onRight,
    }
  );

  @override
  _CustomPopupSplitState createState() => _CustomPopupSplitState();
}

class _CustomPopupSplitState extends State<CustomPopupSplit> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if(widget.topButtonBar != null)
              widget.topButtonBar,
            if(widget.topButtonBar == null)
              CommonAssets.topButtonBar(
                topButtonBarWidth: widget.topButtonBarWidth,
                topButtonBarHeight: widget.topButtonBarHeight,
                iconLeftEnable: widget.iconLeftEnable,
                iconRightEnable: widget.iconRightEnable,
                iconLeft: widget.iconLeft, 
                title: widget.title, 
                message: widget.message, 
                iconRight: widget.iconRight,
                onDTLeft: widget.onDTLeft,
                onLeft: widget.onLeft,
                onRight: widget.onRight,
              ),
            Expanded(
              flex: 6,
              child: Container(
                width: widget.middleWidth,
                child: widget.topWidget,
              )
            ),
            Expanded(
              flex: 11,
              child: Container(
                width: widget.middleWidth,
                child: widget.bottomWidget
              )
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: LogButton(
                  width: widget.buttonWidth,
                  text: widget.bottomButtonTitle,
                  icon: widget.bottomButtonIcon,
                  color: (widget.tutorial) ? ((widget.active) ? FoodFrenzyColors.main : FoodFrenzyColors.jjTransparent) : FoodFrenzyColors.main,
                  textColor: (widget.tutorial) ? ((widget.active) ? null : FoodFrenzyColors.jjTransparent) : null,
                  onTap: (){controller.reverse();}
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPopupTwoButtonSplit extends StatefulWidget {
  final Widget mainWidget;
  final IconData bottomButtonIconLeft;
  final IconData bottomButtonIconRight;
  final Color bottomButtonColorLeft;
  final Color bottomButtonColorRight;
  final Function onBottomButtonLeft;
  final Function onBottomButtonRight;
  final Function onBottomButtonRightLongPress;
  final double middleWidth;
  final double buttonWidth;
  final bool visable;

  final double topButtonBarWidth;
  final double topButtonBarHeight;
  final IconData iconLeft;
  final IconData iconRight;
  final bool iconLeftEnable;
  final bool iconRightEnable;
  final String title;
  final String message;
  final Function onLeft;
  final Function onDTLeft;
  final Function onRight;

  CustomPopupTwoButtonSplit(
    {
      this.mainWidget,
      this.bottomButtonIconLeft,
      this.bottomButtonIconRight,
      this.bottomButtonColorLeft,
      this.bottomButtonColorRight,
      this.onBottomButtonLeft,
      this.onBottomButtonRight,
      this.onBottomButtonRightLongPress,
      this.middleWidth,
      this.buttonWidth,
      this.visable, 

      @required this.topButtonBarWidth,
      @required this.topButtonBarHeight,
      this.iconLeftEnable = true,
      @required this.iconLeft,
      this.onLeft,
      this.onDTLeft,
      @required this.title,
      @required this.message,
      this.iconRightEnable = true,
      @required this.iconRight,
      this.onRight,
    }
  );

  @override
  _CustomPopupTwoButtonSplitState createState() => _CustomPopupTwoButtonSplitState();
}

class _CustomPopupTwoButtonSplitState extends State<CustomPopupTwoButtonSplit> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CommonAssets.topButtonBar(
              topButtonBarWidth: widget.topButtonBarWidth,
              topButtonBarHeight: widget.topButtonBarHeight,
              iconLeftEnable: widget.iconLeftEnable,
              iconRightEnable: widget.iconRightEnable,
              iconLeft: widget.iconLeft, 
              title: widget.title, 
              message: widget.message, 
              iconRight: widget.iconRight,
              onDTLeft: widget.onDTLeft,
              onLeft: widget.onLeft,
              onRight: widget.onRight,
            ),
            Expanded(
              flex: 17,
              child: Container(
                width: widget.middleWidth,
                child: widget.mainWidget
              )
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: LogSplitButton(
                  width: widget.buttonWidth,
                  colorLeft: widget.bottomButtonColorLeft ?? FoodFrenzyColors.main,
                  colorRight: widget.bottomButtonColorRight ?? FoodFrenzyColors.main,
                  iconLeft: widget.bottomButtonIconLeft,
                  iconRight: widget.bottomButtonIconRight,
                  onTapLeft: widget.onBottomButtonLeft,
                  onTapRight: widget.onBottomButtonRight,
                  onLongPressRight: widget.onBottomButtonRightLongPress,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPopup extends StatefulWidget {
  final double topButtonBarHeight;
  final double buttonWidth;
  final double screenHeight;
  final double screenWidth;
  final double middleWidth;
  final Function onExit;
  final Widget child;
  final bool visable;

  CustomPopup(
    {
      this.topButtonBarHeight,
      this.buttonWidth,
      this.screenHeight,
      this.screenWidth,
      this.middleWidth,
      this.onExit, 
      this.child, 
      this.visable, 
    }
  );

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> with SingleTickerProviderStateMixin{
  Animation<double> fadeAnimation;
  
  AnimationController controller;
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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

    Timer(Duration(seconds: 3), (){
    });
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: SafeArea(
        child: Center(
          child: Container(
            width: widget.middleWidth,
            height: widget.screenHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: widget.topButtonBarHeight, 
                  width: widget.screenWidth,
                ), //to not interfere with top button bar
                Expanded(
                  flex: 17,
                  child: widget.child
                ),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: LogButton(
                      width: widget.buttonWidth,
                      text: "Set",
                      icon: FontAwesomeIcons.check,
                      color: FoodFrenzyColors.main,
                      onTap: (){
                        controller.reverse();
                      }
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPopupSingleNotSafe extends StatefulWidget {
  final Widget mainWidget;
  final bool visable;
  final Function onExit;

  CustomPopupSingleNotSafe(
    {
      this.mainWidget,
      this.visable, 
      this.onExit,
    }
  );

  @override
  _CustomPopupSingleNotSafeState createState() => _CustomPopupSingleNotSafeState();
}

class _CustomPopupSingleNotSafeState extends State<CustomPopupSingleNotSafe> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: Container(
        color: FoodFrenzyColors.jjBlack.withAlpha(241),
        child: SafeArea(
          child: widget.mainWidget
        ),
      ),
    );
  }
}

class CustomPopupSingle extends StatefulWidget {
  final Widget mainWidget;
  final bool visable;
  final Function onExit;

  CustomPopupSingle(
    {
      this.mainWidget,
      this.visable, 
      this.onExit,
    }
  );

  @override
  _CustomPopupSingleState createState() => _CustomPopupSingleState();
}

class _CustomPopupSingleState extends State<CustomPopupSingle> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: GestureDetector(
        onTap: (){controller.reverse();},
        child: Container(
          color: FoodFrenzyColors.jjBlack.withAlpha(200),
          child: SafeArea(
            child: Center(
              child: widget.mainWidget,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPopupSingleNonExit extends StatefulWidget {
  final Widget mainWidget;
  final bool visable;
  final Function onExit;

  CustomPopupSingleNonExit(
    {
      this.mainWidget,
      this.visable, 
      this.onExit,
    }
  );

  @override
  _CustomPopupSingleNonExitState createState() => _CustomPopupSingleNonExitState();
}

class _CustomPopupSingleNonExitState extends State<CustomPopupSingleNonExit> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: CustomPopupDefines.duration);
  Animation<double> fadeAnimation;
  AnimationController controller;
  bool _moving = false;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1.0
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
    controller.dispose();
    super.dispose();
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

    return FadeTransition(
      opacity: fadeAnimation,
      child: Container(
        color: FoodFrenzyColors.tertiary,
        child: SafeArea(
          child: Center(
            child: widget.mainWidget,
          ),
        ),
      ),
    );
  }
}