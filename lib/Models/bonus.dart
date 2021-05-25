/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal

class BonusActions{
  static const String misc = "Misc";
  static const String progressPic = "PP";
  static const String weight = "Weight";
  static const String food = "Food";
  static const String perfectDay = "PD";
}

class Bonuses{
  static const String all = "All Actions";
  static const String progressPic = "Progress Picture Bonuses";
  static const String weight = "Recording Weight Bonuses";
  static const String food = "Logging Food Bonuses";
  static const String perfectDay = "Perfect Day Bonuses";

  Bonuses();

  Map<String, List<int>> bonuses = {
    all : List<int>(2),
    progressPic : List<int>(2),
    weight : List<int>(2),
    food : List<int>(2),
    perfectDay : List<int>(2),
  };

  int get allPercent => bonuses[all][0];
  int get allPlus => bonuses[all][1];

  int get progressPicPercent => bonuses[progressPic][0];
  int get progressPicPlus => bonuses[progressPic][1];

  int get weightPercent => bonuses[weight][0];
  int get weightPlus => bonuses[weight][1];

  int get foodPercent => bonuses[food][0];
  int get foodPlus => bonuses[food][1];

  int get perfectDayPercent => bonuses[perfectDay][0];
  int get perfectDayPlus => bonuses[perfectDay][1];

  static int _addPercent(int points, int percent){
    return (points.toDouble() * (1.0 + (percent.toDouble() / 100.0))).truncate();
  }

  int applyBonus(int points, [String type = BonusActions.misc]){

    switch(type){
      case BonusActions.food:
        points += foodPlus;
        points = _addPercent(points, foodPercent);
        break;
      case BonusActions.weight:
        points += weightPlus;
        points = _addPercent(points, weightPercent);
        break;
      case BonusActions.progressPic:
        points += progressPicPlus;
        points = _addPercent(points, progressPicPercent);
        break;
      case BonusActions.perfectDay:
        points += perfectDayPlus;
        points = _addPercent(points, perfectDayPercent);
        break;
    }

    points += allPlus;
    points = _addPercent(points, allPercent);

    return points;
  }
}