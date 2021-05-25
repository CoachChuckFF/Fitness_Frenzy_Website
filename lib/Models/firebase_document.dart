/*
* Christian Krueger Health LLC
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/

import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreModels{

  static final Map models = {
    UserState: (data) => UserState.fromMap(data),
    UserCommonIngredients: (data) => UserCommonIngredients.fromMap(data),
    Ingredient: (data) => Ingredient.fromMap(data),
    IngredientAggregate: (data) => IngredientAggregate.fromMap(data),
    IngredientAggregateTags: (data) => IngredientAggregateTags.fromMap(data),
    Day: (data) => Day.fromMap(data),
    UserLog: (data) => UserLog.fromMap(data),
    UserPoints: (data) => UserPoints.fromMap(data),
    UserLogEntries: (data) => UserLogEntries.fromMap(data),
    YoutubeAggregate: (data) => YoutubeAggregate.fromMap(data),
    Meal: (data) => Meal.fromMap(data),
    SprinkleUnlocks: (data) => SprinkleUnlocks.fromMap(data),
    UserHabits: (data) => UserHabits.fromMap(data),
    // UserWorkoutRecords: (data) => UserWorkoutRecords.fromMap(data),
    UserWorkouts: (data) => UserWorkouts.fromMap(data),
    UserRecords: (data) => UserRecords.fromMap(data),
    UserACQ: (data) => UserACQ.fromMap(data),
    Workout: (data) => Workout.fromMap(data),
    Exercise: (data) => Exercise.fromMap(data),
    ExerciseAggregate: (data) => ExerciseAggregate.fromMap(data),
  };
}

class StaticGlobalData<T> {
  static final AuthController _auth = AuthController();
  final String collection;
  final String document;

  StaticGlobalData(this.collection, this.document);


  Stream<T> get documentStream {
    return _auth.user.switchMap((user) {
      if(user != null){
        String path = '$collection/$document';
        Document<T> doc = Document<T>(path: path); 
        LOG.log("Got static global stream: $path", FoodFrenzyDebugging.info);
        return doc.streamData();
      }
      return Stream<T>.value(null);
    });
  }

  Future<T> getDocument() async {
    if(_auth.getUser== null) return null;
    String path = '$collection/$document';
    Document doc = Document<T>(path: '$collection/$document'); 
    return doc.getData()..then((document){
      LOG.log("Got static global document: $path:${document}", FoodFrenzyDebugging.info);
    });
  }

  Future<bool> checkExists() async {
    if(_auth.getUser == null) return null;
    String path = '$collection/$document';
    Document<T> ref = Document(path: path);
    return ref.checkExists()..then((exists){
        LOG.log("Check static global document: $path:${exists ? 'Exists.' : 'Does not exist.'}", FoodFrenzyDebugging.info);
    });
  }
}

class GlobalData<T> {
  static final AuthController _auth = AuthController();
  final String collection;

  GlobalData(this.collection);

  Stream<T> getDocumentStream(String document) {
    return _auth.user.switchMap((user) {
      if(user != null){
        String path = '$collection/$document';
        Document<T> doc = Document<T>(path: path); 
        LOG.log("Got global stream: $path", FoodFrenzyDebugging.info);
        return doc.streamData();
      }
      return Stream<T>.value(null);
    });
  }

  Future<T> getDocument(String document) async {
    if(_auth.getUser == null) return null;
    String path = '$collection/$document';
    Document doc = Document<T>(path: '$collection/$document'); 
    return doc.getData()..then((document){
      LOG.log("Got global document: $path:${document}", FoodFrenzyDebugging.info);
    });
  }

  Future<bool> checkExists(String document) async {
    if(_auth.getUser == null) return null;
    String path = '$collection/$document';
    Document<T> ref = Document(path: path);
    return ref.checkExists()..then((exists){
        LOG.log("Check global document: $path:${exists ? 'Exists.' : 'Does not exist.'}", FoodFrenzyDebugging.info);
    });
  }

  Future<void> upsert(Map data, String id, {bool merge}) async {
    if(_auth.getUser == null) return null;
    String path = '$collection/${id}';
    LOG.log("Upserted global document: $path", FoodFrenzyDebugging.info);
    Document<T> ref = Document(path: path);
    return ref.upsert(data, merge: merge);
  }

  Future<void> update(Map data, String id) async {
    if(_auth.getUser == null) return null;
    String path = '$collection/${id}';
    LOG.log("Updated global document: $path", FoodFrenzyDebugging.info);
    Document<T> ref = Document(path: path);
    return ref.update(data);
  }
}

class WorkoutData<T> {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String collection = "Workouts";

  WorkoutData();

  static Future<List<Workout>> getMyWorkouts({String uid, String createdFor}) async{

    if(uid == null){ 
      User user = _auth.currentUser;
      uid = user.uid;
    }

    if(uid != null) {
      List<Workout> workouts;

      collection;
      Document doc = Document<Workout>(collection: collection); 
      if(createdFor != null){
        workouts = await doc.getDataContaining2(
          feild: "createdBy",
          value: uid,
          feild2: "createdFor",
          value2: createdFor,
          orderBy: "name",
        );
      } else {
        workouts = await doc.getDataContaining(
          feild: "createdBy",
          value: uid,
          orderBy: "name",
        );
      }

      LOG.log("Got all my workouts: ${workouts.length}", FoodFrenzyDebugging.info);
      return workouts;

    } else {
      LOG.log("Could not get user - get my workouts", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  static Future<Map<String, List<Workout>>> getLoggableWorkouts({String uid}) async{
    Map<String, List<Workout>> workouts = {};

    if(uid != null){
      List<Workout> otherWorkouts = await getOthersWorkout(uid);
      if(otherWorkouts != null){
        workouts[uid] = [];
        workouts[uid].addAll(otherWorkouts);
      }

      LOG.log("Got all loggable workouts from buddy: ${workouts.length}", FoodFrenzyDebugging.info);
      return workouts;
    } else {
      String uid = _auth.currentUser.uid;

      if(uid != null) {
        List<Workout> myWorkouts;
        List<Workout> othersWorkouts;
        List<Workout> globalWorkouts;

        collection;
        Document doc = Document<Workout>(collection: collection); 
        myWorkouts = await doc.getDataContaining2(
          feild: "createdBy",
          value: uid,
          feild2: "createdFor",
          value2: "EVERYONE",
          orderBy: "name",
        );

        if(myWorkouts != null)
          workouts[uid] = List<Workout>.from(myWorkouts);
        

        othersWorkouts = await doc.getDataContaining(
          feild: "createdFor",
          value: uid,
          orderBy: "name",
        );

        for(Workout workout in othersWorkouts){
          if(workouts.containsKey(workout.createdBy)){
            workouts[workout.createdBy].add(workout);
          } else {
            workouts[workout.createdBy] = [];
            workouts[workout.createdBy].add(workout);
          }
        }

        globalWorkouts = await doc.getDataContaining2(
          feild: "createdBy",
          value: "Ya Boi",
          feild2: "createdFor",
          value2: "EVERYONE",
          orderBy: "name",
        );

        if(globalWorkouts != null)
          workouts['global'] = List<Workout>.from(globalWorkouts);

        LOG.log("Got all loggable workouts: ${workouts.length}", FoodFrenzyDebugging.info);
        return workouts;

      } else {
        LOG.log("Could not get user - get loggable workouts", FoodFrenzyDebugging.crash);
        return null;
      }
    }
  }

  static Future<List<Workout>> getOthersWorkout(String uid) async{

    if(uid != null) {
      List<Workout> workouts;

      collection;
      Document doc = Document<Workout>(collection: collection); 
      workouts = await doc.getDataContaining2(
        feild: "createdBy",
        value: uid,
        feild2: "createdFor",
        value2: "EVERYONE",
        orderBy: "name",
      );

      LOG.log("Got all buddy's workouts: ${workouts.length}", FoodFrenzyDebugging.info);
      return workouts;

    } else {
      LOG.log("Could not get user - get others workouts", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  static Future<Workout> saveWorkout(Workout workout) async{
    User user = _auth.currentUser;

    if (user != null) {
      workout.createdBy = user.uid;
      workout.documentName = '$collection/${user.uid}_${workout.uid}';

      String path = workout.documentName;
      Document doc = Document<Workout>(path: path); 
      await doc.upsert(workout.toMap());
      LOG.log("Saved workout: $path", FoodFrenzyDebugging.info);
      return workout;

    } else {
      LOG.log("Could not get user - save user workout: ${workout.name}", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  static Future<Workout> saveGlobal(Workout workout) async{

    if (AuthController().isAdmin) {
      
      workout.documentName = '$collection/00C_${workout.uid}';
      String path = workout.documentName;
      Document doc = Document<Workout>(path: path); 
      await doc.upsert(workout.toMap());
      LOG.log("Saved global workout: $path", FoodFrenzyDebugging.info);
      return workout;

    } else {
      LOG.log("Not admin - could not save global workout: ${workout.name}", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  static Future<void> deleteWorkout(String path){
    Document doc = Document<Workout>(path: path);

    LOG.log("Deleted Workout: ${path}", FoodFrenzyDebugging.info);
    return doc.delete();
  }

  static Future<void> copyWorkout(Workout workout){
    return saveWorkout(Workout.copyWorkout(workout));
  }

  // Future<void> loveWorkout(String document){ //love workout will bring to my workout

  // }
}

class MealData<T> {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String collection = "Meals";

  MealData();

  static Future<List<Meal>> getMyMeals(String uid) async{

    if(uid == null){
      User user = _auth.currentUser;
      uid = user.uid;
    }
    
    if (uid != null) {

      Document doc = Document<Meal>(collection: collection); 
      List<Meal> meals = await doc.getDataContaining(
        feild: "createdBy",
        value: uid,
        orderBy: "name",
      );

      LOG.log("Got all my meals: ${meals.length}", FoodFrenzyDebugging.info);
      return meals;

    } else {
      LOG.log("Could not get user - get my meals", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  static Future<Meal> saveMeal(Meal meal) async{
    User user = _auth.currentUser;

    if (user != null) {
      meal.createdBy = user.uid;
      meal.documentName = '$collection/${user.uid}_${meal.uid}';

      String path = meal.documentName;
      Document doc = Document<Meal>(path: path); 
      await doc.upsert(meal.toMap());
      LOG.log("Saved meal: $path", FoodFrenzyDebugging.info);
      return meal;

    } else {
      LOG.log("Could not get user - save user meal: ${meal.name}", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  static Future<void> deleteMeal(String path){
    Document doc = Document<Meal>(path: path);

    LOG.log("Deleted Meal: ${path}", FoodFrenzyDebugging.info);
    return doc.delete();
  }

  // Future<void> loveMeal(String document){ //love meal will bring to my meals

  // }
}

class UserData<T> {
  final AuthController _auth = AuthController();
  final String collection;

  UserData(this.collection);

  Stream<T> get documentStream{

    return _auth.user.switchMap((user) {
      
      if (user != null) {
        String path = '$collection/${user.uid}';
        Document<T> doc = Document<T>(path: path); 
        LOG.log("Got user stream: $path", FoodFrenzyDebugging.info);
        return doc.streamData();
      } else {
        LOG.log("Could not get user - get user document stream: $collection", FoodFrenzyDebugging.crash);
        return Stream<T>.value(null);
      }
    });
  }

  Stream<T> get todaysStream{

    return _auth.user.switchMap((user) {
      
      if (user != null) {
        String path = '$collection/${user.uid}/logs/${TextHelpers.getTodaysFirebaseDate()}';
        Document<T> doc = Document<T>(path: path); 
        LOG.log("Got today's user stream: $path", FoodFrenzyDebugging.info);
        return doc.streamData();
      } else {
        LOG.log("Could not get user - get today's user document stream: $collection", FoodFrenzyDebugging.crash);
        return Stream<T>.value(null);
      }
    });
  }

  Future<List<T>> getDocumentsInRange(DateTime start, DateTime end, {String uid}) async {
    User user = _auth.getUser;

    if (user != null && start != null && end != null) {
      String path = '$collection/${(uid != null) ? uid: user.uid}/logs/';

      if(start.compareTo(end) > 0){
        DateTime temp = start;
        start = end;
        end = temp;
      }

      Document<T> doc = Document<T>(collection: path);
      return doc.getDataByDate(start, end)..then((documents){
        if(documents == null){
          LOG.log("Returned null docuemnts", FoodFrenzyDebugging.crash);
        } else {
          LOG.log("Got ${documents.length} documents from $start to $end: $path", FoodFrenzyDebugging.info);
        }
      });
    } else {
      LOG.log("Could not get documents in range $start:$end - user: $user? $collection", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  Future<T> getLatestRecord(String workoutUID) async {
    User user = _auth.getUser;

    if (user != null && workoutUID != null && workoutUID.isNotEmpty) {
      String path = '$collection/${user.uid}/$workoutUID/';
 
      Document<T> doc = Document<T>(collection: path);
      return doc.getLatestData()..then((document){
        LOG.log("Got latest record from: $path", FoodFrenzyDebugging.info);
      }, onError: (error){
        LOG.log("Could not get record - it may not exist: $workoutUID: $error", FoodFrenzyDebugging.crash);
      });
    } else {
      LOG.log("Could not get record - bad input: $workoutUID", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  Future<void> createNewRecord(UserRecords record) async {
    User user = _auth.getUser;

    if (user != null && record != null) {
      String path = '$collection/${user.uid}/${record.workoutUid}/${TextHelpers.getTodaysFirebaseDate()}';

      Document<T> doc = Document<T>(path: path);
      LOG.log("Updated today's document: $path", FoodFrenzyDebugging.info);
      return doc.upsert(record.toMap());

    } else {
      LOG.log("Could not get user - create new record: $collection", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  Future<T> getTodaysDocument(Map newDocument) async {
    User user = _auth.getUser;

    if (user != null) {
      String path = '$collection/${user.uid}/logs/${TextHelpers.getTodaysFirebaseDate()}';
      Document<T> doc = Document<T>(path: path);
      bool exists = await doc.checkExists();
      
      if(!exists){
        LOG.log("$path does not exists - Get today's document", FoodFrenzyDebugging.info);
        await doc.upsert(
          newDocument..['uid'] = user.uid
        );
        LOG.log("New Document Created: $path", FoodFrenzyDebugging.info);
      }

      return doc.getData()..then((document){
        LOG.log("Got today's user docuemnt: $path:$document", FoodFrenzyDebugging.info);
      });

    } else {
      LOG.log("User Not Found - Get Todays Document", FoodFrenzyDebugging.crash);
      return null;
    }

  }

  Future<T> getDocumentFromDate(DateTime date, {Map newDocument, bool shouldCreate = false}) async {
    User user = _auth.getUser;

    if (user != null) {
      String path = '$collection/${user.uid}/logs/${TextHelpers.getTodaysFirebaseDate(date: date)}';
      Document<T> doc = Document<T>(path: path);
      bool exists = await doc.checkExists();
      
      if(!exists && shouldCreate && newDocument != null){
        LOG.log("$path does not exists - Get today's document", FoodFrenzyDebugging.info);
        await doc.upsert(
          newDocument..['uid'] = user.uid
        );

        exists = true;
        LOG.log("New Document Created: $path", FoodFrenzyDebugging.info);
      }

      if(exists){
        return doc.getData()..then((document){
          LOG.log("Got user docuemnt from date: $path:$document", FoodFrenzyDebugging.info);
        });
      } else {
        LOG.log("ERROR - Get Document From Date", FoodFrenzyDebugging.crash);
        return null;
      }
    } else {
      LOG.log("User Not Found - Get Document From Date", FoodFrenzyDebugging.crash);
      return null;
    }

  }

  Future<void> updateTodaysDocument(Map data) async {
    User user = _auth.getUser;
    
    if(user != null){
      String path = '$collection/${user.uid}/logs/${TextHelpers.getTodaysFirebaseDate()}';
      Document<T> ref = Document(path: path);
      LOG.log("Updated today's document: $path", FoodFrenzyDebugging.info);
      return ref.update(data);
    } else {
      LOG.log("Could not get user - updated today's document: $collection", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  Future<void> updateDocumentFromDate(DateTime date, Map data) async {
    User user = _auth.getUser;
    
    if(user != null){
      String path = '$collection/${user.uid}/logs/${TextHelpers.getTodaysFirebaseDate(date: date)}';
      Document<T> ref = Document(path: path);
      LOG.log("Updated document from date: $path", FoodFrenzyDebugging.info);
      return ref.update(data);
    } else {
      LOG.log("Could not get user - updated document from date: $collection", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  Future<T> getDocument({String uid}){
    if(uid == null || uid.isEmpty){
      if(_auth.getUser == null){
        LOG.log("Could not get user - get user document: $collection", FoodFrenzyDebugging.crash);
        return null;
      }
      uid = _auth.getUser.uid;
    }


    String path = '$collection/$uid';
    Document doc = Document<T>(path: path); 
    return doc.getData()..then((document){
      LOG.log("Got user document: $path:$document", FoodFrenzyDebugging.info);
    });
  }

  // Future<T> getLatestDocument() async {
  //   User user = _auth.currentUser;

  //   if (user != null) {
  //     String path = '$collection/${user.uid}';
  //     Document doc = Document<T>(path: path); 
  //     return doc.getLatestData()..then((document){
  //       LOG.log("Got latest user document: $path:$document", FoodFrenzyDebugging.info);
  //     });
  //   } else {
  //     LOG.log("Could not get user - get latest user document: $collection", FoodFrenzyDebugging.crash);
  //     return null;
  //   }
  // }

  Future<void> upsert(Map data, {bool merge}) async {
    User user = _auth.getUser;
    if(user != null){
      String path = '$collection/${user.uid}';
      LOG.log("Upserted user document: $path", FoodFrenzyDebugging.info);
      Document<T> ref = Document(path: path);
      return ref.upsert(data, merge: merge);
    } else {
      LOG.log("Could not get user - upsert user document: $collection", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  Future<void> update(Map data) async {
    User user = _auth.getUser;
    if(user != null){
      String path = '$collection/${user.uid}';
      LOG.log("Updated user document: $path", FoodFrenzyDebugging.info);
      Document<T> ref = Document(path: path);
      return ref.update(data);
    } else {
      LOG.log("Could not get user - update user document: $collection", FoodFrenzyDebugging.crash);
      return null;
    }
  }

  Future<bool> checkExists() async {
    User user = _auth.getUser;

    if (user != null) {
      String path = '$collection/${user.uid}';
      Document doc = Document<T>(path: path); 
      return doc.checkExists()..then((exists){
        LOG.log("$path ${exists ? 'exists.' : 'does not exist.'}", FoodFrenzyDebugging.info);
      });
    } else {
      LOG.log("Could not get user - check user document exists: $collection", FoodFrenzyDebugging.crash);
      return null;
    }
  }
}

class Document<T> {
  static num gdc = 0;
  static num gdbf = 0;
  static num gdb2f = 0;
  static num gdbdc = 0;
  static num gldc = 0;
  static num sc = 0;
  static num usc = 0;
  static num udc = 0;
  static num cec = 0;
  static num upc = 0;
  static num gpc = 0;
  static num del = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String path;
  String collection;
  DocumentReference reference;

  Document({
    this.path,
    this.collection,
  }){
    //TODO clean up this hack
    if(path != null){
      reference = _firestore.doc(path);
    }
  }

  static void updateUploadPhotoCount()=>upc++;
  static void updateGetPhotoCount()=>gpc++;

  static String getFirebaseStats(){
    String stats = "";
    stats += "------- Firebase Stats ------ \n";
    stats += "Get Data Count: $gdc\n";
    stats += "Get Data By Field: $gdbf\n";
    stats += "Get Data By 2 Fields: $gdb2f\n";
    stats += "Get Data By Date Count: $gdbdc\n";
    stats += "Get Latest Data Count: $gldc\n";
    stats += "Stream Count: $sc\n";
    stats += "Upsert Count: $usc\n";
    stats += "Update Count: $udc\n";
    stats += "Check Exists Count: $cec\n\n";
    stats += "Upload Photo Count: $upc\n";
    stats += "Download Photo Count: $gpc\n";
    stats += "Deletes: $del\n";
    stats += "------- Firebase Stats ------ \n";
    return stats;
  }

  Future<T> getData() {
    gdc++;
    return reference
      .get()
      .then((v) => (FirestoreModels.models[T](v.data()) as T), onError: (error){
        LOG.log("$error - get ${reference.path}", FoodFrenzyDebugging.crash);
      });
  }

  Future<List<T>> getDataByDate(DateTime start, DateTime end){
    gdbdc++;
    return _firestore.collection(collection)
      .where('date', isGreaterThanOrEqualTo: Calculations.getTopOfTheMorning(day: start))
      .where('date', isLessThanOrEqualTo: Calculations.getEOD(day: end))
      .orderBy('date')
      .get()
      .then((v){
        List<T> list = List<T>();
        for (var doc in v.docs) {
          list.add(FirestoreModels.models[T](doc.data()) as T);
        }
        return list;
      }, onError: (error){
        LOG.log("$error - get ${collection}", FoodFrenzyDebugging.crash);
      });
  }

  Future<T> getLatestData(){
    gldc++;
    return _firestore.collection(collection)
      .orderBy('date', descending: true)
      .limit(1)
      .get()
      .then((v){
        if(v.docs.length != 0) return FirestoreModels.models[T](v.docs[0].data()) as T;
        return null;
      }, onError: (error){
        LOG.log("$error - get ${collection}", FoodFrenzyDebugging.crash);
      });
  }

  // Future<T> getLatestData() {
  //   gldc++;
  //   String collection = path.split('/')[0];
  //   String uid = path.split('/')[1];
  //   return _firestore.collection(collection)
  //     .where('uid', isEqualTo: '$uid')
  //     .orderBy('timestamp')
  //     .limit(1)
  //     .getDocuments()
  //     .then((v){
  //       if(v.documents.length != 0) return FirestoreModels.models[T](v.documents[0].data()) as T;
  //       return null;
  //     });
  // }

  Future<List<T>> getDataContaining({String feild, String value, String orderBy, bool descending = false}){
    gdbf++;

    return _firestore.collection(collection)
      .where(feild, isEqualTo: value)
      .orderBy(orderBy, descending: descending)
      .get()
      .then((v){
        List<T> list = List<T>();
        for (var doc in v.docs) {
          list.add(FirestoreModels.models[T](doc.data()) as T);
        }
        return list;
      }, onError: (error){
        LOG.log("$error - get ${collection}", FoodFrenzyDebugging.crash);
      });
  }

  Future<List<T>> getDataContaining2({String feild, String value, String feild2, String value2, String orderBy, bool descending = false}){
    gdb2f++;

    return _firestore.collection(collection)
      .where(feild, isEqualTo: value)
      .where(feild2, isEqualTo: value2)
      .orderBy(orderBy, descending: descending)
      .get()
      .then((v){
        List<T> list = List<T>();
        for (var doc in v.docs) {
          list.add(FirestoreModels.models[T](doc.data()) as T);
        }
        return list;
      }, onError: (error){
        LOG.log("$error - get ${collection}", FoodFrenzyDebugging.crash);
      });
  }

  Stream<T> streamData() {
    sc++;
    return reference
      .snapshots()
      .map((v) => (FirestoreModels.models[T](v.data()) as T));
  }

  Future<void> upsert(Map data, {bool merge = true}){
    usc++;
    return reference
      .set(
        Map<String, dynamic>.from(data),
        SetOptions(merge: true)
      );
  }

  Future<void> update(Map data){
    udc++;
    return reference.update(Map<String, dynamic>.from(data));
  }

  Future<bool> checkExists(){
    cec++;
    return reference
      .get()
      .then((v){
        return v.exists;
      });
  }

  Future<void> delete(){
    return reference.delete();
  }
}