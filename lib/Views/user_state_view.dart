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
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class UserStateStreamView extends StatelessWidget {
  final Widget Function(UserState) onData;
  final Widget Function() onLoading;

  UserStateStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    UserState state = Provider.of<UserState>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class UserPointsView extends StatelessWidget {
  final String uid;
  final Widget Function(UserPoints) onData;
  final Widget Function() onLoading;

  UserPointsView(this.onData, {this.onLoading, Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserPoints.firebase.getDocument(uid: uid),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as UserPoints);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class UserPointsStreamView extends StatelessWidget {
  final Widget Function(UserPoints) onData;
  final Widget Function() onLoading;

  UserPointsStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    UserPoints state = Provider.of<UserPoints>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class UserCommonIngredientStreamView extends StatelessWidget {
  final Widget Function(UserCommonIngredients) onData;
  final Widget Function() onLoading;

  UserCommonIngredientStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    UserCommonIngredients state = Provider.of<UserCommonIngredients>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class UserStateView extends StatelessWidget {
  final String uid;
  final Widget Function(UserState) onData;
  final Widget Function() onLoading;

  UserStateView(this.onData, {this.onLoading, Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserState.firebase.getDocument(uid: uid),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as UserState);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class MyMealsView extends StatelessWidget {
  final String uid;
  final Widget Function(List<Meal>) onData;
  final Widget Function() onLoading;

  MyMealsView(this.uid, this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MealData.getMyMeals(uid),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as List<Meal>);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class MyWorkoutsView extends StatelessWidget {
  final String uid;
  final Widget Function(List<Workout>) onData;
  final Widget Function() onLoading;

  MyWorkoutsView(this.onData, {this.uid, this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WorkoutData.getMyWorkouts(uid: uid),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as List<Workout>);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class LoggableWorkoutsView extends StatelessWidget {
  final Map<String, String> buddies; 
  final String buddy; 
  final String uid;
  final Widget Function(Map<String, List<Workout>>) onData;
  final Widget Function() onLoading;

  LoggableWorkoutsView(this.onData, this.buddies, this.uid, {this.buddy, this.onLoading, Key key}) : super(key: key);

  Future<Map<String, List<Workout>>> _getAllWorkouts(){
    return WorkoutData.getLoggableWorkouts(uid: buddy).then((workouts){
      Map<String, String> refactoredBuddies = Map<String, String>.from(buddies);
      Map<String, List<Workout>> refactoredWorkouts = {};

      if(buddy == null){
        refactoredBuddies[uid] = "Me";
        refactoredBuddies['global'] = "Global";
      }

      

      for(String key in workouts.keys){
        if(refactoredBuddies.containsKey(key)){
          refactoredWorkouts[refactoredBuddies[key]] = [];
          refactoredWorkouts[refactoredBuddies[key]].addAll(workouts[key]);
        }
      }

      return refactoredWorkouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAllWorkouts(),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as Map<String, List<Workout>>);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class UserLogView extends StatelessWidget {
  final Widget Function(UserLog) onData;
  final Widget Function() onLoading;

  UserLogView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserLog.getTodaysLog(),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as UserLog);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class UserDayView extends StatelessWidget {
  final Widget Function(Day) onData;
  final Widget Function() onLoading;

  UserDayView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Day.firebase.getDocument(),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as Day);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class UserDayStreamView extends StatelessWidget {
  final Widget Function(Day) onData;
  final Widget Function() onLoading;

  UserDayStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Day state = Provider.of<Day>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class LastRecordView extends StatelessWidget {
  final String workoutUID;
  final Widget Function(UserRecords) onData;
  final Widget Function() onLoading;

  LastRecordView(this.workoutUID, this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserRecords.getLatestRecord(workoutUID),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.connectionState == ConnectionState.done){
          if(snap.hasData){
            return onData(snap.data as UserRecords);
          } else {
            return onData(null);
          }
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class UserHabitStreamView extends StatelessWidget {
  final Widget Function(UserHabits) onData;
  final Widget Function() onLoading;

  UserHabitStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UserHabits state = Provider.of<UserHabits>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class UserHabitView extends StatelessWidget {
  final Widget Function(UserHabits) onData;
  final Widget Function() onLoading;

  UserHabitView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserHabits.firebase.getDocument(),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as UserHabits);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class YoutubeView extends StatelessWidget {
  final Widget Function(YoutubeAggregate) onData;
  final Widget Function() onLoading;

  YoutubeView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: YoutubeAggregate.firebase.getDocument(),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as YoutubeAggregate);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class IngredientAggregateView extends StatelessWidget {
  final Widget Function(IngredientAggregate) onData;
  final Widget Function() onLoading;

  IngredientAggregateView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IngredientAggregate.firebase.getDocument(),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.hasData){
          return onData(snap.data as IngredientAggregate);
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}

class IngredientAggregateStreamView extends StatelessWidget {
  final Widget Function(IngredientAggregate) onData;
  final Widget Function() onLoading;

  IngredientAggregateStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    IngredientAggregate state = Provider.of<IngredientAggregate>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class ExerciseAggregateStreamView extends StatelessWidget {
  final Widget Function(ExerciseAggregate) onData;
  final Widget Function() onLoading;

  ExerciseAggregateStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ExerciseAggregate state = Provider.of<ExerciseAggregate>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class SprinkleUnlockStreamView extends StatelessWidget {
  final Widget Function(SprinkleUnlocks) onData;
  final Widget Function() onLoading;

  SprinkleUnlockStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SprinkleUnlocks state = Provider.of<SprinkleUnlocks>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class UserStatsView extends StatelessWidget {
  final Widget Function(List<UserLog>) onData;
  final Widget Function() onLoading;
  final DateTime start;
  final DateTime end;
  final String uid;

  UserStatsView(this.start, this.end, this.onData, {this.uid, this.onLoading, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserLog.firebase.getDocumentsInRange(start, end, uid: uid),
      builder: (BuildContext context, AsyncSnapshot snap){
        if(snap.connectionState == ConnectionState.done){
          if(snap.hasData){
            return onData(snap.data as List<UserLog>);
          } else {
            return onData(null);
          }
        } else {
          if(onLoading == null){
            return Loader();
          } else {
            return onLoading();
          }
        }
      }
    );
  }
}


class UserLogStreamView extends StatelessWidget {
  final Widget Function(UserLog) onData;
  final Widget Function() onLoading;

  UserLogStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    UserLog state = Provider.of<UserLog>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}

class UserLogEntriesStreamView extends StatelessWidget {
  final Widget Function(UserLogEntries) onData;
  final Widget Function() onLoading;

  UserLogEntriesStreamView(this.onData, {this.onLoading, Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    UserLogEntries state = Provider.of<UserLogEntries>(context);

    if(state != null){
      return onData(state);
    } else {
      if(onLoading == null){
        return Loader();
      } else {
        return onLoading();
      }
    }
  }
}