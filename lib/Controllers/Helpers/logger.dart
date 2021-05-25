/*
* Christian Krueger Health LLC
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//External
import 'package:colorize/colorize.dart';
//Internal
import 'package:fitnessFrenzyWebsite/Models/configurations.dart';

class LOG{

  static void log(String message, int level){


    if(level > FoodFrenzyDebugging.debugLevel) return;

    Colorize preamble = Colorize("");

    switch(level){
      case FoodFrenzyDebugging.mute:
        preamble = Colorize("???")..yellow();
        break;
      case FoodFrenzyDebugging.crash:
        preamble = Colorize("XXX")..red();
        break;
      case FoodFrenzyDebugging.info:
        preamble = Colorize("NFO")..lightGray();
        break;
      case FoodFrenzyDebugging.verbose:
        preamble = Colorize("VRB")..blue();
        break;
      default: 
        preamble = Colorize("SVB")..magenta();
    }

    print("$preamble : ${DateTime.now()} ~ $message");
    
  }
}