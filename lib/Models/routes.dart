/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/

import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Models/user_info.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';

class FoodFrenzyRoutes{
  static const String login = '/';
  static const String hello = '/Hello';
  static const String welcomeBack = '/Welcome_Back';
  static const String home = '/Home';
  static const String zen = '/Zen';
  static const String macroCalc = '/Macro_Calc';
  static const String sourcesNDisclaimer = '/Boring';
  static const String logout = '/Logout';
  static const String cancel = '/Cancel';
  static const String feedback = '/Feedback';
  static const String countdownWorkoutPlayer = '/Countdown';
  static const String traditionalWorkoutPlayer = '/Traditional';
  static const String workoutBuilderWorkspaceTraditional = '$home/Workout_Builder/Workout_Builder_Traditional';
  static const String workoutBuilderWorkspaceCountdown = '$home/Workout_Builder/Workout_Builder_Countdown';
  static const String easterEgg3 = '$home/EasterEgg/Three';

  // Menu Indexes
  // Planner
    static const int menuIndexPlanMeals = 0x00;
    static const int menuIndexPlanCalc = 0x01;
    // static const int menuIndexPlanStagingArea = 0x02;
    // static const int menuIndexPlanMealsArea = 0x03;
    // static const int menuIndexPlanAdd = 0x04;
    // static const int menuIndexPlanScan = 0x05;
    static const int menuIndexShoppingList = 0x06;

  // Builder
    static const int menuIndexBuildType = 0x10;

  // Dashboard
    static const int menuIndexDashboardSprinkles = 0x20;
    static const int menuIndexDashboardSettings = 0x21;

    static const int menuIndexDashboardLogFood = 0x22;
    static const int menuIndexDashboardLogFoodOtherMeal = 0x23;
    static const int menuIndexDashboardLogFoodAddFood = 0x24;
    static const int menuIndexDashboardLogFoodQuickAdd = 0x25;
    static const int menuIndexDashboardLogFoodAlcEST = 0x26;
    static const int menuIndexDashboardLogFoodFoodEST = 0x27;
    static const int menuIndexDashboardLogFoodBars = 0x28;

    static const int menuIndexDashboardLogWeight = 0x29;
    static const int menuIndexDashboardLogPicture = 0x2A;

    static const int menuIndexDashboardLogHabit = 0x2B;
    static const int menuIndexDashboardLogHabitSet = 0x2C;

    static const int menuIndexDashboardLogWorkout = 0x2D;

  // Buddies
    static const int menuIndexBuddiesAdd = 0x30;
    static const int menuIndexBuddiesSprinkles = 0x31;

  // Stats
    static const int menuIndexStatsSettings = 0x40;
    static const int menuIndexStatsSpreadsheet = 0x41;


  static const String mealPlanner = '$home/Meal_Planner';
  static const String mealPlannerMeals = '$home/Meal_Planner/Meals';
  // static const String mealPlannerStagingArea = '$home/Meal_Planner/Staging_Area';
  // static const String mealPlannerMealsArea = '$home/Meal_Planner/Meals_Area';
  static const String mealPlannerAdd = '$home/Meal_Planner/Add';
  static const String mealPlannerScan = '$home/Meal_Planner/Scan';
  static const String mealPlannerShoppingList = '$home/Meal_Planner/Shopping_List';

  static const String workoutBuilder = '$home/Workout_Builder';
  static const String workoutBuilderType = '$home/Workout_Builder/Type';

  static const String dashboard = '$home';
  static const String dashboardSettings = '$home/Settings';
  static const String dashboardLogFood = '$home/Log_Food';
  static const String dashboardLogFoodOtherMeal = '$home/Log_Food/Other_Meal';
  static const String dashboardLogFoodAddFood = '$home/Log_Food/Add_Food';
  static const String dashboardLogFoodQuickAdd = '$home/Log_Food/Quick_Add';
  static const String dashboardLogFoodAlcEST = '$home/Log_Food/Alc_EST';
  static const String dashboardLogFoodFoodEST = '$home/Log_Food/Food_EST';
  static const String dashboardLogFoodBars = '$home/Log_Food/Food_Bars';
  static const String dashboardLogWeight = '$home/Log_Weight';
  static const String dashboardLogPicture = '$home/Log_Picture';
  static const String dashboardLogHabit = '$home/Log_Habit';
  static const String dashboardLogHabitSet = '$home/Log_Habit/Set';
  static const String dashboardLogWorkout = '$home/Log_Workout';

  static const String buddies = '$home/Buddies';
  static const String buddiesAdd = '$home/Buddies/Add';
  static const String buddiesSprinkles = '$home/Buddies/Sprinkles';

  static const String stats = '$home/Stats';
  static const String statsSettings = '$home/Stats/Settings';
  static const String statsSpreadsheet = '$home/Stats/Spreadsheet';


  static String linkToRoute(String link){

    if(link == null || link.isEmpty){
      return dashboard;
    }

    link = link.replaceAll("/", "");

    if(TextHelpers.matchExactString("buddy", link)){
      String uid = link.replaceAll("buddy", "");

      // Add buddy
      if(uid.length == 28){
        UserState.firebase.getDocument().then((userState){
          if(uid != userState.uid){
            if(!userState.accountabilibuddies.keys.contains(uid)){
              userState.addAccountabilibuddy(uid);
            }
          }
        });
      }

      link = "ba";
    }

    switch(link){
      case "ee3": return easterEgg3;

      case "mp": return mealPlanner;
      case "mpm": return mealPlannerMeals;
      case "mpc": return macroCalc; //changed
      case "mpsa": return dashboard; //redacted
      case "mpma": return dashboard; //redacted
      case "mpa": return dashboard; //redacted
      case "mps": return dashboard; //redacted
      case "mpsl": return mealPlannerShoppingList;

      case "wb": return workoutBuilder;
      case "wbt": return workoutBuilderType;

      case "d": return dashboard;
      case "dsp": return buddiesSprinkles; //changed
      case "ds": return dashboardSettings;
      case "dlf": return dashboardLogFood;
      case "dlfom": return dashboardLogFoodOtherMeal;
      case "dlfaf": return dashboardLogFoodAddFood;
      case "dlfqa": return dashboardLogFoodQuickAdd;
      case "dlfae": return dashboardLogFoodAlcEST;
      case "dlffe": return dashboardLogFoodFoodEST;
      case "dlfb": return dashboardLogFoodBars;
      case "dlw": return dashboardLogWeight;
      case "dlp": return dashboardLogPicture;
      case "dlh": return dashboardLogHabit;
      case "dlhs": return dashboard; //redacted
      case "dlwrk": return dashboardLogWorkout;
      case "dsl": return mealPlannerShoppingList; //changed

      case "b": return buddies;
      case "ba": return buddiesAdd;
      case "bas": return buddiesSprinkles;

      case "s": return stats;
      case "ss": return statsSettings;
      case "ssp": return statsSpreadsheet;

      case "mc": return macroCalc;

      case "fb": return feedback;
      case "cs": return cancel;
    }

    return dashboard;
  }

  // static MaterialPageRoute getRoutes(RouteSettings settings) {
  //   switch (settings.name) {
  //     case login:
  //       return FadeRoute(LoginPage(), settings: settings);
  //     case hello:
  //       return FadeRoute(HelloPage(), settings: settings);
  //     case welcomeBack:
  //       return FadeRoute(WelcomeBackPage(), settings: settings);
  //     case home:
  //       return FadeRoute(HomePage(), settings: settings);
  //     case countdownWorkoutPlayer:
  //       return FadeRoute(CountdownWorkoutPlayer(), settings: settings);     
  //     case traditionalWorkoutPlayer:
  //       return FadeRoute(TraditionalWorkoutPlayerBuffer(), settings: settings);
  //     case workoutBuilderWorkspaceTraditional:
  //       return FadeRoute(WorkoutBuilderTraditionalWorkspacePage(), settings: settings);
  //     case workoutBuilderWorkspaceCountdown:
  //       return FadeRoute(WorkoutBuilderCountdownWorkspacePage(), settings: settings);
  //     case sourcesNDisclaimer:
  //       return FadeRoute(ZenPage(), settings: settings);
  //     case zen:
  //       return FadeRoute(ZenPage(zenMode: true,), settings: settings);
  //     case macroCalc:
  //       return FadeRoute(MacroCalcPage(), settings: settings);
  //     case easterEgg3:
  //       return FadeRoute(EasterEgg3(), settings: settings);
  //     case logout: 
  //       return FadeRoute(LogoutPage(), settings: settings);
  //     case cancel: 
  //       return FadeRoute(CancelSubPage(), settings: settings);
  //     case feedback: 
  //       return FadeRoute(FeedbackPage(), settings: settings);

  //     // --------------------- In App Routes -------------------- 
  //     case mealPlanner:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.planIndex,), settings: settings);
  //     case mealPlannerMeals:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.planIndex, startingMenuIndex: menuIndexPlanMeals,), settings: settings);
  //     // case mealPlannerCalc:
  //     //   return FadeRoute(MacroCalcPage(), settings: settings);
  //     // case mealPlannerStagingArea:
  //     //   return FadeRoute(HomePage(startingIndex: HomePageDefines.planIndex, startingMenuIndex: menuIndexPlanStagingArea,), settings: settings);
  //     // case mealPlannerMealsArea:
  //     //   return FadeRoute(HomePage(startingIndex: HomePageDefines.planIndex, startingMenuIndex: menuIndexPlanMealsArea,), settings: settings);
  //     // case mealPlannerAdd:
  //     //   return FadeRoute(HomePage(startingIndex: HomePageDefines.planIndex, startingMenuIndex: menuIndexPlanAdd,), settings: settings);
  //     // case mealPlannerScan:
  //     //   return FadeRoute(HomePage(startingIndex: HomePageDefines.planIndex, startingMenuIndex: menuIndexPlanScan,), settings: settings);
  //     case mealPlannerShoppingList:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.planIndex, startingMenuIndex: menuIndexShoppingList,), settings: settings);
  //     case workoutBuilder:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.buildIndex,), settings: settings);
  //     case workoutBuilderType:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.buildIndex, startingMenuIndex: menuIndexBuildType), settings: settings);

  //     case dashboard:
  //       return FadeRoute(HomePage(), settings: settings);
  //     case dashboardSettings:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardSettings), settings: settings);
  //     case dashboardLogFood:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogFood), settings: settings);
  //     case dashboardLogFoodOtherMeal:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogFoodOtherMeal), settings: settings);
  //     case dashboardLogFoodAddFood:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogFoodAddFood), settings: settings);
  //     case dashboardLogFoodQuickAdd:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogFoodQuickAdd), settings: settings);
  //     case dashboardLogFoodAlcEST:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogFoodAlcEST), settings: settings);
  //     case dashboardLogFoodFoodEST:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogFoodFoodEST), settings: settings);
  //     case dashboardLogFoodBars:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogFoodBars), settings: settings);
  //     case dashboardLogWeight:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogWeight), settings: settings);
  //     case dashboardLogPicture:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogPicture), settings: settings);
  //     case dashboardLogHabit:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogHabit), settings: settings);
  //     // case dashboardLogHabitSet:
  //     //   return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogHabitSet), settings: settings);
  //     case dashboardLogWorkout:
  //       return FadeRoute(HomePage(startingMenuIndex: menuIndexDashboardLogWorkout), settings: settings);
  //     case buddiesSprinkles:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.scheduleIndex, startingMenuIndex: menuIndexBuddiesSprinkles,), settings: settings);
  //     case buddies:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.scheduleIndex, startingMenuIndex: menuIndexBuddiesAdd), settings: settings);
  //     case buddiesAdd:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.scheduleIndex, startingMenuIndex: menuIndexBuddiesAdd), settings: settings);

  //     case stats:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.statsIndex,), settings: settings);
  //     case statsSettings:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.statsIndex, startingMenuIndex: menuIndexStatsSettings), settings: settings);
  //     case statsSpreadsheet:
  //       return FadeRoute(HomePage(startingIndex: HomePageDefines.statsIndex, startingMenuIndex: menuIndexStatsSpreadsheet), settings: settings);

  //     // --------------------- Error -------------------- 
  //     default:
  //       return FadeRoute(HomePage(), settings: settings);
  //   }
  // }
}