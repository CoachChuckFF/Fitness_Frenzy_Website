/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';


abstract class SprinklesInfo{
  final String name;
  final String bonus;

  SprinklesInfo(this.name, this.bonus);
}
abstract class SprinklesType {
  final List<Color> colors;
  final int modifier;

  SprinklesType(this.colors, {this.modifier});
}
abstract class SprinklesAmount {
  final int amount;

  SprinklesAmount(this.amount);
}
abstract class UnlockByWin {
  final String unlockedBy;
  final int cost;

  UnlockByWin(this.unlockedBy, this.cost);
}
abstract class UnlockByPoints {
  final int price;

  UnlockByPoints(this.price);
}

class BuySprinklesInfo extends SprinklesInfo implements SprinklesType, UnlockByPoints{
  final int _modifier;
  final int _price;
  final List<Color> _colors;

  BuySprinklesInfo(
    String name,
    String bonus,
    this._price,
    this._colors,
    [this._modifier = 0]
) : super(name, bonus);

  @override
  List<Color> get colors => _colors;

  @override
  int get modifier => _modifier;

  @override
  int get price => _price;
}

class WinSprinklesInfo extends SprinklesInfo implements SprinklesType, UnlockByWin{
  final String _unlockedBy;
  final List<Color> _colors;
  final int _modifier;
  final int _cost;

  WinSprinklesInfo(
    String name,
    String bonus,
    this._unlockedBy,
    this._cost,
    this._colors,
    [this._modifier = 0]
  ) : super(name, bonus);

  @override
  List<Color> get colors => _colors;

  @override
  int get modifier => _modifier;

  @override
  String get unlockedBy => _unlockedBy;

  @override
  int get cost => _cost;
}

class SprinklesAmountInfo extends SprinklesInfo implements SprinklesAmount, UnlockByPoints{
  final int _amount;
  final int _price;

  SprinklesAmountInfo(
    String name,
    String bonus,
    this._price,
    this._amount,
  ) : super(name, bonus);

  @override
  int get amount => _amount;

  @override
  int get price => _price;
}

class SprinklesColors{

  static List<Color> _defaultColors = <Color>[
    FoodFrenzyColors.main,
    FoodFrenzyColors.tertiary,
  ];

  static List<Color> _americaColors = <Color>[
    Color(0xFFB22234),
    Color(0xFFFFFFFF),
    Color(0xFF3C3B6E),
  ];

  static List<Color> _holidayColors = <Color>[
    Color(0xFFDF6264),
    Color(0xFFB82A36),
    Color(0xFF990027),
    Color(0xFF19830D),
    Color(0xFF59A230),
    Color(0xFF94BA62),
    Color(0xFFCFCFCF),
  ];

  static List<Color> _spookyColors = <Color>[
    Color(0xFF5E2C93),
    Color(0xFF67A131),
    Color(0xFF171615),
    // Color(0xFFF6CE03),
    Color(0xFFEB6123),
    Color(0xFFC03B08),
  ];

  static List<Color> _bronzeColors = <Color>[
    Color(0xFF804A00),
    Color(0xFF895E1B),
    Color(0xFF9C793C),
    Color(0xFFAF8C58),
    Color(0xFFA56018),
  ];

  static List<Color> _silverColors = <Color>[
    Color(0xFFCFCFCF),
    Color(0xFFBEBEBE),
    Color(0xFFACACAC),
    Color(0xFF9B9B9B),
    Color(0xFF898989),
  ];

  static List<Color> _goldColors = <Color>[
    Color(0xFFFFDE00),
    Color(0xFFF6D10A),
    Color(0xFFEDC30E),
    Color(0xFFE4B417),
    Color(0xFFDBA521),
  ];

  static List<Color> _diamondColors = <Color>[
    Color(0xFF1F4BE8),
    Color(0xFF437FF9),
    Color(0xFF49A5F8),
    Color(0xFFEDF7F8),
    Color(0xFFA6F9F9),
    Color(0xFF6DCEFC),
    Color(0xFF00D7FE),
    Color(0xFFBAF1FF),
  ];

  static List<Color> _frenzyColors = <Color>[
    FoodFrenzyColors.jj1,
    FoodFrenzyColors.jj2,
    FoodFrenzyColors.jj3,
    FoodFrenzyColors.jj4,
    FoodFrenzyColors.jj5,
    FoodFrenzyColors.jj6,
    FoodFrenzyColors.jj7,
    FoodFrenzyColors.jj8,
    FoodFrenzyColors.jjWhite,
  ];

  static List<Color> _flameColors = <Color>[
    Color(0xFFFBF829),
    Color(0xFFFF9320),
    Color(0xFFFF6C02),
    Color(0xFFFF3A00),
    Color(0xFFFE0B00),

  ];

  static List<Color> _acidColors = <Color>[
    Color(0xFFAFC019),
    Color(0xFFCCE215),
    Color(0xFFFEFE2F),
    Color(0xFFFFE52F),
  ];

  static List<Color> _earthColors = <Color>[
    Color(0xFFAC8441),
    Color(0xFF674516),
    Color(0xFF018039),
    Color(0xFF22B34B),
    Color(0xFF39D15C),
  ];

  static List<Color> _etherColors = <Color>[
    Color(0xFF1B1B3A),
    Color(0xFF693668),
    Color(0xFFA74481),
    Color(0xFFF74AA7),
  ];

  static List<Color> _waterColors = <Color>[
    Color(0xFFF9E8D9),
    Color(0xFFF9F5F1),
    Color(0xFF08ECD9),
    Color(0xFF03C9E0),
    Color(0xFF07A7E0),
  ];

  static List<Color> _redColors = <Color>[
    FoodFrenzyColors.jjRed
  ];

  static List<Color> _greenColors = <Color>[
    FoodFrenzyColors.jjGreen2
  ];

  static List<Color> _blueColors = <Color>[
    FoodFrenzyColors.jjBlue
  ];

  static List<Color> _whiteColors = <Color>[
    FoodFrenzyColors.jjWhite
  ];

  static List<Color> _blackColors = <Color>[
    FoodFrenzyColors.jjBlack
  ];

  static List<Color> _mysteryColors = <Color>[
    Color(0xFFEDDAD8),
    Color(0xFF171CE3),
    Color(0xFF7F1700),
    Color(0xFF11E11B),
    Color(0xFFE3E019),
    Color(0xFFA518DE),
  ];
}

class BuiltInSprinkles{

  //buy sprinkles
  static BuySprinklesInfo defaultSprinkles = BuySprinklesInfo(
    "Default",
    "No Bonus",
    -1,
    SprinklesColors._defaultColors
  );

  static BuySprinklesInfo redSprinkles = BuySprinklesInfo(
    "Red",
    "📸 = 500",
    30000,
    SprinklesColors._redColors
  );

  static BuySprinklesInfo greenSprinkles = BuySprinklesInfo(
    "Green",
    "⚖️ = 500",
    30000,
    SprinklesColors._greenColors
  );

  static BuySprinklesInfo blueSprinkles = BuySprinklesInfo(
    "Blue",
    "🍽️ = 500",
    30000,
    SprinklesColors._blueColors
  );

  static BuySprinklesInfo whiteSprinkles = BuySprinklesInfo(
    "White",
    "💎 = 1000",
    80000,
    SprinklesColors._whiteColors
  );

  static BuySprinklesInfo blackSprinkles = BuySprinklesInfo(
    "Black",
    "Points x100",
    1300000,
    SprinklesColors._blackColors
  );

  static BuySprinklesInfo americaSprinkles = BuySprinklesInfo(
    "USA",
    "No Bonus",
    50000000,
    SprinklesColors._americaColors
  );

  static BuySprinklesInfo spookySprinkles = BuySprinklesInfo(
    "Spooky",
    "No Bonus",
    50000000,
    SprinklesColors._spookyColors
  );

  static BuySprinklesInfo holidaySprinkles = BuySprinklesInfo(
    "Holiday",
    "No Bonus",
    50000000,
    SprinklesColors._holidayColors
  );

  static BuySprinklesInfo bronzeSprinkles = BuySprinklesInfo(
    "Bronze",
    "Streak x2",
    50000000,
    SprinklesColors._bronzeColors
  );

  static BuySprinklesInfo silverSprinkles = BuySprinklesInfo(
    "Silver",
    "Streak x2",
    250000000,
    SprinklesColors._silverColors
  );

  static BuySprinklesInfo goldSprinkles = BuySprinklesInfo(
    "Gold",
    "Streak x5",
    1000000000,
    SprinklesColors._goldColors
  );

  static BuySprinklesInfo diamondSprinkles = BuySprinklesInfo(
    "Diamond",
    "Streak x5",
    10000000000,
    SprinklesColors._diamondColors
  );

  static BuySprinklesInfo frenzySprinkles = BuySprinklesInfo(
    "Rainbow Frenzy",
    "Streak x10",
    150000000000,
    SprinklesColors._frenzyColors,
  );

  static BuySprinklesInfo mysterySprinkles = BuySprinklesInfo(
    "???",
    "???",
    9999999999999,
    SprinklesColors._mysteryColors,
    13
  );

  //win sprinkles
  static WinSprinklesInfo flameSprinkles = WinSprinklesInfo(
    "Flame",
    "+100%",
    "1 FF",
    1,
    SprinklesColors._flameColors
  );

  static WinSprinklesInfo waterSprinkles = WinSprinklesInfo(
    "Water",
    "+300%",
    "2 FF",
    2,
    SprinklesColors._waterColors
  );

  static WinSprinklesInfo earthSprinkles = WinSprinklesInfo(
    "Earth",
    "+800%",
    "3 FF",
    3,
    SprinklesColors._earthColors
  );

  static WinSprinklesInfo acidSprinkles = WinSprinklesInfo(
    "Acid",
    "+2100%",
    "4 FF",
    4,
    SprinklesColors._acidColors
  );

  static WinSprinklesInfo etherSprinkles = WinSprinklesInfo(
    "Ether",
    "+5500%",
    "5 FF",
    5,
    SprinklesColors._etherColors
  );

  //sprinkles amount
  static SprinklesAmountInfo zeroAmount = SprinklesAmountInfo(
    "No Sprinkles",
    "No Bonus",
    -1,
    0,
  );

  static SprinklesAmountInfo littleAmount = SprinklesAmountInfo(
    "Sparse Sprinkles",
    "No Bonus",
    100000,
    Fib.f5,
  );

  static SprinklesAmountInfo someAmount = SprinklesAmountInfo(
    "Some Sprinkles",
    "No Bonus",
    100000,
    Fib.f8,
  );

  static SprinklesAmountInfo defaultAmount = SprinklesAmountInfo(
    "Normal Sprinkles",
    "No Bonus",
    -1,
    Fib.f10,
  );

  static SprinklesAmountInfo lotsAmount = SprinklesAmountInfo(
    "Lots of Sprinkles",
    "No Bonus",
    1000000,
    Fib.f12,
  );

  static SprinklesAmountInfo tonAmount = SprinklesAmountInfo(
    "Ton of Sprinkles",
    "No Bonus",
    50000000,
    Fib.f14,
  );

  static SprinklesAmountInfo allAmount = SprinklesAmountInfo(
    "All of the Sprinkles!",
    "No Bonus",
    10000000000,
    Fib.f18,
  );

  static SprinklesAmount getSprinklesAmountByName(String name){
    switch(name){
      case "No Sprinkles": return zeroAmount;
      case "Sparse Sprinkles": return littleAmount;
      case "Some Sprinkles": return someAmount;
      case "Lots of Sprinkles": return lotsAmount;
      case "Ton of Sprinkles": return tonAmount;
      case "All of the Sprinkles!": return allAmount;
      default: return defaultAmount;
    }
  }

  static String checkSprinklesAmountName(String name){
    switch(name){
      case "No Sprinkles": return name;
      case "Sparse Sprinkles": return name;
      case "Some Sprinkles": return name;
      case "Lots of Sprinkles": return name;
      case "Ton of Sprinkles": return name;
      case "All of the Sprinkles!": return name;
      default: return defaultAmount.name;
    }
  }

  static SprinklesType getSprinklesTypeByName(String name){
    switch(name){
      case "Red": return redSprinkles;
      case "Green": return greenSprinkles;
      case "Blue": return blueSprinkles;
      case "White": return whiteSprinkles;
      case "Black": return blackSprinkles;
      case "USA": return americaSprinkles;
      case "Spooky": return spookySprinkles;
      case "Holiday": return holidaySprinkles;
      case "Bronze": return bronzeSprinkles;
      case "Silver": return silverSprinkles;
      case "Gold": return goldSprinkles;
      case "Diamond": return diamondSprinkles;
      case "Rainbow Frenzy": return frenzySprinkles;
      case "???": return mysterySprinkles;
      case "Flame": return flameSprinkles;
      case "Water": return waterSprinkles;
      case "Earth": return earthSprinkles;
      case "Acid": return acidSprinkles;
      case "Ether": return etherSprinkles;
      default: return defaultSprinkles;
    }
  }

  static String checkSprinklesName(String name){
    switch(name){
      case "Red": return name;
      case "Green": return name;
      case "Blue": return name;
      case "White": return name;
      case "Black": return name;
      case "USA": return name;
      case "Spooky": return name;
      case "Holiday": return name;
      case "Bronze": return name;
      case "Silver": return name;
      case "Gold": return name;
      case "Diamond": return name;
      case "Rainbow Frenzy": return name;
      case "???": return name;
      case "Flame": return name;
      case "Water": return name;
      case "Earth": return name;
      case "Acid": return name;
      case "Ether": return name;
      default: return defaultSprinkles.name;
    }
  }
}