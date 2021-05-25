/*
* Christian Krueger Health LLC
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//External

import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';


class AuthController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User get getUser => _auth.currentUser;

  Stream<User> get user => _auth.authStateChanges();

  bool get isAdmin{
    return this.getUser.uid == "9GPolryscaMMDUuXyapkSxxjN6n2";
  }

  Future<void> _initPlatformState(String uid) async {
    Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("ZMPdAGqRLoTzZUfzysYjkkmpSkQXyWIf", appUserId: uid);
  }

  Future<User> appleSignIn({Function(dynamic) onError}) async {
    User user;

    try {
      AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            AppleIdCredential appleIdCredential = result.credential;
            OAuthProvider oAuthProvider = OAuthProvider("apple.com");

            AuthCredential credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            await _auth.signInWithCredential(credential).then((result){
              if(result != null) user = result.user;
            });

            if(user == null) throw Error();

            await _updateUserData(user);

            // FirebaseAuth.instance.currentUser().then((val) async {
            //   UserUpdateInfo updateUser = UserUpdateInfo();
            //   updateUser.displayName =
            //       "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";
            //   updateUser.photoUrl =
            //       "define an url";
            //   await val.updateProfile(updateUser);
            // });

          } catch (error) {
            LOG.log("Error logging in with Apple - Null User", FoodFrenzyDebugging.crash);
            if(onError != null) onError(error);
            return null;
          }
          break;

        case AuthorizationStatus.error:
          LOG.log("Error authing with Apple", FoodFrenzyDebugging.crash);
          if(onError != null) onError("Error");
          return null;

        case AuthorizationStatus.cancelled:
          LOG.log("User canceld Apple Sign in", FoodFrenzyDebugging.info);
          return null;
      }

    } catch (error) {
      LOG.log("Error logging in with Apple", FoodFrenzyDebugging.crash);
      if(onError != null) onError(error);
      return null;
    }

    return user;
  }

  Future<User> googleSignIn({Function(dynamic) onError}) async {
    User user;

    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential).then((result){
        if(result != null) user = result.user;
      });

      if(user == null) throw Error();

      await _updateUserData(user);

      return user;
    } catch (error) {
      if(onError != null) onError(error);
      return null;
    }
  }

  Future<User> debugLogin() async {
    User user = (await _auth.signInAnonymously()).user;

    await _updateUserData(user);

    return user;
  }

  Future<void> relogin(User user){

    //Revnue Cat
    return _initPlatformState(user.uid).then((value){
      LOG.log("Welcome Back User", FoodFrenzyDebugging.info);
    });
  }

  //TODO-DEBUG 
  //TODO set to false
  bool debugTurnOffPurchases = false;
  bool debugReturnValue = false;

  Future<bool> checkHasSubscription() async{
    if(debugTurnOffPurchases) return debugReturnValue;
    return Purchases.getPurchaserInfo().then((info){
      return info.activeSubscriptions.isNotEmpty;
    });
  }

  Future<void> _updateUserData(User user) async{
    bool exists;

    //Revnue Cat
    await _initPlatformState(user.uid);
    LOG.log("Revenue Cat is prowling around", FoodFrenzyDebugging.info);

    //user acq
    exists = await UserACQ.firebase.checkExists();
    if(!exists){
      UserACQ userACQ = UserACQ(
        uid: user.uid,
        name: user.displayName ?? "User",
        email: user.email ?? "?@?.?",
        platform: Platform.isAndroid ? "Android" : "IOS",
        visitCount: 0,
      );
      await UserACQ.firebase.upsert(
        userACQ.toMap()
      );
    }

    //user state
    exists = await UserState.firebase.checkExists();
    if(!exists){
      UserState userState = UserState(uid: user.uid);
      await UserState.firebase.upsert(
        userState.toMap()
      );
    }

    //User Points
    exists = await UserPoints.firebase.checkExists();
    if(!exists){
      UserPoints userPoints = UserPoints(uid: user.uid);
      await UserPoints.firebase.upsert(
        userPoints.toMap()
      );

      //Unlock Counts
      SprinkleUnlocks.update(BuiltInSprinkles.defaultAmount.name);
      SprinkleUnlocks.update(BuiltInSprinkles.defaultSprinkles.name);
    }

    //UserLog
    await UserLog.getTodaysLog();

    //Day
    exists = await Day.firebase.checkExists();
    if(!exists){
      Day day = Day.fromMap({});
      await Day.firebase.upsert(
        day.toMap()
      );
    }

    //user common ingredients
    exists = await UserCommonIngredients.firebase.checkExists();
    if(!exists){
      UserCommonIngredients commonIngredients = UserCommonIngredients();
      await UserCommonIngredients.firebase.upsert(
        commonIngredients.toMap()
      );
    }

    //user log entries
    exists = await UserLogEntries.firebase.checkExists();
    if(!exists){
      UserLogEntries userLogEntries = UserLogEntries();
      await UserLogEntries.firebase.upsert(
        userLogEntries.toMap()
      );
    }

    //user habits
    exists = await UserHabits.firebase.checkExists();
    if(!exists){
      UserHabits userHabits = UserHabits(log: {
        "Verbalized one thing I am grateful for." : []
      });
      await UserHabits.firebase.upsert(
        userHabits.toMap()
      );
    }

  }


  Future<void> signOut() {
    return _auth.signOut();
  }
}