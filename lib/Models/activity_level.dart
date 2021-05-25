/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal

class ActivityLevel{

  static const String sedentary = "Sedentary";
  static const String lightlyActive = "Lightly Active";
  static const String moderatelyActive = "Moderately Active";
  static const String veryActive = "Very Active";
  static const String extremelyActive = "Extremely Active";

  static const List<String> levels = [
    sedentary,
    lightlyActive,
    moderatelyActive,
    veryActive,
    extremelyActive,
  ];

  static double getActivityMultiplier(String activity){
    switch(activity){
      case sedentary: //(little to no exercise + work a desk job)
        return 1.2;
      case lightlyActive: //(light exercise 1-3 days / week)
        return 1.375;
      case moderatelyActive: //(moderate exercise 3-5 days / week)
        return 1.55;
      case veryActive: //(heavy exercise 6-7 days / week)
        return 1.725;
      case extremelyActive: //(very heavy exercise, hard labor job, training 2x / day)
        return 1.9;
      default:
        return 1.2;
    }
  }

  static double getWaterActivityMultiplier(String activity){
    switch(activity){
      case sedentary: //(little to no exercise + work a desk job)
        return 0;
      case lightlyActive: //(light exercise 1-3 days / week)
        return 1;
      case moderatelyActive: //(moderate exercise 3-5 days / week)
        return 2;
      case veryActive: //(heavy exercise 6-7 days / week)
        return 3;
      case extremelyActive: //(very heavy exercise, hard labor job, training 2x / day)
        return 4;
      default:
        return 0;
    }
  }

  static String getShortString(String activity){
    switch(activity){
      case sedentary: //(little to no exercise + work a desk job)
        return "Sedentary";
      case lightlyActive: //(light exercise 1-3 days / week)
        return "Light";
      case moderatelyActive: //(moderate exercise 3-5 days / week)
        return "Moderate";
      case veryActive: //(heavy exercise 6-7 days / week)
        return "Heavy";
      case extremelyActive: //(very heavy exercise, hard labor job, training 2x / day)
        return "Extreme";
      default:
        return "Sedentary";
    }
  }

  static String getDescription(String activity){
    switch(activity){
      case sedentary: //(little to no exercise + work a desk job)
        return "Little to no exercise / work a desk job";
      case lightlyActive: //(light exercise 1-3 days / week)
        return "Light exercise 1-3 days / week";
      case moderatelyActive: //(moderate exercise 3-5 days / week)
        return "Moderate exercise 3-5 days / week";
      case veryActive: //(heavy exercise 6-7 days / week)
        return "Heavy exercise 6-7 days";
      case extremelyActive: //(very heavy exercise, hard labor job, training 2x / day)
        return "Very heavy exercise, Hard labor job, Training 2x / day";
      default:
        return "Sedentary";
    }
  }

}