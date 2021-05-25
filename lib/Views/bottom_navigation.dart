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
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class FoodFrenzyBottomNavigation extends StatelessWidget{
  final Function(int) _onTap;
  final int _index;

  FoodFrenzyBottomNavigation(this._index, this._onTap);

  Widget _buildBar(bool mpEnabled){
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: _index,
      backgroundColor: FoodFrenzyColors.tertiary,
      items: [
        BottomNavigationBarItem(
          icon: (_index == 0 && mpEnabled) ? Icon(FontAwesomeIcons.undo) : Icon(FontAwesomeIcons.puzzlePiece),
          label:(_index == 0 && mpEnabled) ? "Undo" : "Meal Prep",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.dumbbell),
          label: "Build Workout"
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.home),
          label: "Log"
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.usersCrown),
          label: "Buddies"
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.chartLineDown),
          label: "Statistics"
        ),
      ],
      unselectedItemColor: FoodFrenzyColors.secondary,
      selectedItemColor: FoodFrenzyColors.main,
      onTap: _onTap
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserStateStreamView((userState){
      return _buildBar(userState.showMP);
    }, onLoading: (){
      return _buildBar(false);
    },);
  }
}