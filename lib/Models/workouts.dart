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

class ExerciseAggregate{
  static final StaticGlobalData<ExerciseAggregate> firebase = StaticGlobalData(ingredientAggregateCollection, ingredientAggregateDocument);
  static const String ingredientAggregateCollection = "Aggregate";
  static const String ingredientAggregateDocument = "Exercises";

  Map<String, Exercise> database = Map<String, Exercise>();

  ExerciseAggregate();

  ExerciseAggregate.fromMap(Map data){
    data.forEach((key, value){
      database[key] = Exercise.fromMap(value);
    });
  }

  int get length => database.keys.length;
  Exercise getFromIndex(int index){
    if(index.abs() < database.keys.length){
      return database[database.keys.elementAt(index.abs())];
    }

    return null;
  }
}

class Exercise{
  static final GlobalData<Exercise> firebase = GlobalData(exerciseCollection);
  static const String exerciseCollection = "Exercise";

  //TODO Add in Seal PST (note, swimming, pu, su, pu, running)
  //TODO add in gif downloader
  //TODO pay Chris to write workouts with this

  static const List<String> types = [
    "Countdown Bodyweight", //time
    "Countdown Weights", //time, weight
    "Countdown Cardio", //time, *direction

    "Cardio Time", //time, speed
    "Cardio Distance", //distance, comp time
    "Bodyweight", //reps
    "Bodyweight Time", //reps time
    "Weights", //reps, weight
    "Weights Time", //time, reps, weight

    "Note", //instructor notes
    "Rest", //rest time
  ];

  static const List<String> muscles = [
    "Traps",
    "Delts",
    "Pecs",
    "Biceps",
    "Abs",
    "Forearms",
    "Grip"
    "Quads",
    "Calves",
    "Lats",
    "Triceps",
    "Lower Back",
    "Glutes",
    "Hamstrings",
    "Neck",
    "Full Body",
    "Upper Body",
    "Lower Body",
    "Push",
    "Pull",
    "Legs",
    "Arms",
    "Chest",
    "Back",
    "Bodyweight",
    "Cardio",
    "Weights",
  ];

  String name;
  String type;
  String gif;
  String description;
  String uid;

  String direction;

  num distance;
  String distanceUnit;
  num bottomRep;
  num topRep;
  num time; //seconds

  //Sorting Purposes
  String tag1;
  String tag2;
  String tag3;
  String tag4;
  String tag5;
  String possibleType1;
  String possibleType2;
  String possibleType3;
  String possibleType4;
  String possibleType5;
  String possibleType6;
  String possibleType7;
  String possibleType8;

  Exercise({
    this.name,
    this.type,
    this.gif,
    this.description,
    this.uid,

    this.direction,

    this.bottomRep,
    this.topRep,
    this.time,
    this.distance,
    this.distanceUnit,

    this.tag1,
    this.tag2,
    this.tag3,
    this.tag4,
    this.tag5,
    this.possibleType1,
    this.possibleType2,
    this.possibleType3,
    this.possibleType4,
    this.possibleType5,
    this.possibleType6,
    this.possibleType7,
    this.possibleType8,
  }){
    if(this.uid == null){
      this.uid = Calculations.getUuid();
    }
  }

  String repsToString(){
    if(topRep == null) return "ERROR";

    if(topRep == 0){
      return "To Failure";
    }

    bool plus = topRep.isNegative;
    String repsString = "";

    if(bottomRep != null && bottomRep > 0){
      repsString = "$bottomRep-";
    }

    if(topRep <= bottomRep){
      return "${topRep.abs()}${plus ? '+' : ''}";
    } 

    return repsString += "${topRep.abs()}${plus ? '+' : ''}";

  }

  String distanceToString(){
    if(distance == null || distanceUnit == null) return "ERROR";

    
    String distanceString = distance.toStringAsFixed((distanceUnit == "Miles") ? 2 : 0) + " ";

    if(distance == 1){
      distanceString += distanceUnit.substring(0, distanceUnit.length - 1);
    } else {
      distanceString += distanceUnit;
    }

    return distanceString;
  }

  void setType({String newType, bool isCoundown = false}){
    if(newType != null){ this.type = newType; return;}
    if(this.containsType("Note")){ this.type = "Note"; return;}
    if(this.containsType("Rest")){ this.type = "Rest"; return;}

    if(isCoundown){
      List<String> types = this.typesToList();

      newType = types.firstWhere((type){
        return type.contains("Countdown");
      }, orElse: (){return null;});
    }

    if(newType != null){
      this.type = newType;
    } else {
      LOG.log("Could not set type for $name", FoodFrenzyDebugging.crash);
    }

  }

  bool containsTag(String tag){
    return tag1 == tag ||
      tag2 == tag ||
      tag3 == tag ||
      tag4 == tag ||
      tag5 == tag;
  }

  bool containsPartialTag(String tag){
    tag = tag.toLowerCase();
    return tag1.toLowerCase().contains(tag) ||
      tag2.toLowerCase().contains(tag) ||
      tag3.toLowerCase().contains(tag) ||
      tag4.toLowerCase().contains(tag) ||
      tag5.toLowerCase().contains(tag);
  }

  bool containsStartOfTag(String tag){
    int unit = tag.toLowerCase().codeUnitAt(0);

    bool tag1Match = (tag1.isNotEmpty) ? tag1.toLowerCase().codeUnitAt(0) == unit : false;
    bool tag2Match = (tag2.isNotEmpty) ? tag2.toLowerCase().codeUnitAt(0) == unit : false;
    bool tag3Match = (tag3.isNotEmpty) ? tag3.toLowerCase().codeUnitAt(0) == unit : false;
    bool tag4Match = (tag4.isNotEmpty) ? tag4.toLowerCase().codeUnitAt(0) == unit : false;
    bool tag5Match = (tag5.isNotEmpty) ? tag5.toLowerCase().codeUnitAt(0) == unit : false;


    return tag1Match ||
      tag2Match ||
      tag3Match ||
      tag4Match ||
      tag5Match;
  }

  int getMainTypeIndex(){
    List<String> types = this.typesToList();

    if(types.contains("Note")) return 0;
    if(types.contains("Rest")) return 0;
    if(types.contains("Weights")) return 1;
    if(types.contains("Weights Time")) return 1;
    if(types.contains("Bodyweight")) return 2;
    if(types.contains("Bodyweight Time")) return 2;
    if(types.contains("Cardio Time")) return 3;
    if(types.contains("Cardio Distance")) return 3;

    return -1; //Countdown Index

  }

  List<String> typesToList(){
    List<String> types = List<String>();
    
    if(this.possibleType1.isNotEmpty) types.add(this.possibleType1);
    if(this.possibleType2.isNotEmpty) types.add(this.possibleType2);
    if(this.possibleType3.isNotEmpty) types.add(this.possibleType3);
    if(this.possibleType4.isNotEmpty) types.add(this.possibleType4);
    if(this.possibleType5.isNotEmpty) types.add(this.possibleType5);
    if(this.possibleType6.isNotEmpty) types.add(this.possibleType6);
    if(this.possibleType7.isNotEmpty) types.add(this.possibleType7);
    if(this.possibleType8.isNotEmpty) types.add(this.possibleType8);

    return types;
  }

  bool containsType(String type){
    return possibleType1 == type ||
      possibleType2 == type ||
      possibleType3 == type ||
      possibleType4 == type ||
      possibleType5 == type ||
      possibleType6 == type ||
      possibleType7 == type ||
      possibleType8 == type;
  }

  factory Exercise.refresh(Exercise old){
    return Exercise(
      name: old.name,
      type: old.type,
      gif: old.gif,
      description: old.description,
      uid: Calculations.getUuid(),

      direction: old.direction,

      bottomRep: old.bottomRep,
      topRep: old.topRep,
      time: old.time,
      distance: old.distance,
      distanceUnit: old.distanceUnit,
      
      tag1: old.tag1,
      tag2: old.tag2,
      tag3: old.tag3,
      tag4: old.tag4,
      tag5: old.tag5,
      possibleType1: old.possibleType1,
      possibleType2: old.possibleType2,
      possibleType3: old.possibleType3,
      possibleType4: old.possibleType4,
      possibleType5: old.possibleType5,
      possibleType6: old.possibleType6,
      possibleType7: old.possibleType7,
      possibleType8: old.possibleType8,
    );
  }

  factory Exercise.fromMap(Map data){
    return Exercise(
      name: data['name'] ?? "",
      type: data['type'] ?? "",
      gif: data['gif'] ?? "",
      description: data['description'] ?? "",
      uid: data['uid'] ?? Calculations.getUuid(),

      direction: data['direction'] ?? "",

      bottomRep: data['bottom rep'] ?? -1,
      topRep: data['top rep'] ?? -1,
      time: data['time'] ?? -1,
      distance: data['distance'] ?? -1,
      distanceUnit: data['distance unit'] ?? "",

      tag1: data['tag 1'] ?? "",
      tag2: data['tag 2'] ?? "",
      tag3: data['tag 3'] ?? "",
      tag4: data['tag 4'] ?? "",
      tag5: data['tag 5'] ?? "",
      possibleType1: data['possible type 1'] ?? "",
      possibleType2: data['possible type 2'] ?? "",
      possibleType3: data['possible type 3'] ?? "",
      possibleType4: data['possible type 4'] ?? "",
      possibleType5: data['possible type 5'] ?? "",
      possibleType6: data['possible type 6'] ?? "",
      possibleType7: data['possible type 7'] ?? "",
      possibleType8: data['possible type 8'] ?? "",
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': this.name ?? "",
      'type': this.type ?? "",
      'gif': this.gif ?? "",
      'description': this.description ?? "",
      'uid': this.uid ?? Calculations.getUuid(),

      'direction': this.direction ?? "",

      'bottom rep': this.bottomRep ?? -1,
      'top rep': this.topRep ?? -1,
      'time': this.time ?? -1,
      'distance': this.distance ?? -1,
      'distance unit': this.distanceUnit ?? -1,
    };
  }

  bool operator ==(Object other) {
    return other is Exercise
      && other.name == name 
      && other.uid == uid;
  }
}

class Record{
  String name;
  String type;
  String gif;
  String description;
  String direction;
  String uid;

  num bottomRep; //0 == none
  num topRep; //0 = Failure //-(reps) == +
  num loggedReps;

  num loggedWeight;

  num distance;
  String distanceUnit;
  num loggedDistance;

  num time;
  num loggedTime;

  num formScore; //1 = good form | -1 = bad form

  String note;

  Record({
    this.name,
    this.type,
    this.gif,
    this.description,
    this.direction,
    this.uid,
    
    this.bottomRep,
    this.topRep,
    this.loggedReps,

    this.loggedWeight,

    this.distance,
    this.distanceUnit,
    this.loggedDistance,

    this.time,
    this.loggedTime,

    this.formScore,

    this.note
  });

  String loggedToString(){
    String string = "";

    switch(this.type){
      case "Cardio Time": 
        string += "${TextHelpers.removeDecimalIfNeeded(this.loggedDistance, 2)} ${this.distanceUnit} in ${TextHelpers.secondsToTimerString(this.time)}";
        break;
      case "Cardio Distance":
        string += "${TextHelpers.removeDecimalIfNeeded(this.distance, 2)} ${this.distanceUnit} in ${TextHelpers.secondsToTimerString(this.loggedTime)}";
        break;
      case "Bodyweight Time": 
        string += "${TextHelpers.removeDecimalIfNeeded(this.loggedReps, 0)} reps in ${TextHelpers.secondsToTimerString(this.time)}";
        break;
      case "Bodyweight Reps":
        string += "${TextHelpers.removeDecimalIfNeeded(this.loggedReps, 0)} reps";
        break;
      case "Weights Time": 
        string += "${TextHelpers.removeDecimalIfNeeded(this.loggedReps, 0)}x${(this.loggedWeight == 0) ? 'bw' : (TextHelpers.removeDecimalIfNeeded(this.loggedWeight, 1) + 'lbs')} in ${TextHelpers.secondsToTimerString(this.time)}";
        break;
      case "Weights Reps":
        string += "${TextHelpers.removeDecimalIfNeeded(this.loggedReps, 0)}x${(this.loggedWeight == 0) ? 'bw' : (TextHelpers.removeDecimalIfNeeded(this.loggedWeight, 1) + 'lbs')}";
        break;
    }

    return string;
  }

  factory Record.fromExercise(Exercise exercise){
    return Record(
      name: exercise.name ?? "",
      type: exercise.type ?? "",
      gif: exercise.gif ?? "",
      description: exercise.description ?? "",
      direction: exercise.direction ?? "",
      uid: exercise.uid,

      bottomRep: null,
      topRep: null,
      loggedReps: null,

      loggedWeight: null, //0 = BW

      distance: null,
      distanceUnit: null,
      loggedDistance: null,

      time: null,
      loggedTime: null,

      formScore: null,

      note: "",
    );
  }

  factory Record.fromMap(Map data){
    return Record(
      name: data['name'] ?? "",
      type: data['type'] ?? "",
      gif: data['gif'] ?? "",
      description: data['description'] ?? "",
      direction: data['direction'] ?? "",
      uid: data['uid'],

      bottomRep: data['bottom rep'],
      topRep: data['top rep'],
      loggedReps: data['logged reps'],

      loggedWeight: data['logged weight'], //0 = BW

      distance: data['distance'],
      distanceUnit: data['distance unit'],
      loggedDistance: data['logged distance'],

      time: data['time'],
      loggedTime: data['logged time'],

      formScore: data['form score'],

      note: data['note'] ?? "",
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name' : this.name ?? "",
      'type' : this.type ?? "",
      'gif': this.gif ?? "",
      'description': this.description ?? "",
      'direction': this.direction ?? "",
      'uid': this.uid,

      'bottom rep': this.bottomRep,
      'top rep': this.topRep,
      'logged reps': this.loggedReps,

      'logged weight': this.loggedWeight,

      'distance': this.distance,
      'distance unit': this.distanceUnit,
      'logged distance': this.loggedDistance,

      'time': this.time,
      'logged time': this.loggedTime,

      'form score': this.formScore,

      'note': this.note,
    };
  }
}

class Workout{
  static final GlobalData<Workout> firebase = GlobalData(workoutCollection);
  static const String workoutCollection = "Workouts";

  static const String countdownType = "countdown";
  static const String traditionalType = "traditional";
  static const String appleType = "apple";

  String createdBy;
  String createdFor;
  String documentName;

  String name;
  String type;
  String description;
  String photo;
  String uid;

  num time; //seconds

  DateTime logTimestamp;
  num logCals;
  num logDuration; //seconds

  List<Exercise> exercises;

  //Only used for User Log
  Map<String, Record> record;
  Map<String, Record> lastRecord;

  Workout({
    //Firebase Stuff
    this.createdFor,
    this.createdBy,
    this.documentName,

    this.name,
    this.type,
    this.description,
    this.photo,
    this.uid,

    this.time,

    this.logTimestamp,
    this.logCals,
    this.logDuration,

    this.exercises,

    this.record,
    this.lastRecord,
  }){
    if(uid == null){
      this.uid = Calculations.getUuid();
    }

    if(exercises == null){
      this.exercises = List<Exercise>();
    }

    if(record == null){
      this.record = Map<String, Record>();
    }

    if(lastRecord == null){
      this.lastRecord = Map<String, Record>();
    }

  }

  factory Workout.copyWorkout(Workout workout){
    Map<String, dynamic> data = workout.toMap();

    return Workout(
      createdBy: data['createdBy'] ?? "",
      createdFor: data['createdFor'] ?? "EVERYONE",
      documentName: null, //IMPORTANT
      name: (data['name'] != null) ? (data['name'] + " COPY") : "COPY",
      type: data['type'] ?? "",
      description: data['description'] ?? "",
      photo: data['photo'] ?? "",
      uid: Calculations.getUuid(), //IMPORTANT
      time: data['time'] ?? -1,
      logCals: data['logCals'] ?? -1,
      logDuration: data['logDuration'] ?? -1,
      logTimestamp: (data['logTimestamp'] != null) ? ((data['logTimestamp'] is Timestamp) ? (data['logTimestamp'] as Timestamp).toDate() : (data['logTimestamp'] as DateTime)) : DateTime.now(),
      exercises: (data['exercises'] != null) ? [for(var exercise in data['exercises']) Exercise.fromMap(exercise)] : [],
      record: {
        if(data['record'] != null) for(String key in (data['record'] as Map<String, dynamic>).keys) key : Record.fromMap((data['record'] as Map<String, dynamic>)[key]),
      },
      lastRecord: {
        if(data['last record'] != null) for(String key in (data['last record'] as Map<String, dynamic>).keys) key : Record.fromMap((data['last record'] as Map<String, dynamic>)[key]),
      }
    );
  }

  // factory Workout.sendToWorkout(Workout workout, String uid){
  //   Map<String, dynamic> data = workout.toMap();

  //   return Workout(
  //     createdBy: data['createdBy'] ?? "",
  //     createdFor: uid, //IMPORTANT
  //     documentName: workout.documentName, //IMPORTANT
  //     name: data['name'] ?? "",
  //     type: data['type'] ?? "",
  //     description: data['description'] ?? "",
  //     photo: data['photo'] ?? "",
  //     uid: workout.uid, //IMPORTANT
  //     time: data['time'] ?? -1,
  //     exercises: (data['exercises'] != null) ? [for(var exercise in data['exercises']) Exercise.fromMap(exercise)] : [],
  //     record: {},
  //     lastRecord: {}
  //   );
  // }

  factory Workout.toGlobalWorkout(Workout workout){
    Map<String, dynamic> data = workout.toMap();
    String uid = Calculations.getUuid();

    return Workout(
      createdBy: "Ya Boi", //IMPORTANT
      createdFor: "EVERYONE", //IMPORTANT
      documentName: null, //IMPORTANT
      name: data['name'] ?? "",
      type: data['type'] ?? "",
      description: data['description'] ?? "",
      photo: data['photo'] ?? "",
      uid: uid, //IMPORTANT
      time: data['time'] ?? -1,
      logCals: data['logCals'] ?? -1,
      logDuration: data['logDuration'] ?? -1,
      logTimestamp: (data['logTimestamp'] != null) ? ((data['logTimestamp'] is Timestamp) ? (data['logTimestamp'] as Timestamp).toDate() : (data['logTimestamp'] as DateTime)) : DateTime.now(),
      exercises: (data['exercises'] != null) ? [for(var exercise in data['exercises']) Exercise.fromMap(exercise)] : [],
      record: {},
      lastRecord: {}
    );
  }

  factory Workout.sendToWorkoutCopy(Workout workout, String uid){
    Map<String, dynamic> data = workout.toMap();

    return Workout(
      createdBy: data['createdBy'] ?? "",
      createdFor: uid, //IMPORTANT
      documentName: null, //IMPORTANT
      name: data['name'] ?? "",
      type: data['type'] ?? "",
      description: data['description'] ?? "",
      photo: data['photo'] ?? "",
      uid: Calculations.getUuid(), //IMPORTANT
      time: data['time'] ?? -1,
      logCals: data['logCals'] ?? -1,
      logDuration: data['logDuration'] ?? -1,
      logTimestamp: (data['logTimestamp'] != null) ? ((data['logTimestamp'] is Timestamp) ? (data['logTimestamp'] as Timestamp).toDate() : (data['logTimestamp'] as DateTime)) : DateTime.now(),
      exercises: (data['exercises'] != null) ? [for(var exercise in data['exercises']) Exercise.fromMap(exercise)] : [],
      record: {},
      lastRecord: {}
    );
  }

  factory Workout.fromMap(Map data){
    
    return Workout(
      createdBy: data['createdBy'] ?? "",
      createdFor: data['createdFor'] ?? "EVERYONE",
      documentName: data['documentName'] ?? "",
      name: data['name'] ?? "",
      type: data['type'] ?? "",
      description: data['description'] ?? "",
      photo: data['photo'] ?? "",
      uid: data['uid'] ?? Calculations.getUuid(),
      time: data['time'] ?? -1,
      logCals: data['logCals'] ?? -1,
      logDuration: data['logDuration'] ?? -1,
      logTimestamp: (data['logTimestamp'] != null) ? ((data['logTimestamp'] is Timestamp) ? (data['logTimestamp'] as Timestamp).toDate() : (data['logTimestamp'] as DateTime)) : DateTime.now(),
      exercises: (data['exercises'] != null) ? [for(var exercise in data['exercises']) Exercise.fromMap(exercise)] : [],
      record: {
        if(data['record'] != null) for(String key in (data['record'] as Map<String, dynamic>).keys) key : Record.fromMap((data['record'] as Map<String, dynamic>)[key]),
      },
      lastRecord: {
        if(data['last record'] != null) for(String key in (data['last record'] as Map<String, dynamic>).keys) key : Record.fromMap((data['last record'] as Map<String, dynamic>)[key]),
      }
    );
  }

  factory Workout.fromAppleForLogging(AppleWorkoutRecord data){
    
    return Workout(
      name: data.common,
      description: "Apple Workout Code: ${data.id}",
      type: Workout.appleType,
      uid: data.uid,
      logCals: data.cals,
      logDuration: data.duration,
      logTimestamp: data.timestamp,
    );
  }

  void toLoggingWorkout({num cals, num duration, DateTime timestamp}){
    this.logCals = cals;
    this.logDuration = duration;
    this.logTimestamp = timestamp;
  }

  Map<String, dynamic> toMap(){
    return {
      'createdBy': this.createdBy ?? "",
      'createdFor': this.createdFor ?? "EVERYONE",
      'documentName': this.documentName ?? "",

      'name': this.name ?? "",
      'type': this.type ?? "",
      'description': this.description ?? "",
      'photo': this.photo ?? "",
      'uid': this.uid ?? Calculations.getUuid(),

      'time': this.time ?? -1,

      'logCals': this.logCals ?? -1,
      'logDuration': this.logDuration ?? -1,
      'logTimestamp': this.logTimestamp ?? DateTime.now(),

      'exercises': (this.exercises != null) ? [for(Exercise exercise in this.exercises) exercise.toMap()] : null,

      'record': {
        if(record != null) if(record.isNotEmpty) for(String key in this.record.keys) key : record[key].toMap(),
      },
      'last record': {
        if(lastRecord != null) if(lastRecord.isNotEmpty) for(String key in this.lastRecord.keys) key : lastRecord[key].toMap(),
      }
    };
  }

  bool operator == (o){
    return(
      o is Workout &&
      o.uid == uid
    );
  }
}

class UserRecords{
  static final UserData<UserRecords> firebase = UserData(UserRecordsCollection);
  static const String UserRecordsCollection = "User Records";

  DateTime date;
  String workoutUid;
  Map<String, Record> record;

  UserRecords({
    this.date,
    this.workoutUid,
    this.record,
  });

  static Future<UserRecords> getLatestRecord(String workoutUID){
    return firebase.getLatestRecord(workoutUID);
  }

  Future<void> updateRecord(){return firebase.createNewRecord(this);}

  factory UserRecords.fromMap(Map data){
    return UserRecords(
      date: (data['date'] != null) ? ((data['date'] is Timestamp) ? (data['date'] as Timestamp).toDate() : (data['date'] as DateTime)) : Calculations.getTopOfTheMorning(),
      workoutUid: data['workoutuid'],
      record: {
        if(data['record'] != null) for(String key in (data['record'] as Map<String, dynamic>).keys) key : Record.fromMap((data['record'] as Map<String, dynamic>)[key]),
      },
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'workoutuid' : this.workoutUid ?? "ERROR",
      'date' : this.date ?? Calculations.getTopOfTheMorning(),
      'record': {
        for(String key in this.record.keys) key : record[key].toMap(),
      },
    };
  }

}

class AppleWorkoutRecord{
  final int id;
  final String name;
  final String common;
  final String emoji;
  final double duration;
  final double cals;
  final DateTime timestamp;
  final String uid;


  AppleWorkoutRecord({
    this.id,
    this.name,
    this.common,
    this.emoji,
    this.duration,
    this.cals,
    this.timestamp,
    this.uid,
  });

  static DateTime _parseHKTimestamp(String timestamp){
    if(timestamp == null) return DateTime.now();

    List<String> ymdhm = timestamp.split(":");
    if(ymdhm.length != 5) return DateTime.now();

    return DateTime(
      int.tryParse(ymdhm[0]) ?? 0,
      int.tryParse(ymdhm[1]) ?? 0,
      int.tryParse(ymdhm[2]) ?? 0,
      int.tryParse(ymdhm[3]) ?? 0,
      int.tryParse(ymdhm[4]) ?? 0,
    );
  }

  factory AppleWorkoutRecord.fromHKMap(Map data){
    
    return AppleWorkoutRecord(
      id: int.tryParse(data['ID'] ?? 0) ?? 0,
      name: data['Name'] ?? "",
      common: data['Common'] ?? "",
      emoji: data['Emoji'] ?? "",
      duration: double.tryParse(data['Duration'] ?? 0) ?? 0,
      cals: double.tryParse(data['Cals'] ?? 0) ?? 0,
      timestamp: _parseHKTimestamp(data['Timestamp']),
      uid: data['UID'] ?? "",
    );
  }

  @override
  String toString() {
    return "Apple Workout- ${this.name} for ${this.duration.toStringAsFixed(0)}s burned ${this.duration.toStringAsFixed(0)}cals";
  }

  bool operator == (o){
    return(
      o is AppleWorkoutRecord &&
      o.uid == uid
    );
  }
}