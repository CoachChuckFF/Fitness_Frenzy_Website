/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/
import 'dart:ui';
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class CommonAssets {

  static Widget buildLoader({double size = 55, Color color}){
    return Center(
      child: Loader(
        size: size,
        color: color,
      ),
    );
  }

  static List<BoxShadow> fullShadow(){
    return [
      BoxShadow(
        color: FoodFrenzyColors.secondary,
        spreadRadius: 1,
        blurRadius: 0,
        offset: Offset(1, 1), // changes position of shadow
      ),
      BoxShadow(
        color: FoodFrenzyColors.secondary,
        spreadRadius: 1,
        blurRadius: 2,
        offset: Offset(3, 3), // changes position of shadow
      )
    ];
  }

  static Widget _buildAccountabilibuddyButton(UserState state, String uid, bool isSelected, Function(String) onTap){
    String name = state.accountabilibuddies[uid];

    return Tooltip(
      message: uid.isEmpty ? "Thats me!" : "See $name's meals",
      preferBelow: false,
      child: GestureDetector(
        onTap: (){
          if(!isSelected){
            onTap(uid);
          }
        },
        child: Container(
          color: FoodFrenzyColors.jjTransparent,
          child: Center(
            child: LayoutBuilder(
              builder: (context, size) {
                return Container(
                  width: size.maxHeight,
                  margin: EdgeInsets.only(right: (uid.isEmpty) ? 0 : 8),
                  decoration: (isSelected) ?
                    BoxDecoration(
                      color: FoodFrenzyColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: CommonAssets.shadow,
                    ) :
                    null,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            (isSelected) ? ((uid.isEmpty) ? FontAwesomeIcons.userCrown : TextHelpers.getUserIcon()) : FontAwesomeIcons.user,
                            color: (isSelected) ? FoodFrenzyColors.tertiary : FoodFrenzyColors.secondary,
                          ),
                          Container(height: 3),
                          Expanded(
                            child: AST(
                              uid.isEmpty ? "Me" : name,
                              color: (isSelected) ? FoodFrenzyColors.tertiary : FoodFrenzyColors.secondary,
                              size: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      LOG.log("Could not launch url: $url", FoodFrenzyDebugging.crash);
    }
  }

  static void showSnackbar(BuildContext context, String message, {Duration duration}){
    int miliseconds = (message.length > 80) ? 8900 : 5500;
    MediaQueryData query = MediaQuery.of(context);


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: query.size.height * 0.1,
          padding: EdgeInsets.only(left: 13, right: 13),
          child: Column(
            children: [
              Icon(
                FontAwesomeIcons.angleDown,
                color: FoodFrenzyColors.tertiary,
              ),
              Container(height: 8,),
              Expanded(
                child: AST(
                  message,
                  maxLines: 3,
                  size: 25,
                  color: FoodFrenzyColors.tertiary,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: FoodFrenzyColors.secondary,
        duration: duration ?? Duration(milliseconds: miliseconds),
      )
    );
  }

  // onHorizontalDragEnd: (DragEndDetails details),
  // onVerticalDragEnd: (DragEndDetails details),
  static void handleSwipe(DragEndDetails details, {Function onRight, Function onUp, Function onLeft, Function onDown}){
    if (details.primaryVelocity > 0) { //swipe right up
      if(onRight != null) onRight();
      if(onDown != null) onDown();
    } else if (details.primaryVelocity < 0) { //swipe left down
      if(onLeft != null) onLeft();
      if(onUp != null) onUp();
    }
  }

  // onHorizontalDragStart: (DragEndDetails details),
  // onVerticalDragStart: (DragEndDetails details),
  static void cancelSwipe(DragStartDetails details){}

  static Widget buildAccountabilibuddyBar(UserState state, String selectedUID, Function(String) onTap){
    if(selectedUID == null) selectedUID = '';

    return Container(
      height: 60,
      child: Container(
        margin: EdgeInsets.only(left: 8.0, right: 8, top: 5, bottom: 5.0),
        child: Row(
          children: [
            Expanded(
              child: _buildAccountabilibuddyButton(state, '', selectedUID == '', onTap),
            ),
            Expanded(
              flex: 4,
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [FoodFrenzyColors.tertiary, Colors.transparent, Colors.transparent, FoodFrenzyColors.tertiary,],
                    stops: [0.0, 0.05, 0.95, 1.0], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  children: [
                    Container(width: 5,),
                    for (String uid in state.accountabilibuddies.keys)
                      _buildAccountabilibuddyButton(state, uid, selectedUID == uid, onTap)
                  ],
                ),
              )
            ),
          ] 
        )
      ),
    );
  }

  static Widget buildBlur(){
    return Container(
      // color: FoodFrenzyColors.tertiary.withOpacity(0.3),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
        child: Container(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  static Widget builScreenBlur(){
    return Container(
      // color: FoodFrenzyColors.tertiary.withOpacity(0.3),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.white.withOpacity(0.80),
        ),
      ),
    );
  }

  static Widget topButtonBar({
    @required double topButtonBarWidth,
    @required double topButtonBarHeight,
    bool iconLeftEnable = true,
    @required IconData iconLeft,
    Color iconLeftColor,
    Function onLeft,
    Function onDTLeft,
    @required String title,
    @required String message,
    bool iconRightEnable = true,
    Color iconRightColor,
    @required IconData iconRight,
    Function onRight,
    Function onDTRight,
    Color bgColor,
    bool hasShadow = true,
  }){
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: (bgColor == null) ? ((hasShadow) ? FoodFrenzyColors.tertiary : FoodFrenzyColors.jjTransparent) : bgColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: (hasShadow) ? CommonAssets.shadow : [],
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 13, right: 13),
          width: topButtonBarWidth,
          height: topButtonBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onDoubleTap: onDTLeft,
                child: IconButton(
                  icon: Icon(iconLeft, color: (iconLeftEnable) ? ((iconLeftColor != null) ? iconLeftColor : FoodFrenzyColors.secondary) : FoodFrenzyColors.jjTransparent),
                  onPressed: (){
                    if(onLeft != null && iconLeftEnable) onLeft();
                  }
                ),
              ),
              Expanded(
                child: Tooltip(
                  message: message,
                  preferBelow: true,
                  child: Center(
                    child: AST(
                      title, 
                      color: FoodFrenzyColors.secondary,
                      isBold: true,
                      size: 21,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onDoubleTap: onDTRight,
                child: IconButton(
                  icon: Icon(iconRight, color: (iconRightEnable) ? ((iconRightColor != null) ? iconRightColor : FoodFrenzyColors.secondary) : FoodFrenzyColors.jjTransparent),
                  onPressed: (){
                    if(onRight != null && iconRightEnable) onRight();
                  }
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  static Widget buildKey(String value, Function(String) onPress, {int flex: 2, bool enabled = true, bool visable = true, bool uppercase = false, Color color, Color textColor}){

    if(uppercase) value = value.toUpperCase();

    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: (){
          if(enabled){
            HapticFeedback.lightImpact();
            onPress(value);
          }
        },
        child: Container(
          color: FoodFrenzyColors.jjTransparent,
          margin: EdgeInsets.only(bottom: 8, left: 3, right: 3),
          child: (!visable) ? 
            Container() :
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: (color != null && enabled) ? color : FoodFrenzyColors.tertiary,
                boxShadow: CommonAssets.shadow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: AST(
                value,
                color: (textColor != null) ?
                  ((enabled) ? textColor : FoodFrenzyColors.secondary.withAlpha(34)) :
                  ((enabled) ? FoodFrenzyColors.secondary : FoodFrenzyColors.secondary.withAlpha(34)),
                textAlign: TextAlign.center,
                size: 34,
              ), 
            ),
        ),
      ),
    );
  }

  static Widget calcMacroKeypad(Function handleButton, bool Function(String) getButtonEnabled, bool plus, bool minus, bool times, bool div, int macroState){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildKey("+", handleButton, enabled: true, color: (plus) ? FoodFrenzyColors.main : null, textColor: (plus) ? FoodFrenzyColors.tertiary : null),
              buildKey("-", handleButton, enabled: true, color: (minus) ? FoodFrenzyColors.main : null, textColor: (minus) ? FoodFrenzyColors.tertiary : null),
              buildKey("*", handleButton, enabled: true, color: (times) ? FoodFrenzyColors.main : null, textColor: (times) ? FoodFrenzyColors.tertiary : null),
              buildKey("/", handleButton, enabled: true, color: (div) ? FoodFrenzyColors.main : null, textColor: (div) ? FoodFrenzyColors.tertiary : null),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("❌", handleButton, enabled: getButtonEnabled("❌"), textColor: FoodFrenzyColors.tertiary),
              buildKey("f", handleButton, enabled: getButtonEnabled("f"), color: (macroState == 0) ? FoodFrenzyColors.main : null, textColor: (macroState == 0) ? FoodFrenzyColors.tertiary : null),
              buildKey("c", handleButton, enabled: getButtonEnabled("c"), color: (macroState == 1) ? FoodFrenzyColors.main : null, textColor: (macroState == 1) ? FoodFrenzyColors.tertiary : null),
              buildKey("p", handleButton, enabled: getButtonEnabled("p"), color: (macroState == 2) ? FoodFrenzyColors.main : null, textColor: (macroState == 2) ? FoodFrenzyColors.tertiary : null),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("1", handleButton, enabled: getButtonEnabled("1")),
              buildKey("2", handleButton, enabled: getButtonEnabled("2")),
              buildKey("3", handleButton, enabled: getButtonEnabled("3")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("4", handleButton, enabled: getButtonEnabled("4")),
              buildKey("5", handleButton, enabled: getButtonEnabled("5")),
              buildKey("6", handleButton, enabled: getButtonEnabled("6")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("7", handleButton, enabled: getButtonEnabled("7")),
              buildKey("8", handleButton, enabled: getButtonEnabled("8")),
              buildKey("9", handleButton, enabled: getButtonEnabled("9")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("", handleButton, enabled: false, visable: false),
              buildKey("0", handleButton, enabled: getButtonEnabled("0")),
              buildKey("=", handleButton, enabled: getButtonEnabled("=")),
            ],
          )
        ),
      ],
    );
  }

  static Widget calcCalKeypad(Function handleButton, bool Function(String) getButtonEnabled, bool plus, bool minus, bool times, bool div){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildKey("+", handleButton, enabled: true, color: (plus) ? FoodFrenzyColors.main : null, textColor: (plus) ? FoodFrenzyColors.tertiary : null),
              buildKey("-", handleButton, enabled: true, color: (minus) ? FoodFrenzyColors.main : null, textColor: (minus) ? FoodFrenzyColors.tertiary : null),
              buildKey("*", handleButton, enabled: true, color: (times) ? FoodFrenzyColors.main : null, textColor: (times) ? FoodFrenzyColors.tertiary : null),
              buildKey("/", handleButton, enabled: true, color: (div) ? FoodFrenzyColors.main : null, textColor: (div) ? FoodFrenzyColors.tertiary : null),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("❌", handleButton, enabled: getButtonEnabled("❌"), textColor: FoodFrenzyColors.tertiary),
              buildKey("", handleButton, enabled: false, visable: false),
              buildKey("", handleButton, enabled: false, visable: false),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("1", handleButton, enabled: getButtonEnabled("1")),
              buildKey("2", handleButton, enabled: getButtonEnabled("2")),
              buildKey("3", handleButton, enabled: getButtonEnabled("3")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("4", handleButton, enabled: getButtonEnabled("4")),
              buildKey("5", handleButton, enabled: getButtonEnabled("5")),
              buildKey("6", handleButton, enabled: getButtonEnabled("6")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("7", handleButton, enabled: getButtonEnabled("7")),
              buildKey("8", handleButton, enabled: getButtonEnabled("8")),
              buildKey("9", handleButton, enabled: getButtonEnabled("9")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("", handleButton, enabled: false, visable: false),
              buildKey("0", handleButton, enabled: getButtonEnabled("0")),
              buildKey("=", handleButton, enabled: getButtonEnabled("=")),
            ],
          )
        ),
      ],
    );
  }

  static Widget numpad(Function handleButton, bool Function(String) getButtonEnabled, {bool neg = false}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("C", handleButton, enabled: getButtonEnabled("C"), color: FoodFrenzyColors.main, textColor: FoodFrenzyColors.tertiary),
              buildKey("", handleButton, enabled: false, visable: false),
              if(neg)
                buildKey("-/+", handleButton, enabled: getButtonEnabled("-/+")),
              if(!neg)
                buildKey("", handleButton, enabled: false, visable: false),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("1", handleButton, enabled: getButtonEnabled("1")),
              buildKey("2", handleButton, enabled: getButtonEnabled("2")),
              buildKey("3", handleButton, enabled: getButtonEnabled("3")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("4", handleButton, enabled: getButtonEnabled("4")),
              buildKey("5", handleButton, enabled: getButtonEnabled("5")),
              buildKey("6", handleButton, enabled: getButtonEnabled("6")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("7", handleButton, enabled: getButtonEnabled("7")),
              buildKey("8", handleButton, enabled: getButtonEnabled("8")),
              buildKey("9", handleButton, enabled: getButtonEnabled("9")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey(".", handleButton, enabled: false, visable: false),
              buildKey("0", handleButton, enabled: getButtonEnabled("0")),
              buildKey("✔️", handleButton, enabled: getButtonEnabled("✔️")),
            ],
          )
        ),
      ],
    );
  }

  static Widget calcKeypad(Function handleButton, bool Function(String) getButtonEnabled, {bool neg = true}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("C", handleButton, enabled: getButtonEnabled("C"), color: FoodFrenzyColors.main, textColor: FoodFrenzyColors.tertiary),
              buildKey("", handleButton, enabled: false, visable: false),
              if(neg)
                buildKey("-/+", handleButton, enabled: getButtonEnabled("-/+")),
              if(!neg)
                buildKey("", handleButton, enabled: false, visable: false),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("1", handleButton, enabled: getButtonEnabled("1")),
              buildKey("2", handleButton, enabled: getButtonEnabled("2")),
              buildKey("3", handleButton, enabled: getButtonEnabled("3")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("4", handleButton, enabled: getButtonEnabled("4")),
              buildKey("5", handleButton, enabled: getButtonEnabled("5")),
              buildKey("6", handleButton, enabled: getButtonEnabled("6")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey("7", handleButton, enabled: getButtonEnabled("7")),
              buildKey("8", handleButton, enabled: getButtonEnabled("8")),
              buildKey("9", handleButton, enabled: getButtonEnabled("9")),
            ],
          )
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildKey(".", handleButton, enabled: getButtonEnabled(".")),
              buildKey("0", handleButton, enabled: getButtonEnabled("0")),
              buildKey("✔️", handleButton, enabled: getButtonEnabled("✔️")),
            ],
          )
        ),
      ],
    );
  }

  static final double keyboardLineHeight = (Fib.f12.toDouble() / 3);

  static Widget fullKeyboard(Function handleButton, bool Function(String) getButtonEnabled, {bool uppercase = false, double height, bool period = false}){
    return Container(
      height: height ?? keyboardLineHeight * 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("1", handleButton, enabled: getButtonEnabled("1")),
                buildKey("2", handleButton, enabled: getButtonEnabled("2")),
                buildKey("3", handleButton, enabled: getButtonEnabled("3")),
                buildKey("4", handleButton, enabled: getButtonEnabled("4")),
                buildKey("5", handleButton, enabled: getButtonEnabled("5")),
                buildKey("6", handleButton, enabled: getButtonEnabled("6")),
                buildKey("7", handleButton, enabled: getButtonEnabled("7")),
                buildKey("8", handleButton, enabled: getButtonEnabled("8")),
                buildKey("9", handleButton, enabled: getButtonEnabled("9")),
                buildKey("0", handleButton, enabled: getButtonEnabled("0")),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("q", handleButton, enabled: getButtonEnabled("q"), uppercase: uppercase),
                buildKey("w", handleButton, enabled: getButtonEnabled("w"), uppercase: uppercase),
                buildKey("e", handleButton, enabled: getButtonEnabled("e"), uppercase: uppercase),
                buildKey("r", handleButton, enabled: getButtonEnabled("r"), uppercase: uppercase),
                buildKey("t", handleButton, enabled: getButtonEnabled("t"), uppercase: uppercase),
                buildKey("y", handleButton, enabled: getButtonEnabled("y"), uppercase: uppercase),
                buildKey("u", handleButton, enabled: getButtonEnabled("u"), uppercase: uppercase),
                buildKey("i", handleButton, enabled: getButtonEnabled("i"), uppercase: uppercase),
                buildKey("o", handleButton, enabled: getButtonEnabled("o"), uppercase: uppercase),
                buildKey("p", handleButton, enabled: getButtonEnabled("p"), uppercase: uppercase),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("", handleButton, enabled: false, flex: 1, visable: false),
                buildKey("a", handleButton, enabled: getButtonEnabled("a"), uppercase: uppercase),
                buildKey("s", handleButton, enabled: getButtonEnabled("s"), uppercase: uppercase),
                buildKey("d", handleButton, enabled: getButtonEnabled("d"), uppercase: uppercase),
                buildKey("f", handleButton, enabled: getButtonEnabled("f"), uppercase: uppercase),
                buildKey("g", handleButton, enabled: getButtonEnabled("g"), uppercase: uppercase),
                buildKey("h", handleButton, enabled: getButtonEnabled("h"), uppercase: uppercase),
                buildKey("j", handleButton, enabled: getButtonEnabled("j"), uppercase: uppercase),
                buildKey("k", handleButton, enabled: getButtonEnabled("k"), uppercase: uppercase),
                buildKey("l", handleButton, enabled: getButtonEnabled("l"), uppercase: uppercase),
                buildKey("", handleButton, enabled: false, flex: 1, visable: false),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("❌", handleButton, flex: 21),
                buildKey("", handleButton, enabled: false, visable: false, flex: 6),
                buildKey("z", handleButton, enabled: getButtonEnabled("z"), flex: 18, uppercase: uppercase),
                buildKey("x", handleButton, enabled: getButtonEnabled("x"), flex: 18, uppercase: uppercase),
                buildKey("c", handleButton, enabled: getButtonEnabled("c"), flex: 18, uppercase: uppercase),
                buildKey("v", handleButton, enabled: getButtonEnabled("v"), flex: 18, uppercase: uppercase),
                buildKey("b", handleButton, enabled: getButtonEnabled("b"), flex: 18, uppercase: uppercase),
                buildKey("n", handleButton, enabled: getButtonEnabled("n"), flex: 18, uppercase: uppercase),
                buildKey("m", handleButton, enabled: getButtonEnabled("m"), flex: 18, uppercase: uppercase),
                buildKey("", handleButton, enabled: false, visable: false, flex: 6),
                buildKey("🔙", handleButton, flex: 21, enabled: getButtonEnabled("🔙")),
              ],
            ),
          ),
          if(!period)
            Expanded(
              child: Row(
                children: <Widget>[
                  buildKey("", handleButton, enabled: false, visable: false, flex: 5),
                  buildKey("Space", handleButton, flex: 10, enabled: getButtonEnabled(" ")),
                  buildKey("", handleButton, enabled: false, visable: false, flex: 2),
                  buildKey("✔️", handleButton, flex: 3, enabled: getButtonEnabled("✔️")),
                ],
              ),
            ),
          if(period)
            Expanded(
              child: Row(
                children: <Widget>[
                  buildKey(".", handleButton, flex: 3, enabled: getButtonEnabled(".")),
                  buildKey("", handleButton, enabled: false, visable: false, flex: 2),
                  buildKey("Space", handleButton, flex: 10, enabled: getButtonEnabled(" ")),
                  buildKey("", handleButton, enabled: false, visable: false, flex: 2),
                  buildKey("✔️", handleButton, flex: 3, enabled: getButtonEnabled("✔️")),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static Widget keyboard(Function handleButton, bool Function(String) getButtonEnabled, {bool uppercase = false, double height}){
    return Container(
      height: height ?? keyboardLineHeight * 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("q", handleButton, enabled: getButtonEnabled("q"), uppercase: uppercase),
                buildKey("w", handleButton, enabled: getButtonEnabled("w"), uppercase: uppercase),
                buildKey("e", handleButton, enabled: getButtonEnabled("e"), uppercase: uppercase),
                buildKey("r", handleButton, enabled: getButtonEnabled("r"), uppercase: uppercase),
                buildKey("t", handleButton, enabled: getButtonEnabled("t"), uppercase: uppercase),
                buildKey("y", handleButton, enabled: getButtonEnabled("y"), uppercase: uppercase),
                buildKey("u", handleButton, enabled: getButtonEnabled("u"), uppercase: uppercase),
                buildKey("i", handleButton, enabled: getButtonEnabled("i"), uppercase: uppercase),
                buildKey("o", handleButton, enabled: getButtonEnabled("o"), uppercase: uppercase),
                buildKey("p", handleButton, enabled: getButtonEnabled("p"), uppercase: uppercase),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("", handleButton, enabled: false, flex: 1, visable: false),
                buildKey("a", handleButton, enabled: getButtonEnabled("a"), uppercase: uppercase),
                buildKey("s", handleButton, enabled: getButtonEnabled("s"), uppercase: uppercase),
                buildKey("d", handleButton, enabled: getButtonEnabled("d"), uppercase: uppercase),
                buildKey("f", handleButton, enabled: getButtonEnabled("f"), uppercase: uppercase),
                buildKey("g", handleButton, enabled: getButtonEnabled("g"), uppercase: uppercase),
                buildKey("h", handleButton, enabled: getButtonEnabled("h"), uppercase: uppercase),
                buildKey("j", handleButton, enabled: getButtonEnabled("j"), uppercase: uppercase),
                buildKey("k", handleButton, enabled: getButtonEnabled("k"), uppercase: uppercase),
                buildKey("l", handleButton, enabled: getButtonEnabled("l"), uppercase: uppercase),
                buildKey("", handleButton, enabled: false, flex: 1, visable: false),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("❌", handleButton, flex: 21),
                buildKey("", handleButton, enabled: false, visable: false, flex: 6),
                buildKey("z", handleButton, enabled: getButtonEnabled("z"), flex: 18, uppercase: uppercase),
                buildKey("x", handleButton, enabled: getButtonEnabled("x"), flex: 18, uppercase: uppercase),
                buildKey("c", handleButton, enabled: getButtonEnabled("c"), flex: 18, uppercase: uppercase),
                buildKey("v", handleButton, enabled: getButtonEnabled("v"), flex: 18, uppercase: uppercase),
                buildKey("b", handleButton, enabled: getButtonEnabled("b"), flex: 18, uppercase: uppercase),
                buildKey("n", handleButton, enabled: getButtonEnabled("n"), flex: 18, uppercase: uppercase),
                buildKey("m", handleButton, enabled: getButtonEnabled("m"), flex: 18, uppercase: uppercase),
                buildKey("", handleButton, enabled: false, visable: false, flex: 6),
                buildKey("🔙", handleButton, flex: 21, enabled: getButtonEnabled("🔙")),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("", handleButton, enabled: false, visable: false, flex: 5),
                buildKey("Space", handleButton, flex: 10, enabled: getButtonEnabled(" ")),
                buildKey("", handleButton, enabled: false, visable: false, flex: 2),
                buildKey("✔️", handleButton, flex: 3, enabled: getButtonEnabled("✔️")),
              ],
            ),
          ),
        ],
      ),
    );
  }

    static Widget foodKeyboard(Function handleButton, bool Function(String) getButtonEnabled, {bool uppercase = false, double height, String addString = "+ Add"}){
    return Container(
      height: height ?? keyboardLineHeight * 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("q", handleButton, enabled: getButtonEnabled("q"), uppercase: uppercase),
                buildKey("w", handleButton, enabled: getButtonEnabled("w"), uppercase: uppercase),
                buildKey("e", handleButton, enabled: getButtonEnabled("e"), uppercase: uppercase),
                buildKey("r", handleButton, enabled: getButtonEnabled("r"), uppercase: uppercase),
                buildKey("t", handleButton, enabled: getButtonEnabled("t"), uppercase: uppercase),
                buildKey("y", handleButton, enabled: getButtonEnabled("y"), uppercase: uppercase),
                buildKey("u", handleButton, enabled: getButtonEnabled("u"), uppercase: uppercase),
                buildKey("i", handleButton, enabled: getButtonEnabled("i"), uppercase: uppercase),
                buildKey("o", handleButton, enabled: getButtonEnabled("o"), uppercase: uppercase),
                buildKey("p", handleButton, enabled: getButtonEnabled("p"), uppercase: uppercase),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("", handleButton, enabled: false, flex: 1, visable: false),
                buildKey("a", handleButton, enabled: getButtonEnabled("a"), uppercase: uppercase),
                buildKey("s", handleButton, enabled: getButtonEnabled("s"), uppercase: uppercase),
                buildKey("d", handleButton, enabled: getButtonEnabled("d"), uppercase: uppercase),
                buildKey("f", handleButton, enabled: getButtonEnabled("f"), uppercase: uppercase),
                buildKey("g", handleButton, enabled: getButtonEnabled("g"), uppercase: uppercase),
                buildKey("h", handleButton, enabled: getButtonEnabled("h"), uppercase: uppercase),
                buildKey("j", handleButton, enabled: getButtonEnabled("j"), uppercase: uppercase),
                buildKey("k", handleButton, enabled: getButtonEnabled("k"), uppercase: uppercase),
                buildKey("l", handleButton, enabled: getButtonEnabled("l"), uppercase: uppercase),
                buildKey("", handleButton, enabled: false, flex: 1, visable: false),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("❌", handleButton, flex: 21),
                buildKey("", handleButton, enabled: false, visable: false, flex: 6),
                buildKey("z", handleButton, enabled: getButtonEnabled("z"), flex: 18, uppercase: uppercase),
                buildKey("x", handleButton, enabled: getButtonEnabled("x"), flex: 18, uppercase: uppercase),
                buildKey("c", handleButton, enabled: getButtonEnabled("c"), flex: 18, uppercase: uppercase),
                buildKey("v", handleButton, enabled: getButtonEnabled("v"), flex: 18, uppercase: uppercase),
                buildKey("b", handleButton, enabled: getButtonEnabled("b"), flex: 18, uppercase: uppercase),
                buildKey("n", handleButton, enabled: getButtonEnabled("n"), flex: 18, uppercase: uppercase),
                buildKey("m", handleButton, enabled: getButtonEnabled("m"), flex: 18, uppercase: uppercase),
                buildKey("", handleButton, enabled: false, visable: false, flex: 6),
                buildKey("🔙", handleButton, flex: 21),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildKey("", handleButton, enabled: false, visable: false, flex: 2),
                buildKey("Space", handleButton, flex: 10, enabled: getButtonEnabled(" ")),
                buildKey("", handleButton, enabled: false, visable: false, flex: 1),
                buildKey(addString, handleButton, flex: 7, enabled: true, color: FoodFrenzyColors.main, textColor: FoodFrenzyColors.tertiary),
              ],
            ),
          ),
        ],
      ),
    );
  }


  static const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
  static const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
  static const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12
  static const List<BoxShadow> shadow = [
    BoxShadow(offset: Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.0, color: _kKeyUmbraOpacity),
    // BoxShadow(offset: Offset(0.0, 3.0), blurRadius: 3.0, spreadRadius: -2.0, color: _kKeyUmbraOpacity),
    BoxShadow(offset: Offset(0.0, 3.0), blurRadius: 4.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
    BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 8.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
  ];

  static const List<BoxShadow> shadowBottom = [
    BoxShadow(offset: Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.0, color: _kKeyUmbraOpacity),
    // BoxShadow(offset: Offset(0.0, 3.0), blurRadius: 3.0, spreadRadius: -2.0, color: _kKeyUmbraOpacity),
    BoxShadow(offset: Offset(0.0, 3.0), blurRadius: 4.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
    BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 8.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
  ];

  static const List<BoxShadow> shadowBottomOnly = [
    // BoxShadow(offset: Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.0, color: _kKeyUmbraOpacity),
    // BoxShadow(offset: Offset(0.0, 3.0), blurRadius: 3.0, spreadRadius: -2.0, color: _kKeyUmbraOpacity),
    BoxShadow(offset: Offset(0.0, 4.0), blurRadius: 3.0, spreadRadius: -3.0, color: _kKeyPenumbraOpacity),
    BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 1.0, spreadRadius: -3.0, color: _kAmbientShadowOpacity),
  ];

  static const List<BoxShadow> shadowTopOnly = [
    // BoxShadow(offset: Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.0, color: _kKeyUmbraOpacity),
    // BoxShadow(offset: Offset(0.0, 3.0), blurRadius: 3.0, spreadRadius: -2.0, color: _kKeyUmbraOpacity),
    BoxShadow(offset: Offset(0.0, -4.0), blurRadius: 3.0, spreadRadius: -3.0, color: _kKeyPenumbraOpacity),
    BoxShadow(offset: Offset(0.0, -2.0), blurRadius: 1.0, spreadRadius: -3.0, color: _kAmbientShadowOpacity),
  ];

}