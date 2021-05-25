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
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class SprinklesList extends StatefulWidget {
  const SprinklesList({Key key}) : super(key: key);

  @override
  _SprinklesListState createState() => _SprinklesListState();
}

void _handleTransaction(String sprinkles, int cost){
  UserPoints.firebase.getDocument().then((points){
    points.unlock(sprinkles, cost, false);
    SprinkleUnlocks.update(sprinkles);
  });
}

void _handleUnlock(String sprinkles, int cost){
  UserPoints.firebase.getDocument().then((points){
    points.unlock(sprinkles, cost, true);
    SprinkleUnlocks.update(sprinkles);
  });
}

class _SprinklesListState extends State<SprinklesList> {
  @override
  Widget build(BuildContext context) {
    return UserStateStreamView((info){
      return UserPointsStreamView((points){
        return SprinkleUnlockStreamView((unlocks){
          return ListView(
            padding: EdgeInsets.all(3),
            children: [
              SprinklesItem(BuiltInSprinkles.defaultSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.defaultSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.defaultSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.redSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.redSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.redSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.greenSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.greenSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.greenSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.blueSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.blueSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.blueSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.whiteSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.whiteSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.whiteSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.blackSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.blackSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.blackSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.americaSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.americaSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.americaSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.spookySprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.spookySprinkles.name], unlocks.unlockCount(BuiltInSprinkles.spookySprinkles.name)),
              SprinklesItem(BuiltInSprinkles.holidaySprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.holidaySprinkles.name], unlocks.unlockCount(BuiltInSprinkles.holidaySprinkles.name)),
              SprinklesItem(BuiltInSprinkles.bronzeSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.bronzeSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.bronzeSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.silverSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.silverSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.silverSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.goldSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.goldSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.goldSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.diamondSprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.diamondSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.diamondSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.frenzySprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.frenzySprinkles.name], unlocks.unlockCount(BuiltInSprinkles.frenzySprinkles.name)),
              SprinklesItem(BuiltInSprinkles.mysterySprinkles, info.sprinkles, points.points, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.mysterySprinkles.name], unlocks.unlockCount(BuiltInSprinkles.mysterySprinkles.name)),
              Container(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: Divider()
              ),
              SprinklesItem(BuiltInSprinkles.flameSprinkles, info.sprinkles, points.perfectStreak, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleUnlock(s,c), points.unlocks[BuiltInSprinkles.flameSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.flameSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.waterSprinkles, info.sprinkles, points.perfectStreak, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleUnlock(s,c), points.unlocks[BuiltInSprinkles.waterSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.waterSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.earthSprinkles, info.sprinkles, points.perfectStreak, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleUnlock(s,c), points.unlocks[BuiltInSprinkles.earthSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.earthSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.acidSprinkles, info.sprinkles, points.perfectStreak, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleUnlock(s,c), points.unlocks[BuiltInSprinkles.acidSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.acidSprinkles.name)),
              SprinklesItem(BuiltInSprinkles.etherSprinkles, info.sprinkles, points.perfectStreak, points.ffCount, (s)=>info.updateSelectedSprinkles(s), (s,c)=>_handleUnlock(s,c), points.unlocks[BuiltInSprinkles.etherSprinkles.name], unlocks.unlockCount(BuiltInSprinkles.etherSprinkles.name)),
              Container(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: Divider()
              ),
              SprinklesItem(BuiltInSprinkles.littleAmount, info.sprinklesAmount, points.points, points.ffCount, (a)=>info.updateSelectedSprinklesAmount(a), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.littleAmount.name], unlocks.unlockCount(BuiltInSprinkles.littleAmount.name)),
              SprinklesItem(BuiltInSprinkles.someAmount, info.sprinklesAmount, points.points, points.ffCount, (a)=>info.updateSelectedSprinklesAmount(a), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.someAmount.name], unlocks.unlockCount(BuiltInSprinkles.someAmount.name)),
              SprinklesItem(BuiltInSprinkles.defaultAmount, info.sprinklesAmount, points.points, points.ffCount, (a)=>info.updateSelectedSprinklesAmount(a), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.defaultAmount.name], unlocks.unlockCount(BuiltInSprinkles.defaultAmount.name)),
              SprinklesItem(BuiltInSprinkles.lotsAmount, info.sprinklesAmount, points.points, points.ffCount, (a)=>info.updateSelectedSprinklesAmount(a), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.lotsAmount.name], unlocks.unlockCount(BuiltInSprinkles.lotsAmount.name)),
              SprinklesItem(BuiltInSprinkles.tonAmount, info.sprinklesAmount, points.points, points.ffCount, (a)=>info.updateSelectedSprinklesAmount(a), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.tonAmount.name], unlocks.unlockCount(BuiltInSprinkles.tonAmount.name)),
              SprinklesItem(BuiltInSprinkles.allAmount, info.sprinklesAmount, points.points, points.ffCount, (a)=>info.updateSelectedSprinklesAmount(a), (s,c)=>_handleTransaction(s,c), points.unlocks[BuiltInSprinkles.allAmount.name], unlocks.unlockCount(BuiltInSprinkles.allAmount.name)),
              Tooltip(
                preferBelow: false,
                message: "Matt said I should add this here",
                child: UserStateStreamView(
                  (state){
                    return ListTile(
                      leading: Icon(
                        (state.sprinklesAmount == BuiltInSprinkles.zeroAmount.name) ?
                          Icons.check_box :
                          Icons.check_box_outline_blank,
                          color: FoodFrenzyColors.secondary,
                      ),
                      trailing: AST(
                        "Disable Sprinkles",
                        color: FoodFrenzyColors.main
                      ),
                      onTap: (){
                        if(state.sprinklesAmount == BuiltInSprinkles.zeroAmount.name){
                          state.updateSelectedSprinklesAmount(BuiltInSprinkles.defaultAmount.name);
                        } else {
                          state.updateSelectedSprinklesAmount(BuiltInSprinkles.zeroAmount.name);
                        }
                      },
                    );
                  }
                ),
              ),
            ]
          ); 
          }, onLoading: (){
            return Center(
              child: Loader(
                size: 55
              ),
            ); 
          },
        );
      }, 
      onLoading: (){
        return Center(
          child: Loader(
            size: 55
          ),
        ); 
      },
      );
    }, 
    onLoading: (){
      return Center(
        child: Loader(
          size: 55
        ),
      );
    },
    );
  }
}

