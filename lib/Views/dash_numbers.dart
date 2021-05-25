import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

  class PointsNumber extends StatelessWidget {
    final int points;
    final String message;
    final bool tutorial;
    final bool active;

    PointsNumber(
      this.points,
      {
        this.message,
        this.tutorial = false,
        this.active = false,
        Key key
      }
    ) : super(key: key);

    Widget _buildNumberSlot(String char, [highlighted = false]){
      Color normalColor = (highlighted) ? FoodFrenzyColors.main : FoodFrenzyColors.secondary;

      return Expanded(
        child: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: LayoutBuilder(
            builder: (context, layout) {
              return Text(
                char,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: (tutorial) ? ((active) ? (normalColor == FoodFrenzyColors.secondary) ? FoodFrenzyColors.tertiary : normalColor : FoodFrenzyColors.jjTransparent) : normalColor,
                  fontWeight: FontWeight.bold,
                  fontSize: layout.maxWidth + 8,               
                ),
              );
            }
          ),
        ),
      );
    }

    int _getActiveIndex(String stringNumber){
      int index = 0;

      for (var i = 0; i < stringNumber.length; i++, index++) {
        if(stringNumber[i] != "0" && stringNumber[i] != ","){
          return index;
        }
      } 

      return index;
    }

    @override
    Widget build(BuildContext context) {
      String stringNumber = TextHelpers.pointsToString((points > 9999999999999) ? 9999999999999 : points);
      int highlightedIndex = _getActiveIndex(stringNumber);

      return Tooltip(
        message: message ?? "Log -> Points -> Sprinkles",
        preferBelow: false,
        child: GestureDetector(
          onTap: (){
            CommonAssets.showSnackbar(context, "Earn points by logging, spend points on sprinkles", duration: Duration(milliseconds: 2100));
          },
          child: Container(
            color: FoodFrenzyColors.jjTransparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for(var i = 0; i < 17; i++)
                  _buildNumberSlot(stringNumber[i], (i >= highlightedIndex))
              ]
            ),
          ),
        ),
      );
    }
  }

  class MacroTitle extends StatelessWidget {
    static final int length = 20;
    static final int negativeLength = 24;

    final Color color;

    MacroTitle({
      this.color,
    });

    Widget _buildNumberSlot(String char, {bool isBold = false}){
      return Expanded(
        child: Container(
          child: LayoutBuilder(
            builder: (context, layout) {
              return Text(
                char,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: (isBold) ? FontWeight.bold : FontWeight.normal,
                  fontSize: layout.maxWidth + 8,               
                ),
              );
            }
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {

      return Tooltip(
        preferBelow: false,
        message: "Calories, fat, carbs, protein",
        child: Row(
          children: [
            _buildNumberSlot("C", isBold: true),
            _buildNumberSlot("a"),
            _buildNumberSlot("l"),
            _buildNumberSlot("s"),
            _buildNumberSlot(""),
            _buildNumberSlot(""),
            _buildNumberSlot("f", isBold: true),
            _buildNumberSlot("a"),
            _buildNumberSlot("t"),
            _buildNumberSlot(""),
            _buildNumberSlot(""),
            _buildNumberSlot("c", isBold: true),
            _buildNumberSlot("a"),
            _buildNumberSlot("r"),
            _buildNumberSlot("b"),
            _buildNumberSlot(""),
            _buildNumberSlot("p", isBold: true),
            _buildNumberSlot("r"),
            _buildNumberSlot("o"),
            _buildNumberSlot("t"),
          ]
        ),
      );
    }
  }

  class MicroNumbers extends StatelessWidget {

    Micro micro;

    MicroNumbers({
      this.micro,
    });

    Widget _buildNumberSlot(String char, int index){

      Color color = FoodFrenzyColors.secondary;

      return Expanded(
        child: Container(
          color: FoodFrenzyColors.jjTransparent,
          child: LayoutBuilder(
            builder: (context, layout) {
              return Text(
                char,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: (false) ? FontWeight.bold : FontWeight.normal,
                  fontSize: layout.maxWidth + 8,               
                ),
              );
            }
          ),
        ),
      );
    }

    String _microToString(){
      int sodium = micro.sodium.round().abs();
      if(sodium > 9999) sodium = 9999;
      int sugar = micro.sugar.round().abs();
      if(sugar > 999) sugar = 999;
      int fiber = micro.fiber.round();
      if(fiber > 999) fiber = 999;
      int alcohol = micro.alcohol.round();
      if(alcohol > 999) alcohol = 999;

      String ret = TextHelpers.naToString(sodium, "na") + " ";
      ret += TextHelpers.macroToString(sugar, "s") + " ";
      ret += TextHelpers.macroToString(fiber, "f") + " ";
      ret += TextHelpers.alcToString(alcohol, "a");

      return ret;
    }


    @override
    Widget build(BuildContext context) {
      String microString = _microToString();

      return Tooltip(
        preferBelow: false,
        message: "Sodium (mg), Sugar, Fiber, Alcohol",
        child: Row(
          children: [
            for(var i = 0; i < microString.length; i++)
              _buildNumberSlot(microString[i], i),
          ]
        ),
      );
    }
  }

  class MacroNumbers extends StatelessWidget {
    static final int length = 20;
    static final int negativeLength = 24;

    Macro macro;

    int cal;
    int fat;
    int carb;
    int prot;

    bool isBold;
    bool canBeNegative;
    bool noCal;
    bool isBoldCal;
    bool isBoldFat;
    bool isBoldCarb;
    bool isBoldProt;

    Color calColor; 
    Color fatColor; 
    Color carbColor; 
    Color protColor;
    Color defaultColor;

    Function onCal;
    Function onFat;
    Function onCarb;
    Function onProt;

    MacroNumbers({
      this.macro,
      this.cal = 0,
      this.fat = 0,
      this.carb = 0,
      this.prot = 0,
      this.calColor,
      this.fatColor,
      this.carbColor,
      this.protColor,
      this.defaultColor,
      this.isBoldCal,
      this.isBoldFat,
      this.isBoldCarb,
      this.isBoldProt,
      this.isBold = true,
      this.canBeNegative = false,
      this.noCal = false,
      this.onCal,
      this.onFat,
      this.onCarb,
      this.onProt,
    }){
      if(macro != null){
        this.cal = macro.cal.round();
        this.fat = macro.fat.round();
        this.carb = macro.carb.round();
        this.prot = macro.prot.round();
      }

      if(defaultColor == null) defaultColor = FoodFrenzyColors.secondary;
      if(calColor == null) calColor = defaultColor;
      if(fatColor == null) fatColor = defaultColor;
      if(carbColor == null) carbColor = defaultColor;
      if(protColor == null) protColor = defaultColor;

      isBoldCal = isBoldCal ?? isBold;
      isBoldFat = isBoldFat ?? isBold;
      isBoldCarb = isBoldCarb ?? isBold;
      isBoldProt = isBoldProt ?? isBold;
    }

    Widget _buildNumberSlot(String char, int index){

      Function onTap = null;
      bool isIndBold = isBold;
      Color color = FoodFrenzyColors.secondary;

      if(canBeNegative){
        if(noCal){
          if(index < 5){
            color = fatColor;
            isIndBold = isBoldFat;
            onTap = onFat;
          } else if(index < 12){
            color = carbColor;
            isIndBold = isBoldCarb;
            onTap = onCarb;
          } else {
            color = protColor;
            isIndBold = isBoldProt;
            onTap = onProt;
          }
        } else {
          if(index < 6){
            color = calColor;
            isIndBold = isBoldCal;
            onTap = onCal;
          } else if(index < 12){
            color = fatColor;
            isIndBold = isBoldFat;
            onTap = onFat;
          } else if(index < 18){
            color = carbColor;
            isIndBold = isBoldCarb;
            onTap = onCarb;
          } else {
            color = protColor;
            isIndBold = isBoldProt;
            onTap = onProt;
          }
        }
      } else {
        if(noCal){
          if(index < 5){
            color = fatColor;
            isIndBold = isBoldFat;
            onTap = onFat;
          } else if(index < 10){
            color = carbColor;
            isIndBold = isBoldCarb;
            onTap = onCarb;
          } else {
            color = protColor;
            isIndBold = isBoldProt;
            onTap = onProt;
          }
        } else {
          if(index < 5){
            color = calColor;
            isIndBold = isBoldCal;
            onTap = onCal;
          } else if(index < 10){
            color = fatColor;
            isIndBold = isBoldFat;
            onTap = onFat;
          } else if(index < 15){
            color = carbColor;
            isIndBold = isBoldCarb;
            onTap = onCarb;
          } else {
            color = protColor;
            isIndBold = isBoldProt;
            onTap = onProt;
          }
        }
      }

      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: FoodFrenzyColors.jjTransparent,
            child: LayoutBuilder(
              builder: (context, layout) {
                return Text(
                  char,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontWeight: (isIndBold) ? FontWeight.bold : FontWeight.normal,
                    fontSize: layout.maxWidth + 8,               
                  ),
                );
              }
            ),
          ),
        ),
      );
    }

    String _macroToString(){
      int calVal = cal.abs();
      if(calVal > 9999) calVal = 9999;
      int fatVal = fat.abs();
      if(fatVal > 999) fatVal = 999;
      int carbVal = carb.abs();
      if(carbVal > 999) carbVal = 999;
      int protVal = prot.abs();
      if(protVal > 999) protVal = 999;

      String ret = TextHelpers.calToString(calVal) + " ";
      ret += TextHelpers.macroToString(fatVal, "f") + " ";
      ret += TextHelpers.macroToString(carbVal, "c") + " ";
      ret += TextHelpers.macroToString(protVal, "p");

      return ret;
    }

    String _macroWOCalToString(){
      int fatVal = fat.abs();
      if(fatVal > 999) fatVal = 999;
      int carbVal = carb.abs();
      if(carbVal > 999) carbVal = 999;
      int protVal = prot.abs();
      if(protVal > 999) protVal = 999;

      String ret = TextHelpers.macroToString(fatVal, "f") + " ";
      ret += TextHelpers.macroToString(carbVal, "c") + " ";
      ret += TextHelpers.macroToString(protVal, "p");

      return ret;
    }

    String _negativeMacroToString(){
      int calVal = cal;
      if(cal.abs() > 9999) calVal = 9999 * ((cal < 0) ? -1 : 1);
      int fatVal = fat;
      if(fat.abs() > 999) fatVal = 999 * ((fat < 0) ? -1 : 1);
      int carbVal = carb;
      if(carb.abs() > 999) carbVal = 999 * ((carb < 0) ? -1 : 1);
      int protVal = prot;
      if(prot.abs() > 999) protVal = 999 * ((prot < 0) ? -1 : 1);

      String ret = TextHelpers.negCalToString(calVal) + " ";
      ret += TextHelpers.negMacroToString(fatVal, "f") + " ";
      ret += TextHelpers.negMacroToString(carbVal, "c") + " ";
      ret += TextHelpers.negMacroToString(protVal, "p");

      return ret;
    }

    String _negativeMacroWOCalToString(){
      int fatVal = fat;
      if(fat.abs() > 999) fatVal = 999 * ((fat < 0) ? -1 : 1);
      int carbVal = carb;
      if(carb.abs() > 999) carbVal = 999 * ((carb < 0) ? -1 : 1);
      int protVal = prot;
      if(prot.abs() > 999) protVal = 999 * ((prot < 0) ? -1 : 1);

      String ret = TextHelpers.negMacroToString(fatVal, "f") + " ";
      ret += TextHelpers.negMacroToString(carbVal, "c") + " ";
      ret += TextHelpers.negMacroToString(protVal, "p");

      return ret;
    }

    @override
    Widget build(BuildContext context) {
      String macroString;

      if(canBeNegative){
        if(noCal){
          macroString = _negativeMacroWOCalToString();
        } else {
          macroString = _negativeMacroToString();
        }
      } else {
        if(noCal){
          macroString = _macroWOCalToString();
        } else {
          macroString = _macroToString();
        }
      }

      return Tooltip(
        preferBelow: false,
        message: "Calories, fat, carbs, protein",
        child: Row(
          children: [
            for(var i = 0; i < macroString.length; i++)
              _buildNumberSlot(macroString[i], i),
          ]
        ),
      );
    }
  }

  class DaysNStreak extends StatelessWidget {
    final int daysLeft;
    final int streak;
    final bool tutorial;
    final bool active;

    DaysNStreak(
      this.daysLeft,
      this.streak,
      {
        this.active = false,
        this.tutorial = false,
        Key key
      }
    ) : super(key: key);

    Widget _buildNumberSlot(String char, [highlighted = false, Color color]){
      Color normalColor = (highlighted) ? FoodFrenzyColors.main : FoodFrenzyColors.secondary;

      return Expanded(
        child: Container(
          child: LayoutBuilder(
            builder: (context, layout) {
              return Text(
                char,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: (tutorial) ? ((active) ? (normalColor == FoodFrenzyColors.secondary) ? FoodFrenzyColors.tertiary : normalColor : FoodFrenzyColors.jjTransparent) : normalColor,
                  fontWeight: FontWeight.bold,
                  fontSize: layout.maxWidth + 8,               
                ),
              );
            }
          ),
        ),
      );
    }

    int _getActiveIndex(String stringNumber){
      int index = 0;

      for (var i = 0; i < stringNumber.length; i++, index++) {
        if(stringNumber[i] != "0" && 
          stringNumber[i] != "," &&
          stringNumber[i] != "."
        ){
          return index;
        }
      } 

      return index;
    }

    @override
    Widget build(BuildContext context) {
      String daysLeftString = TextHelpers.countToString(daysLeft);
      int weightHighlightedIndex = _getActiveIndex(daysLeftString);
      String streakString = TextHelpers.streakToString(streak);
      int streakHighlightedIndex = _getActiveIndex(streakString);

      return Row(
        children: [
          _buildNumberSlot(""),
          for(var i = 0; i < 3; i++)
            _buildNumberSlot(daysLeftString[i], (i >= weightHighlightedIndex), FoodFrenzyColors.jjBlue),
          _buildNumberSlot(""),
          _buildNumberSlot("F"),
          _buildNumberSlot("F"),
          _buildNumberSlot(""),
          _buildNumberSlot(""),
          _buildNumberSlot(""),
          for(var i = 0; i < 5; i++)
            _buildNumberSlot(streakString[i], (i >= streakHighlightedIndex)),
          _buildNumberSlot(""),
          _buildNumberSlot("S"),
        ]
      );
    }
  }
