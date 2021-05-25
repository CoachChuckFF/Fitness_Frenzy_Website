/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal
import 'package:fitnessFrenzyWebsite/Views/views.dart';

class Fib{
  static const int f1 = 1;
  static const int f2 = 2;
  static const int f3 = 3;
  static const int f4 = 5;
  static const int f5 = 8;
  static const int f6 = 13;
  static const int f7 = 21;
  static const int f8 = 34;
  static const int f9 = 55;
  static const int f10 = 89;
  static const int f11 = 144;
  static const int f12 = 233;
  static const int f13 = 377;
  static const int f14 = 610;
  static const int f15 = 987;
  static const int f16 = 1597;
  static const int f17 = 2584;
  static const int f18 = 4181;
  static const int f19 = 6765;
  static const int f20 = 10946;
  static const int f21 = 17711;

  static int getFib(int index){
    int i, temp, past = 1, present = 1;

    for(i = 0; i < index; i++){
      temp = present;
      present += past;
      past = temp;
    }

    return present;
  }
}

class FoodFrenzyTheme{
  static ThemeData main(){
    return ThemeData(
      brightness: Brightness.light,
      // primaryTextTheme: FoodFrenzyTextThemes.main(),
      // accentTextTheme: FoodFrenzyTextThemes.accent(),
      unselectedWidgetColor: Colors.white,
      //sliderTheme: sliderData,
    );
  }
}



class FoodFrenzyColors{

  //JJ Colors
  static Color main = Color(0xFFFF5C39);
  static Color secondary = Color(0xAA101010);
  static Color tertiary = jjWhite;

  static Color jjRed = main;
  static Color jjRedA = Color(0xFF60291E);

  static Color jjOrange = Color(0xFFFF8E38);
  static Color jjOrangeA = Color(0xFF603A1D);

  static Color jjYellow = Color(0xFFFFE734);
  static Color jjYellowA = Color(0xFF60581B);

  static Color jjGreen = Color(0xFFB4FF52);
  static Color jjGreenA = Color(0xFF466026);

  static Color jjGreen2 = Color(0xFF63FF83);
  static Color jjGreen2A = Color(0xFF2C6036);

  static Color jjGreen3 = Color(0xFF37FFBA);
  static Color jjGreen3A = Color(0xFF1D6049);

  static Color jjBlue = Color(0xFF43D4F2);
  static Color jjBlueA = Color(0xFF20515B);

  static Color jjPurple = Color(0xFF977BE8);
  static Color jjPurpleA = Color(0xFF3D3458);


  static Color jjTransparent = Colors.transparent;
  static Color jjWhite = Colors.white;
  static Color jjBlack = Colors.black;
  static Color jjGrey = Colors.grey;

  static Color jj0 = secondary;
  static Color jj1 = jjRed;
  static Color jj2 = jjOrange;
  static Color jj3 = jjYellow;
  static Color jj4 = jjGreen;
  static Color jj5 = jjGreen2;
  static Color jj6 = jjGreen3;
  static Color jj7 = jjBlue;
  static Color jj8 = jjPurple;

  static Color fastingColor = jj0;
  static Color preWorkoutColor = jj1;
  static Color postWorkoutColor = jj2;
  static Color breakfastColor = jj3;
  static Color morningSnackColor = jj4;
  static Color lunchColor = jj5;
  static Color afternoonSnackColor = jj6;
  static Color dinnerColor = jj7;
  static Color eveningSnackColor = jj8;

  static Color error = jjRed;

}

class FoodFrenzyIcons{
  static IconData fastingIcon = FontAwesomeIcons.timesOctagon;
  static IconData freeMealIcon = FontAwesomeIcons.heart;
  static IconData preWorkoutIcon = FontAwesomeIcons.tachometerSlowest;
  static IconData postWorkoutIcon = FontAwesomeIcons.tachometerFastest;
  static IconData breakfastIcon = FontAwesomeIcons.sunrise;
  static IconData morningSnackIcon = FontAwesomeIcons.eggFried;
  static IconData lunchIcon = FontAwesomeIcons.sun;
  static IconData afternoonSnack = FontAwesomeIcons.salad;
  static IconData dinner = FontAwesomeIcons.sunset;
  static IconData eveningSnack = FontAwesomeIcons.cookieBite;
  static IconData placeholder = FontAwesomeIcons.crosshairs;
}

class FoodFrenzyRatios{
  static const double gold = 1.61803399;

  static const double middleScreenWidthRatio = 0.89;
  static const double sideDrawerWidthRatio = 0.89;
  static const double verticalDrawerWidthRatio = 0.55;
  static const double verticalTallDrawerWidthRatio = 0.80;
  static const double topButtonBarHeightRatio = 0.05;
}

class FoodFrenzySprinklesCount{
  static const int sad = 0;
  static const int little = 34;
  static const int norm = 89;
  static const int lots = 144;
  static const int tons = 233;
  static const int all = 987;
}