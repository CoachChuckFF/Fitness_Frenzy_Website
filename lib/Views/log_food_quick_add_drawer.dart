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

class LogFoodQuickAddDrawerDefines {
  static const caloriesState = 0;
  static const macrosState = 1;
  static const nameState = 2;
}

class LogFoodQuickAddDrawer extends StatefulWidget {
  final Function(Ingredient) onExit;
  final double screenHeight;
  final double screenWidth;
  final double topButtonBarHeight;
  final double topButtonBarWidth;
  final double buttonWidth;
  final bool visable;
  final Ingredient ingredient;

  LogFoodQuickAddDrawer({
    this.onExit,
    this.screenHeight,
    this.screenWidth,
    this.topButtonBarHeight,
    this.topButtonBarWidth,
    this.buttonWidth,
    this.visable,
    this.ingredient,
  });

  @override
  _LogFoodQuickAddDrawerState createState() => _LogFoodQuickAddDrawerState();
}

class _LogFoodQuickAddDrawerState extends State<LogFoodQuickAddDrawer> {
  IntBLoC _stateBloc = IntBLoC(1);
  IngredientListStateBLoC _ingredientsBloc;
  BoolBLoC _updateKeyboardBloc = BoolBLoC();

  Ingredient _calIngredient;
  Ingredient _fatIngredient;
  Ingredient _carbIngredient;
  Ingredient _protIngredient;

  double _multnum = 0;
  String _multString = "";
  bool _plus = false;
  bool _minus = false;
  bool _times = false;
  bool _div = false;
  bool _calcDone = false;

  int _currentMacroState = 0;
  int _lastState = 0;

  @override
  void initState() { 

    _calIngredient = Ingredient(
      name: "Calories",
      hsu: "hCal",
      hss: 1,
      ss: 100,
      amount: 0,
      cal: 100,
      fat: 0,
      carb: 0,
      prot: 0,
      usesml: false,
    );

    _fatIngredient = Ingredient(
      name: "Fat",
      hsu: "g Fat",
      hss: 1,
      ss: 1,
      amount: 0,
      cal: 9,
      fat: 1,
      carb: 0,
      prot: 0,
      usesml: false,
    );

    _carbIngredient = Ingredient(
      name: "Carbohydrate",
      hsu: "g Carb",
      hss: 1,
      ss: 1,
      amount: 0,
      cal: 4,
      fat: 0,
      carb: 1,
      prot: 0,
      usesml: false,
    );

    _protIngredient = Ingredient(
      name: "Protein",
      hsu: "g Prot",
      hss: 1,
      ss: 1,
      amount: 0,
      cal: 4,
      fat: 0,
      carb: 0,
      prot: 1,
      usesml: false,
    );
    
    _ingredientsBloc = IngredientListStateBLoC([
      _calIngredient,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ingredientToState();
    });
    super.initState();
  }

  @override
  void dispose() {
    _stateBloc.dispose();
    _ingredientsBloc.dispose();
    super.dispose();
  }

  void _ingredientToState(){

    if(
      widget.ingredient.fat != 0 ||
      widget.ingredient.carb != 0 ||
      widget.ingredient.prot != 0
    ){
      _fatIngredient.amount = widget.ingredient.fat;
      _carbIngredient.amount = widget.ingredient.carb;
      _protIngredient.amount = widget.ingredient.prot;
      _goToMacros();
    } else if(widget.ingredient.cal != 0){
      _calIngredient.amount = widget.ingredient.cal;
      _goToCals();
    }
  }

  Ingredient _stateToIngredient(){
    int state = _stateBloc.state;
    Ingredient _ingredient = Ingredient.fromMap({});

    _ingredient.name = "Quick Add";
    _ingredient.amount = 1;
    _ingredient.ss = 1;
    _ingredient.hss = 1;

    if(state == LogFoodQuickAddDrawerDefines.nameState) state = _lastState;

    switch(state){
      case LogFoodQuickAddDrawerDefines.caloriesState:
        _ingredient.hsu = "Calories";
        _ingredient.cal = _calIngredient.amount;
      break;
      case LogFoodQuickAddDrawerDefines.macrosState:
        _ingredient.hsu = "Macros";
        _ingredient.fat = _fatIngredient.amount;
        _ingredient.carb = _carbIngredient.amount;
        _ingredient.prot = _protIngredient.amount;
        _ingredient.cal = Calculations.macroToCals(
          _ingredient.fat,
          _ingredient.carb,
          _ingredient.prot
        );
      break;
    }

    return _ingredient;
  }

  void _updateKeyboard(){
    _updateKeyboardBloc.add(BoolToggleEvent());
  }

  Widget _buildBox({bool visable = true, Widget child, Color color, Function onTap, String message, bool selected = false}){
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
              boxShadow: (selected) ? CommonAssets.shadow : [],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  void _goToCals(){
    _stateBloc.add(IntUpdateEvent(LogFoodQuickAddDrawerDefines.caloriesState));
    _ingredientsBloc.add(IngredientListStateClearIngredientsEvent());
    _ingredientsBloc.add(IngredientListStateAddIngredientEvent(_calIngredient));

  } 

  void _goToMacros(){
    _stateBloc.add(IntUpdateEvent(LogFoodQuickAddDrawerDefines.macrosState));
    _ingredientsBloc.add(IngredientListStateClearIngredientsEvent());
    _ingredientsBloc.add(IngredientListStateAddIngredientEvent(_fatIngredient));
    _ingredientsBloc.add(IngredientListStateAddIngredientEvent(_carbIngredient));
    _ingredientsBloc.add(IngredientListStateAddIngredientEvent(_protIngredient));
  }

  Widget _buildSwitchButton(int state){
    return Row(
      children: [
        Expanded(
          child: _buildBox(
            color: (state == LogFoodQuickAddDrawerDefines.macrosState) ? FoodFrenzyColors.main : FoodFrenzyColors.jjTransparent,
            selected: (state == LogFoodQuickAddDrawerDefines.macrosState),
            message: "Add by Macros",
            child: Center(
              child: AST(
                "Macros",
                isBold: true,
                color: (state == LogFoodQuickAddDrawerDefines.macrosState) ? FoodFrenzyColors.tertiary : FoodFrenzyColors.secondary,
              )
            ),
            onTap: (){
              if(state == LogFoodQuickAddDrawerDefines.caloriesState){
                _goToMacros();
              }
            }
          )
        ),
        Expanded(
          child: _buildBox(
            color: (state == LogFoodQuickAddDrawerDefines.caloriesState) ? FoodFrenzyColors.main : FoodFrenzyColors.jjTransparent,
            selected: (state == LogFoodQuickAddDrawerDefines.caloriesState),
            message: "Add by Calories",
            child: Center(
              child: AST(
                "Calories",
                isBold: true,
                color: (state == LogFoodQuickAddDrawerDefines.caloriesState) ? FoodFrenzyColors.tertiary : FoodFrenzyColors.secondary,
              ),
            ),
            onTap: (){
              if(state == LogFoodQuickAddDrawerDefines.macrosState){
                _goToCals();
              }
            }
          ),
        ),
        Container(width: 8,),
        GestureDetector(
          onTap: (){
            CommonAssets.showSnackbar(context, "Double Tap to save as Ingredient");
          },
          onDoubleTap: (){
            _lastState = _stateBloc.state;
            _stateBloc.add(IntUpdateEvent(LogFoodQuickAddDrawerDefines.nameState));
          },
          child: LayoutBuilder(
            builder: (context, size) {
              return Container(
                width: size.maxHeight,
                height: size.maxHeight,
                decoration: BoxDecoration(
                  color: FoodFrenzyColors.tertiary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: CommonAssets.shadow,
                ),
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.save,
                    color: FoodFrenzyColors.secondary,
                  ),
                ),
              );
            }
          ),
        )
      ],
    );
  }

  void _clearMults(){
    _plus = false;
    _minus = false;
    _times = false;
    _div = false;
    _calcDone = false;
    _multnum = 0;
  }

  bool _getCalcActive(){
    return _plus || _minus || _times || _div;
  }

  bool _getButtonEnable(String button){
    if(button == "="){
      return _getCalcActive();
    }

    return true;
  }

  void _handleMacroButton(String button){

    switch(button){
      case "f":
        _currentMacroState = 0;
        _clearMults();
        break;
      case "c":
        _currentMacroState = 1;
        _clearMults();
        break;
      case "p":
        _currentMacroState = 2;
        _clearMults();
        break;
      case "❌":
        _fatIngredient.amount = 0;
        _carbIngredient.amount = 0;
        _protIngredient.amount = 0;
        _clearMults();
        break;
      case "+":
        if(_plus){
          _clearMults();
        } else {
          _clearMults();
          _plus = true;
          _multString = "+";
        }
      break;
      case "-":
        if(_minus){
          _clearMults();
        } else {
          _clearMults();
          _minus = true;
          _multString = "-";
        }
      break;
      case "*":
        if(_times){
          _clearMults();
        } else {
          _clearMults();
          _times = true;
          _multString = "*";
        }
      break;
      case "/":
        if(_div){
          _clearMults();
        } else {
          _clearMults();
          _div = true;
          _multString = "/";
        }
      break;
      case "=":
        if(_getCalcActive()){
          switch(_currentMacroState){
            case 0:
              if(_plus){
                _fatIngredient.amount = _fatIngredient.amount + _multnum;
              } else if(_minus){
                _fatIngredient.amount = _fatIngredient.amount - _multnum;
              } else if(_times){
                _fatIngredient.amount = _fatIngredient.amount * _multnum;
              } else { //div
                if(_multnum != 0){
                  _fatIngredient.amount = _fatIngredient.amount / _multnum;
                } else {
                  _fatIngredient.amount = 0;
                }
              }
              break;
            case 1: 
              if(_plus){
                _carbIngredient.amount = _carbIngredient.amount + _multnum;
              } else if(_minus){
                _carbIngredient.amount = _carbIngredient.amount - _multnum;
              } else if(_times){
                _carbIngredient.amount = _carbIngredient.amount * _multnum;
              } else { //div
                if(_multnum != 0){
                  _carbIngredient.amount = _carbIngredient.amount / _multnum;
                } else {
                  _carbIngredient.amount = 0;
                }
              }
              break;
            default:
              if(_plus){
                _protIngredient.amount = _protIngredient.amount + _multnum;
              } else if(_minus){
                _protIngredient.amount = _protIngredient.amount - _multnum;
              } else if(_times){
                _protIngredient.amount = _protIngredient.amount * _multnum;
              } else { //div
                if(_multnum != 0){
                  _protIngredient.amount = _protIngredient.amount / _multnum;
                } else {
                  _protIngredient.amount = 0;
                }
              }
              break;
          }
        }

        //precheck
        _clearMults();
        _calcDone = true;


        //postcheck
        switch(_currentMacroState){
          case 0:
            if(_fatIngredient.cals > 20000 || _fatIngredient.amount.isNegative){
              _fatIngredient.amount = 0;
            }
            break;
          case 1:
            if(_carbIngredient.cals > 20000 || _carbIngredient.amount.isNegative){
              _carbIngredient.amount = 0;
            }
            break;
          default:
            if(_protIngredient.cals > 20000 || _protIngredient.amount.isNegative){
              _protIngredient.amount = 0;
            }
            break;
        }

      break;
      default: //numbers
        //precheck

        if(_calcDone){
          _clearMults();
          switch(_currentMacroState){
            case 0:
              _fatIngredient.amount = 0;
              break;
            case 1:
              _carbIngredient.amount = 0;
              break;
            default:
              _protIngredient.amount = 0;
              break;
          }
        }

        if(_getCalcActive()){
          _multnum = _multnum * 10 + (int.tryParse(button) ?? 0);

          //postcheck
          if(_multnum > 20000 || _multnum.isNegative){
            _multnum = 0;
          }
        } else {
          switch(_currentMacroState){
            case 0:
              _fatIngredient.amount = _fatIngredient.amount * 10 + (int.tryParse(button) ?? 0);
              break;
            case 1:
              _carbIngredient.amount = _carbIngredient.amount * 10 + (int.tryParse(button) ?? 0);
              break;
            default:
              _protIngredient.amount = _protIngredient.amount * 10 + (int.tryParse(button) ?? 0);
              break;
          }
          
          //postcheck
          switch(_currentMacroState){
            case 0:
              if(_fatIngredient.cals > 20000 || _fatIngredient.amount.isNegative){
                _fatIngredient.amount = 0;
              }
              break;
            case 1:
              if(_carbIngredient.cals > 20000 || _carbIngredient.amount.isNegative){
                _carbIngredient.amount = 0;
              }
              break;
            default:
              if(_protIngredient.cals > 20000 || _protIngredient.amount.isNegative){
                _protIngredient.amount = 0;
              }
              break;
          }
        }

      break;
    }
    _updateKeyboard();
  }

  void _handleButton(String button){

    switch(button){
      case "❌":
        _calIngredient.amount = 0;
        _clearMults();
        break;
      case "+":
        if(_plus){
          _clearMults();
        } else {
          _clearMults();
          _plus = true;
          _multString = "+";
        }
      break;
      case "-":
        if(_minus){
          _clearMults();
        } else {
          _clearMults();
          _minus = true;
          _multString = "-";
        }
      break;
      case "*":
        if(_times){
          _clearMults();
        } else {
          _clearMults();
          _times = true;
          _multString = "*";
        }
      break;
      case "/":
        if(_div){
          _clearMults();
        } else {
          _clearMults();
          _div = true;
          _multString = "/";
        }
      break;
      case "=":
        if(_getCalcActive()){
          if(_plus){
            _calIngredient.amount = _calIngredient.amount + _multnum;
          } else if(_minus){
            _calIngredient.amount = _calIngredient.amount - _multnum;
          } else if(_times){
            _calIngredient.amount = _calIngredient.amount * _multnum;
          } else { //div
            if(_multnum != 0){
              _calIngredient.amount = _calIngredient.amount / _multnum;
            } else {
              _calIngredient.amount = 0;
            }
          }
        }

        //precheck
        _clearMults();
        _calcDone = true;


        //postcheck
        if(_calIngredient.amount > 20000 || _calIngredient.amount.isNegative){
          _calIngredient.amount = 0;
        }
      break;
      default: //numbers
        //precheck

        if(_calcDone){
          _clearMults();
          _calIngredient.amount = 0;
        }

        if(_getCalcActive()){
          _multnum = _multnum * 10 + (int.tryParse(button) ?? 0);

          //postcheck
          if(_multnum > 20000 || _multnum.isNegative){
            _multnum = 0;
          }
        } else {
          _calIngredient.amount = _calIngredient.amount * 10 + (int.tryParse(button) ?? 0);

          //postcheck
          if(_calIngredient.amount > 20000 || _calIngredient.amount.isNegative){
            _calIngredient.amount = 0;
          }
        }

      break;
    }
    _updateKeyboard();
  }

  Widget _buildHelperSquare(String char, bool enabled){
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(3),
        child: Center(
          child: AST(
            char,
            size: 34,
            isBold: enabled,
            color: (enabled) ? FoodFrenzyColors.main : FoodFrenzyColors.secondary.withOpacity(0.1),
            textAlign: TextAlign.center,
          )
        ),
      ),
    );
  }

  Widget _buildMacroNumpad(){
    return BlocBuilder(
      cubit:_ingredientsBloc,
      builder: (context, List<Ingredient> ingredients) {
        return BlocBuilder(
          cubit: _updateKeyboardBloc,
          builder: (context, updated) {
            num totalFat = _fatIngredient.fats;
            num totalCarb = _carbIngredient.carbs();
            num totalProt = _protIngredient.prots;
            num activeNum = 0;
            String activeUnit = "";


            switch(_currentMacroState){
              case 0:
                activeNum = _fatIngredient.fats;
                activeUnit = "f";
                break;
              case 1:
                activeNum = _carbIngredient.carbs();
                activeUnit = "c";
                break;
              default:
                activeNum = _protIngredient.prots;
                activeUnit = "p";
                break;
            }

            return Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: FoodFrenzyColors.tertiary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: CommonAssets.shadow
                      ),
                      child: Container(
                        padding: EdgeInsets.all(13),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: MacroNumbers(
                                      noCal: true,
                                      // cal: totalCals.round(),
                                      // isBold: false,
                                      // defaultColor: FoodFrenzyColors.secondary,

                                      fat: totalFat.round(),
                                      fatColor: _currentMacroState == 0 ? FoodFrenzyColors.main : FoodFrenzyColors.secondary,
                                      isBoldFat: _currentMacroState == 0,
                                      onFat: (){_handleMacroButton('f');},

                                      carb: totalCarb.round(),
                                      carbColor: _currentMacroState == 1 ? FoodFrenzyColors.main : FoodFrenzyColors.secondary,
                                      isBoldCarb: _currentMacroState == 1,
                                      onCarb: (){_handleMacroButton('c');},


                                      prot: totalProt.round(),
                                      protColor: _currentMacroState == 2 ? FoodFrenzyColors.main : FoodFrenzyColors.secondary,
                                      isBoldProt: _currentMacroState == 2,
                                      onProt: (){_handleMacroButton('p');},


                                    )
                                  ),
                                  if(!_getCalcActive())
                                    Container(height: 34,),
                                  if(_getCalcActive())
                                    Container(
                                      height: 34,
                                      child: Row(
                                        children: [
                                          Expanded(child: Container(),),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Center(
                                                child: AST(
                                                  "${activeNum.toStringAsFixed(0)} $activeUnit",
                                                  textAlign: TextAlign.center,
                                                  color: FoodFrenzyColors.secondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Center(
                                              child: AST(
                                                _multString,
                                                textAlign: TextAlign.center,
                                                color: FoodFrenzyColors.secondary,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Center(
                                                child: AST(
                                                  _multnum.toStringAsFixed(0) + "  $activeUnit",
                                                  textAlign: TextAlign.center,
                                                  color: FoodFrenzyColors.secondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(child: Container(),),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(width: 21,),
                            Container(
                              width: 55,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildHelperSquare("+", _plus),
                                        _buildHelperSquare("-", _minus),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildHelperSquare("*", _times),
                                        _buildHelperSquare("/", _div),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  ),
                  Container(height: 21,),
                  Expanded(
                    child: CommonAssets.calcMacroKeypad(_handleMacroButton, _getButtonEnable, _plus, _minus, _times, _div, _currentMacroState),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildCalNumpad(){
    return BlocBuilder(
      cubit:_ingredientsBloc,
      builder: (context, List<Ingredient> ingredients) {
        return BlocBuilder(
          cubit: _updateKeyboardBloc,
          builder: (context, updated) {
            return Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: FoodFrenzyColors.tertiary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: CommonAssets.shadow
                      ),
                      child: Container(
                        padding: EdgeInsets.all(13),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: AST(
                                        "${_calIngredient.amount.toStringAsFixed(0)} C",
                                        color: FoodFrenzyColors.secondary,
                                        textAlign: TextAlign.center,
                                        size: 55,
                                      ),
                                    ),
                                  ),
                                  if(!_getCalcActive())
                                    Container(height: 34,),
                                  if(_getCalcActive())
                                    Container(
                                      height: 34,
                                      child: Row(
                                        children: [
                                          Expanded(child: Container(),),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Center(
                                                child: AST(
                                                  "${_calIngredient.amount.toStringAsFixed(0)} C",
                                                  textAlign: TextAlign.center,
                                                  color: FoodFrenzyColors.secondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Center(
                                              child: AST(
                                                _multString,
                                                textAlign: TextAlign.center,
                                                color: FoodFrenzyColors.secondary,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Center(
                                                child: AST(
                                                  _multnum.toStringAsFixed(0) + " C",
                                                  textAlign: TextAlign.center,
                                                  color: FoodFrenzyColors.secondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(child: Container(),),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              width: 55,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildHelperSquare("+", _plus),
                                        _buildHelperSquare("-", _minus),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildHelperSquare("*", _times),
                                        _buildHelperSquare("/", _div),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  ),
                  Container(height: 21,),
                  Expanded(
                    child: CommonAssets.calcCalKeypad(_handleButton, _getButtonEnable, _plus, _minus, _times, _div),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildNameEntry(){
    Ingredient tempIngredient = _stateToIngredient();

    tempIngredient.name = "";
    return Container();

  }

  Widget _buildHub(){
    return BlocBuilder(
      cubit: _stateBloc,
      builder: (context, state) {

        if(state == LogFoodQuickAddDrawerDefines.nameState) return _buildNameEntry();

        return Column(
          children: [
            Container(
              height: widget.screenHeight * 0.05,
              child: _buildSwitchButton(state),
            ),
            if(state == LogFoodQuickAddDrawerDefines.caloriesState)
            Expanded(
              child: _buildCalNumpad(),
            ),
            if(state == LogFoodQuickAddDrawerDefines.macrosState)
            Expanded(
              child: _buildMacroNumpad(),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogButton(
                    icon: FontAwesomeIcons.check,
                    text: "Done",
                    color: FoodFrenzyColors.main,
                    onTap: (){
                      widget.onExit(_stateToIngredient());
                    },
                    width: widget.buttonWidth,
                  ),
                ],
              ),
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
        child: _buildHub(),
      ),
      visable: widget.visable,
      onExit: (){
        
        widget.onExit(_stateToIngredient());
      },
    );
  }
}