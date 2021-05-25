/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/

// Used Packages
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';

class LogFoodDefines {
  static const String fullDayFast = "Full Day Fast";
  static const String freeMeal = "Free Meal";
  static const String preWorkout = "Pre-Workout";
  static const String postWorkout = "Post-Workout";
  static const String breakfast = "Breakfast";
  static const String morningSnack = "Morning Snack";
  static const String lunch = "Lunch";
  static const String afternoonSnack = "Afternoon Snack";
  static const String dinner = "Dinner";
  static const String eveningSnack = "Evening Snack";
  static const String otherMeal = "Saved Meals";
  static const String addFood = "Ingredients";
  static const String quickAdd = "Macro Calc";
  static const String alcohol = "Alcohol Calc";
  static const String foodEstimator = "Event Calc";

  static IconData mealToIcon(String meal){
    switch(meal){
      case LogFoodDefines.fullDayFast: return FoodFrenzyIcons.fastingIcon;
      case LogFoodDefines.freeMeal: return FoodFrenzyIcons.freeMealIcon;
      case LogFoodDefines.preWorkout: return FoodFrenzyIcons.preWorkoutIcon;
      case LogFoodDefines.postWorkout: return FoodFrenzyIcons.postWorkoutIcon;
      case LogFoodDefines.breakfast: return FoodFrenzyIcons.breakfastIcon;
      case LogFoodDefines.morningSnack: return FoodFrenzyIcons.morningSnackIcon;
      case LogFoodDefines.lunch: return FoodFrenzyIcons.lunchIcon;
      case LogFoodDefines.afternoonSnack: return FoodFrenzyIcons.afternoonSnack;
      case LogFoodDefines.dinner: return FoodFrenzyIcons.dinner;
      case LogFoodDefines.eveningSnack: return FoodFrenzyIcons.eveningSnack;
      default: return FontAwesomeIcons.appleAlt;
    }
  }

  static Color mealToColor(String name){
    switch(name){
      case LogFoodDefines.fullDayFast: return FoodFrenzyColors.jjWhite;
      case LogFoodDefines.freeMeal: return FoodFrenzyColors.jj1;
      case LogFoodDefines.preWorkout: return FoodFrenzyColors.jj1;
      case LogFoodDefines.postWorkout: return FoodFrenzyColors.jj2;
      case LogFoodDefines.breakfast: return FoodFrenzyColors.jj3;
      case LogFoodDefines.morningSnack: return FoodFrenzyColors.jj4;
      case LogFoodDefines.lunch: return FoodFrenzyColors.jj5;
      case LogFoodDefines.afternoonSnack: return FoodFrenzyColors.jj6;
      case LogFoodDefines.dinner: return FoodFrenzyColors.jj7;
      case LogFoodDefines.eveningSnack: return FoodFrenzyColors.jj8;
      default: return FoodFrenzyColors.jjWhite;
    }
  }
}

class LogFood extends StatefulWidget {

  final bool visable;
  final double screenWidth;
  final double screenHeight;
  final double buttonWidth;
  final double topButtonBarWidth;
  final double topButtonBarHeight;
  final double screenTopPadding;
  final double sideDrawerWidth;
  final double sideDrawerHeight;

  final int startingMenuIndex;
  final Function clearStartingIndex;

  final Function onExit;

  LogFood({
    this.visable,
    this.screenWidth,
    this.screenHeight,
    this.buttonWidth,
    this.topButtonBarHeight,
    this.topButtonBarWidth,
    this.screenTopPadding,
    this.sideDrawerHeight,
    this.sideDrawerWidth,
    this.startingMenuIndex = -1,
    this.clearStartingIndex,
    this.onExit,
    Key key
  }) : super(key: key);

  @override
  _LogFoodState createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  LogFoodDrawerStateBLoC _drawerBloc = LogFoodDrawerStateBLoC();
  BoolBLoC _setStateBloc = BoolBLoC();
  BoolBLoC _dragToStart = BoolBLoC(true);
  IntBLoC _waterLevel = IntBLoC();
  Day _day;
  UserLog _log;
  UserState _state;
  UserLogEntries _entries = UserLogEntries.fromMap({});
  bool delete = false;
  bool show = false;
  bool bullseye = true;
  String _meal;
  bool moving = false;
  List<Ingredient> _tempIngredients;
  String type = "";
  int toTime;
  double waterGoal = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStartingMenu(widget.startingMenuIndex);
    });

    super.initState();
  }

  @override
  void dispose() {
    _setStateBloc.dispose();
    _drawerBloc.dispose();
    super.dispose();
  }

  void _handleStartingMenu(int index){
    if(index.isNegative){
      // _drawerBloc.add(DrawerClearStateEvent());
      return;
    }

    switch(index){
      case FoodFrenzyRoutes.menuIndexDashboardLogFoodOtherMeal:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Other Meal"));
        break;
      case FoodFrenzyRoutes.menuIndexDashboardLogFoodAddFood:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Add Food"));
        break;
      case FoodFrenzyRoutes.menuIndexDashboardLogFoodQuickAdd:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Quick Add"));
        break;
      case FoodFrenzyRoutes.menuIndexDashboardLogFoodAlcEST:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Alcohol"));
        break;
      case FoodFrenzyRoutes.menuIndexDashboardLogFoodFoodEST:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Food Estimator"));
        break;
      case FoodFrenzyRoutes.menuIndexDashboardLogFoodBars:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Food Stats"));
        break;
    }

    if(widget.clearStartingIndex != null){
      widget.clearStartingIndex();
    }
  }

  bool _isLogEmpty(UserLog log){
    for(int i = 0; i < 24; i++){
      if(log.food[i].isNotEmpty) return false;
    }

    return true;
  }

  void _tapToFunction(String name){
    switch(name){
      case LogFoodDefines.preWorkout:
      case LogFoodDefines.postWorkout:
      case LogFoodDefines.breakfast:
      case LogFoodDefines.morningSnack:
      case LogFoodDefines.lunch:
      case LogFoodDefines.afternoonSnack:
      case LogFoodDefines.dinner:
      case LogFoodDefines.eveningSnack:
        // Navigator.pushReplacementNamed(context, FoodFrenzyRoutes.mealPlanner);
        // _meal = name;
        // if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Nutrition Label"));
        break;
      case LogFoodDefines.fullDayFast:
        CommonAssets.showSnackbar(context, "The ultimate body detox");
        break;
      case LogFoodDefines.freeMeal:
        CommonAssets.showSnackbar(context, "An untracked healthy meal: ${(_state.freeMealFrequency == 0) ? '1 evey week' : '1 every 2 weeks'}");
        break;
      case LogFoodDefines.otherMeal:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Other Meal"));
        break;
      case LogFoodDefines.addFood:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Add Food"));
        break;
      case LogFoodDefines.alcohol:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Alcohol"));
        break;
      case LogFoodDefines.foodEstimator:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Food Estimator"));
        break;
      case LogFoodDefines.quickAdd:
        if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Quick Add"));
        break;
    }
  }

  void _clearEntry(String name){
    switch(name){
      case LogFoodDefines.otherMeal:
        _entries.otherMeal = [];
        break;
      case LogFoodDefines.addFood:
        _entries.addFood = [];
        break;
      case LogFoodDefines.alcohol:
        _entries.alcohol = [];
        break;
      case LogFoodDefines.foodEstimator:
        _entries.foodEstimator = [];
        break;
      case LogFoodDefines.quickAdd:
        _entries.quickAdd = Ingredient.fromMap({});
        break;
    }
  }

  void _setEntry(String name, List<Ingredient> ingredients){
    switch(name){
      case LogFoodDefines.otherMeal:
        if(_entries.otherMeal.isEmpty)
          _entries.otherMeal = List<Ingredient>.from(ingredients);
        break;
      case LogFoodDefines.addFood:
        if(_entries.addFood.isEmpty)
          _entries.addFood = List<Ingredient>.from(ingredients);
        break;
      case LogFoodDefines.alcohol:
        if(_entries.alcohol.isEmpty)
          _entries.alcohol = List<Ingredient>.from(ingredients);
        break;
      case LogFoodDefines.foodEstimator:
        if(_entries.foodEstimator.isEmpty)
          _entries.foodEstimator = List<Ingredient>.from(ingredients);
        break;
      case LogFoodDefines.quickAdd:
        if(_entries.quickAdd.cals == 0)
          _entries.quickAdd = Ingredient.fromMap(ingredients.first.toMap());
        break;
    }
  }

  void _addToCurrentTime(String block){
    bool didChange = false;
    _setState(() {
      _dragDragStarted();
      show = false;
      delete = false;

      if(block == LogFoodDefines.fullDayFast){
        _clearLog();
        _log.didFast = true;
        didChange = true;
        for (var i = 0; i < _log.food.length; i++) {
          _log.food[i].add(Ingredient(logType: LogFoodDefines.fullDayFast));
        }
      } else if(!_log.didFast){

        //get current time
        int hour = DateTime.now().hour;

        for(int i = hour; i < 24; i++){
          if(_log.food[i].isEmpty){
            _log.food[i] = []; //clear list
            _addIngredients(block, i);
            didChange = true;
            break;
          }
        }
      }
    });

    //Save On Update
    if(didChange){
      _clearEntry(block);
      _saveLog();
    }
  }

  Widget _buildDragToTile([int index = 0]){
    return DragTarget<String>(
      onWillAccept: (block){

        _setState(() {
          show = true;
          bullseye = false;
          delete = false;
          type = block;
          toTime = index;       
        });

        return _log.food[index].isEmpty; //don't allow an overwrite
      },
      onAccept: (block){
        _setState(() {
          show = false;
          bullseye = true;
          delete = false;

          if(block == LogFoodDefines.fullDayFast){
            _clearLog();
            _log.didFast = true;
            for (var i = 0; i < _log.food.length; i++) {
              _log.food[i].add(Ingredient(logType: LogFoodDefines.fullDayFast));
            }
          } else if(!_log.didFast){
            _log.food[index] = []; //clear list

            if(moving){
              _tempIngredients.forEach((ingredient) {_log.food[index].add(ingredient); });
            } else {
              _addIngredients(block, index);
            }

            _clearEntry(block);
          }
        });

        //Save On Update
        _saveLog();
      },
      onLeave: (block){
        if(block == LogFoodDefines.fullDayFast && delete){
          _clearLog();
          _saveLog();
        } else if(_log.food[index].isNotEmpty && delete){
          if(moving){
            if(_tempIngredients.length >= 2){
              String block = _tempIngredients[0].logType;
              _setEntry(block, _tempIngredients.sublist(1));
            }
          }
          _log.food[index] = [];
          _saveLog();
        }

      },
      builder: (context, candidates, rejects){

        Color color;
        Color textColor;
        String text = null;

        if(_log.didFast){
          color = LogFoodDefines.mealToColor(LogFoodDefines.fullDayFast);
          textColor = FoodFrenzyColors.secondary;
        } else if(candidates.length > 0){
          color = LogFoodDefines.mealToColor(candidates.first);
          textColor = FoodFrenzyColors.secondary;
          text = candidates.first;
        }else if(_log.food[index].isNotEmpty){
          color = LogFoodDefines.mealToColor(_log.food[index][0].logType);
          textColor = FoodFrenzyColors.secondary;
        } else {
          color = FoodFrenzyColors.jjTransparent;
          textColor = FoodFrenzyColors.jjTransparent;
        }

        return Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular((index == 0) ? 5 : 0),
              bottomLeft: Radius.circular((index == 23) ? 5 : 0),
              topRight: Radius.circular((index == 0) ? 5 : 0),
              bottomRight: Radius.circular((index == 23) ? 5 : 0),
            )
          ),
          child: (_log.food[index].length == 0) ? 
            _buildUnslotted(textColor, index, text) : 
            _buildSlotted(textColor, index),
        );
      }
    );
  }

  Widget _buildSlotted(Color textColor, int index){
    return Center(
      child: Draggable<String>(
        dragAnchor: DragAnchor.pointer,
        onDragStarted: (){
          _setState(() {
            _tempIngredients = List<Ingredient>.from(_log.food[index]);
            moving = true;
            delete = true;
            show = false;
            bullseye = true;
          });
        },
        onDraggableCanceled: (v,o){
          _setState(() {
            moving = false;
            delete = false;
            show = false;
            bullseye = true;
          });
        },
        onDragCompleted: (){
          _setState(() {
            moving = false;
            delete = false;
            show = false;
            bullseye = true;
          });   
        },
        feedback: Icon(
          FontAwesomeIcons.appleAlt, 
          color: FoodFrenzyColors.secondary,
          size: 40,
        ),
        childWhenDragging: Container(),
        data: _log.food[index][0].logType,
        child: GestureDetector(
          onTap: (){
            CommonAssets.showSnackbar(context, "Double Tap or Drag Left to delete");
          },
          onDoubleTap: (){
            _setState(() {
              _tempIngredients = List<Ingredient>.from(_log.food[index]);
              _log.food[index] = [];
              if(_tempIngredients.length >= 2){
                String block = _tempIngredients[0].logType;
                _setEntry(block, _tempIngredients.sublist(1));
              }

              if(_tempIngredients.first.logType == LogFoodDefines.fullDayFast){
                _clearLog();
              }

              moving = false;
              delete = false;
              show = false;
              bullseye = false;
            });
            _saveLog();
          },
          child: Container(
            color: FoodFrenzyColors.jjTransparent,
            child: _buildUnslotted(textColor, index, null),
          ),
        ),
      ),
    );
  }

  Widget _buildUnslotted(Color textColor, int index, String text){
    return Container(
      padding: EdgeInsets.only(left: 3, right: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: AST(
                TextHelpers.indexToTime(index),
                color: textColor,
                isBold: true,
                size: 34,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: AST(
                text ?? ((_log.food[index].isNotEmpty) ? _log.food[index][0].logType : ""),
                color: textColor,
                textAlign: TextAlign.center,
                isBold: true,
                size: 34,
              )
            )
          ),
          Expanded(
            child: Container(
              child: AST(
                ((_log.food[index].isNotEmpty) ? "${TextHelpers.numberToShort(Ingredient.calsFromList(_log.food[index]))}C" : ""),
                color: textColor,
                isBold: true,
                textAlign: TextAlign.end,
                size: 34,
              )
            )
          ),
        ],
      ),
    );
  }

  Widget _buildFoodObjectTile(String text, Color color, IconData icon, double height, double width, {bool canDrag = true, bool editable = false}){

    Widget child = 
    GestureDetector(
      onTap: ()=> _tapToFunction(text),
      onHorizontalDragStart: (canDrag) ? null : (_)=> _tapToFunction(text),
      child: Container(
        decoration: BoxDecoration(
          color: color,//color.withAlpha(200),
          borderRadius: BorderRadius.circular(5),
          boxShadow: CommonAssets.shadow,
        ), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AST(
                    text,
                    textAlign: TextAlign.left,
                    color: FoodFrenzyColors.secondary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  if(canDrag){
                    _addToCurrentTime(text);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: (canDrag) ? color : FoodFrenzyColors.jjTransparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: (canDrag) ? CommonAssets.shadow : null,
                  ),
                    child: Center(
                      child: Icon(
                      (canDrag) ? FontAwesomeIcons.arrowAltCircleRight : FontAwesomeIcons.edit,
                      color: (canDrag) ? FoodFrenzyColors.secondary : FoodFrenzyColors.jjTransparent,
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
      )
    );


    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      child: (canDrag) ? Draggable<String>(
        dragAnchor: DragAnchor.pointer,
        affinity: Axis.horizontal,
        onDragStarted: (){
          _dragDragStarted();
        },
        onDraggableCanceled: (v,o){
          _setState(() {
            show = false;
            bullseye = true;
          });
        },
        onDragCompleted: (){
          _setState(() {
            show = false;
            bullseye = true;
          });   
        },
        data: text,
        feedback: Icon(
          icon,
          color: FoodFrenzyColors.secondary,
          size: 34,
        ),
        child: child) : child, 
    );
  }


  void _dragDragStarted(){
    if(_dragToStart.state){
      _dragToStart.add(BoolUpdateEvent(false));
    }
  }

  Widget _buildTitle({String title, Function onTap, bool hasShadow = false, double size = 34, Widget bottomWidget}){
    return GestureDetector(
      onTap: onTap ?? null,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: (hasShadow) ? BoxDecoration(
          color: FoodFrenzyColors.tertiary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: CommonAssets.shadow,
        ) : null,
        child: Column(
          children: [
            Center(
              child: AST(
                title ?? '',
                color: FoodFrenzyColors.secondary,
                isBold: true,
                size: size,
              ),
            ),
            if(bottomWidget != null)
              bottomWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildFoodLogger(){
    Color fatColor = FoodFrenzyColors.jjRed;
    Color carbColor = FoodFrenzyColors.jjRed;
    Color protColor = FoodFrenzyColors.jjRed;         
    double fat = 0;
    double carb = 0;
    double prot = 0;
    bool showFreeMeal = true;

    _log.food.forEach((time) {
      if(time.isNotEmpty){
        Macro macro = Calculations.getMacros(time, _state.convertAlc);

        fat += macro.fat;
        carb += macro.carb;
        prot += macro.prot;

        if(time.first.logType == LogFoodDefines.freeMeal){
          showFreeMeal = false;
        }
      }
    });

    if(showFreeMeal){
      switch(_state.freeMealFrequency){
        case 0: //1 time a week
          showFreeMeal = _state.lastFreeMeal.isBefore(Calculations.getTopOfTheWeek()) || Calculations.isSameDay(_state.lastFreeMeal);
          break;
        case 1: //1 time /2weeks
          showFreeMeal = _state.lastFreeMeal.isBefore(Calculations.getTopOfTheWeek().subtract(Duration(days: 7))) || Calculations.isSameDay(_state.lastFreeMeal);
          break;
        default: //off
          showFreeMeal = false;
          break;
      }
    }

    fat = _state.fat - fat;
    if(fat.round() < 0){
      fatColor = FoodFrenzyColors.jjRed;
    } else {
      fatColor = FoodFrenzyColors.secondary;
    }

    carb = _state.carb - carb;
    if(carb.round() < 0){
      carbColor = FoodFrenzyColors.jjRed;
    } else {
      carbColor = FoodFrenzyColors.secondary;
    }

    prot = _state.prot - prot;
    if(prot.round() < 0){
      protColor = FoodFrenzyColors.jjRed;
    } else {
      protColor = FoodFrenzyColors.secondary;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, size) {
                  double width = size.maxWidth;
                  double height = size.maxHeight/8;
                  return Container(
                    padding: EdgeInsets.only(
                      left: 13, 
                      right: 21,
                    ),
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
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 21),
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[ 
                          if(_day != null)
                          _buildTitle(
                            title: "Prepped Meals",
                            onTap: (){
                              Navigator.pushReplacementNamed(context, FoodFrenzyRoutes.mealPlanner);
                            }
                          ),
                          _buildFoodObjectTile(LogFoodDefines.fullDayFast, FoodFrenzyColors.tertiary, FoodFrenzyIcons.fastingIcon, height, width),
                          if(showFreeMeal) _buildFoodObjectTile(LogFoodDefines.freeMeal, FoodFrenzyColors.jj1, FoodFrenzyIcons.freeMealIcon, height, width),
                          if(_day != null && _day.day[LogFoodDefines.preWorkout].isNotEmpty) _buildFoodObjectTile(LogFoodDefines.preWorkout, FoodFrenzyColors.preWorkoutColor, FoodFrenzyIcons.preWorkoutIcon, height, width, editable: true),
                          if(_day != null && _day.day[LogFoodDefines.postWorkout].isNotEmpty) _buildFoodObjectTile(LogFoodDefines.postWorkout, FoodFrenzyColors.postWorkoutColor, FoodFrenzyIcons.postWorkoutIcon, height, width, editable: true),
                          if(_day != null && _day.day[LogFoodDefines.breakfast].isNotEmpty) _buildFoodObjectTile(LogFoodDefines.breakfast, FoodFrenzyColors.breakfastColor, FoodFrenzyIcons.breakfastIcon, height, width, editable: true),
                          if(_day != null && _day.day[LogFoodDefines.morningSnack].isNotEmpty) _buildFoodObjectTile(LogFoodDefines.morningSnack, FoodFrenzyColors.morningSnackColor, FoodFrenzyIcons.morningSnackIcon, height, width, editable: true),
                          if(_day != null && _day.day[LogFoodDefines.lunch].isNotEmpty) _buildFoodObjectTile(LogFoodDefines.lunch, FoodFrenzyColors.lunchColor, FoodFrenzyIcons.lunchIcon, height, width, editable: true),
                          if(_day != null && _day.day[LogFoodDefines.afternoonSnack].isNotEmpty) _buildFoodObjectTile(LogFoodDefines.afternoonSnack, FoodFrenzyColors.afternoonSnackColor, FoodFrenzyIcons.afternoonSnack, height, width, editable: true),
                          if(_day != null && _day.day[LogFoodDefines.dinner].isNotEmpty) _buildFoodObjectTile(LogFoodDefines.dinner, FoodFrenzyColors.dinnerColor, FoodFrenzyIcons.dinner, height, width, editable: true),
                          if(_day != null && _day.day[LogFoodDefines.eveningSnack].isNotEmpty) _buildFoodObjectTile(LogFoodDefines.eveningSnack, FoodFrenzyColors.eveningSnackColor, FoodFrenzyIcons.eveningSnack, height, width, editable: true),
                          _buildFoodObjectTile(LogFoodDefines.otherMeal, FoodFrenzyColors.tertiary, FoodFrenzyIcons.placeholder, height, width, canDrag: _entries.otherMeal.length != 0, editable: true),
                          Container(height: 21,),
                          _buildTitle(
                            title: "Impromptu Meals"
                          ),
                          _buildFoodObjectTile(LogFoodDefines.addFood, FoodFrenzyColors.tertiary, FoodFrenzyIcons.placeholder, height, width, canDrag: _entries.addFood.length != 0, editable: true),
                          _buildFoodObjectTile(LogFoodDefines.quickAdd, FoodFrenzyColors.tertiary, FoodFrenzyIcons.placeholder, height, width, canDrag: _entries.quickAdd.cal != 0, editable: true),
                          _buildFoodObjectTile(LogFoodDefines.alcohol, FoodFrenzyColors.tertiary, FoodFrenzyIcons.placeholder, height, width, canDrag: _entries.alcohol.length != 0, editable: true),
                          _buildFoodObjectTile(LogFoodDefines.foodEstimator, FoodFrenzyColors.tertiary, FoodFrenzyIcons.placeholder, height, width, canDrag: _entries.foodEstimator.length != 0, editable: true),
                        ],
                      ),
                    ),
                  );
                }
              ),
              (show) ? IgnorePointer(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 13,
                    right: 21
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: CommonAssets.shadow,
                      color: LogFoodDefines.mealToColor(type),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(13),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Container()),
                            AST(
                              type,
                              color: FoodFrenzyColors.secondary,
                              size: 55,
                            ),
                            Icon(
                              FontAwesomeIcons.arrowDown,
                              size: 34,
                              color: FoodFrenzyColors.secondary,
                            ),
                            Expanded(
                              child: AST(
                                TextHelpers.indexToStdTime(toTime),
                                maxLines: 1,
                                color: FoodFrenzyColors.secondary,
                                size: 55,
                              ),
                            ),
                          ]
                        ),
                      )
                    ),
                  ),
                )
              ) : Container(),
              (delete) ? IgnorePointer(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 13,
                    right: 21
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: FoodFrenzyColors.main,
                      boxShadow: CommonAssets.shadow
                    ),
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.trash,
                        color: FoodFrenzyColors.secondary,
                        size: 55
                      )
                    ),
                  ),
                )
              ) : Container()
            ]
          )
        ), 
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              right: 13,
            ),
            child: Container(
              child: Column(
                children: [
                  _buildTitle(
                    // title: "Total: " + TextHelpers.numberToShort((_log != null) ? _log.totalCal : 0) + "C",
                    title: (_state.showAM) ? 
                      "Macros Left" :
                      "Meals Logged: " + TextHelpers.numberToShort((_log != null) ? _log.totalMeals : 0),
                    bottomWidget: (!_state.showAM) ? null :
                      Container(
                        padding: EdgeInsets.all(3),
                        child: MacroNumbers(
                          noCal: true,
                          canBeNegative: true,
                          fat: fat.round(),
                          fatColor: fatColor,
                          carb: carb.round(),
                          carbColor: carbColor,
                          prot: prot.round(),
                          protColor: protColor,
                        ),
                      ),
                    onTap: (){
                      if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Food Stats"));
                    },
                    size: 21,
                    hasShadow: true,
                  ),
                  Container(height: 8,),
                  Expanded(
                    child: BlocBuilder(
                      cubit:_dragToStart,
                      builder: (context, dragToStart) {
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: CommonAssets.shadow,
                                  color: FoodFrenzyColors.tertiary,
                                ),
                              )
                            ),
                            Positioned.fill(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(child: _buildDragToTile(0)),
                                  Expanded(child: _buildDragToTile(1)),
                                  Expanded(child: _buildDragToTile(2)),
                                  Expanded(child: _buildDragToTile(3)),
                                  Expanded(child: _buildDragToTile(4)),
                                  Expanded(child: _buildDragToTile(5)),
                                  Expanded(child: _buildDragToTile(6)),
                                  Expanded(child: _buildDragToTile(7)),
                                  Expanded(child: _buildDragToTile(8)),
                                  Expanded(child: _buildDragToTile(9)),
                                  Expanded(child: _buildDragToTile(10)),
                                  Expanded(child: _buildDragToTile(11)),
                                  Expanded(child: _buildDragToTile(12)),
                                  Expanded(child: _buildDragToTile(13)),
                                  Expanded(child: _buildDragToTile(14)),
                                  Expanded(child: _buildDragToTile(15)),
                                  Expanded(child: _buildDragToTile(16)),
                                  Expanded(child: _buildDragToTile(17)),
                                  Expanded(child: _buildDragToTile(18)),
                                  Expanded(child: _buildDragToTile(19)),
                                  Expanded(child: _buildDragToTile(20)),
                                  Expanded(child: _buildDragToTile(21)),
                                  Expanded(child: _buildDragToTile(22)),
                                  Expanded(child: _buildDragToTile(23)),
                                ]
                              ),
                            ),
                            Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                decoration: BoxDecoration(
                                    color: FoodFrenzyColors.jjTransparent,
                                  ),
                                  child: (!_log.hasFoodInLog && bullseye) ? Center(
                                    child: Icon(
                                      FontAwesomeIcons.bullseye,
                                      color: FoodFrenzyColors.secondary,
                                      size: 34,
                                    ),
                                  ) : null
                                ),
                              )
                            ),
                            // Positioned.fill(
                            //   child: GestureDetector(
                            //     onTap: (){
                            //       CommonAssets.showSnackbar(context, "Drag over the arrows to log");
                            //     },
                            //     child: Container(
                            //       color: FoodFrenzyColors.jjTransparent,
                            //     ),
                            //   )
                            // ),
                            // if(dragToStart)
                            //   Positioned.fill(
                            //     child: Container(
                            //       padding: EdgeInsets.all(8),
                            //       decoration: BoxDecoration(
                            //         color: FoodFrenzyColors.secondary,
                            //         borderRadius: BorderRadius.circular(8),
                            //       ),
                            //       child: Center(
                            //         child: AST(
                            //           "Tap a Tile,\nDrag an Icon!",
                            //           color: FoodFrenzyColors.tertiary,
                            //           textAlign: TextAlign.center,
                            //           isBold: true,
                            //           size: 55,
                            //           maxLines: 2,
                            //         )
                            //       ),
                            //     )
                            //   ),
                          ],
                        );
                      }
                    ),
                  ),
                ],
              ),
            )
          )
        )
      ],
    );
  }

  Widget _getLoader(){
    return Center(
      child: Loader(size: 55,)
    );
  }

  _buildNutritionLabel(){
    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){

        if(!visable["Nutrition Label"]) return Container();

        Ingredient ingredient = Ingredient.fromList(_meal, _day.day[_meal]);

        return CustomPopupSingle(
          visable: visable["Nutrition Label"],
          mainWidget: NutritionLabel(
            ingredient,
            widget.screenHeight * 0.69,
            // barcode: ingredient.upc,
          ),
          onExit: (){
            _drawerBloc.add(LogFoodDrawerClearStateEvent());
          },
        );
      }
    );
  }

  Widget _buildOtherMeal(){
    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){

        if(!visable["Other Meal"]){
          return Container();
        }

        return LogFoodOtherMealDrawer(
          screenHeight: widget.screenHeight,
          screenWidth: widget.screenWidth,
          topButtonBarHeight: widget.topButtonBarHeight,
          topButtonBarWidth: widget.topButtonBarWidth,
          buttonWidth: widget.buttonWidth,
          visable: visable["Other Meal"],
          ingredients: _entries.otherMeal,
          onExit: (ingredients){

            if(ingredients.isNotEmpty){
              setState(() {
                _entries.otherMeal = List<Ingredient>.from(ingredients);                
              });
            }

            _drawerBloc.add(LogFoodDrawerClearStateEvent());
          },
        );

      }
    );
  }

  Widget _buildAddFood(){

    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){

        if(!visable["Add Food"]){
          return Container();
        }

        return LogFoodAddFoodDrawer(
          screenHeight: widget.screenHeight,
          screenWidth: widget.screenWidth,
          topButtonBarHeight: widget.topButtonBarHeight,
          topButtonBarWidth: widget.topButtonBarWidth,
          buttonWidth: widget.buttonWidth,
          visable: visable["Add Food"],
          ingredients: _entries.addFood,
          state: _state,
          onExit: (ingredients){

            setState(() {
              _entries.addFood = List<Ingredient>.from(ingredients);
            });
            _drawerBloc.add(LogFoodDrawerClearStateEvent());
          },
        );

      }
    );
  }

  Widget _buildAlcohol(){
    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){

        if(!visable["Alcohol"]){
          return Container();
        }

        return LogFoodAlcoholDrawer(
          screenHeight: widget.screenHeight,
          screenWidth: widget.screenWidth,
          topButtonBarHeight: widget.topButtonBarHeight,
          topButtonBarWidth: widget.topButtonBarWidth,
          buttonWidth: widget.buttonWidth,
          visable: visable["Alcohol"],
          ingredients: _entries.alcohol,
          onExit: (ingredients){

            setState(() {
              _entries.alcohol = List<Ingredient>.from(ingredients);
            });
            _drawerBloc.add(LogFoodDrawerClearStateEvent());
          },
        );

      }
    );
  }

  Widget _buildFoodEstimator(){
    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){

        if(!visable["Food Estimator"]){
          return Container();
        }

        return LogFoodFoodEstimator(
          screenHeight: widget.screenHeight,
          screenWidth: widget.screenWidth,
          topButtonBarHeight: widget.topButtonBarHeight,
          topButtonBarWidth: widget.topButtonBarWidth,
          buttonWidth: widget.buttonWidth,
          visable: visable["Food Estimator"],
          onExit: (ingredients){
            setState(() {
              _entries.foodEstimator = List<Ingredient>.from(ingredients);
            });
            _drawerBloc.add(LogFoodDrawerClearStateEvent());
          },
        );

      }
    );
  }

  Widget _buildQuickAdd(){
    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){

        if(!visable["Quick Add"]){
          return Container();
        }

        return LogFoodQuickAddDrawer(
          screenHeight: widget.screenHeight,
          screenWidth: widget.screenWidth,
          topButtonBarHeight: widget.topButtonBarHeight,
          topButtonBarWidth: widget.topButtonBarWidth,
          buttonWidth: widget.buttonWidth,
          visable: visable["Quick Add"],
          ingredient: _entries.quickAdd,
          onExit: (ingredient){


            UserLogEntries.updateQuickAdd(ingredient);
            setState(() {
              _entries.quickAdd = ingredient;
            });
            _drawerBloc.add(LogFoodDrawerClearStateEvent());
          },
        );
      }
    );
  }



  Widget _buildFoodStats(){

    Color calColor = FoodFrenzyColors.jjRed;
    Color fatColor = FoodFrenzyColors.jjRed;
    Color carbColor = FoodFrenzyColors.jjRed;
    Color protColor = FoodFrenzyColors.jjRed;         
    double cal = 0;
    double fat = 0;
    double carb = 0;
    double prot = 0;

    _log.food.forEach((time) {
      Macro macro = Calculations.getMacros(time, _state.convertAlc);

      cal += macro.cal;
      fat += macro.fat;
      carb += macro.carb;
      prot += macro.prot;
    });

    if((_state.cal - cal).round() < 0){
      calColor = FoodFrenzyColors.jjRed;
    } else {
      calColor = FoodFrenzyColors.secondary;
    }

    if((_state.fat - fat).round() < 0){
      fatColor = FoodFrenzyColors.jjRed;
    } else {
      fatColor = FoodFrenzyColors.secondary;
    }

    if((_state.carb - carb).round() < 0){
      carbColor = FoodFrenzyColors.jjRed;
    } else {
      carbColor = FoodFrenzyColors.secondary;
    }

    if((_state.prot - prot).round() < 0){
      protColor = FoodFrenzyColors.jjRed;
    } else {
      protColor = FoodFrenzyColors.secondary;
    }

    return Column(
      children: [
        Container(height: 10),
        Row(
          children: [
            Container(
              width: 21,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  FontAwesomeIcons.bullseyeArrow,
                  color: FoodFrenzyColors.jjTransparent,
                ),
              ),
            ),
            Container(width: 8),
            Expanded(
              child: MacroTitle(
                color: FoodFrenzyColors.secondary,
              ),
            ),
          ],
        ),
        Divider(),
        Tooltip(
          message: "Goal",
          preferBelow: false,
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.bullseyeArrow,
                size: 21,
                color: FoodFrenzyColors.secondary,
              ),
              Container(width: 5,),
              Expanded(
                child: MacroNumbers(
                  cal: _state.cal.round(),
                  fat: _state.fat.round(),
                  carb: _state.carb.round(),
                  prot: _state.prot.round(),
                ),
              ),
            ],
          ),
        ),
        Container(height: 8),
        Tooltip(
          message: "Macros Logged",
          preferBelow: false,
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.minus,
                size: 21,
                color: FoodFrenzyColors.secondary,
              ),
              Container(width: 5,),
              Expanded(
                child: MacroNumbers(
                  cal: cal.round(),
                  fat: fat.round(),
                  carb: carb.round(),
                  prot: prot.round(),
                ),
              ),
            ],
          ),
        ),
        Container(height: 13),
        Tooltip(
          message: "Macros Remaining",
          preferBelow: false,
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.equals,
                size: 21,
                color: FoodFrenzyColors.secondary,
              ),
              Container(width: 5,),
              Expanded(
                child: MacroNumbers(
                  cal: (_state.cal - cal).round(),
                  fat: (_state.fat - fat).round(),
                  carb: (_state.carb - carb).round(),
                  prot: (_state.prot - prot).round(),
                  calColor: calColor,
                  fatColor: fatColor,
                  carbColor: carbColor,
                  protColor: protColor,
                  isBold: false,
                  canBeNegative: true,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
          child: Container(
            child: _log.didFast ? 
              GestureDetector(
                onTap: (){
                  _drawerBloc.add(LogFoodDrawerClearStateEvent());
                },
                child: Container(
                  color: FoodFrenzyColors.jjTransparent,
                  child: Center(
                    child: AST(
                      "Fasting Day!",
                      size: 34,
                      color: FoodFrenzyColors.secondary,
                    ),
                  ),
                ),
              ) : 
              _log.hasFoodInLog ? ClipRRect(
                borderRadius: BorderRadius.circular(5),
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
                      for(var hour = 0; hour < _log.food.length; hour++) if(_log.food[hour].isNotEmpty) _buildFoodList(hour, _log.food[hour])
                    ],
                  ),
                ),
              ) : GestureDetector(
                onTap: (){
                  _drawerBloc.add(LogFoodDrawerClearStateEvent());
                },
                child: Container(
                  color: FoodFrenzyColors.jjTransparent,
                  child: Center(
                    child: AST(
                      "Empty Log",
                      size: 34,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      color: FoodFrenzyColors.secondary,
                    ),
                  ),
                ),
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodList(int hour, List<Ingredient> food){
    double cal = 0;
    double fat = 0;
    double carb = 0;
    double prot = 0;

    food.forEach((i) {
      if(i.isIngredient){
        cal += i.cals;
        fat += i.fats;
        carb += i.carbs(useAlc: _state.convertAlc);
        prot += i.prots;
      }
    });


    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 13),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: CommonAssets.shadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: LogFoodDefines.mealToColor(food[0].logType),
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AST(
                      TextHelpers.indexToTime(hour) + " " + food[0].logType,
                      textAlign: TextAlign.left,
                      color: FoodFrenzyColors.secondary,
                      isBold: true,
                    ),
                    Container(height: 5),
                    MacroNumbers(
                      cal: cal.round(),
                      fat: fat.round(),
                      carb: carb.round(),
                      prot: prot.round(),
                    ),
                  ],
                ),
              ),
              Container(
                color: LogFoodDefines.mealToColor(food[0].logType),
                child: Container(
                  decoration: BoxDecoration(
                    color: FoodFrenzyColors.secondary,
                  ),
                  child: Column(
                    children: [
                      for(var ingredient in food) if(ingredient.logType == 'ingredient') _buildIngredient(ingredient),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredient(Ingredient ingredient){
    return Container(
      padding: EdgeInsets.all(13),
      child: Column(
        children: [
          AST(
            ingredient.name,
            color: FoodFrenzyColors.tertiary,
          ),
          Container(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AST(
                "${(ingredient.amount / ingredient.ss).toStringAsFixed(1)}x ${ingredient.hsu}",
                color: FoodFrenzyColors.tertiary,
              ),
              AST(
                "${ingredient.amount} ${ingredient.usesml ? 'ml' : 'g'}",
                color: FoodFrenzyColors.tertiary,
                textAlign: TextAlign.right,
              )
            ],
          ),
          Container(height: 5),
          MacroNumbers(
            cal: (ingredient.cals).round(),
            fat: (ingredient.fats).round(),
            carb: (ingredient.carbs(useAlc: _state.convertAlc)).round(),
            prot: (ingredient.prots).round(),
            calColor: FoodFrenzyColors.tertiary,
            fatColor: FoodFrenzyColors.tertiary,
            carbColor: FoodFrenzyColors.tertiary,
            protColor: FoodFrenzyColors.tertiary,
            canBeNegative: true,
            isBold: false,
          )
        ]
      ),
    );
  }

  Widget _buildFoodStatsDrawer(){
    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){

        if(!visable["Food Stats"]) return Container();

        return CustomLeftDrawer(
          title: "Macro Stats",
          visable: visable["Food Stats"],
          screenWidth: widget.screenWidth,
          topPadding: widget.screenTopPadding,
          width: widget.sideDrawerWidth,
          height: widget.sideDrawerHeight,
          buttonHeight: widget.topButtonBarHeight,
          onExit: (){
            _drawerBloc.add(LogFoodDrawerClearStateEvent());
          },
          child: _buildFoodStats(),
        );
      }
    );
  }


  Widget _buildMainHub(){
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: _buildFoodLogger()
        ),
        // Expanded(
        //   child: _buildWaterLogger(),
        // )
      ],
    );
  }

  void _saveLog(){
    bool freeMealedIt = false;
    for(List<Ingredient> meal in _log.food)
      if(meal.isNotEmpty)
        if(meal.first.logType == LogFoodDefines.freeMeal)
          freeMealedIt = true;

    UserLog.getTodaysLog().then((log) async {
      bool didLog = _checkDidLog();

      if((!log.didLog && didLog)){
        await UserLog.updateTodaysDidLog(true).then((_) async{
          // only update points after log
          await UserPoints.handlePoints(log, UserPoints.lfIndex);
        });
      } else if(!log.naughtyLog){
        await UserLog.updateTodaysNaughtyLog(log.didLog && !didLog);     
      }



      await UserLog.updateTodaysFood(_log.food);     
      await UserLog.updateTodaysDidFast(_log.didFast);  

      if(!freeMealedIt && Calculations.isSameDay(_state.lastFreeMeal)) //if deleted reset free meal
        _state.updateLastFreeMeal(DateTime.now().subtract(Duration(days: 34)));

      if(freeMealedIt && _state.freeMealFrequency < 2) //set free meal
        _state.updateLastFreeMeal(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {

    return UserStateStreamView(
      (state){
        _state = state;
        waterGoal = Calculations.getWaterGoal(
          lbs: state.lastWeight,
          activity: state.activityLevel
        );

        return UserDayView(
          (day){
            _day = day;
            return UserLogView(
              (log){
                _log = log;
                _dragToStart.add(BoolUpdateEvent(_isLogEmpty(log)));

                    return BlocBuilder(
                      cubit:_setStateBloc,
                      builder: (context, updated) {

                        return GestureDetector(
                          onHorizontalDragStart: (_){},
                          child: Container(
                            color: FoodFrenzyColors.jjTransparent,
                            child: Stack(
                              children: [
                                CustomPopupWhole(
                                  visable: widget.visable,
                                  middleWidth: widget.screenWidth,
                                  buttonWidth: widget.buttonWidth,
                                  topButtonBarHeight: widget.topButtonBarHeight,
                                  topButtonBarWidth: widget.topButtonBarWidth,
                                  topButtonBarHasShadow: false,
                                  iconLeft: FontAwesomeIcons.chartBar,
                                  onLeft: (){
                                    if(_drawerBloc.canOpen()) _drawerBloc.add(LogFoodDrawerStateSetEvent("Food Stats"));
                                  },
                                  title: "Log Food",
                                  message: "Tap a left tile to set it",
                                  iconRight: FontAwesomeIcons.apple,
                                  iconRightEnable: false,
                                  mainWidget: _buildMainHub(),
                                  bottomButtonTitle: "Log",
                                  bottomButtonIcon: FontAwesomeIcons.save,
                                  onExit: () {
                                    _saveLog();
                                    widget.onExit();
                                  },
                                ),
                                // _buildNutritionLabel(),
                                _buildOtherMeal(),
                                _buildAddFood(),
                                _buildAlcohol(),
                                _buildFoodEstimator(),
                                _buildQuickAdd(),
                                _buildFoodStatsDrawer(),
                              ],
                            ),
                          ),
                        );
                      }
                    );
              },
              onLoading: _getLoader
            );
          },
          onLoading: _getLoader
        );
      },
      onLoading: _getLoader,
    );
  }

  void _addIngredients(String logType, int index){

    _log.food[index] = []; //clear and reset list
    _log.food[index].add(Ingredient.logTypeHeader(logType)); //First Slot is Always the Log Type
    
    switch(logType){
      case LogFoodDefines.fullDayFast:
        _log.food[index].add(Ingredient.fromMap(Ingredient(name: "Full Day Fast").toMap()));
        break;
      case LogFoodDefines.freeMeal:
        _log.food[index].add(Ingredient.fromMap(Ingredient(name: "Free Meal").toMap()));
        break;
      case LogFoodDefines.preWorkout:
      case LogFoodDefines.postWorkout:
      case LogFoodDefines.breakfast:
      case LogFoodDefines.morningSnack:
      case LogFoodDefines.lunch:
      case LogFoodDefines.afternoonSnack:
      case LogFoodDefines.dinner:
      case LogFoodDefines.eveningSnack:
        _day.day[logType].forEach((ingredient) {_log.food[index].add(ingredient);});
        break;
      case LogFoodDefines.otherMeal:
        _entries.otherMeal.forEach((ingredient) {_log.food[index].add(ingredient); });
        break;
      case LogFoodDefines.addFood:
        _entries.addFood.forEach((ingredient) {_log.food[index].add(ingredient); });
        break;
      case LogFoodDefines.alcohol:
        _entries.alcohol.forEach((ingredient) {_log.food[index].add(ingredient); });
        break;
      case LogFoodDefines.foodEstimator:
        _entries.foodEstimator.forEach((ingredient) {_log.food[index].add(ingredient); });
        break;
      case LogFoodDefines.quickAdd:
        _log.food[index].add(_entries.quickAdd);
        break;
    }
  }

  void _setState(Function todo){
    todo();
    _setStateBloc.add(BoolUpdateEvent(!_setStateBloc.state));
  }

  void _clearLog(){
    _log.food = List<List<Ingredient>>(24);
    _log.didFast = false;
    _log.didLog = false;
    
    for (var i = 0; i < _log.food.length; i++) {
      _log.food[i] = List<Ingredient>();
    }
  }

  bool _checkDidLog(){
    if(_log.didFast) return true;

    for (var hour in _log.food) {
      if(hour != null){
        for (var item in hour) {
          if(item != null) return true;
        }
      }
    }
    return false;
  }
}

