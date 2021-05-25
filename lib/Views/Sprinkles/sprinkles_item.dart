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


class SprinklesItem extends StatefulWidget {
  SprinklesInfo sprinkles;
  Function(String) onSelect;
  Function(String, int) onBuy;
  String selected;
  int points;
  int ffCount;
  bool unlocked;
  num unlockedCount;

  SprinklesItem(this.sprinkles, this.selected, this.points, this.ffCount, this.onSelect, this.onBuy, this.unlocked, this.unlockedCount, {Key key}) : super(key: key);

  @override
  _SprinklesItemState createState() => _SprinklesItemState();
}

class _SprinklesItemState extends State<SprinklesItem> {

  Widget _buildLocked(){
    SprinklesInfo info = widget.sprinkles;

    String tip = "";
    String cost = "";
    int price = 0;
    bool canBuy = false;

    if(info is WinSprinklesInfo){
      int amountLeft = (info.cost * 30) - (widget.points);
      tip = "You need to log ${amountLeft} more perfect days to unlock";
      cost = info.unlockedBy;
      if(info.cost <= widget.ffCount){
        tip = "Double Tap to unlock!";
        price = info.cost;
        canBuy = true;
      }
    } else if(info is BuySprinklesInfo){
      if(info.price > widget.points){
        tip = "You need ${TextHelpers.costToString(info.price - widget.points)} more points to unlock";
      } else {
        tip = "Double Tap to buy!";
        price = info.price;
        canBuy = true;
      }
      cost = TextHelpers.numberToShort(info.price);
    } else if(info is SprinklesAmountInfo){
      if(info.price > widget.points){
        tip = "You need ${TextHelpers.costToString(info.price - widget.points)} more points to unlock";
      } else {
        tip = "Double Tap to buy!";
        price = info.price;
        canBuy = true;
      }
      cost = TextHelpers.numberToShort(info.price);
    }

    return Tooltip(
      preferBelow: false,
      message: tip,
      child: GestureDetector(
        onDoubleTap: (){
          if(canBuy){
            widget.onBuy(info.name, price);
          }
        },
        onTap: (){
          CommonAssets.showSnackbar(context, tip, duration: Duration(milliseconds: 2100));
        },
        child: Container(
          decoration: BoxDecoration(
            color: FoodFrenzyColors.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: CommonAssets.shadow
          ),
          child: ListTile(
            leading: Icon(
              (canBuy) ? FontAwesomeIcons.keySkeleton : FontAwesomeIcons.lockAlt,
              color: (canBuy) ? FoodFrenzyColors.tertiary: FoodFrenzyColors.tertiary,
            ),
            title: AST(
              info.name, 
              color: (canBuy) ? FoodFrenzyColors.tertiary: FoodFrenzyColors.tertiary,
            ),
            subtitle: Align(
              alignment: Alignment.bottomLeft,
              child: AST(
                info.bonus, 
                color: (canBuy) ? FoodFrenzyColors.tertiary: FoodFrenzyColors.tertiary,
              ),
            ),
            trailing: AST(
              cost,
              color: (canBuy) ? FoodFrenzyColors.tertiary: FoodFrenzyColors.tertiary,
              isBold: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnlockedSelected(){
    SprinklesInfo info = widget.sprinkles;

    String tip = "${widget.unlockedCount} total have unocked ${info.name}";

    return Container(
      decoration: BoxDecoration(
        color: FoodFrenzyColors.main,
        borderRadius: BorderRadius.circular(8),
        boxShadow: CommonAssets.shadow,
      ),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.unlockAlt,
          color: FoodFrenzyColors.tertiary
        ),
        title: AST(
          info.name, 
          color: FoodFrenzyColors.tertiary,
          isBold: true,
        ),
        subtitle: AST(
          info.bonus, 
          color: FoodFrenzyColors.tertiary,
        ),
        trailing: Tooltip(
          preferBelow: false,
          message: tip,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AST(
                TextHelpers.numberToShort(widget.unlockedCount),
                color: FoodFrenzyColors.tertiary,
                isBold: true,
              ),
              Container(width: 8),
              Icon(
                FontAwesomeIcons.userUnlock,
                color: FoodFrenzyColors.tertiary,
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildUnlockedUnselected(){
    SprinklesInfo info = widget.sprinkles;

    String tip = "${widget.unlockedCount} total have unocked ${info.name}";

    return Container(
      decoration: BoxDecoration(
        color: FoodFrenzyColors.tertiary,
        borderRadius: BorderRadius.circular(8)
      ),
      child: ListTile(
        leading: Icon(
          FontAwesomeIcons.unlockAlt,
          color: FoodFrenzyColors.secondary
        ),
        title: AST(
          info.name, 
          color: FoodFrenzyColors.secondary,
        ),
        subtitle: AST(
          info.bonus, 
          color: FoodFrenzyColors.secondary,
        ),
        trailing: Tooltip(
          preferBelow: false,
          message: tip,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AST(
                TextHelpers.numberToShort(widget.unlockedCount),
                color: FoodFrenzyColors.secondary,
                isBold: true,
              ),
              Container(width: 8),
              Icon(
                FontAwesomeIcons.userUnlock,
                color: FoodFrenzyColors.secondary,
              ),
            ],
          ),
        ),
        onTap: (){
          widget.onSelect(widget.sprinkles.name);
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    SprinklesInfo info = widget.sprinkles;
    Widget item;
    bool locked = !widget.unlocked;

    if(widget.selected == info.name) {
      locked = false;
    }

    // locked = false;
    // Uncomment this to debug

    if(!locked){
      if(widget.selected == info.name){
        item = _buildUnlockedSelected();
      } else {
        item = _buildUnlockedUnselected();
      }
    } else {
      item = _buildLocked();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 13),
      child: item,
    );

  }
}