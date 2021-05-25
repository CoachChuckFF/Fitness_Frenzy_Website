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
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class SprinkleUnlocks{
  static final GlobalData<SprinkleUnlocks> firebase = GlobalData(leaderboardCollection);
  static const String leaderboardCollection = "Leaderboard";
  static const String sprinkleUnlockDocument = "Sprinkle Unlocks";

  Map<String, dynamic> unlocks;

  static Future<void> update(String sprinkles){
    return firebase.getDocument(sprinkleUnlockDocument).then((unlocked){
      firebase.update(
        {
          sprinkles : (unlocked.unlocks[sprinkles] ?? 0) + 1
        }, 
        sprinkleUnlockDocument
      );
    });
  }

  num unlockCount(String sprinkle){
    return unlocks[sprinkle] ?? 0;
  }

  SprinkleUnlocks({
    this.unlocks,
  });

  factory SprinkleUnlocks.fromMap(Map data){
    return SprinkleUnlocks(
      unlocks: data
    );
  }

}