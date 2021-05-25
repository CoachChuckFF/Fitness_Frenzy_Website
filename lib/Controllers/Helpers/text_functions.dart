/*
* Christian Krueger Health LLC
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//External
//Internal

import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:intl/intl.dart';

class TextHelpers {
  static Random random = Random();
  static const List<String> alphabet = [
    "All",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
  ];

  static int letterToIndex(String letter){
    switch(letter){
      case "All": return 0;
      case "A": return 1;
      case "B": return 2;
      case "C": return 3;
      case "D": return 4;
      case "E": return 5;
      case "F": return 6;
      case "G": return 7;
      case "H": return 8;
      case "I": return 9;
      case "J": return 10;
      case "K": return 11;
      case "L": return 12;
      case "M": return 13;
      case "N": return 14;
      case "O": return 15;
      case "P": return 16;
      case "Q": return 17;
      case "R": return 18;
      case "S": return 19;
      case "T": return 20;
      case "U": return 21;
      case "V": return 22;
      case "W": return 23;
      case "X": return 24;
      case "Y": return 25;
      case "Z": return 26;
    }

    return 0;
  }


  static String indexToTime(int index){
    return "$index:00";
  }

  static String indexToStdTime(int index){
    String ampm = "AM";

    if(index == 0) return "12:00 AM";
    if(index >= 12){
      index -= 12;
      if(index == 0) return "12:00 PM";
      ampm = "PM";
    }
    
    return "$index:00 $ampm";
  }

  static String firstWord(String string){
    if(string == null) return null;
    return string.split(" ")[0];
  }

  static String secondWord(String string){
    if(string == null) return "";
    if(!string.contains(" ")) return "";
    return string.split(" ")[1];
  }

  static bool matchString(String search, String match){
    match = match.toUpperCase();
    search = search.toUpperCase();

    return search.allMatches(match).isNotEmpty;
  }

  static String removeSpecChars(String string){
    string = string.replaceAll(RegExp(r'[^\w\s]+'),'');

    return string;
  }

  static bool matchExactString(String search, String match){
    match = match.toUpperCase();
    search = search.toUpperCase();

    match = removeSpecChars(match);

    if(match.contains(" ") && !search.contains(" ")){
      List<String> split = match.split(" ");
      for(String word in split){
        if(matchExactString(search, word)) return true;
      }
    }

    if(search.length > match.length) return false;

    for(int i = 0; i < search.codeUnits.length; i++){
      if(search.codeUnitAt(i) != match.codeUnitAt(i)) return false;
    }

    return true;
  }

  static String monthToString(int monthNum){
    String month = "";
    switch (monthNum) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }

    return month;
  }

  static String monthToShortString(int monthNum){
    String month = "";
    switch (monthNum) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sep";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }

    return month;
  }

  static String dayToShortString(int dayNum){
    String day = "";
    switch (dayNum) {
      case 7:
        day = "Su";
        break;
      case 1:
        day = "M";
        break;
      case 2:
        day = "T";
        break;
      case 3:
        day = "W";
        break;
      case 4:
        day = "Th";
        break;
      case 5:
        day = "F";
        break;
      case 6:
        day = "S";
        break;
    }

    return day;
  }

  static padString(String string, int length){
    int difference = length - string.length;

    for (var i = 0; i < difference; i++) {
      string = " " + string;
    }

    return string;
  }

  static String decimalToTimerString(int decimal){
    String sec = "0";
    String tenSec = "0";
    String min = "0";
    String tenMin = "0";
    String hour = "0";
    String tenHour = "0";

    int temp;

    if(decimal >= 100000){ temp = (decimal ~/ 100000); decimal -= 100000 * temp; tenHour = temp.toString();}
    if(decimal >= 10000){ temp = (decimal ~/ 10000); decimal -= 10000 * temp; hour = temp.toString();}
    if(decimal >= 1000){ temp = (decimal ~/ 1000); decimal -= 1000 * temp; tenMin = temp.toString();}
    if(decimal >= 100){ temp = (decimal ~/ 100); decimal -= 100 * temp; min = temp.toString();}
    if(decimal >= 10){ temp = (decimal ~/ 10); decimal -= 10 * temp; tenSec = temp.toString();}
    if(decimal >= 1){ temp = (decimal ~/ 1); decimal -= 1 * temp; sec = temp.toString();}

    return "$tenHour$hour:$tenMin$min:$tenSec$sec";
  }

  static String secondsToTimerString(int seconds){
    seconds = seconds ?? 0;
    bool hasHr = (seconds >= 60 * 60);

    String hr = NumberFormat(
      "#"
    ).format(
      (seconds ~/ (60 * 60))
    );

    String min = NumberFormat(
      hasHr ? '00' : '0'
    ).format(
      (seconds ~/ 60) % 60
    );

    String sec = NumberFormat(
      "00"
    ).format(
      (seconds % 60)
    );

    return "${hasHr ? hr + ':' : ''}" + min + ":" + sec;
  }

  static String removeDecimalIfNeeded(num number, [num didgets = 1]){
    number = number ?? 0;
    if(number.remainder(1) == 0){
      return number.toStringAsFixed(0);
    } else {
      return number.toStringAsFixed(didgets);
    }
  } 

  static String getYesterdaysFirebaseDate(){
    return datetimeToFirebaseString(DateTime.now().subtract(Duration(days: 1)));
  }

  static String getTodaysFirebaseDate({DateTime date}){
    return datetimeToFirebaseString(date ?? DateTime.now());
  }

  static String getTodaysLongFirebaseDate(){
    return datetimeToLongFirebaseString(DateTime.now());
  }

  static String getTodaysDate(){
    return datetimeToNumString(DateTime.now());
  }

  static String datetimeToFirebaseString(DateTime time){
    return "${time.month}_${time.day}_${time.year}";
  }

  static String datetimeToLongFirebaseString(DateTime time){
    return "${time.month}_${time.day}_${time.year}__${time.hour}_${time.minute}_${time.second}";
  }

  static String datetimeToNumString(DateTime time){
    return "${time.month}.${time.day}.${time.year}";
  }

  static String datetimeToLongString(DateTime time){
    return "${monthToString(time.month)} ${time.day}, ${time.year}";
  }

  static String datetimeToShortString(DateTime time){
    return "${monthToShortString(time.month)} ${time.day}, ${time.year}";
  }

  static List<IconData> _userIcons = [
    // FontAwesomeIcons.userAlien,
    // FontAwesomeIcons.userAstronaut,
    // FontAwesomeIcons.userRobot,
    FontAwesomeIcons.userCrown,
    // FontAwesomeIcons.userTie,
    // FontAwesomeIcons.userNinja,
    // FontAwesomeIcons.userCowboy
  ];

  static IconData getUserIcon(){
    return _userIcons[random.nextInt(_userIcons.length)];
  }

  static List<String> stringTips = <String>[
    "Don't be afraid to explore!",
    "Long presses will usually provide more info.",
  ];

  static String getTips(){
    return stringTips[random.nextInt(loggingHelp.length)];
  }

  static List<String> loggingHelp = <String>[
    "HV stands for 'High Value'",
    "COM stands for 'Combination Meal'",
    "Swipe Left on a heart to remove as favorite",
    "Tap on the down arrow to set your selection",
    "Your scanned foods will show up here too!",
  ];

  static String getLoggingHelp(){
    return loggingHelp[random.nextInt(loggingHelp.length)];
  }

  static List<String> greetings = [
    "You've got this!",
    "#logeveryday",
    "You can only log for the current day",
    "Consistency is key",
    "Trust the process",
    "Keep yourself and others accountable - add buddies",
    "At a social gathering? Use the Event Calc!",
    "Logging somthing is better than nothing",
    "Maximize accuracy by weighing your food",
    "At a restaurant? Use the Macro Calc!",
    "Want to a full day fast? You can log that!",
    "At the bar? Use the Alcohol Calc!",
    "Remember to get enough high-quality sleep",
    "Take a drink of water",
    "Scanned food gets added to your personal database",
    "Crush your goals without thinking, try meal prepping",
    "HV means the Highest macro Values from similar ingredients",
    "COM stands for 'Combination Meal'",
    "All ingredients are raw unless specified",
    "You are enough.",
    "What's your why?",
    "You only fail if you give up",
    "Fitness is a lifestyle",
    "1g of Carb = 4 Calories",
    "1g of Protein = 4 Calories",
    "1g of Alcohol = 7 Calories",
    "1g of Fat = 9 Calories",
    "Aim to eat 0.8g-1g of protein per pound of bodyweight",
    "Body transformation is a marathon, not a sprint",
    "Don't obsess over the scale! It's the trend that matters.",
    "Remember, this is YOUR journey",
    "Honesty is the best policy",
    "Compare yourself to yesterday you, not others",
    "Start with small portions, wait 3 min, then get seconds if hungry",
    "They might not understand; Let the results speak for themselves",
    "Keep going, I promise, results will come",
    "Cultivate discipline",
    "You only accomplish what you prioritize",
    "Commitment comes BEFORE results - take the leap",
    "Commitment to health is not selfish; it's necessary",
    "Set a goal, make a plan, take action until complete",
    "Make a good decision; it gets easier. However, the opposite is also true",
    "Trust the plan, don't deviate",
    "Hunger is deceiving, its a feeling, not an obligation",
    "Sacrifice is part of the process, it gives the reward meaning",
    "Value comes from the cost",
    "Discipline = Freedom",
  ];

  static String getGreeting(User user){

    int index = random.nextInt(2 + greetings.length);

    switch(index){
      case 0: 
        String message = "Good ";
        TimeOfDay time = TimeOfDay.now();
        if(time.hour < 11){
          message += "morning";
        } else if(time.hour < 15){
          message += "afternoon";
        } else {
          message += "evening";
        }

        if(user != null){
          if(user.displayName != null){
            message += ", ${TextHelpers.firstWord(user.displayName)}";
            return message;
          }
        }

        return message;
      case 1:
        return datetimeToLongString(DateTime.now());
      default:
        return greetings[index - 2];
    }
  }

  static String nameToShort(String name, {int length = 3, bool capital = true}){
    int count = 0;
    String retVal = "";
    List<String> initals = name.split(" ");


    if(initals.length == 1){
      if(name.length <= length){
        retVal = name;
      } else {
        retVal = name.substring(0, length);
      }
    } else {
      for(String word in initals){
        if(count < length && word.isNotEmpty){
          count++;
          retVal += word.characters.first;
        }
      }
    }

    if(capital){
      retVal = retVal.toUpperCase();
    } else {
      retVal = retVal.toLowerCase();
    }

    return retVal;
  }

  static String getSettingsTitle(User user){
    if(user != null){
      if(user.displayName != null){
        return firstWord(user.displayName);
      }
    }

    return "Settings";
  }

  static String pointsToString(int points){
    return NumberFormat(
      "0,000,000,000,000"
    ).format(
      points
    );
  }

  static String costToString(int points){
    return NumberFormat(
      "#,###,###,###,##0"
    ).format(
      points
    );
  }

  static String netWeightToString(double weight){
    return NumberFormat(
      "00.00"
    ).format(
      weight.abs()
    );
  }

  static String calToString(int cal){
    return NumberFormat(
      "0000"
    ).format(
      cal.abs()
    ) + "C";
  }

  static String negCalToString(int cal){
    return NumberFormat(
      "${cal < 0 ? '-' : ' '}0000"
    ).format(
      cal.abs()
    ) + "C";
  }

  static String negCalToStringAlt(int cal){
    return NumberFormat(
      "${cal < 0 ? '-' : ''}0000"
    ).format(
      cal.abs()
    ) + "C";
  }
  
  static String macroToString(int macro, String end){
    return NumberFormat(
      "000"
    ).format(
      macro.abs()
    ) + end;
  }

  static String naToString(int macro, String end){
    return NumberFormat(
      "0000"
    ).format(
      macro.abs()
    ) + end;
  }

  static String alcToString(int macro, String end){
    return NumberFormat(
      "00"
    ).format(
      macro.abs()
    ) + end;
  }

  static String negMacroToString(int macro, String end){
    return NumberFormat(
      "${macro < 0 ? '-' : ' '}000"
    ).format(
      macro.abs()
    ) + end;
  }

  static String streakToString(int streak){
    return NumberFormat(
      "0,000"
    ).format(
      streak
    );
  }

  static String countToString(int count){
    return NumberFormat(
      "000"
    ).format(
      count
    );
  }

  static String numberToShort(num points){
    return NumberFormat.compact().format(points);
  }

  static String heightToString(double height, bool prefersMetric){

    if(prefersMetric){
      return "${height.round().toString()} cm";
    } else {
      double totalInches = Calculations.cmToInches(height);
      int feet = totalInches ~/ 12;
      int inches = (totalInches.round()) % 12;

      return "${feet}' ${inches}\"";
    }
  }
}