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

class UserACQ{
  static const String userACQCollection = "UserACQ";
  static final UserData<UserACQ> firebase = UserData(userACQCollection);

  final String uid;
  final String name;
  final String email;
  final String platform;
  final int visitCount;
  final DateTime created;
  final DateTime settings;
  final DateTime presub;
  final DateTime sub;
 

  UserACQ({
    this.uid,
    this.name,
    this.email,
    this.platform,
    this.visitCount,
    this.created,
    this.settings,
    this.presub,
    this.sub,
  });

  static Future<void> _updateVisitCount(int setTo){return firebase.update({'visits' : setTo ?? 0});}
  static Future<void> _updateSettings(DateTime setTo){return firebase.update({'settings' : setTo ?? null});}
  static Future<void> _updatePreSub(DateTime setTo){return firebase.update({'presub' : setTo ?? null});}
  static Future<void> _updateSub(DateTime setTo){return firebase.update({'sub' : setTo ?? null});}

  static Future<void> setSettings(
    String id,
    String display,
    String email,
  ){
    return firebase.getDocument().then((value){
      if(value.settings == null){
        return _updateSettings(DateTime.now()).then((value){
          return AnalyticsController.sendAnalyticsEvent(
            "Stage 1", 
            {
              'ID' : id,
              'Display Name' : display,
              'Email' : email,
              'Date' : TextHelpers.datetimeToLongString(DateTime.now()),
              'Platform' : Platform.isAndroid ? "Android" : "IOS",
            }
          );
        });
      }
    });
  }

  static Future<void> setPreSub(
    String id,
    String display,
    String email,
  ){
    return firebase.getDocument().then((value){
      if(value.presub == null){
        return _updatePreSub(DateTime.now()).then((value){
          return AnalyticsController.sendAnalyticsEvent(
            "Stage 2", 
            {
              'ID' : id,
              'Display Name' : display,
              'Email' : email,
              'Date' : TextHelpers.datetimeToLongString(DateTime.now()),
              'Platform' : Platform.isAndroid ? "Android" : "IOS",
            }
          );
        });
      }
    });
  }

  static Future<void> setSub(
    String id,
    String display,
    String email,
  ){
    return firebase.getDocument().then((value){
      if(value.sub == null){
        return _updateSub(DateTime.now()).then((value){
          return AnalyticsController.sendAnalyticsEvent(
            "Blastoff", 
            {
              'ID' : id,
              'Display Name' : display,
              'Email' : email,
              'Date' : TextHelpers.datetimeToLongString(DateTime.now()),
              'Platform' : Platform.isAndroid ? "Android" : "IOS",
            }
          );
        });
      }
    });
  }

  static Future<void> updateAddVisitCount(){
    return firebase.getDocument().then((value){
      return _updateVisitCount(value.visitCount + 1);
    });
  }

  factory UserACQ.fromMap(Map data){
    return UserACQ(
      uid: data['uid'] ?? null,
      name: data['name'] ?? null,
      email: data['email'] ?? null,
      platform: data['platform'] ?? null,
      visitCount: data['visits'] ?? 0,
      created: (data['created'] != null) ? ((data['created'] is Timestamp) ? (data['created'] as Timestamp).toDate() : (data['created'] as DateTime)) : DateTime.now(),
      settings: (data['settings'] != null) ? ((data['settings'] is Timestamp) ? (data['settings'] as Timestamp).toDate() : (data['settings'] as DateTime)) : null,
      presub: (data['presub'] != null) ? ((data['presub'] is Timestamp) ? (data['presub'] as Timestamp).toDate() : (data['presub'] as DateTime)) : null,
      sub: (data['sub'] != null) ? ((data['sub'] is Timestamp) ? (data['sub'] as Timestamp).toDate() : (data['sub'] as DateTime)) : null,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid' : this.uid ?? null,
      'name' : this.name ?? null,
      'email' : this.email ?? null,
      'platform' : this.platform ?? null,
      'visits' : this.visitCount ?? 0,
      'created' : this.created ?? DateTime.now(),
      'settings' : this.settings ?? null,
      'presub' : this.presub ?? null,
      'sub' : this.sub ?? null,
    };
  }

}

class UserPoints{
  static const String userPointsCollection = "User Points";
  static final UserData<UserPoints> firebase = UserData(userPointsCollection);

  final String uid;
  final DateTime lastLog;
  final DateTime lastPerfectLog;
  final double lastWeight;
  final int points;
  final int streak;
  final int perfectStreak;
  final int ffCount;
  final int ee3hs;
  final Map<String, bool> unlocks;
  final String lastPhotoURL;

  UserPoints({
    this.uid,
    this.points,
    this.lastLog,
    this.lastPerfectLog,
    this.lastWeight,
    this.ffCount,
    this.streak,
    this.ee3hs,
    this.perfectStreak,
    this.unlocks,
    this.lastPhotoURL,
  });

  static const int listLength = 9;
  static const int lpIndex = 0;
  static const int lwIndex = 1;
  static const int lfIndex = 2;
  static const int pdIndex = 3;
  static const int stkIndex = 4;
  static const int ffbIndex = 5;
  static const int mpdIndex = 6;

  static const int wrkIndex = 7;
  static const int habIndex = 8;

  List<double> getPointModifiers(){
    List<double> pointInfo = List<double>(listLength);

    //Base Points
    pointInfo[lpIndex] = (unlocks[BuiltInSprinkles.redSprinkles.name]) ? 500 : 50;
    pointInfo[lwIndex] = (unlocks[BuiltInSprinkles.greenSprinkles.name]) ? 500 : 50;
    pointInfo[lfIndex] = (unlocks[BuiltInSprinkles.blueSprinkles.name]) ? 500 : 50;
    pointInfo[pdIndex] = (unlocks[BuiltInSprinkles.whiteSprinkles.name]) ? 1000 : 100;
    pointInfo[wrkIndex] = 500;
    pointInfo[habIndex] = 50;

    //With Black Multiplier x100
    pointInfo[lpIndex] *= (unlocks[BuiltInSprinkles.blackSprinkles.name]) ? 100 : 1;
    pointInfo[lwIndex] *= (unlocks[BuiltInSprinkles.blackSprinkles.name]) ? 100 : 1;
    pointInfo[lfIndex] *= (unlocks[BuiltInSprinkles.blackSprinkles.name]) ? 100 : 1;
    pointInfo[pdIndex] *= (unlocks[BuiltInSprinkles.blackSprinkles.name]) ? 100 : 1;
    pointInfo[wrkIndex] *= (unlocks[BuiltInSprinkles.blackSprinkles.name]) ? 100 : 1;
    pointInfo[habIndex] *= (unlocks[BuiltInSprinkles.blackSprinkles.name]) ? 100 : 1;

    //Streak Multiplier
    pointInfo[stkIndex] = streakMult;

    //FF Bonus
    pointInfo[ffbIndex] = ffBonus.toDouble();

    //MPD
    double mpd = pointInfo[lpIndex];
    mpd += pointInfo[lwIndex];
    mpd += pointInfo[lfIndex];
    mpd += pointInfo[pdIndex];
    mpd += pointInfo[wrkIndex];
    mpd += pointInfo[habIndex];

    mpd *= pointInfo[stkIndex];

    mpd *= ffMult;


    pointInfo[mpdIndex] = mpd;

    //checkStreak();

    return pointInfo;
  }

  double get streakMult {
    double mult = 1 + (streak * 0.2);
    if(mult > 5) mult = 5;

    mult *= (unlocks[BuiltInSprinkles.bronzeSprinkles.name]) ? 2 : 1;
    mult *= (unlocks[BuiltInSprinkles.silverSprinkles.name]) ? 2 : 1;
    mult *= (unlocks[BuiltInSprinkles.goldSprinkles.name]) ? 5 : 1;
    mult *= (unlocks[BuiltInSprinkles.diamondSprinkles.name]) ? 5 : 1;
    mult *= (unlocks[BuiltInSprinkles.frenzySprinkles.name]) ? 10 : 1;

    return mult;
  }

  int get ffBonus {
    int mult = 100;

    mult += (unlocks[BuiltInSprinkles.flameSprinkles.name]) ? 100 : 0;
    mult += (unlocks[BuiltInSprinkles.waterSprinkles.name]) ? 300 : 0;
    mult += (unlocks[BuiltInSprinkles.earthSprinkles.name]) ? 800 : 0;
    mult += (unlocks[BuiltInSprinkles.acidSprinkles.name]) ? 2100 : 0;
    mult += (unlocks[BuiltInSprinkles.etherSprinkles.name]) ? 5500 : 0;

    return mult;
  }

  int get ffMult {
    return ffBonus ~/100;
  }

  int _addBonus(int base){
    base *= (unlocks[BuiltInSprinkles.blackSprinkles.name]) ? 100 : 1; //black
    base = (base * streakMult).round(); //streak
    base *= ffMult; //ff bonus
    return base;
  }

  static Future<void> updatePhotoURL(String setTo){return firebase.update({'photo url' : setTo});}
  static Future<void> updateLastWeight(double setTo){return firebase.update({'last weight' : setTo});}

  Future<void> addPointsWorkout(){return firebase.update(
    {
      'points' : _getPointsWorkout(),
      'last log' : Calculations.getTopOfTheMorning(),
    }
  );}
  int _getPointsWorkout(){

    int pts = 500;

    return _addBonus(pts) + points;
  }

  Future<void> addPointsHabit(){return firebase.update(
    {
      'points' : _getPointsHabit(),
      'last log' : Calculations.getTopOfTheMorning(),
    }
  );}
  int _getPointsHabit(){

    int pts = 50;

    return _addBonus(pts) + points;
  }

  Future<void> addPointsLogPicture(){return firebase.update(
    {
      'points' : _getPointsLogPicture(),
      'last log' : Calculations.getTopOfTheMorning(),
      if(daysSinceLastLog() == 1) 'streak' : streak + 1,
      if(streak == 0) 'streak' : 1,
    }
  );}
  int _getPointsLogPicture(){

    int pts = (unlocks[BuiltInSprinkles.redSprinkles.name]) ? 500 : 50; //red

    return _addBonus(pts) + points;
  }

  Future<void> addPointsLogWeight(){return firebase.update(
    {
      'points' : _getPointsLogWeight(),
      'last log' : Calculations.getTopOfTheMorning(),
      if(daysSinceLastLog() == 1) 'streak' : streak + 1,
      if(streak == 0) 'streak' : 1,
    }
  );}
  int _getPointsLogWeight(){

    int pts = (unlocks[BuiltInSprinkles.greenSprinkles.name]) ? 500 : 50; //red

    return _addBonus(pts) + points;
  }

  Future<void> addPointsLogFood(){return firebase.update(
    {
      'points' : _getPointsLogFood(),
      'last log' : Calculations.getTopOfTheMorning(),
      if(daysSinceLastLog() == 1) 'streak' : streak + 1,
      if(streak == 0) 'streak' : 1,
    }
  );}
  int _getPointsLogFood(){

    int pts = (unlocks[BuiltInSprinkles.blueSprinkles.name]) ? 500 : 50; //red

    return _addBonus(pts) + points;
  }

  Future<void> addPointsPerfectDay(String lastPoints){
    int totalPoints = _getPointsPerfectDay();

    switch(lastPoints){
      case "Food": totalPoints += _getPointsLogFood(); break;
      case "Weight": totalPoints += _getPointsLogWeight(); break;
      case "Picture": totalPoints += _getPointsLogPicture(); break;
    }

    return firebase.update(
    {
      'points' : totalPoints,
      'last perfect log' : Calculations.getTopOfTheMorning(),
      if(daysSinceLastPerfectLog() == 1) 'perfect streak' : perfectStreak + 1,
      if(perfectStreak == 0) 'perfect streak' : 1,
      if(perfectStreak != 0 && (perfectStreak % 30 == 0)) 'ff count' : ffCount + 1,
    }
  );}
  int _getPointsPerfectDay(){

    int pts = (unlocks[BuiltInSprinkles.whiteSprinkles.name]) ? 1000 : 100; //red

    return _addBonus(pts);
  }

  Future<void> unlock(String unlock, int cost, bool ffUnlock){
    if(ffUnlock){
      if(cost > ffCount){
        LOG.log("Cannot buy $unlock, you only have $ffCount but need $cost", FoodFrenzyDebugging.crash);
        return null;
      }
    } else {
      if(cost > points){
        LOG.log("Cannot buy $unlock, you only have $points but need $cost", FoodFrenzyDebugging.crash);
        return null;
      }
    }

    return firebase.update(
    {
      if(!ffUnlock) 'points' : points - cost,
      'unlocks' : {
        BuiltInSprinkles.defaultSprinkles.name : true,
        BuiltInSprinkles.redSprinkles.name : (unlock == BuiltInSprinkles.redSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.redSprinkles.name],
        BuiltInSprinkles.greenSprinkles.name : (unlock == BuiltInSprinkles.greenSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.greenSprinkles.name],
        BuiltInSprinkles.blueSprinkles.name : (unlock == BuiltInSprinkles.blueSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.blueSprinkles.name],
        BuiltInSprinkles.whiteSprinkles.name : (unlock == BuiltInSprinkles.whiteSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.whiteSprinkles.name],
        BuiltInSprinkles.blackSprinkles.name : (unlock == BuiltInSprinkles.blackSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.blackSprinkles.name],
        BuiltInSprinkles.americaSprinkles.name : (unlock == BuiltInSprinkles.americaSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.americaSprinkles.name],
        BuiltInSprinkles.spookySprinkles.name : (unlock == BuiltInSprinkles.spookySprinkles.name) ? true : this.unlocks[BuiltInSprinkles.spookySprinkles.name],
        BuiltInSprinkles.holidaySprinkles.name : (unlock == BuiltInSprinkles.holidaySprinkles.name) ? true : this.unlocks[BuiltInSprinkles.holidaySprinkles.name],
        BuiltInSprinkles.bronzeSprinkles.name : (unlock == BuiltInSprinkles.bronzeSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.bronzeSprinkles.name],
        BuiltInSprinkles.silverSprinkles.name : (unlock == BuiltInSprinkles.silverSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.silverSprinkles.name],
        BuiltInSprinkles.goldSprinkles.name : (unlock == BuiltInSprinkles.goldSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.goldSprinkles.name],
        BuiltInSprinkles.diamondSprinkles.name : (unlock == BuiltInSprinkles.diamondSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.diamondSprinkles.name],
        BuiltInSprinkles.frenzySprinkles.name : (unlock == BuiltInSprinkles.frenzySprinkles.name) ? true : this.unlocks[BuiltInSprinkles.frenzySprinkles.name],
        BuiltInSprinkles.mysterySprinkles.name : (unlock == BuiltInSprinkles.mysterySprinkles.name) ? true : this.unlocks[BuiltInSprinkles.mysterySprinkles.name],
        /// FF Challenges
        BuiltInSprinkles.flameSprinkles.name : (unlock == BuiltInSprinkles.flameSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.flameSprinkles.name],
        BuiltInSprinkles.waterSprinkles.name : (unlock == BuiltInSprinkles.waterSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.waterSprinkles.name],
        BuiltInSprinkles.earthSprinkles.name : (unlock == BuiltInSprinkles.earthSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.earthSprinkles.name],
        BuiltInSprinkles.acidSprinkles.name : (unlock == BuiltInSprinkles.acidSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.acidSprinkles.name],
        BuiltInSprinkles.etherSprinkles.name : (unlock == BuiltInSprinkles.etherSprinkles.name) ? true : this.unlocks[BuiltInSprinkles.etherSprinkles.name],
        /// Sprinkle Amounts 
        BuiltInSprinkles.zeroAmount.name : true,
        BuiltInSprinkles.littleAmount.name : (unlock == BuiltInSprinkles.littleAmount.name) ? true : this.unlocks[BuiltInSprinkles.littleAmount.name],
        BuiltInSprinkles.someAmount.name : (unlock == BuiltInSprinkles.someAmount.name) ? true : this.unlocks[BuiltInSprinkles.someAmount.name],
        BuiltInSprinkles.defaultAmount.name : true,
        BuiltInSprinkles.lotsAmount.name : (unlock == BuiltInSprinkles.lotsAmount.name) ? true : this.unlocks[BuiltInSprinkles.lotsAmount.name],
        BuiltInSprinkles.tonAmount.name : (unlock == BuiltInSprinkles.tonAmount.name) ? true : this.unlocks[BuiltInSprinkles.tonAmount.name],
        BuiltInSprinkles.allAmount.name : (unlock == BuiltInSprinkles.allAmount.name) ? true : this.unlocks[BuiltInSprinkles.allAmount.name],
      },
    });
  }

  static Future<void> handlePoints(UserLog log, int type) async{
    UserPoints points = await UserPoints.firebase.getDocument();
    bool logged = log.didLog;
    bool weighed = log.weight != null;
    bool shot = log.photoURL != null;

    switch(type){
      case lpIndex: //shot
        // if(weighed && logged) return points.addPointsPerfectDay("Picture");
        return points.addPointsLogPicture();
      case lwIndex: //weighed
        if(logged) return points.addPointsPerfectDay("Weight");
        return points.addPointsLogWeight();
      case lfIndex: //logged
        if(weighed) return points.addPointsPerfectDay("Food");
        return points.addPointsLogFood();
      default: return null;
    }
  }

  Future<void> clearStreak(){return firebase.update(
    {
      'streak' : 0,
      'perfect streak' : 0,
    }
  );}
  int daysSinceLastLog(){
    if(lastLog == null){
      return -1;
    }

    return (DateTime.now().difference(lastLog).inDays.abs());
  }
  int daysSinceLastPerfectLog(){
    if(lastPerfectLog == null){
      return -1;
    }

    return (DateTime.now().difference(lastPerfectLog).inDays.abs());
  }

  static Map<String, bool> _fireUnlockToMap(Map<String, dynamic> map){
    Map<String, bool> temp = Map<String, bool>();

    if(map == null){
      return {
        BuiltInSprinkles.defaultSprinkles.name : true,
        BuiltInSprinkles.redSprinkles.name : false,
        BuiltInSprinkles.greenSprinkles.name : false,
        BuiltInSprinkles.blueSprinkles.name : false,
        BuiltInSprinkles.whiteSprinkles.name : false,
        BuiltInSprinkles.blackSprinkles.name : false,
        BuiltInSprinkles.americaSprinkles.name : false,
        BuiltInSprinkles.spookySprinkles.name : false,
        BuiltInSprinkles.holidaySprinkles.name : false,
        BuiltInSprinkles.bronzeSprinkles.name : false,
        BuiltInSprinkles.silverSprinkles.name : false,
        BuiltInSprinkles.goldSprinkles.name : false,
        BuiltInSprinkles.diamondSprinkles.name : false,
        BuiltInSprinkles.frenzySprinkles.name : false,
        BuiltInSprinkles.mysterySprinkles.name : false,
        /// FF Challenges
        BuiltInSprinkles.flameSprinkles.name : false,
        BuiltInSprinkles.waterSprinkles.name : false,
        BuiltInSprinkles.earthSprinkles.name : false,
        BuiltInSprinkles.acidSprinkles.name : false,
        BuiltInSprinkles.etherSprinkles.name : false,
        /// Sprinkle Amounts 
        BuiltInSprinkles.zeroAmount.name : true,
        BuiltInSprinkles.littleAmount.name : false,
        BuiltInSprinkles.someAmount.name : false,
        BuiltInSprinkles.defaultAmount.name : true,
        BuiltInSprinkles.lotsAmount.name : false,
        BuiltInSprinkles.tonAmount.name : false,
        BuiltInSprinkles.allAmount.name : false,
      };
    }

    map.keys.forEach((key) {
      temp[key] = (map[key] is bool) ? map[key] : false;
    });

    return temp;
  }

  Future<void> updateEE3HS(int setTo){return firebase.update({'ee3hs' : setTo ?? this.ee3hs});}

  factory UserPoints.fromMap(Map data){
    return UserPoints(
      uid: data['uid'] ?? "",
      points: data['points'] ?? 0,
      lastLog: (data['last log'] != null) ? ((data['last log'] is Timestamp) ? (data['last log'] as Timestamp).toDate() : (data['last log'] as DateTime)) : DateTime(1995),
      lastPerfectLog: (data['last perfect log'] != null) ? ((data['last perfect log'] is Timestamp) ? (data['last perfect log'] as Timestamp).toDate() : (data['last perfect log'] as DateTime)) : DateTime(1995),
      lastWeight: (data['last weight'] != null) ? ((data['last weight'] is int) ? (data['last weight'].toDouble()) : (data['last weight'])) : 0,
      streak: data['streak'] ?? 0,
      perfectStreak: data['perfect streak'] ?? 0,
      ffCount: data['ff count'] ?? 0,
      ee3hs: data['ee3hs'] ?? -1,
      lastPhotoURL: data['photo url'] ?? "",
      unlocks: _fireUnlockToMap(data['unlocks']),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid' : this.uid ?? "",
      'points' : this.points ?? 0,
      'last log' : this.lastLog ?? DateTime(1995),
      'last perfect log' : this.lastPerfectLog ?? DateTime(1995),
      'last weight' : this.lastWeight ?? -1,
      'streak' : this.streak ?? 0,
      'perfect streak' : this.perfectStreak ?? 0,
      'ff count' : this.ffCount ?? 0,
      'ee3hs' : this.ee3hs ?? -1,
      'photo url' : this.lastPhotoURL ?? "",
      'unlocks' : {
        BuiltInSprinkles.defaultSprinkles.name : true,
        BuiltInSprinkles.redSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.redSprinkles.name] : false,
        BuiltInSprinkles.greenSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.greenSprinkles.name] : false,
        BuiltInSprinkles.blueSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.blueSprinkles.name] : false,
        BuiltInSprinkles.whiteSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.whiteSprinkles.name] : false,
        BuiltInSprinkles.blackSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.blackSprinkles.name] : false,
        BuiltInSprinkles.holidaySprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.holidaySprinkles.name] : false,
        BuiltInSprinkles.spookySprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.spookySprinkles.name] : false,
        BuiltInSprinkles.americaSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.americaSprinkles.name] : false,
        BuiltInSprinkles.bronzeSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.bronzeSprinkles.name] : false,
        BuiltInSprinkles.silverSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.silverSprinkles.name] : false,
        BuiltInSprinkles.goldSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.goldSprinkles.name] : false,
        BuiltInSprinkles.diamondSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.diamondSprinkles.name] : false,
        BuiltInSprinkles.frenzySprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.frenzySprinkles.name] : false,
        BuiltInSprinkles.mysterySprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.mysterySprinkles.name] : false,
        /// FF Challenges
        BuiltInSprinkles.flameSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.flameSprinkles.name] : false,
        BuiltInSprinkles.waterSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.waterSprinkles.name] : false,
        BuiltInSprinkles.earthSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.earthSprinkles.name] : false,
        BuiltInSprinkles.acidSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.acidSprinkles.name] : false,
        BuiltInSprinkles.etherSprinkles.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.etherSprinkles.name] : false,
        /// Sprinkle Amounts 
        BuiltInSprinkles.zeroAmount.name : true,
        BuiltInSprinkles.littleAmount.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.littleAmount.name] : false,
        BuiltInSprinkles.someAmount.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.someAmount.name] : false,
        BuiltInSprinkles.defaultAmount.name : true,
        BuiltInSprinkles.lotsAmount.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.lotsAmount.name] : false,
        BuiltInSprinkles.tonAmount.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.tonAmount.name] : false,
        BuiltInSprinkles.allAmount.name : (this.unlocks != null) ? this.unlocks[BuiltInSprinkles.allAmount.name] : false,
      },
    };
  }

}

class UserLog{
  static final UserData<UserLog> firebase = UserData(userLogCollection);
  static const String userLogCollection = "User Log";

  DateTime date;
  String uid;
  bool didLog;
  bool didLogHabit;
  bool naughtyLog;
  bool didFast;
  double weight; //in lbs
  String photoURL; 
  String habit;
  List<List<Ingredient>> food;
  List<DrawingPointsData> signature;
  List<Workout> workouts;
  // List<String> workoutUid;

  DateTime weightTimestamp;
  DateTime photoTimestamp;
  DateTime habitTimestamp;

  UserLog({
    this.uid,
    this.date,
    this.didLog,
    this.didLogHabit,
    this.naughtyLog,
    this.didFast,
    this.weight,
    this.photoURL,
    this.habit,
    this.food,
    this.signature,
    // this.workoutUid,
    this.workouts,

    this.weightTimestamp,
    this.photoTimestamp,
    this.habitTimestamp,
  });

  int get totalTrad {
    int count = 0;
    for(Workout workout in this.workouts){
      if(workout.type == Workout.traditionalType)
        count++;
    }

    return count;
  }

  double get totalActiveTime {
    double time = 0;
    for(Workout workout in this.workouts){
      time += workout.logDuration;
    }

    return time;
  }

  double get totalCardioActiveTime {
    double time = 0;
    for(Workout workout in this.workouts){
      if(workout.type != Workout.traditionalType)
        time += workout.logDuration;
    }

    return time;
  }

  double get totalActiveCals {
    double cals = 0;
    for(Workout workout in this.workouts){
      if(workout.logCals != -1)
        cals += workout.logCals;
    }

    return cals;
  }

  bool get hasFoodInLog {
    for (var meal in food) {
      for (var ingredient in meal) {
        return true;
      }
    }

    return false;
  }

  double get totalNA {
    double na = 0;

    if(didFast) return 0;

    for (var meal in food) {
      for (var ingredient in meal) {
        if(ingredient.ss != 0) na += ingredient.bananas;
      }
    }
    return na;
  }

  double get totalFib {
    double fib = 0;

    if(didFast) return 0;

    for (var meal in food) {
      for (var ingredient in meal) {
        if(ingredient.ss != 0) fib += ingredient.fibers;
      }
    }
    return fib;
  }

  double get totalSugar {
    double sugar = 0;

    if(didFast) return 0;

    for (var meal in food) {
      for (var ingredient in meal) {
        if(ingredient.ss != 0) sugar += ingredient.sugars;
      }
    }
    return sugar;
  }

  int get totalMeals {
    int meals  = 0;

    if(didFast) return 1;

    for (var meal in food) {
      if(meal.isNotEmpty) meals++;
    }
    return meals;
  }

  double get totalCal {
    double cal = 0;

    if(didFast) return 0;

    for (var meal in food) {
      for (var ingredient in meal) {
        if(ingredient.ss != 0 && ingredient.name != null) cal += ingredient.cals;
      }
    }
    return cal;
  }

  double get totalFat {
    double fat = 0;

    if(didFast) return 0;

    for (var meal in food) {
      for (var ingredient in meal) {
        if(ingredient.ss != 0) fat += ingredient.fats;
      }
    }
    return fat;
  }

  double get totalCarb {
    double carb = 0;

    if(didFast) return 0;

    for (var meal in food) {
      for (var ingredient in meal) {
        if(ingredient.ss != 0) carb += ingredient.carbs();
      }
    }
    return carb;
  }

  double get totalProt {
    double prot = 0;

    if(didFast) return 0;

    for (var meal in food) {
      for (var ingredient in meal) {
        if(ingredient.ss != 0) prot += ingredient.prots;
      }
    }
    return prot;
  }

  static UserLog getBlankLog(){
    return UserLog.fromMap({});
  }

  static UserLog getBlankDateLog(DateTime date){
    return UserLog.fromMap(UserLog(date: date).toMap());
  }

  static Future<UserLog> getTodaysLog(){
    return firebase.getTodaysDocument(getBlankLog().toMap());
  }

  static Future<UserLog> getLogFromDate(DateTime date, {bool shouldCreate = false}){
    return firebase.getDocumentFromDate(date, newDocument: getBlankDateLog(Calculations.getTopOfTheMorning(day: date)).toMap(), shouldCreate: shouldCreate);
  }

  static Future<List<UserLog>> getThisMonthsLog({DateTime day, String uid}){
    if(day == null) day = DateTime.now();

    return firebase.getDocumentsInRange(
      Calculations.getTopOfTheMonth(day: day), 
      Calculations.getEndOfTheMonth(day: day),
      uid: uid
    );
  }

  //Check Marks
  static Future<void> updateTodaysPhotoURL(String setTo){return firebase.updateTodaysDocument({'photo url' : setTo, 'photoTimestamp' : DateTime.now()});}
  static Future<void> updateTodaysWeight(double setTo){return firebase.updateTodaysDocument({'weight' : setTo, 'weightTimestamp' : DateTime.now()});}
  static Future<void> updateTodaysDidLog(bool setTo){return firebase.updateTodaysDocument({'did log' : setTo});}
  static Future<void> updateTodaysDidLogHabit(bool setTo){return firebase.updateTodaysDocument({'did log habit' : setTo, 'habitTimestamp' : DateTime.now()});}
  static Future<void> updateTodaysNaughtyLog(bool setTo){return firebase.updateTodaysDocument({'naughty log' : setTo});}

  //timestamps
  static Future<void> updateTodaysWeightTimestamp(){return firebase.updateTodaysDocument({'weightTimestamp' : DateTime.now()});}
  static Future<void> updateTodaysPhotoTimestamp(){return firebase.updateTodaysDocument({'photoTimestamp' : DateTime.now()});}
  static Future<void> updateTodaysHabitTimestamp(){return firebase.updateTodaysDocument({'habitTimestamp' : DateTime.now()});}


  //Save Signiture
  static Future<void> updateSignature(List<DrawingPointsData> setTo, String habit){
    return firebase.updateTodaysDocument(
      {
        'habit' : habit,
        'habitTimestamp' : DateTime.now(),
        'signature' : [
          for(DrawingPointsData point in setTo) (point == null) ? null : point.toMap(),
        ]
      }
    );
  }

  //Save Workout
  static Future<void> addWorkoutToLog(Workout setTo){
    return getTodaysLog().then((log){

      log.workouts.removeWhere((workout){
        return workout.uid == setTo.uid;
      });

      log.workouts.add(setTo);

      firebase.updateTodaysDocument(
        {
          'workouts' : [
            for(Workout workout in log.workouts) workout.toMap(),
          ]
        }
      );
    });
  }

  //Save Workout
  static Future<void> addWorkoutToPreviousLog(Workout setTo, DateTime date){
    return getLogFromDate(date, shouldCreate: true).then((log){

      if(log == null){
        LOG.log("No log found", FoodFrenzyDebugging.crash);
        return;
      }

      log.workouts.removeWhere((workout){
        return workout.uid == setTo.uid;
      });

      log.workouts.add(setTo);

      firebase.updateDocumentFromDate(
        date,
        {
          'workouts' : [
            for(Workout workout in log.workouts) workout.toMap(),
          ]
        }
      );
    });
  }


  //Add In Ingredients
  static Future<void> updateTodaysDidFast(bool setTo){return firebase.updateTodaysDocument({'did fast' : setTo});}
  static Future<void> updateTodaysFood(List<List<Ingredient>> setTo){return firebase.updateTodaysDocument(_foodLogToFirebase(setTo));}

  static Map<dynamic, dynamic> _foodLogToFirebase(List<List<Ingredient>> setTo){
    return {
      'food 0' : [if(setTo[0] != null) for(var ingredient in setTo[0]) ingredient.toMap()],
      'food 1' : [if(setTo[1] != null) for(var ingredient in setTo[1]) ingredient.toMap()],
      'food 2' : [if(setTo[2] != null) for(var ingredient in setTo[2]) ingredient.toMap()],
      'food 3' : [if(setTo[3] != null) for(var ingredient in setTo[3]) ingredient.toMap()],
      'food 4' : [if(setTo[4] != null) for(var ingredient in setTo[4]) ingredient.toMap()],
      'food 5' : [if(setTo[5] != null) for(var ingredient in setTo[5]) ingredient.toMap()],
      'food 6' : [if(setTo[6] != null) for(var ingredient in setTo[6]) ingredient.toMap()],
      'food 7' : [if(setTo[7] != null) for(var ingredient in setTo[7]) ingredient.toMap()],
      'food 8' : [if(setTo[8] != null) for(var ingredient in setTo[8]) ingredient.toMap()],
      'food 9' : [if(setTo[9] != null) for(var ingredient in setTo[9]) ingredient.toMap()],
      'food 10' : [if(setTo[10] != null) for(var ingredient in setTo[10]) ingredient.toMap()],
      'food 11' : [if(setTo[11] != null) for(var ingredient in setTo[11]) ingredient.toMap()],
      'food 12' : [if(setTo[12] != null) for(var ingredient in setTo[12]) ingredient.toMap()],
      'food 13' : [if(setTo[13] != null) for(var ingredient in setTo[13]) ingredient.toMap()],
      'food 14' : [if(setTo[14] != null) for(var ingredient in setTo[14]) ingredient.toMap()],
      'food 15' : [if(setTo[15] != null) for(var ingredient in setTo[15]) ingredient.toMap()],
      'food 16' : [if(setTo[16] != null) for(var ingredient in setTo[16]) ingredient.toMap()],
      'food 17' : [if(setTo[17] != null) for(var ingredient in setTo[17]) ingredient.toMap()],
      'food 18' : [if(setTo[18] != null) for(var ingredient in setTo[18]) ingredient.toMap()],
      'food 19' : [if(setTo[19] != null) for(var ingredient in setTo[19]) ingredient.toMap()],
      'food 20' : [if(setTo[20] != null) for(var ingredient in setTo[20]) ingredient.toMap()],
      'food 21' : [if(setTo[21] != null) for(var ingredient in setTo[21]) ingredient.toMap()],
      'food 22' : [if(setTo[22] != null) for(var ingredient in setTo[22]) ingredient.toMap()],
      'food 23' : [if(setTo[23] != null) for(var ingredient in setTo[23]) ingredient.toMap()],
    };
  }

  factory UserLog.fromMap(Map data){
    DateTime date = (data['date'] != null) ? ((data['date'] is Timestamp) ? (data['date'] as Timestamp).toDate() : (data['date'] as DateTime)) : Calculations.getTopOfTheMorning();

    return UserLog(
      uid: data['uid'],
      date: date,
      didLog: data['did log'] ?? false,
      didLogHabit: data['did log habit'] ?? false,
      didFast: data['did fast'] ?? false,
      naughtyLog: data['naughty log'] ?? false,
      weight: data['weight'],
      photoURL: data['photo url'],
      habit: data['habit'],
      signature: [if(data['signature'] != null) for(var sig in data['signature']) DrawingPointsData.fromMap(sig)],
      // workoutUid: [if(data['workoutUID'] != null) for(String uid in data['workoutUID']) uid],
      workouts: [if(data['workouts'] != null) for(var workout in data['workouts']) Workout.fromMap(workout)],
      // workouts: [],
      weightTimestamp: (data['weightTimestamp'] != null) ? ((data['weightTimestamp'] is Timestamp) ? (data['weightTimestamp'] as Timestamp).toDate() : (data['weightTimestamp'] as DateTime)) : Calculations.getTopOfTheMorning(day: date),
      photoTimestamp: (data['photoTimestamp'] != null) ? ((data['photoTimestamp'] is Timestamp) ? (data['photoTimestamp'] as Timestamp).toDate() : (data['photoTimestamp'] as DateTime)) : Calculations.getTopOfTheMorning(day: date),
      habitTimestamp: (data['habitTimestamp'] != null) ? ((data['habitTimestamp'] is Timestamp) ? (data['habitTimestamp'] as Timestamp).toDate() : (data['habitTimestamp'] as DateTime)) : Calculations.getTopOfTheMorning(day: date),
      food: [
        [if(data["food 0"] != null) for(var ingredient in data["food 0"]) Ingredient.fromMap(ingredient)],
        [if(data["food 1"] != null) for(var ingredient in data["food 1"]) Ingredient.fromMap(ingredient)],
        [if(data["food 2"] != null) for(var ingredient in data["food 2"]) Ingredient.fromMap(ingredient)],
        [if(data["food 3"] != null) for(var ingredient in data["food 3"]) Ingredient.fromMap(ingredient)],
        [if(data["food 4"] != null) for(var ingredient in data["food 4"]) Ingredient.fromMap(ingredient)],
        [if(data["food 5"] != null) for(var ingredient in data["food 5"]) Ingredient.fromMap(ingredient)],
        [if(data["food 6"] != null) for(var ingredient in data["food 6"]) Ingredient.fromMap(ingredient)],
        [if(data["food 7"] != null) for(var ingredient in data["food 7"]) Ingredient.fromMap(ingredient)],
        [if(data["food 8"] != null) for(var ingredient in data["food 8"]) Ingredient.fromMap(ingredient)],
        [if(data["food 9"] != null) for(var ingredient in data["food 9"]) Ingredient.fromMap(ingredient)],
        [if(data["food 10"] != null) for(var ingredient in data["food 10"]) Ingredient.fromMap(ingredient)],
        [if(data["food 11"] != null) for(var ingredient in data["food 11"]) Ingredient.fromMap(ingredient)],
        [if(data["food 12"] != null) for(var ingredient in data["food 12"]) Ingredient.fromMap(ingredient)],
        [if(data["food 13"] != null) for(var ingredient in data["food 13"]) Ingredient.fromMap(ingredient)],
        [if(data["food 14"] != null) for(var ingredient in data["food 14"]) Ingredient.fromMap(ingredient)],
        [if(data["food 15"] != null) for(var ingredient in data["food 15"]) Ingredient.fromMap(ingredient)],
        [if(data["food 16"] != null) for(var ingredient in data["food 16"]) Ingredient.fromMap(ingredient)],
        [if(data["food 17"] != null) for(var ingredient in data["food 17"]) Ingredient.fromMap(ingredient)],
        [if(data["food 18"] != null) for(var ingredient in data["food 18"]) Ingredient.fromMap(ingredient)],
        [if(data["food 19"] != null) for(var ingredient in data["food 19"]) Ingredient.fromMap(ingredient)],
        [if(data["food 20"] != null) for(var ingredient in data["food 20"]) Ingredient.fromMap(ingredient)],
        [if(data["food 21"] != null) for(var ingredient in data["food 21"]) Ingredient.fromMap(ingredient)],
        [if(data["food 22"] != null) for(var ingredient in data["food 22"]) Ingredient.fromMap(ingredient)],
        [if(data["food 23"] != null) for(var ingredient in data["food 23"]) Ingredient.fromMap(ingredient)],
      ]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid' : this.uid ?? "ERROR",
      'date' : this.date ?? Calculations.getTopOfTheMorning(),
      'did log' : this.didLog ?? false,
      'did log habit' : this.didLogHabit ?? false,
      'naughty log' : this.naughtyLog ?? false,
      'weight' : this.weight,
      'photo url' : this.photoURL,
      'did fast' : this.didFast ?? false,
      'habit' : this.habit,
      'weightTimestamp' : this.weightTimestamp ?? Calculations.getTopOfTheMorning(),
      'photoTimestamp' : this.photoTimestamp ?? Calculations.getTopOfTheMorning(),
      'habitTimestamp' : this.habitTimestamp ?? Calculations.getTopOfTheMorning(),
      'signature': [if(this.signature != null) for(DrawingPointsData point in this.signature) point.toMap()],
      // 'workoutUID': [if(this.workoutUid != null) for(String uid in this.workoutUid) uid],
      'workouts': [if(this.workouts != null) for(var workout in this.workouts) workout.toMap()],
      'food 0' : [if(this.food != null) if(this.food[0] != null) for(var ingredient in this.food[0]) ingredient.toMap()],
      'food 1' : [if(this.food != null) if(this.food[1] != null) for(var ingredient in this.food[1]) ingredient.toMap()],
      'food 2' : [if(this.food != null) if(this.food[2] != null) for(var ingredient in this.food[2]) ingredient.toMap()],
      'food 3' : [if(this.food != null) if(this.food[3] != null) for(var ingredient in this.food[3]) ingredient.toMap()],
      'food 4' : [if(this.food != null) if(this.food[4] != null) for(var ingredient in this.food[4]) ingredient.toMap()],
      'food 5' : [if(this.food != null) if(this.food[5] != null) for(var ingredient in this.food[5]) ingredient.toMap()],
      'food 6' : [if(this.food != null) if(this.food[6] != null) for(var ingredient in this.food[6]) ingredient.toMap()],
      'food 7' : [if(this.food != null) if(this.food[7] != null) for(var ingredient in this.food[7]) ingredient.toMap()],
      'food 8' : [if(this.food != null) if(this.food[8] != null) for(var ingredient in this.food[8]) ingredient.toMap()],
      'food 9' : [if(this.food != null) if(this.food[9] != null) for(var ingredient in this.food[9]) ingredient.toMap()],
      'food 10' : [if(this.food != null) if(this.food[10] != null) for(var ingredient in this.food[10]) ingredient.toMap()],
      'food 11' : [if(this.food != null) if(this.food[11] != null) for(var ingredient in this.food[11]) ingredient.toMap()],
      'food 12' : [if(this.food != null) if(this.food[12] != null) for(var ingredient in this.food[12]) ingredient.toMap()],
      'food 13' : [if(this.food != null) if(this.food[13] != null) for(var ingredient in this.food[13]) ingredient.toMap()],
      'food 14' : [if(this.food != null) if(this.food[14] != null) for(var ingredient in this.food[14]) ingredient.toMap()],
      'food 15' : [if(this.food != null) if(this.food[15] != null) for(var ingredient in this.food[15]) ingredient.toMap()],
      'food 16' : [if(this.food != null) if(this.food[16] != null) for(var ingredient in this.food[16]) ingredient.toMap()],
      'food 17' : [if(this.food != null) if(this.food[17] != null) for(var ingredient in this.food[17]) ingredient.toMap()],
      'food 18' : [if(this.food != null) if(this.food[18] != null) for(var ingredient in this.food[18]) ingredient.toMap()],
      'food 19' : [if(this.food != null) if(this.food[19] != null) for(var ingredient in this.food[19]) ingredient.toMap()],
      'food 20' : [if(this.food != null) if(this.food[20] != null) for(var ingredient in this.food[20]) ingredient.toMap()],
      'food 21' : [if(this.food != null) if(this.food[21] != null) for(var ingredient in this.food[21]) ingredient.toMap()],
      'food 22' : [if(this.food != null) if(this.food[22] != null) for(var ingredient in this.food[22]) ingredient.toMap()],
      'food 23' : [if(this.food != null) if(this.food[23] != null) for(var ingredient in this.food[23]) ingredient.toMap()],
    };
  }

}

class UserCommonIngredients{
  static final UserData<UserCommonIngredients> firebase = UserData(userCommonIngeredientCollection);
  static const String userCommonIngeredientCollection = "User Common Ingredient";

  Map<String, Ingredient> database = Map<String, Ingredient>();

  UserCommonIngredients.fromMap(Map data){
    data.forEach((key, value){
      database[key] = Ingredient.fromMap(value);
    });
  }

  UserCommonIngredients();

  static Future<void> removeIngredient(Ingredient ingredient){
    return firebase.update(
      {
        ((ingredient.upc != '') ? ingredient.upc : ingredient.name) : FieldValue.delete()
      }
    );
  }

  static Future<void> updateIngredient(Ingredient ingredient){
    return firebase.update(
      {
        ((ingredient.upc != '') ? ingredient.upc : ingredient.name) : Ingredient.toUserIngredient(ingredient).toMap()
      }
    );
  }

  Map<String, dynamic> toMap(){

    return {
      if(database.length != 0)
        for(int i = 0; i < database.length; i++) 
          '${database.keys.elementAt(i)}' : database[database.keys.elementAt(i)].toMap()
    };
  }

}

class UserLogEntries{
  static final UserData<UserLogEntries> firebase = UserData(userLogEntriesCollection);
  static const String userLogEntriesCollection = "User Log Entries";

  List<Ingredient> otherMeal;
  List<Ingredient> addFood;
  List<Ingredient> alcohol;
  List<Ingredient> foodEstimator;
  Ingredient quickAdd;

  UserLogEntries({
    this.otherMeal,
    this.addFood,
    this.alcohol,
    this.foodEstimator,
    this.quickAdd,
  });

  factory UserLogEntries.fromMap(Map data){
    return UserLogEntries(
      otherMeal: [if(data["other meal"] != null) for(var ingredient in data["other meal"]) Ingredient.fromMap(ingredient)],
      addFood: [if(data["add food"] != null) for(var ingredient in data["add food"]) Ingredient.fromMap(ingredient)],
      alcohol: [if(data["alcohol"] != null) for(var ingredient in data["alcohol"]) Ingredient.fromMap(ingredient)],
      foodEstimator: [if(data["food estimator"] != null) for(var ingredient in data["food estimator"]) Ingredient.fromMap(ingredient)],
      quickAdd: Ingredient.fromMap((data['quick add'] != null) ? data['quick add'] : {})
    );
  }

  static Future<void> updateOtherMeal(List<Ingredient> ingredients){
    return firebase.update(
      {
        'other meal' : [if(ingredients != null) for(var ingredient in ingredients) ingredient.toMap()]
      }
    );
  }

  static Future<void> updateAddFood(List<Ingredient> ingredients){
    return firebase.update(
      {
        'add food' : [if(ingredients != null) for(var ingredient in ingredients) ingredient.toMap()]
      }
    );
  }

  static Future<void> updateAlcohol(List<Ingredient> ingredients){
    return firebase.update(
      {
        'alcohol' : [if(ingredients != null) for(var ingredient in ingredients) ingredient.toMap()]
      }
    );
  }

  static Future<void> updateFoodEsimator(List<Ingredient> ingredients){
    return firebase.update(
      {
        'food estimator' : [if(ingredients != null) for(var ingredient in ingredients) ingredient.toMap()]
      }
    );
  }

  static Future<void> updateQuickAdd(Ingredient ingredient){
    return firebase.update(
      {
        'quick add' : (ingredient != null) ? ingredient.toMap() : Ingredient().toMap(),
      }
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'other meal' : [if(this.otherMeal != null) for(var ingredient in this.otherMeal) ingredient.toMap()],
      'add food' : [if(this.addFood != null) for(var ingredient in this.addFood) ingredient.toMap()],
      'alcohol' : [if(this.alcohol != null) for(var ingredient in this.alcohol) ingredient.toMap()],
      'food estimator' : [if(this.foodEstimator != null) for(var ingredient in this.foodEstimator) ingredient.toMap()],
      'quick add' : (this.quickAdd != null) ? this.quickAdd.toMap() : Ingredient().toMap(),
    };
  }

}

class UserHabits{
  static final UserData<UserHabits> firebase = UserData(userHabitsCollection);
  static const String userHabitsCollection = "User Habits";

  Map<String, List<DateTime>> log;
  // List<DrawingPoints

  UserHabits({
    this.log,
  });

  Future<void> updateHabit(){
    return firebase.upsert(this.toMap(), merge: false);
  }

  factory UserHabits.fromMap(Map data){
    return UserHabits(
      log : {
        if(data != null)
          for(String key in data.keys) key : [
            for(Timestamp date in data[key]) Calculations.getTopOfTheMorning(day: date.toDate()),
          ]
      }
    );
  }


  Map<String, dynamic> toMap(){
    return {
      for(String key in log.keys) key : [
        for(DateTime date in log[key]) date,
      ]
    };
  }

}

class UserState{
  static final UserData<UserState> firebase = UserData(userGeneralCollection);
  static const String userGeneralCollection = "User General";

  String uid;

  //One time flag
  bool isNew;
  bool showWB;
  bool showMP;
  bool showAM;
  bool convertAlc;

  //New Day Tracking
  DateTime lastSeen;

  //Settings
  DateTime birthday;
  double height; //always stored as cm
  bool isFemale;
  bool prefersMetric; //is set when weight is selected
  bool prefersSoundOn;

  //Stats Settings
  DateTime startDate;
  DateTime endDate;
  double goalWeight;
  bool rollingDate;
  int rollingDuration; //90Days

  //Sprinkles
  String selectedSprinkles;
  String selectedSprinklesAmount;

  //Tracking
  DateTime lastPhotoDate;
  double lastWeight;
  String currentHabit;

  //Meals
  // List<String> meals;

  //Workouts
  // List<String> workouts;

  //Accountabilibuddy
  Map<String, String> accountabilibuddies;
  List<String> canSeePhotos;
  num publicLevel;

  //Goals
  String split;
  String activityLevel;
  double planningChange;
  double planningWeight; //always stored as kg 

  double planningFat;
  double planningCarb;
  double planningProt;

  double cal;
  double fat;
  double carb;
  double prot;

  DateTime lastFreeMeal;
  num freeMealFrequency;

  //CHEAT CODES
  String cc;

  double get age => (birthday.difference(DateTime.now()).inDays / 365).abs();

  String get sprinkles => BuiltInSprinkles.checkSprinklesName(selectedSprinkles);
  String get sprinklesAmount => BuiltInSprinkles.checkSprinklesAmountName(selectedSprinklesAmount);

  Future<void> updateIsNew(bool setTo){return firebase.update({'is new' : setTo ?? false});}
  Future<void> updateShowWB(bool setTo){return firebase.update({'show workout builder' : setTo ?? false});}
  Future<void> updateShowMP(bool setTo){return firebase.update({'show meal prepper' : setTo ?? false});}
  Future<void> updateShowAM(bool setTo){return firebase.update({'show advanced metrics' : setTo ?? false});}
  Future<void> updateConvertAlc(bool setTo){return firebase.update({'convert alcohol to carbs' : setTo ?? false});}

  Future<void> updateLastSeen(DateTime setTo){return firebase.update({'last seen' : setTo ?? this.lastSeen});}

  Future<void> updateSelectedSprinkles(String setTo){return firebase.update({'selected sprinkles' : setTo ?? this.selectedSprinkles});}
  Future<void> updateSelectedSprinklesAmount(String setTo){return firebase.update({'selected sprinkles amount' : setTo ?? this.selectedSprinklesAmount});}
  Future<void> updateBirthday(DateTime setTo){return firebase.update({'birthday' : setTo ?? this.birthday});}
  Future<void> updateHeight(double setTo){return firebase.update({'height' : setTo ?? this.height});}
  Future<void> updateIsFemale(bool setTo){return firebase.update({'is female' : setTo ?? this.isFemale});}
  Future<void> updatePrefersMetric(bool setTo){return firebase.update({'prefers metric' : setTo ?? this.prefersMetric});}
  Future<void> updatePrefersSoundOn(bool setTo){return firebase.update({'prefers sound on' : setTo ?? this.prefersSoundOn});}

  Future<void> updateStartDate(DateTime setTo){return firebase.update({'start date' : setTo ?? this.startDate});}
  Future<void> updateEndDate(DateTime setTo){return firebase.update({'end date' : setTo ?? this.endDate});}
  Future<void> updateGoalWeight(double setTo){return firebase.update({'goal weight' : setTo ?? this.goalWeight});}
  Future<void> updateRollingDate(bool setTo){return firebase.update({'use rolling date' : setTo ?? true});}
  Future<void> updateRollingDuration(double setTo){return firebase.update({'rolling duration' : setTo ?? this.rollingDuration});}


  Future<void> updateCurrentHabit(String setTo){return firebase.update({'current habit' : setTo ?? this.currentHabit});}
  Future<void> updateLastPhotoDate({DateTime setTo}){return firebase.update({'last photo date' : setTo ?? Calculations.getTopOfTheMorning()});}
  Future<void> updateLastWeight(double setTo){return firebase.update({'last weight' : setTo ?? this.lastWeight});}
  Future<void> updateLastPerfectDay(DateTime setTo){return firebase.update({'last perfect day' : setTo});}

  Future<void> updateMeals(List<String> setTo){return firebase.update({'meals' : [for(var meal in setTo) meal]});}

  Future<void> updateWorkouts(List<String> setTo){return firebase.update({'workouts' : [for(var workout in setTo) workout]});}

  Future<void> addAccountabilibuddy(String uid){
    this.accountabilibuddies[uid] = "Buddy ${uid.substring(0, 5)}";

    return firebase.update({
      'accountabilibuddies' : this.accountabilibuddies,
    });
  }

  Future<void> removeAccountabilibuddy(String uid){
    this.accountabilibuddies.remove(uid);
    this.canSeePhotos.remove(uid);

    return firebase.update({
      'accountabilibuddies' : this.accountabilibuddies,
      'canseephotos' : [for(String uid in this.canSeePhotos) uid],
    });
  }

  Future<void> setAccountabilibuddies(Map<String, String> setTo){return firebase.update({'accountabilibuddies' : setTo});}
  Future<void> updateAccountabilibuddies(){return firebase.update({'accountabilibuddies' : this.accountabilibuddies});}

  Future<void> setCanSeePhotos(List<String> setTo){return firebase.update({'canseephotos' : [for(String uid in setTo) uid]});}
  Future<void> updateCanSeePhotos(){return firebase.update({'canseephotos' : (this.canSeePhotos != null) ? [for(String uid in this.canSeePhotos) uid] : []});}

  Future<void> updatePublicLevel(num setTo){return firebase.update({'publiclevel' : setTo ?? this.publicLevel});}

  Future<void> updateSplit(String setTo){return firebase.update({'split' : setTo ?? this.split});}
  Future<void> updateActivityLevel(String setTo){return firebase.update({'activity level' : setTo ?? this.activityLevel});}
  Future<void> updatePlanningChange(double setTo){return firebase.update({'planning change' : setTo ?? this.planningChange});}
  Future<void> updatePlanningWeight(double setTo){return firebase.update({'planning weight' : setTo ?? this.planningWeight});}
  Future<void> updatePlanningFat(double setTo){return firebase.update({'planning fat' : setTo ?? this.planningFat});}
  Future<void> updatePlanningCarb(double setTo){return firebase.update({'planning carb' : setTo ?? this.planningCarb});}
  Future<void> updatePlanningProt(double setTo){return firebase.update({'planning prot' : setTo ?? this.planningProt});}
  Future<void> updateCal(double setTo){return firebase.update({'cal' : setTo ?? this.cal});}
  Future<void> updateFat(double setTo){return firebase.update({'fat' : setTo ?? this.fat});}
  Future<void> updateCarb(double setTo){return firebase.update({'carb' : setTo ?? this.carb});}
  Future<void> updateProt(double setTo){return firebase.update({'prot' : setTo ?? this.prot});}

  Future<void> updateLastFreeMeal(DateTime setTo){return firebase.update({'lastFreeMeal' : setTo ?? this.lastFreeMeal});}
  Future<void> updateFreeMealFrequency(num setTo){return firebase.update({'freeMealFrequency' : setTo ?? this.freeMealFrequency});}


  Future<void> updateCC(String setTo){return firebase.update({'cc' : setTo ?? this.cc});}

  UserState({
    this.uid,
    this.isNew,
    this.showMP,
    this.showWB,
    this.showAM,
    this.convertAlc,
    this.lastSeen,
    this.birthday,
    this.height,
    this.isFemale,
    this.prefersMetric,
    this.prefersSoundOn,
    this.startDate,
    this.endDate,
    this.goalWeight,
    this.rollingDate,
    this.rollingDuration,
    this.selectedSprinkles,
    this.selectedSprinklesAmount,  
    this.lastPhotoDate,
    this.lastWeight,
    this.currentHabit,
    // this.meals,
    // this.workouts,
    this.accountabilibuddies,
    this.canSeePhotos,
    this.publicLevel,
    this.split, 
    this.activityLevel,
    this.planningChange,
    this.planningWeight,
    this.planningFat,
    this.planningCarb,
    this.planningProt,
    this.cal,
    this.fat,
    this.carb,
    this.prot,
    this.cc,
    this.lastFreeMeal,
    this.freeMealFrequency,
  });

  factory UserState.fromMap(data){

    return UserState(
      uid: data['uid'] ?? "",
      isNew: data['is new'] ?? true,
      showWB: data['show workout builder'] ?? false,
      showMP: data['show meal prepper'] ?? false,
      showAM: data['show advanced metrics'] ?? false,
      convertAlc: data['convert alcohol to carbs'] ?? false,
      lastSeen: (data['last seen'] != null) ? ((data['last seen'] is Timestamp) ? (data['last seen'] as Timestamp).toDate() : (data['last seen'] as DateTime)) : null,
      selectedSprinkles: data['selected sprinkles'] ?? BuiltInSprinkles.defaultSprinkles.name,
      selectedSprinklesAmount: data['selected sprinkles amount'] ?? BuiltInSprinkles.defaultAmount.name,
      birthday: (data['birthday'] != null) ? ((data['birthday'] is Timestamp) ? (data['birthday'] as Timestamp).toDate() : (data['birthday'] as DateTime)) : DateTime(1995, 1, 31, 20, 30),
      height: (data['height'] != null) ? data['height'].toDouble() : 170.0,
      isFemale: data['is female'] ?? false,
      prefersMetric: data['prefers metric'] ?? false,
      prefersSoundOn: data['prefers sound on'] ?? true,
      startDate: (data['start date'] != null) ? ((data['start date'] is Timestamp) ? (data['start date'] as Timestamp).toDate() : (data['start date'] as DateTime)) : DateTime.now(),
      endDate: (data['end date'] != null) ? ((data['end date'] is Timestamp) ? (data['end date'] as Timestamp).toDate() : (data['end date'] as DateTime)) : DateTime.now().add(Duration(days: 90)),
      goalWeight: data['goal weight'] ?? Calculations.getHealthyWeight(cm: (data['height'] != null) ? data['height'].toDouble() : null),
      rollingDate: data['use rolling date'] ?? true,
      rollingDuration: (data['rolling duration'] != null) ? data['rolling duration'].toInt() : 90,
      lastPhotoDate: (data['last photo date'] != null) ? ((data['last photo date'] is Timestamp) ? (data['last photo date'] as Timestamp).toDate() : (data['last photo date'] as DateTime)) : null,
      lastWeight: data['last weight'] ?? 180,
      currentHabit: data['current habit'] ?? "Verbalized one thing I am grateful for.",
      // meals: (data['meals'] != null) ? [for(var meal in data['meals']) meal] : [],
      // workouts: (data['workouts'] != null) ? [for(var workout in data['workouts']) workout] : [],
      accountabilibuddies: (data['accountabilibuddies'] != null) ? {  for(String key in data['accountabilibuddies'].keys) key : (data['accountabilibuddies'][key].toString())} : {},
      canSeePhotos: (data['canseephotos'] != null) ? [for(String uid in data['canseephotos']) uid] : [],
      publicLevel: (data['publiclevel'] != null) ? data['publiclevel'] : 0,
      split: data['split'] ?? MacroSplit.physique,
      activityLevel: data['activity level'] ?? ActivityLevel.sedentary,
      planningChange: (data['planning change'] != null) ? data['planning change'].toDouble() : -1.0,
      planningWeight: (data['planning weight'] != null) ? data['planning weight'].toDouble() : -1.0,
      planningCarb: (data['planning fat'] != null) ? data['planning fat'].toDouble() : 0,
      planningFat: (data['planning carb'] != null) ? data['planning carb'].toDouble() : 0,
      planningProt: (data['planning prot'] != null) ? data['planning prot'].toDouble() : 0,
      cal: (data['cal'] != null) ? data['cal'].toDouble() : 0,
      fat: (data['fat'] != null) ? data['fat'].toDouble() : 0,
      carb: (data['carb'] != null) ? data['carb'].toDouble() : 0,
      prot: (data['prot'] != null) ? data['prot'].toDouble() : 0,
      lastFreeMeal: (data['lastFreeMeal'] != null) ? ((data['lastFreeMeal'] is Timestamp) ? (data['lastFreeMeal'] as Timestamp).toDate() : (data['lastFreeMeal'] as DateTime)) : DateTime.now().subtract(Duration(days: 365)),
      freeMealFrequency: (data['freeMealFrequency'] != null) ? data['freeMealFrequency'] : 0,
      cc: data['cc'] ?? "",
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid' : this.uid ?? "",
      'is new' : this.isNew ?? true,
      'show workout builder' : this.showWB ?? false,
      'show meal prepper' : this.showMP ?? false,
      'show advanced metrics' : this.showAM ?? false,
      'convert alcohol to carbs' : this.convertAlc ?? false,
      'last seen' : this.lastSeen ?? null,
      'selected sprinkles' : this.selectedSprinkles ?? BuiltInSprinkles.defaultSprinkles.name,
      'selected sprinkles amount' : this.selectedSprinklesAmount ?? BuiltInSprinkles.defaultAmount.name,
      'birthday' : this.birthday ?? DateTime(1995, 1, 31, 18, 30),
      'height' : this.height ?? 170.0,
      'is female' : this.isFemale ?? false,
      'prefers metric' : this.prefersMetric ?? false,
      'prefers sound on' : this.prefersSoundOn ?? true,
      'start date' : this.startDate ?? DateTime.now(),
      'end date' : this.endDate ?? DateTime.now().add(Duration(days: 90)),
      'goal weight' : this.goalWeight ?? Calculations.getHealthyWeight(cm: this.height),
      'use rolling date' : this.rollingDate ?? true,
      'rolling duration' : this.rollingDuration ?? 90,
      'last photo date' : this.lastPhotoDate ?? null,
      'last weight' : this.lastWeight ?? 180.0,
      'current habit' : this.currentHabit ?? "Verbalized one thing I am grateful for.",
      // 'meals' : (this.meals != null) ? [for(var meal in this.meals) meal] : [],
      // 'workouts' : (this.workouts != null) ? [for(var workout in this.workouts) workout] : [],
      'accountabilibuddies' : (this.accountabilibuddies != null) ? this.accountabilibuddies : {},
      'canseephotos' : (this.canSeePhotos!= null) ? [for(String uid in this.canSeePhotos) uid] : [],
      'publiclevel': this.publicLevel ?? 0,
      'split' : this.split ?? MacroSplit.physique,
      'activity level' : this.activityLevel ?? ActivityLevel.sedentary,
      'planning change' : this.planningChange ?? -1.0,
      'planning weight' : this.planningWeight ?? -1.0,
      'planning fat' : this.planningFat ?? 0,
      'planning carb' : this.planningCarb ?? 0,
      'planning prot' : this.planningProt ?? 0,
      'cal' : this.cal ?? 0,
      'fat' : this.fat ?? 0,
      'carb' : this.carb ?? 0,
      'prot' : this.prot ?? 0,
      'lastFreeMeal' : this.lastFreeMeal ?? DateTime.now().subtract(Duration(days: 365)),
      'freeMealFrequency' : this.freeMealFrequency ?? 0,
      'cc' : this.cc ?? "",
    };
  }
}

class Day{
  static final UserData<Day> firebase = UserData<Day>(daysCollection);
  static const String daysCollection = "Day";
  
  String createdBy;
  String name;
  DateTime lastEdited;
  bool savedData;
  Map<String, List<Ingredient>> day;

  Day({
    this.createdBy,
    this.lastEdited,
    this.name,
    this.savedData,
    this.day,
  });

  factory Day.fromMap(Map data){
    return Day(
      createdBy: data['uid'] ?? '',
      name: data['name'] ?? '',
      savedData: data['saved data'] ?? false, 
      lastEdited: (data['timestamp'] != null) ? (data['timestamp'] is Timestamp) ? (data['timestamp'] as Timestamp).toDate() : data['timestamp'] : DateTime.now(),
      day: (data['day'] != null) ?
      <String, List<Ingredient>>{
        "Unsorted" : (data['day']["Unsorted"] != null) ? [for(var item in data['day']["Unsorted"]) Ingredient.fromMap(item)] : <Ingredient>[],
        "Pre-Workout" : (data['day']["Pre-Workout"] != null) ? [for(var item in data['day']["Pre-Workout"]) Ingredient.fromMap(item)] : <Ingredient>[],
        "Post-Workout" : (data['day']["Post-Workout"] != null) ? [for(var item in data['day']["Post-Workout"]) Ingredient.fromMap(item)] : <Ingredient>[],
        "Breakfast" : (data['day']["Breakfast"] != null) ? [for(var item in data['day']["Breakfast"]) Ingredient.fromMap(item)] : <Ingredient>[],
        "Morning Snack" : (data['day']["Morning Snack"] != null) ? [for(var item in data['day']["Morning Snack"]) Ingredient.fromMap(item)] : <Ingredient>[],
        "Lunch" : (data['day']["Lunch"] != null) ? [for(var item in data['day']["Lunch"]) Ingredient.fromMap(item)] : <Ingredient>[],
        "Afternoon Snack" : (data['day']["Afternoon Snack"] != null) ? [for(var item in data['day']["Afternoon Snack"]) Ingredient.fromMap(item)] : <Ingredient>[],
        "Dinner" : (data['day']["Dinner"] != null) ? [for(var item in data['day']["Dinner"]) Ingredient.fromMap(item)] : <Ingredient>[],
        "Evening Snack" : (data['day']["Evening Snack"] != null) ? [for(var item in data['day']["Evening Snack"]) Ingredient.fromMap(item)] : <Ingredient>[],
      } :
      <String, List<Ingredient>>{
        "Unsorted" : <Ingredient>[],
        "Pre-Workout" : <Ingredient>[],
        "Post-Workout" : <Ingredient>[],
        "Breakfast" : <Ingredient>[],
        "Morning Snack" : <Ingredient>[],
        "Lunch" : <Ingredient>[],
        "Afternoon Snack" : <Ingredient>[],
        "Dinner" : <Ingredient>[],
        "Evening Snack" : <Ingredient>[],
      }
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid': createdBy ?? "",
      'name': name ?? "",
      'timestamp': lastEdited ?? DateTime.now(),
      'saved data': savedData ?? false,
      'day': <String, List<Map<String, dynamic>>>{
        "Unsorted" : [for(var ingredient in day["Unsorted"]) ingredient.toMap()],
        "Pre-Workout" : [for(var ingredient in day["Pre-Workout"]) ingredient.toMap()],
        "Post-Workout" : [for(var ingredient in day["Post-Workout"]) ingredient.toMap()],
        "Breakfast" : [for(var ingredient in day["Breakfast"]) ingredient.toMap()],
        "Morning Snack" : [for(var ingredient in day["Morning Snack"]) ingredient.toMap()],
        "Lunch" : [for(var ingredient in day["Lunch"]) ingredient.toMap()],
        "Afternoon Snack" : [for(var ingredient in day["Afternoon Snack"]) ingredient.toMap()],
        "Dinner" : [for(var ingredient in day["Dinner"]) ingredient.toMap()],
        "Evening Snack" : [for(var ingredient in day["Evening Snack"]) ingredient.toMap()],
      }
    };
  }
}

class UserWorkouts{
  static final UserData<UserWorkouts> firebase = UserData(userWorkouts);
  static const String userWorkouts = "User Workouts";

  Map<String, Workout> database = Map<String, Workout>();

  UserWorkouts();

  static Future<void> removeWorkout(Workout workout){
    return firebase.update(
      {
        workout.uid : FieldValue.delete()
      }
    );
  }

  static Future<void> updateRecord(Workout workout){
    return firebase.update(
      {
        workout.uid : workout.toMap()
      }
    );
  }

  UserWorkouts.fromMap(Map data){
    data.forEach((key, value){
      database[key] = Workout.fromMap(value);
    });
  }

  Map<String, dynamic> toMap(){
    return {
      if(database.length != 0)
        for(int i = 0; i < database.length; i++) 
          '${database.keys.elementAt(i)}' : database[database.keys.elementAt(i)].toMap()
    };
  }
}

class FeedbackEntry{
  static final GlobalData<FeedbackEntry> firebase = GlobalData(feedbackCollection);
  static const String feedbackCollection = "Feedback";

  static const int feedbackType = 0;
  static const int cancelType = 1;

  String docName;
  DateTime timestamp;

  final String userUid;
  final String displayName;
  final String email;

  final int type; 
  final String payload;

  FeedbackEntry({
    this.userUid,
    this.email,
    this.displayName,
    this.type,
    this.payload,
    this.docName,
    this.timestamp,
  }){
    if(this.docName == null) this.docName = Calculations.getUuid();
    if(this.timestamp == null) this.timestamp = DateTime.now();
  }

  factory FeedbackEntry.fromUser(User user, int type, String payload){
    return FeedbackEntry(
      userUid: user.uid,
      email: user.email,
      displayName: user.displayName ?? "User",
      type: type,
      payload: payload,
    );
  }

  factory FeedbackEntry.fromMap(Map data){
    return FeedbackEntry(
      docName: data['docName'] ?? "",
      timestamp: data['timestamp'] ?? "",
      userUid: data['userUid'] ?? "",
      displayName: data['displayName'] ?? "",
      email: data['email'] ?? "",
      type: data['type'] ?? "",
      payload: data['payload'] ?? "",
    );
  }

  Future<void> makeRecord(){return firebase.upsert(this.toMap(), this.docName, merge: false);}

  Map<String, dynamic> toMap(){
    return {
      'docName': this.docName,
      'timestamp': this.timestamp,
      'userUid': this.userUid ?? "",
      'displayName' : this.displayName ?? "",
      'email' : this.email ?? "",
      'type' : this.type ?? 0,
      'payload' : this.payload ?? ""
    };
  }
}

// class UserWorkoutRecords{
//   static final UserData<UserWorkoutRecords> firebase = UserData(userWorkoutRecords);
//   static const String userWorkoutRecords = "User Workout Records";

//   Map<String, Record> database = Map<String, Record>();

//   UserWorkoutRecords.fromMap(Map data){
//     data.forEach((key, value){
//       database[key] = Record.fromMap(value);
//     });
//   }

//   UserWorkoutRecords();


//   static Future<void> updateRecord(Record record){
//     return firebase.update(
//       {
//         record.name : record.toMap()
//       }
//     );
//   }

//   Map<String, dynamic> toMap(){
//     return {
//       if(database.length != 0)
//         for(int i = 0; i < database.length; i++) 
//           '${database.keys.elementAt(i)}' : database[database.keys.elementAt(i)].toMap()
//     };
//   }
// }
