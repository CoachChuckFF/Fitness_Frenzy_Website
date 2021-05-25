/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal

class AchievementInfo{
  final String name;
  final String bonus;
  final String tip;

  AchievementInfo(
    this.name,
    this.bonus,
    this.tip,
  );
}

class BuiltInAchievements{

  //Tutorial
  static AchievementInfo firstLogin = AchievementInfo(
    "First Login",
    "+1,000",
    "Log in for the first time!"
  );

  static AchievementInfo accountabilibuddy = AchievementInfo(
    "Accountabilibuddy",
    "+10,000",
    "Add an accountabilibuddy in the Stats page"
  );

  static AchievementInfo feedback = AchievementInfo(
    "Feedback",
    "+10,000",
    "Provide feedback in user settings"
  );

  static AchievementInfo fast = AchievementInfo(
    "Try Fasting",
    "+10,000",
    "Try fasting for a whole day, and log it"
  );

  static AchievementInfo timelapse = AchievementInfo(
    "Progress!",
    "+100,000",
    "Create a timelapse in the Stats page with at least 30 photos"
  );

  //Challenger
  static AchievementInfo challenger1 = AchievementInfo(
    "Challenger I",
    "Unlocks Flame Sprinkles",
    "Complete 1 Food Frenzy Challenge"
  );

  static AchievementInfo challenger2 = AchievementInfo(
    "Challenger II",
    "Unlocks Water Sprinkles",
    "Complete 2 Food Frenzy Challenges"
  );

  static AchievementInfo challenger3 = AchievementInfo(
    "Challenger III",
    "Unlocks Earth Sprinkles",
    "Complete 3 Food Frenzy Challenges"
  );

  static AchievementInfo challenger4 = AchievementInfo(
    "Challenger IV",
    "Unlocks Acid Sprinkles",
    "Complete 4 Food Frenzy Challenges"
  );

  static AchievementInfo challenger5 = AchievementInfo(
    "Challenger V",
    "Unlocks Ether Sprinkles",
    "Complete 5 Food Frenzy Challenges"
  );

  //Planner
  static AchievementInfo planner1 = AchievementInfo(
    "Kitchen Assistant",
    "+10,000",
    "Plan 1 day of meals"
  );

  static AchievementInfo planner2 = AchievementInfo(
    "Commis Chef",
    "+100,000",
    "Plan 3 days"
  );

  static AchievementInfo planner3 = AchievementInfo(
    "Station Chef",
    "+1,000,000",
    "Plan 5 days"
  );

  static AchievementInfo planner4 = AchievementInfo(
    "Sous Chef",
    "+10,000,000",
    "Plan 8 days"
  );

  static AchievementInfo planner5 = AchievementInfo(
    "Executive Chef",
    "+1,000,000,000",
    "Plan 13 days"
  );

  //Collector
  static AchievementInfo collector1 = AchievementInfo(
    "Sprinkle Novice",
    "+10,000",
    "Buy 3 Sprinkles"
  );

  static AchievementInfo collector2 = AchievementInfo(
    "Sprinkle Enthusiast",
    "+100,000",
    "Buy 8 Sprinkles"
  );

  static AchievementInfo collector3 = AchievementInfo(
    "Sprinkle Master",
    "+1,000,000",
    "Buy 13 Sprinkles"
  );
}