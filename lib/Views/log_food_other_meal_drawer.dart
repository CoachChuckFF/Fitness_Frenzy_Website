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

class LogFoodOtherMealDrawerDefines {
  static const int main = 0;
  static const int ingredientEntry = 1;
  static const int ingredients = 2;
}

class LogFoodOtherMealDrawer extends StatefulWidget {
  final Function(List<Ingredient>) onExit;
  final double screenHeight;
  final double screenWidth;
  final double topButtonBarHeight;
  final double topButtonBarWidth;
  final double buttonWidth;
  final bool visable;
  final List<Ingredient> ingredients;

  LogFoodOtherMealDrawer({
    this.onExit,
    this.screenHeight,
    this.screenWidth,
    this.topButtonBarHeight,
    this.topButtonBarWidth,
    this.buttonWidth,
    this.visable,
    this.ingredients,
  });

  @override
  _LogFoodOtherMealDrawerState createState() => _LogFoodOtherMealDrawerState();
}

class _LogFoodOtherMealDrawerState extends State<LogFoodOtherMealDrawer> {

  StringBLoC _selectedUserBloc = StringBLoC();
  BoolBLoC _updateMealsBloc = BoolBLoC();
  BoolBLoC _validOutputBloc = BoolBLoC();
  Meal _selectedMeal;

  UserState _userState;

  @override
  void initState() { 
    _selectedMeal = Meal.fromMap({
      'ingredients' : [
        for(Ingredient ingredient in widget.ingredients)
          ingredient.toMap(),
      ]
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validOutputBloc.add(BoolUpdateEvent(widget.ingredients.isNotEmpty));
    });
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
    _selectedUserBloc.dispose();
    _updateMealsBloc.dispose();
  }

  Widget _buildMealTile(Meal meal){
    return BlocBuilder(
      cubit: _updateMealsBloc,
      builder: (context, updated) {
        bool selected = meal.ingredients.length == _selectedMeal.ingredients.length;

        if(selected){
          for(var i in _selectedMeal.ingredients){
            int x = meal.ingredients.indexOf(i);
            if(x == -1 || meal.ingredients[x].amount != i.amount){
              selected = false;
              break;
            }
          }
        }

        Ingredient mealIngredient = meal.toIngredient();

        return GestureDetector(
          onTap: (){
            if(!selected){
              _selectedMeal = Meal.fromMap(meal.toMap());
            _validOutputBloc.add(BoolUpdateEvent(true));
            } else {
              _selectedMeal = Meal.fromMap({});
              _validOutputBloc.add(BoolUpdateEvent(false));
            }
            _updateMealsBloc.add(BoolToggleEvent());
          },
          child: Container(
            height: widget.screenHeight * (0.13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: FoodFrenzyColors.tertiary,
              boxShadow: CommonAssets.shadow,
            ),
            margin: EdgeInsets.only(bottom: 20, left: 8, right: 8),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left:13, right: 13,),
                    child: Row(
                      children: [
                        Center(
                          child: Icon(
                            (selected) ? Icons.check_box : Icons.check_box_outline_blank,
                            size: 34,
                            color: (selected) ? FoodFrenzyColors.main : FoodFrenzyColors.secondary,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: AST(
                              meal.name,
                              textAlign: TextAlign.center,
                              color: FoodFrenzyColors.secondary,
                              isBold: true,
                              size: 21,
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left:13, right: 13, bottom: 5,),
                    child: MacroNumbers(
                      cal: mealIngredient.cals.round(),
                      fat: mealIngredient.fats.round(),
                      carb: mealIngredient.carbs(useAlc: _userState.convertAlc).round(),
                      prot: mealIngredient.prots.round(),
                      isBold: false,
                    ),
                  )
                )
              ],
            )
          ),
        );
      }
    );
  }

  Widget _buildHub(){
    return UserStateStreamView(
      (state){
        _userState = state;

        return BlocBuilder(
          cubit: _selectedUserBloc,
          builder: (context, String selectedUser) {
            return MyMealsView(
              (selectedUser.isEmpty) ? state.uid : selectedUser,
              (meals){

                return Column(
                  children: [
                    CommonAssets.buildAccountabilibuddyBar(
                      state, 
                      selectedUser,
                      (uid){
                        _selectedUserBloc.add(StringUpdateEvent(uid));
                      }
                    ),
                    Container(height: 8),
                    if(meals.isNotEmpty)
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (Rect rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [FoodFrenzyColors.tertiary, Colors.transparent, Colors.transparent, FoodFrenzyColors.tertiary,],
                              stops: [0.0, 0.05, 0.95, 1.0], // 10% purple, 80% transparent, 10% purple
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstOut,
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 21),
                            children: [
                              for(var meal in meals) _buildMealTile(meal)
                            ]
                          ),
                        ),
                      ),
                    if(meals.isEmpty)
                      Expanded(
                        child: Center(
                          child: AST(
                            (selectedUser.isEmpty) ?
                              "You have no meals saved!" :
                              "${state.accountabilibuddies[selectedUser]} has no saved meals!",
                              color: FoodFrenzyColors.secondary,
                          )
                        ),
                      ),
                    Container(height: 8,),
                    BlocBuilder(
                      cubit: _validOutputBloc,
                      builder: (context, isValid) {
                        return LogButton(
                          color: FoodFrenzyColors.main,
                          icon: FontAwesomeIcons.check,
                          // disabled: !isValid,
                          text: "Done",
                          width: widget.buttonWidth,
                          onTap: (){
                            widget.onExit(_selectedMeal.ingredients);
                          },
                        );
                      }
                    )
                  ],
                );
              }, onLoading: (){
                return CommonAssets.buildLoader();
              }
            );
          }
        );
      }, onLoading: (){
        return CommonAssets.buildLoader();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomDrawer(
      width: widget.screenWidth,
      height: widget.screenHeight * FoodFrenzyRatios.verticalTallDrawerWidthRatio,
      screenHeight: widget.screenHeight,
      buttonHeight: widget.topButtonBarHeight,
      child: _buildHub(),
      visable: widget.visable,
      onExit: (){
        widget.onExit(_selectedMeal.ingredients);
      },
    );
  }
}