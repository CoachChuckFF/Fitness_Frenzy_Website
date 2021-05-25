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

class LogFoodAlcoholDrawerDefines {
  static const liquorStateUnselected = 0;
  static const liquorStateSelected = 1;
  static const liquorStateStrait = 2;
  static const liquorStateMixed = 3;
  static const liquorStateMixedNoCals = 4;
  static const liquorStateMixedCals = 5;

  static const beerStateUnselected = 0;
  static const beerStateSelected = 1;
  static const beerStateLight = 2;
  static const beerStateHeavy = 3;

  static const wineStateUnselected = 0;
  static const wineStateSelected = 1;
  static const wineStateDry = 2;
  static const wineStateSweet = 3;

}

class LogFoodAlcoholDrawer extends StatefulWidget {
  final Function(List<Ingredient>) onExit;
  final double screenHeight;
  final double screenWidth;
  final double topButtonBarHeight;
  final double topButtonBarWidth;
  final double buttonWidth;
  final bool visable;
  final List<Ingredient> ingredients;

  LogFoodAlcoholDrawer({
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
  _LogFoodAlcoholDrawerState createState() => _LogFoodAlcoholDrawerState();
}

class _LogFoodAlcoholDrawerState extends State<LogFoodAlcoholDrawer> {
  Ingredient _whiskey;
  Ingredient _hvSpirit;
  Ingredient _hvBeverage;
  Ingredient _lightBeer;
  Ingredient _hvBeer;
  Ingredient _dryWhiteWine;
  Ingredient _hvWine;

  IntBLoC _loadingBloc = IntBLoC();

  IntBLoC _liquorStateBloc = IntBLoC();
  IntBLoC _liquorCountBloc = IntBLoC();

  IntBLoC _beerStateBloc = IntBLoC();
  IntBLoC _beerCountBloc = IntBLoC();

  IntBLoC _wineStateBloc = IntBLoC();
  IntBLoC _wineCountBloc = IntBLoC();

  @override
  void initState() { 
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getIngredients();
      _ingredientsToState();
    });
    super.initState();
  }

  @override
  void dispose() {
    _loadingBloc.dispose();

    _liquorStateBloc.dispose();
    _liquorCountBloc.dispose();

    _beerStateBloc.dispose();
    _beerCountBloc.dispose();

    _wineStateBloc.dispose();
    _wineCountBloc.dispose();

    super.dispose();
  }

  void _getIngredients(){
    Ingredient.firebase.getDocument("Whiskey").then((value){
      _whiskey = value;
      _loadingBloc.add(IntIncrementEvent());
    });
    Ingredient.firebase.getDocument("Spirit HV").then((value){
      _hvSpirit = value;
      _loadingBloc.add(IntIncrementEvent());
    });
    Ingredient.firebase.getDocument("Beverage HV").then((value){
      _hvBeverage = value;
      _loadingBloc.add(IntIncrementEvent());
    });
    Ingredient.firebase.getDocument("Light Beer").then((value){
      _lightBeer = value;
      _loadingBloc.add(IntIncrementEvent());
    });
    Ingredient.firebase.getDocument("Beer HV").then((value){
      _hvBeer = value;
      _loadingBloc.add(IntIncrementEvent());
    });
    Ingredient.firebase.getDocument("Dry White Wine").then((value){
      _dryWhiteWine = value;
      _loadingBloc.add(IntIncrementEvent());
    });
    Ingredient.firebase.getDocument("Wine HV").then((value){
      _hvWine = value;
      _loadingBloc.add(IntIncrementEvent());
    });
  }

  void _ingredientsToState(){
    widget.ingredients.forEach((ingredient) { 
      switch(ingredient.name){
        case "Whiskey": 
          _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateStrait));
          _liquorCountBloc.add(IntUpdateEvent(ingredient.amount ~/ ingredient.ss));
        break;
        case "HV Spirit":
          _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateMixedNoCals));
          _liquorCountBloc.add(IntUpdateEvent(ingredient.amount ~/ ingredient.ss));
        break;
        case "HV Beverage": 
          _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateMixedCals));
          _liquorCountBloc.add(IntUpdateEvent(ingredient.amount ~/ ingredient.ss));
        break;
        case "Light Beer":
          _beerStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.beerStateLight));
          _beerCountBloc.add(IntUpdateEvent(ingredient.amount ~/ ingredient.ss));
        break;
        case "HV Beer": 
          _beerStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.beerStateHeavy));
          _beerCountBloc.add(IntUpdateEvent(ingredient.amount ~/ ingredient.ss));
        break;
        case "Dry White Wine":
          _wineStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.wineStateDry));
          _wineCountBloc.add(IntUpdateEvent(ingredient.amount ~/ 150.0));
        break;
        case "HV Wine":
          _wineStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.wineStateSweet));
          _wineCountBloc.add(IntUpdateEvent(ingredient.amount ~/ 150.0));
        break;
      }
    });
  }

  List<Ingredient> _stateToIngredients(){
    List<Ingredient> _ingredients = List<Ingredient>();

    if( 
      (_liquorStateBloc.state == LogFoodAlcoholDrawerDefines.liquorStateStrait ||
      _liquorStateBloc.state == LogFoodAlcoholDrawerDefines.liquorStateMixedNoCals ||
      _liquorStateBloc.state == LogFoodAlcoholDrawerDefines.liquorStateMixedCals) &&
      _liquorCountBloc.state > 0
    ){
      switch(_liquorStateBloc.state){
        case LogFoodAlcoholDrawerDefines.liquorStateStrait:
          _whiskey.amount = _whiskey.ss * _liquorCountBloc.state;
          _ingredients.add(_whiskey);
        break;
        case LogFoodAlcoholDrawerDefines.liquorStateMixedNoCals:
          _hvSpirit.amount = _hvSpirit.ss * _liquorCountBloc.state;
          _ingredients.add(_hvSpirit);
        break;
        case LogFoodAlcoholDrawerDefines.liquorStateMixedCals:
          _hvSpirit.amount = _hvSpirit.ss * _liquorCountBloc.state;
          _ingredients.add(_hvSpirit);

          _hvBeverage.amount = _hvBeverage.ss * _liquorCountBloc.state;
          _ingredients.add(_hvBeverage);
        break;
      }
    }

    if(
      (_beerStateBloc.state == LogFoodAlcoholDrawerDefines.beerStateLight ||
      _beerStateBloc.state == LogFoodAlcoholDrawerDefines.beerStateHeavy) &&
      _beerCountBloc.state > 0
    ){
      switch(_beerStateBloc.state){
        case LogFoodAlcoholDrawerDefines.beerStateLight:
          _lightBeer.amount = _lightBeer.ss * _beerCountBloc.state;
          _ingredients.add(_lightBeer);
        break;
        case LogFoodAlcoholDrawerDefines.beerStateHeavy:
          _hvBeer.amount = _hvBeer.ss * _beerCountBloc.state;
          _ingredients.add(_hvBeer);
        break;
      }
    }

    if(
      (_wineStateBloc.state == LogFoodAlcoholDrawerDefines.wineStateDry ||
      _wineStateBloc.state == LogFoodAlcoholDrawerDefines.wineStateSweet) &&
      _wineCountBloc.state > 0
    ){
      switch(_wineStateBloc.state){
        case LogFoodAlcoholDrawerDefines.wineStateDry:
          _dryWhiteWine.amount = 150.0 * _wineCountBloc.state; //150ml in glass of wine
          _ingredients.add(_dryWhiteWine);
        break;
        case LogFoodAlcoholDrawerDefines.wineStateSweet:
          _hvWine.amount = 150.0 * _wineCountBloc.state;
          _ingredients.add(_hvWine);
        break;
      }
    }

    return _ingredients;
  }

  Widget _buildBox({bool visable = true, Widget child, Color color, Function onTap, String message}){
    if(!visable) return Container();

    return Container(
      padding: EdgeInsets.all(3),
      child: Tooltip(
        preferBelow: false,
        message: message,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: (color == FoodFrenzyColors.jjTransparent) ? [] : CommonAssets.shadow
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildAmount({bool visable, int amount, Color color, String unit, String message, Function onPlus, Function onMinus, Function onClear}){
    if(!visable) return Container();

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: GestureDetector(
              onLongPress: onClear,
              child: AST(
                amount.toString(),
                size: 55,
                color: FoodFrenzyColors.secondary,
              ),
            )
          )
        ),
        Expanded(
          child: Center(
            child: Tooltip(
              preferBelow: false,
              message: message,
              child: AST(
                unit,
                color: FoodFrenzyColors.secondary,
              ),
            )
          )
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildBox(
                  color: color,
                  onTap: onMinus,
                  message: "Subtract",
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.minus,
                      color: FoodFrenzyColors.secondary,
                    )
                  ),
                ),
              ),
              Expanded(
                child: _buildBox(
                  color: color,
                  onTap: onPlus,
                  message: "Add",
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: FoodFrenzyColors.secondary,
                    )
                  ),
                ),
              ),
            ],
          )
        ),
      ],
    );
  }

  Widget _buildLiquor(int state, Color color){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: _buildBox(
              color: (state >= LogFoodAlcoholDrawerDefines.liquorStateSelected) ? color : FoodFrenzyColors.jjTransparent,
              onTap: (){
                if(state >= LogFoodAlcoholDrawerDefines.liquorStateSelected){
                  _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateUnselected));
                } else {
                  _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateSelected));
                }
              },
              message: "Liquor",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    FontAwesomeIcons.glassMartiniAlt,
                    color: FoodFrenzyColors.secondary,
                    size: 44,
                  ),
                  AST(
                    "Liquor",
                    color: FoodFrenzyColors.secondary,
                  ),
                ]
              )
            ),
          ),
          Expanded(
            flex: 2, 
            child: Row(
              children: [
                Expanded(
                  child: _buildBox(
                    visable: (state >= LogFoodAlcoholDrawerDefines.liquorStateSelected),
                    color: (state == LogFoodAlcoholDrawerDefines.liquorStateStrait) ? color : FoodFrenzyColors.jjTransparent,
                    onTap: (){
                      if(state == LogFoodAlcoholDrawerDefines.liquorStateStrait){
                        _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateSelected));
                      } else {
                        _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateStrait));
                      }
                    },
                    message: "Strait Liquor / Shot",
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.glassWhiskeyRocks,
                              color: FoodFrenzyColors.secondary
                            ),
                            Container(height: 3,),
                            AST(
                              "Straight",
                              color: FoodFrenzyColors.secondary,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildBox(
                    visable: (state >= LogFoodAlcoholDrawerDefines.liquorStateSelected),
                    color: (state >= LogFoodAlcoholDrawerDefines.liquorStateMixed) ? color : FoodFrenzyColors.jjTransparent,
                    onTap: (){
                      if(state >= LogFoodAlcoholDrawerDefines.liquorStateMixed){
                        _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateSelected));
                      } else {
                        _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateMixed));
                      }
                    },
                    message: "Mixed Drink",
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.cocktail,
                              color: FoodFrenzyColors.secondary
                            ),
                            Container(height: 3,),
                            AST(
                              "Mixer",
                              color: FoodFrenzyColors.secondary,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          Expanded(
            flex: 2, 
            child: Row(
              children: [
                Expanded(
                  child: _buildBox(
                    visable: (state >= LogFoodAlcoholDrawerDefines.liquorStateMixed),
                    color: (state == LogFoodAlcoholDrawerDefines.liquorStateMixedCals) ? color : FoodFrenzyColors.jjTransparent,
                    onTap: (){
                      if(state == LogFoodAlcoholDrawerDefines.liquorStateMixedCals){
                        _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateMixed));
                      } else {
                        _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateMixedCals));
                      }
                    },
                    message: "Juice, Soda - Has Cals",
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.appleAlt,
                              color: FoodFrenzyColors.secondary
                            ),
                            Container(height: 3,),
                            AST(
                              "Juice",
                              color: FoodFrenzyColors.secondary,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildBox(
                    visable: (state >= LogFoodAlcoholDrawerDefines.liquorStateMixed),
                    color: (state == LogFoodAlcoholDrawerDefines.liquorStateMixedNoCals) ? color : FoodFrenzyColors.jjTransparent,
                    onTap: (){
                      if(state == LogFoodAlcoholDrawerDefines.liquorStateMixedNoCals){
                        _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateMixed));
                      } else {
                        _liquorStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.liquorStateMixedNoCals));
                      }
                    },
                    message: "Diet Soda - 0 Cals",
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.tint,
                              color: FoodFrenzyColors.secondary
                            ),
                            Container(height: 3,),
                            AST(
                              "Diet",
                              color: FoodFrenzyColors.secondary,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          Expanded(
            flex: 5,
            child: BlocBuilder(
              cubit:_liquorCountBloc,
              builder: (context, count) {
                return _buildAmount(
                  visable: (
                    state == LogFoodAlcoholDrawerDefines.liquorStateMixedCals ||
                    state == LogFoodAlcoholDrawerDefines.liquorStateMixedNoCals ||
                    state == LogFoodAlcoholDrawerDefines.liquorStateStrait
                  ),
                  amount: count,
                  color: color,
                  unit: "Singles",
                  message: "One shot of liquor + 1 cup of whatever mix. A double would be 2 singles",
                  onClear: (){
                    _liquorCountBloc.add(IntUpdateEvent(0));
                  },
                  onPlus: (){
                    _liquorCountBloc.add(IntUpdateEvent(_liquorCountBloc.state + 1));
                  },
                  onMinus: (){
                    _liquorCountBloc.add(IntUpdateEvent((_liquorCountBloc.state <= 0) ? 0 : _liquorCountBloc.state - 1));
                  },
                );
              }
            ),
          ),
        ],
      )
    );
  }

  Widget _buildBeer(int state, Color color){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: _buildBox(
              color: (state >= LogFoodAlcoholDrawerDefines.beerStateSelected) ? color : FoodFrenzyColors.jjTransparent,
              onTap: (){
                if(state >= LogFoodAlcoholDrawerDefines.beerStateSelected){
                  _beerStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.beerStateUnselected));
                } else {
                  _beerStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.beerStateSelected));
                }
              },
              message: "Beer",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    FontAwesomeIcons.beer,
                    color: FoodFrenzyColors.secondary,
                    size: 44,
                  ),
                  AST(
                    "Beer",
                    color: FoodFrenzyColors.secondary,
                  ),
                ]
              )
            ),
          ),
          Expanded(
            flex: 2, 
            child: Row(
              children: [
                Expanded(
                  child: _buildBox(
                    visable: (state >= LogFoodAlcoholDrawerDefines.beerStateSelected),
                    color: (state == LogFoodAlcoholDrawerDefines.beerStateLight) ? color : FoodFrenzyColors.jjTransparent,
                    onTap: (){
                      if(state == LogFoodAlcoholDrawerDefines.beerStateLight){
                        _beerStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.beerStateSelected));
                      } else {
                        _beerStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.beerStateLight));
                      }
                    },
                    message: "Light Beer",
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.feather,
                              color: FoodFrenzyColors.secondary
                            ),
                            Container(height: 3,),
                            AST(
                              "Light",
                              color: FoodFrenzyColors.secondary,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildBox(
                    visable: (state >= LogFoodAlcoholDrawerDefines.beerStateSelected),
                    color: (state == LogFoodAlcoholDrawerDefines.beerStateHeavy) ? color : FoodFrenzyColors.jjTransparent,
                    onTap: (){
                      if(state == LogFoodAlcoholDrawerDefines.beerStateHeavy){
                        _beerStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.beerStateSelected));
                      } else {
                        _beerStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.beerStateHeavy));
                      }
                    },
                    message: "Regular / Craft Beers",
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.weightHanging,
                              color: FoodFrenzyColors.secondary
                            ),
                            Container(height: 3,),
                            AST(
                              "Heavy",
                              color: FoodFrenzyColors.secondary,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          Expanded(
            flex: 2, 
            child: Container(),
          ),
          Expanded(
            flex: 5,
            child: BlocBuilder(
              cubit:_beerCountBloc,
              builder: (context, count) {
                return _buildAmount(
                  visable: (
                    state == LogFoodAlcoholDrawerDefines.beerStateHeavy ||
                    state == LogFoodAlcoholDrawerDefines.beerStateLight
                  ),
                  amount: count,
                  unit: "Beers",
                  message: "One 12oz beer - this is standard for a can, a bottle or a tap pour",
                  color: color,
                  onClear: (){
                    _beerCountBloc.add(IntUpdateEvent(0));
                  },
                  onPlus: (){
                    _beerCountBloc.add(IntUpdateEvent(_beerCountBloc.state + 1));
                  },
                  onMinus: (){
                    _beerCountBloc.add(IntUpdateEvent((_beerCountBloc.state <= 0) ? 0 : _beerCountBloc.state - 1));
                  },
                );
              }
            )
          ),
        ],
      )
    );
  }

  Widget _buildWine(int state, Color color){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: _buildBox(
              color: (state >= LogFoodAlcoholDrawerDefines.wineStateSelected) ? color : FoodFrenzyColors.jjTransparent,
              onTap: (){
                if(state >= LogFoodAlcoholDrawerDefines.wineStateSelected){
                  _wineStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.wineStateUnselected));
                } else {
                  _wineStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.wineStateSelected));
                }
              },
              message: "Wine",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    FontAwesomeIcons.wineGlassAlt,
                    color: FoodFrenzyColors.secondary,
                    size: 44,
                  ),
                  AST(
                    "Wine",
                    color: FoodFrenzyColors.secondary,
                  ),
                ]
              )
            ),
          ),
          Expanded(
            flex: 2, 
            child: Row(
              children: [
                Expanded(
                  child: _buildBox(
                    visable: (state >= LogFoodAlcoholDrawerDefines.wineStateSelected),
                    color: (state == LogFoodAlcoholDrawerDefines.wineStateDry) ? color : FoodFrenzyColors.jjTransparent,
                    onTap: (){
                      if(state == LogFoodAlcoholDrawerDefines.wineStateDry){
                        _wineStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.wineStateSelected));
                      } else {
                        _wineStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.wineStateDry));
                      }
                    },
                    message: "Dry Wine",
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.skullCow,
                              color: FoodFrenzyColors.secondary
                            ),
                            Container(height: 3,),
                            AST(
                              "Dry",
                              color: FoodFrenzyColors.secondary,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildBox(
                    visable: (state >= LogFoodAlcoholDrawerDefines.wineStateSelected),
                    color: (state == LogFoodAlcoholDrawerDefines.wineStateSweet) ? color : FoodFrenzyColors.jjTransparent,
                    onTap: (){
                      if(state == LogFoodAlcoholDrawerDefines.wineStateSweet){
                        _wineStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.wineStateSelected));
                      } else {
                        _wineStateBloc.add(IntUpdateEvent(LogFoodAlcoholDrawerDefines.wineStateSweet));
                      }
                    },
                    message: "Sweet / Dessert Wine",
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.birthdayCake,
                              color: FoodFrenzyColors.secondary
                            ),
                            Container(height: 3,),
                            AST(
                              "Sweet",
                              color: FoodFrenzyColors.secondary,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          Expanded(
            flex: 2, 
            child: Container(),
          ),
          Expanded(
            flex: 5,
            child: BlocBuilder(
              cubit:_wineCountBloc,
              builder: (context, count) {
                return _buildAmount(
                  visable: (
                    state == LogFoodAlcoholDrawerDefines.wineStateDry ||
                    state == LogFoodAlcoholDrawerDefines.wineStateSweet
                  ),
                  amount: count,
                  unit: "Glasses",
                  message: "1/5 bottle of wine (150mL) or 1 restaurant pour",
                  color: color,
                  onClear: (){
                    _wineCountBloc.add(IntUpdateEvent(0));
                  },
                  onPlus: (){
                    _wineCountBloc.add(IntUpdateEvent(_wineCountBloc.state + 1));
                  },
                  onMinus: (){
                    _wineCountBloc.add(IntUpdateEvent((_wineCountBloc.state <= 0) ? 0 : _wineCountBloc.state - 1));
                  },
                );
              }
            )
          ),
        ],
      )
    );
  }

  Widget _buildHub(){
    return BlocBuilder(
      cubit:_loadingBloc,
      builder: (context, loadingCount){
        if(loadingCount < 7) return CommonAssets.buildLoader();

        return Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(5),
                child: AST(
                  "Tap Your Alcohols",
                  isBold: true,
                  color: FoodFrenzyColors.secondary,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  BlocBuilder(
                    cubit:_liquorStateBloc,
                    builder: (context, state) {
                      return _buildLiquor(state, FoodFrenzyColors.jjBlue);
                    }
                  ),
                  BlocBuilder(
                    cubit:_beerStateBloc,
                    builder: (context, state) {
                      return _buildBeer(state, FoodFrenzyColors.jjYellow);
                    }
                  ),
                  BlocBuilder(
                    cubit:_wineStateBloc,
                    builder: (context, state) {
                      return _buildWine(state, FoodFrenzyColors.jjRed);
                    }
                  ),
                ]
              ),
            ),
            Container(height: 13,),
            BlocBuilder(
              cubit: _wineCountBloc,
              builder: (context, ws) {
                return BlocBuilder(
                  cubit: _beerCountBloc,
                  builder: (context, bs) {
                    return BlocBuilder(
                      cubit: _liquorCountBloc,
                      builder: (context, ls) {

                        bool ready = _stateToIngredients().isNotEmpty;

                        return Center(
                          child: LogButton(
                            icon: FontAwesomeIcons.check,
                            text: "Done",
                            // disabled: !ready,
                            color: FoodFrenzyColors.main,
                            onTap: (){
                              widget.onExit(_stateToIngredients());
                            },
                            width: widget.buttonWidth,
                          ),
                        );
                      }
                    );
                  }
                );
              }
            )
          ],
        );
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
      child: Container(
        padding: EdgeInsets.all(13),
        child: _buildHub(),
      ),
      visable: widget.visable,
      onExit: (){
        
        widget.onExit(_stateToIngredients());
      },
    );
  }
}