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

class Calculations{
  static Random rng = Random();
  static Uuid uuid = Uuid();

  static String getUuid(){
    return uuid.v4();
  }

  static double getHealthyWeight({double cm, double inches, double bmi = 23.5}){
    if(inches == null){
      inches = 63;
    }

    if(cm != null){
      inches = cmToInches(cm);
    }

    return bmi * (inches * inches) / 703;
  }

  static double getBMI({double inches, double cm, double lbs, double kg}){
    if(inches == null){
      inches = 63;
    }

    if(cm != null){
      inches = cmToInches(cm);
    }

    if(lbs == null){
      lbs = 175;
    }

    if(kg != null){
      lbs = kgToLbs(kg);
    }

    return lbs/(inches * inches) * 703;
  }

  static Macro getMacros(List<Ingredient> ingredients, bool usesAlc){
    Macro macro = Macro();

    ingredients.forEach((i) {
      if(i.isIngredient){
        if(!(i.amount == null || 
          i.amount == 0 ||
          i.ss == null ||
          i.ss == 0))
        {
          macro.cal += i.cals;
          macro.fat += i.fats;
          macro.carb += i.carbs(useAlc: usesAlc);
          macro.prot += i.prots;
        }
      }
    });

    return macro;
  }

  static double weightToDailyDeficit(double kg){
    return (kgToLbs(kg) * 3500) / 7;
  }

  static double dailyDeficitToWeight(double cals){
    return lbsToKg(cals * 7 / 3500);
  }

  static double macroToPercent({
    @required double cals,
    double fat,
    double carb,
    double prot,
  }){
    if(fat != null) return (fat * 9) / cals * 100;
    if(carb != null) return (carb * 4) / cals * 100;
    if(prot != null) return (prot * 4) / cals * 100;

    return 0;
  }

  static double macroToCals(double fat, double carb, double prot, {double alc = 0}){
    return fat * 9 + carb * 4 + prot * 4 + alc * 7;
  }

  static double lbsToKg(double lbs){
    return lbs / 2.205;
  }

  static double kgToLbs(double kg){
    return kg * 2.205;
  }

  static double inchesToCm(double inches){
    return inches * 2.54;
  }

  static double cmToInches(double cm){
    return cm / 2.54;
  }

  static double getAge(DateTime birthday){
    return (birthday.difference(DateTime.now()).inDays / 365).abs();
  }

  //in floz
  static double getWaterGoal({
    double lbs = 185,
    double kg,
    String activity = ActivityLevel.sedentary,
  }){
    double weight = lbs;
    if(kg != null){
      weight = Calculations.kgToLbs(kg);
    }

    return (weight * 2/3) + (12 * ActivityLevel.getWaterActivityMultiplier(activity));
  }

  static double getTDEE({
    bool isFemale,
    double kg,
    double lbs,
    double cm,
    double inches,
    double yrs,
    String mult = ActivityLevel.sedentary,
  }){
    if(lbs != null){
      kg = lbsToKg(lbs);
    }

    if(inches != null){
      cm = inchesToCm(inches);
    }

    return ActivityLevel.getActivityMultiplier(mult) * getBMR(isFemale, kg, cm, yrs);
  }

  //Harris Benedict Equation
  static double getBMR(bool isFemale, double kg, double cm, double yrs){
    if(isFemale){
      return 655 + (9.6 * kg) + (1.8 * cm) - (4.7 * yrs);
    } else {
      return 66 + (13.7 * kg) + (5 * cm) - (6.8 * yrs);
    }
  }

  static int decimalTimeToSeconds(int decimal){
    int time = 0;
    int temp;

    if(decimal >= 10000){
      temp = (decimal ~/ 10000);
      time += temp * 60 * 60;
      decimal -= temp * 10000;
    }
    if(decimal >= 100){
      temp = (decimal ~/ 100);
      time += temp * 60;
      decimal -= temp * 100;
    }
    if(decimal >= 1){
      temp = (decimal ~/ 1);
      time += temp;
      decimal -= temp * 1;
    }

    return time;
  }

  static bool isSameDay(DateTime then, {DateTime now}){
    if(now == null){
      now = DateTime.now();
    }

    return now.day == then.day && now.month == then.month && now.year == then.year;
  }

  static DateTime getTopOfTheMonth({DateTime day}){
    if(day == null){
      day = DateTime.now();
    }

    return DateTime(
      day.year,
      day.month,
      1,
    );
  }

  static DateTime getEndOfTheMonth({DateTime day}){
    if(day == null){
      day = DateTime.now();
    }

    day = DateTime(
      day.year,
      day.month + 1
    );

    day = day.subtract(Duration(hours: 1));

    return getEOD(day: day);
  }

  static DateTime getTopOfTheWeek({DateTime day}){
    if(day == null){
      day = DateTime.now();
    }

    if(day.weekday != 7){
      day = day.subtract(Duration(days: day.weekday));
    }

    return DateTime(
      day.year,
      day.month,
      day.day,
    );
  }

  static DateTime getTopOfTheMorning({DateTime day}){
    if(day == null){
      day = DateTime.now();
    }

    return DateTime(
      day.year,
      day.month,
      day.day,
    );
  }

  static DateTime getTopOfTheHour(int hour, {DateTime day}){
    if(day == null){
      day = DateTime.now();
    }

    return DateTime(
      day.year,
      day.month,
      day.day,
      hour
    );
  }

  static DateTime getEOD({DateTime day}){
    if(day == null){
      day = DateTime.now();
    }

    return DateTime(
      day.year,
      day.month,
      day.day,
      23,
      59,
      59,
    );
  }

  //2ft is the shortest
  //13ft is the tallest
  static double heightFromIndex(int index, bool prefersMetric){
    if(prefersMetric){
      return index + 60.0; //just under 2ft
    } else {
      return inchesToCm(index + 2 * 12.0); //2ft
    }
  }
  //2ft is the shortest
  //13ft is the tallest
  static int indexFromHeight(double height){
    return height.round() - 60;
  }
}


class LogStats{
  final List<UserLog> logs;

  LogStats(this.logs);

  int get logLength => logs.length;

  Map<DateTime, double> get weights {
    Map<DateTime, double> w = Map<DateTime, double>();
  

    for(var log in logs) w[log.date] = log.weight;

    return w;
  }

  double get weightDiffrence {
    if(logs.where((log){return log.weight != null;}).length < 2) return 0;

    double start = logs.firstWhere((log) => log.weight != null).weight;
    double end = logs.lastWhere((log) => log.weight != null).weight;

    return end - start;
  }

}