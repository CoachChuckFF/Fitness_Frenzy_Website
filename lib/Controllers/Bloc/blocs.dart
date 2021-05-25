/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';

//----------------- Sprinkles ---------------------------------------

abstract class SprinklesEvent{}
class SprinklesUpdateEvent implements SprinklesEvent{
  final int amount;
  final int index;

  SprinklesUpdateEvent(this.amount, this.index);
} 

class SprinklesBLoC extends Bloc<SprinklesEvent, List<int>>{
  final List<int> _start;

  SprinklesBLoC(
    [
      this._start = const [
        FoodFrenzySprinklesCount.norm,
        0,
      ],
    ]
  ) : super(
      _start ?? const [
        FoodFrenzySprinklesCount.norm,
        0,
      ]
    );

  List<int> get initialState => _start;

  @override
  Stream<List<int>> mapEventToState(SprinklesEvent event) async* {
    if(event is SprinklesUpdateEvent){
      List<int> list = [event.amount, event.index];
      yield list;
    }
  }

  dispose() async{
    await close();
  }
}


//--------------- Drawer --------------------------------------

abstract class DrawerStateEvent{}
class DrawerStateSetEvent implements DrawerStateEvent{
  final String key;

  DrawerStateSetEvent(
    this.key,
  );
} 

class DrawerClearStateEvent implements DrawerStateEvent{} 

class DrawerStateBLoC extends Bloc<DrawerStateEvent, Map<String, bool>>{
  DrawerStateBLoC() : super({
    "Left" : false,
    "Right" : false,
    "Log Progress Picture" : false,
    "Log Weight" : false,
    "Log Food" : false,
    "Log Habit" : false,
    "Log Exercise" : false,
    "Nutrition Label" : false,
    "Exercise Info" : false,
    "Ingredient Entry" : false,
    "Note Builder" : false,
    "Meal Saver" : false,
    "Bottom" : false,
    "Shopping List" : false,
    "Zen Mode" : false,
    "Choose Type" : false,
    "Workout Builder" : false,
    "Choose Workout" : false,
  });



  Map<String, bool> get initialState => {
    "Left" : false,
    "Right" : false,
    "Log Progress Picture" : false,
    "Log Weight" : false,
    "Log Food" : false,
    "Log Habit" : false,
    "Log Exercise" : false,
    "Nutrition Label" : false,
    "Exercise Info" : false,
    "Ingredient Entry" : false,
    "Note Builder" : false,
    "Meal Saver" : false,
    "Bottom" : false,
    "Shopping List" : false,
    "Zen Mode" : false,
    "Choose Type" : false,
    "Workout Builder" : false,
    "Choose Workout" : false,
  };


  @override
  Stream<Map<String, bool>> mapEventToState(DrawerStateEvent event) async* {
    if(event is DrawerStateSetEvent){

      if(state.containsKey(event.key)){
        if(canOpen()){
          state[event.key] = true;
        }
      }
      yield Map.from(state);
    } else if(event is DrawerClearStateEvent){
      yield initialState;
    }
  }

  dispose()  async{
    await close();
  }

  canOpen(){
    return !(state.containsValue(true));
  }
}

//--------------- Log Food Drawer --------------------------------------

abstract class LogFoodDrawerStateEvent{}
class LogFoodDrawerStateSetEvent implements LogFoodDrawerStateEvent{
  final String key;

  LogFoodDrawerStateSetEvent(
    this.key,
  );
} 

class LogFoodDrawerClearStateEvent implements LogFoodDrawerStateEvent{} 

class LogFoodDrawerStateBLoC extends Bloc<LogFoodDrawerStateEvent, Map<String, bool>>{
  LogFoodDrawerStateBLoC() : super({
    "Food Stats" : false,
    "Nutrition Label" : false,
    "Other Meal" : false,
    "Add Food" : false,
    "Food Estimator" : false,
    "Quick Add" : false,
    "Alcohol" : false,
  });

  Map<String, bool> get initialState => {
    "Food Stats" : false,
    "Nutrition Label" : false,
    "Other Meal" : false,
    "Add Food" : false,
    "Food Estimator" : false,
    "Quick Add" : false,
    "Alcohol" : false,
  };

  @override
  Stream<Map<String, bool>> mapEventToState(LogFoodDrawerStateEvent event) async* {
    if(event is LogFoodDrawerStateSetEvent){

      if(state.containsKey(event.key)){
        if(canOpen()){
          state[event.key] = true;
        }
      }
      yield Map.from(state);
    } else if(event is LogFoodDrawerClearStateEvent){
      yield initialState;
    }
  }

  dispose()  async{
    await close();
  }

  canOpen(){
    return !(state.containsValue(true));
  }
}

//--------------- Log Habit Drawer --------------------------------------

abstract class LogHabitDrawerStateEvent{}
class LogHabitDrawerStateSetEvent implements LogHabitDrawerStateEvent{
  final String key;

  LogHabitDrawerStateSetEvent(
    this.key,
  );
} 

class LogHabitDrawerClearStateEvent implements LogHabitDrawerStateEvent{} 

class LogHabitDrawerStateBLoC extends Bloc<LogHabitDrawerStateEvent, Map<String, bool>>{
  LogHabitDrawerStateBLoC() : super({
    "Habits" : false,
  });


  Map<String, bool> get initialState => {
    "Habits" : false,
  };


  @override
  Stream<Map<String, bool>> mapEventToState(LogHabitDrawerStateEvent event) async* {
    if(event is LogHabitDrawerStateSetEvent){

      if(state.containsKey(event.key)){
        if(canOpen()){
          state[event.key] = true;
        }
      }
      yield Map.from(state);
    } else if(event is LogHabitDrawerClearStateEvent){
      yield initialState;
    }
  }

  dispose()  async{
    await close();
  }

  canOpen(){
    return !(state.containsValue(true));
  }
}

//--------------- Bool --------------------------------------

abstract class BoolEvent{}
class BoolUpdateEvent implements BoolEvent{
  final bool value;

  BoolUpdateEvent(this.value);
} 

class BoolToggleEvent implements BoolEvent{

  BoolToggleEvent();
} 

class BoolBLoC extends Bloc<BoolEvent, bool>{
  final bool _start;

  BoolBLoC([this._start = false]) : super(_start ?? false);

  bool get initialState => _start;


  @override
  Stream<bool> mapEventToState(BoolEvent event) async* {
    if(event is BoolUpdateEvent){

      yield event.value;
    } else if(event is BoolToggleEvent){
      yield !state;
    }
  }

  dispose()  async{
    await close();
  }
}

//----------------- Int ---------------------------------------

abstract class IntEvent{}
class IntUpdateEvent implements IntEvent{
  final int value;

  IntUpdateEvent(this.value);
} 

class IntIncrementEvent implements IntEvent{

  IntIncrementEvent();
} 

class IntBLoC extends Bloc<IntEvent, int>{
  final int _start;

  IntBLoC([this._start = 0]) : super(_start ?? 0);

  int get initialState => _start;

  @override
  Stream<int> mapEventToState(IntEvent event) async* {
    if(event is IntUpdateEvent){
      yield event.value;
    } else if(event is IntIncrementEvent){
      yield state + 1;
    }
  }

  dispose()  async{
    await close();
  }
}

//----------------- Double ---------------------------------------

abstract class DoubleEvent{}
class DoubleUpdateEvent implements DoubleEvent{
  final double value;

  DoubleUpdateEvent(this.value);
} 

class DoubleBLoC extends Bloc<DoubleEvent, double>{
  final double _start;

  DoubleBLoC([this._start = 0.0]) : super(_start ?? 0.0);

  double get initialState => _start;

  @override
  Stream<double> mapEventToState(DoubleEvent event) async* {
    if(event is DoubleUpdateEvent){
      yield event.value;
    }
  }

  dispose()  async{
    await close();
  }
}

//----------------- String ---------------------------------------

abstract class StringEvent{}
class StringUpdateEvent implements StringEvent{
  final String value;

  StringUpdateEvent(this.value);
} 

class StringBLoC extends Bloc<StringEvent, String>{
  final String _start;

  StringBLoC([this._start = ""]) : super(_start ?? '');

  String get initialState => _start;

  @override
  Stream<String> mapEventToState(StringEvent event) async* {
    if(event is StringUpdateEvent){
      yield event.value;
    }
  }

  dispose()  async{
    await close();
  }
}

//--------------- Search State --------------------------------------

abstract class SearchStateEvent{}
class SearchStateSetEvent implements SearchStateEvent{
  final String search;

  SearchStateSetEvent(
    this.search,
  );
} 

class SearchStateSetTagsEvent implements SearchStateEvent{
  final List<String> tags;

  SearchStateSetTagsEvent(
    this.tags,
  );
} 

class SearchStateToggleEvent implements SearchStateEvent{
  final String tag;

  SearchStateToggleEvent(
    this.tag,
  );
} 

class SearchClearStateEvent implements SearchStateEvent{} 

class SearchStateBLoC extends Bloc<SearchStateEvent, Map<String, dynamic>>{
  SearchStateBLoC() : super({
    "Search" : "All",
  });


  
  Map<String, dynamic> get initialState => {
    "Search" : "All",
  };


  @override
  Stream<Map<String, dynamic>> mapEventToState(SearchStateEvent event) async* {
    if(event is SearchStateSetEvent){
      state["Search"] = event.search;
      yield Map.from(state);
    } else if(event is SearchStateToggleEvent){
      if(state.keys.contains(event.tag)){
        state[event.tag] = !state[event.tag];
      }
      yield Map.from(state);
    } else if(event is SearchStateSetTagsEvent){
      Map<String, dynamic> map = Map<String, dynamic>();
      state.forEach((k, v){
        map[k] = v;
      });
      event.tags.forEach((k){
        map[k] = false;
      });
      yield Map.from(map);
    } else if(event is SearchClearStateEvent){
      state.keys.forEach((key){
        if(key != "Search"){
          state[key] = false;
        } else {
          state[key] = "All";
        }
      });
      yield Map.from(state);
    }
  }

  void dispose()  async{
    await close();
  }

  bool canOpen(){
    return !(state.containsValue(true));
  }

  int searchToIndex(){
    return TextHelpers.letterToIndex(state["Search"]);
  }

}

//--------------- Selected State --------------------------------------


abstract class SelectedStateEvent{}
class SelectedStateToggleEvent implements SelectedStateEvent{
  final SelectedIngredient selected;

  SelectedStateToggleEvent(
    this.selected
  );
} 

class SelectedStateSetEvent implements SelectedStateEvent{
  final SelectedIngredient selected;

  SelectedStateSetEvent(
    this.selected
  );
} 

class SelectedStateUnselectEvent implements SelectedStateEvent{
  final SelectedIngredient unselected;

  SelectedStateUnselectEvent(
    this.unselected
  );
} 

class SelectedStateClearEvent implements SelectedStateEvent{} 

class SelectedStateBLoC extends Bloc<SelectedStateEvent, List<SelectedIngredient>>{
  SelectedStateBLoC() : super([]);



  List<SelectedIngredient> get initialState => [];

  @override
  Stream<List<SelectedIngredient>> mapEventToState(SelectedStateEvent event) async* {
    if(event is SelectedStateToggleEvent){
      if(state.contains(event.selected)){
        state.remove(event.selected);
      } else {
        state.add(event.selected);
      }
      yield List.from(state);
    } if(event is SelectedStateSetEvent){
      if(!state.contains(event.selected)){
        state.add(event.selected);
      }

      yield List.from(state);
    }
     else if(event is SelectedStateClearEvent){
      yield [];
    } else if(event is SelectedStateUnselectEvent){
      if(state.contains(event.unselected)){
        state.remove(event.unselected);
      }
      yield List.from(state);
    }
  }

  void dispose()  async{
    await close();
  }

}

//--------------- Day State --------------------------------------

abstract class DayStateEvent{}
class DayStateSetEvent implements DayStateEvent{
  final Day day;

  DayStateSetEvent(
    this.day,
  );
} 

class DayStateSetNameEvent implements DayStateEvent{
  final String name;

  DayStateSetNameEvent(
    this.name,
  );
} 

class DayStateSetCreatedByEvent implements DayStateEvent{
  final String uid;

  DayStateSetCreatedByEvent(
    this.uid,
  );
}

class DayStateSetLastEditedEvent implements DayStateEvent{} 

class DayStateOverwriteIngredientEvent implements DayStateEvent{
  final Ingredient ingredient;
  final String meal;

  DayStateOverwriteIngredientEvent(
    this.ingredient,
    this.meal,
  );
}

class DayStateAddIngredientEvent implements DayStateEvent{
  final Ingredient ingredient;
  final String meal;

  DayStateAddIngredientEvent(
    this.ingredient,
    this.meal,
  );
}

class DayStateUpdateIngredientAmountEvent implements DayStateEvent{
  final Ingredient ingredient;
  final String meal;
  final double amount;

  DayStateUpdateIngredientAmountEvent(
    this.amount,
    this.ingredient,
    this.meal,
  );
}

class DayStateRemoveIngredientEvent implements DayStateEvent{
  final Ingredient ingredient;
  final String meal;

  DayStateRemoveIngredientEvent(
    this.ingredient,
    this.meal,
  );
}

class DayStateToggleIngredientEvent implements DayStateEvent{
  final Ingredient ingredient;
  final String meal;

  DayStateToggleIngredientEvent(
    this.ingredient,
    this.meal,
  );
}

class DayStateClearIngredientsEvent implements DayStateEvent{} 

class DayStateBLoC extends Bloc<DayStateEvent, Day>{
  DayStateBLoC() : super(Day.fromMap({}));


  Day get initialState => Day.fromMap({});

  @override
  Stream<Day> mapEventToState(DayStateEvent event) async* {
    if(event is DayStateSetEvent){
      if(event.day != null){
        event.day.savedData = true;
        yield Day.fromMap(event.day.toMap());
      }
    } else if(event is DayStateSetNameEvent){
      state.name = event.name;
      yield Day.fromMap(state.toMap());
    } else if(event is DayStateSetCreatedByEvent){
      state.createdBy = event.uid;
      yield Day.fromMap(state.toMap());
    } else if(event is DayStateSetLastEditedEvent){
      state.lastEdited = DateTime.now();
      yield Day.fromMap(state.toMap());
    } else if(event is DayStateAddIngredientEvent){
      if(!state.day[event.meal].contains(event.ingredient)){
        state.day[event.meal].add(event.ingredient);
        yield Day.fromMap(state.toMap());
      }
    } else if(event is DayStateOverwriteIngredientEvent){
      if(state.day[event.meal].contains(event.ingredient)){
        state.day[event.meal].remove(event.ingredient);
      }

      state.day[event.meal].add(event.ingredient);
      yield Day.fromMap(state.toMap());
    } else if(event is DayStateUpdateIngredientAmountEvent){
      if(state.day[event.meal].contains(event.ingredient)){
        for (var i in state.day[event.meal]) {
          if(i == event.ingredient){
            if(event.amount.isNegative || event.amount == 0){
              i.amount = 1;
            } else if(event.amount >= Fib.f20){
              i.amount = Fib.f20.toDouble();
            } else {
              i.amount = event.amount;
            }
          }
        }

        yield Day.fromMap(state.toMap());
      }
    } else if(event is DayStateRemoveIngredientEvent){
      if(state.day[event.meal].contains(event.ingredient)){
        state.day[event.meal].remove(event.ingredient);
        yield Day.fromMap(state.toMap());
      }
    } else if(event is DayStateToggleIngredientEvent){
      if(state.day[event.meal].contains(event.ingredient)){
        state.day[event.meal].remove(event.ingredient);
      } else {
        state.day[event.meal].add(event.ingredient);
      }

      yield Day.fromMap(state.toMap());
    } else if(event is DayStateClearIngredientsEvent){
      yield Day.fromMap({
        'uid' : state.createdBy,
        'name': state.name,
        'timestamp' : state.lastEdited
      });
    } 
  }

  void dispose()  async{
    await close();
  }
}

//--------------- Ingredient List State --------------------------------------

abstract class IngredientListStateEvent{}
class IngredientListStateSetEvent implements IngredientListStateEvent{
  final List<Ingredient> ingredients;

  IngredientListStateSetEvent(
    this.ingredients,
  );
} 

class IngredientListStateAddIngredientEvent implements IngredientListStateEvent{
  final Ingredient ingredient;

  IngredientListStateAddIngredientEvent(
    this.ingredient,
  );
}

class IngredientListStateUpdateIngredientAmountEvent implements IngredientListStateEvent{
  final Ingredient ingredient;
  final double amount;

  IngredientListStateUpdateIngredientAmountEvent(
    this.amount,
    this.ingredient,
  );
}

class IngredientListStateRemoveIngredientEvent implements IngredientListStateEvent{
  final Ingredient ingredient;

  IngredientListStateRemoveIngredientEvent(
    this.ingredient,
  );
}

class IngredientListStateToggleIngredientEvent implements IngredientListStateEvent{
  final Ingredient ingredient;

  IngredientListStateToggleIngredientEvent(
    this.ingredient,
  );
}

class IngredientListStateClearIngredientsEvent implements IngredientListStateEvent{} 

class IngredientListStateBLoC extends Bloc<IngredientListStateEvent, List<Ingredient>>{
  final List<Ingredient> _start;

  IngredientListStateBLoC([this._start = const []]) : super(_start ?? []);

  List<Ingredient> get initialState => _start;

  @override
  Stream<List<Ingredient>> mapEventToState(IngredientListStateEvent event) async* {
    if(event is IngredientListStateSetEvent){
      if(event.ingredients != null){
        yield List<Ingredient>.from(event.ingredients);
      }
    } else if(event is IngredientListStateAddIngredientEvent){
      if(!state.contains(event.ingredient)){
        state.add(event.ingredient);
        yield List<Ingredient>.from(state);
      }
    } else if(event is IngredientListStateUpdateIngredientAmountEvent){
      if(state.contains(event.ingredient)){
        for(var ingredient in state){
          if(ingredient == event.ingredient){
            if(event.amount.isNegative){
              ingredient.amount = 0;
            } else if(event.amount >= Fib.f20){
              ingredient.amount = Fib.f20.toDouble();
            } else {
              ingredient.amount = event.amount;
            }
          }
        }
        yield List<Ingredient>.from(state);
      }
    } else if(event is IngredientListStateRemoveIngredientEvent){
      if(state.contains(event.ingredient)){
        state.remove(event.ingredient);
        yield List<Ingredient>.from(state);
      }
    } else if(event is IngredientListStateToggleIngredientEvent){
      if(state.contains(event.ingredient)){
        state.remove(event.ingredient);
      } else {
        state.add(event.ingredient);
      }

      yield List<Ingredient>.from(state);
    } else if(event is IngredientListStateClearIngredientsEvent){
      yield List<Ingredient>();
    } 
  }

  void dispose()  async{
    await close();
  }
}

//--------------- Log State --------------------------------------

abstract class LogStateEvent{}
class LogStateSetEvent implements LogStateEvent{
  final UserLog log;

  LogStateSetEvent(
    this.log,
  );
} 

class LogStateSetFastEvent implements LogStateEvent{
  final bool didFast;

  LogStateSetFastEvent(
    this.didFast
  );
} 

class LogStateClearIngredientsEvent implements LogStateEvent{} 

class LogStateBLoC extends Bloc<LogStateEvent, UserLog>{
  LogStateBLoC() : super(UserLog.fromMap({}));


  UserLog get initialState => UserLog.fromMap({});

  @override
  Stream<UserLog> mapEventToState(LogStateEvent event) async* {
    if(event is LogStateSetEvent){
      if(event.log != null){
        yield UserLog.fromMap(event.log.toMap());
      }
    } else if (event is LogStateSetFastEvent){
      if(state.didFast != event.didFast){
        state.didFast = event.didFast;
        yield UserLog.fromMap(state.toMap());
      }
    } else if(event is LogStateClearIngredientsEvent){
      state.food = List<List<Ingredient>>(24);
      for (var i = 0; i < state.food.length; i++) {
        state.food[i] = List<Ingredient>();
      }
      yield UserLog.fromMap(state.toMap());
    }
  }

  void dispose()  async{
    await close();
  }
}