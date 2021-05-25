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

// class CloudFunctionsController{
//   static FirebaseFunctions functions = FirebaseFunctions.instance;

//   static Future<void> sendReportingEmail({String email, String body}) async {
//     HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendMail');
//     callable.call(<String, dynamic>{
//       "dest" : "christian.krueger.health.user.acq@gmail.com",
//       "title" : "New Sub: $email",
//       "body" : body,
//     }).then((value){
//       LOG.log(value.data, FoodFrenzyDebugging.info);
//     });
//   }
// }