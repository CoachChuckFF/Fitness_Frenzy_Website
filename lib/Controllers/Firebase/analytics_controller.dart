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

class AnalyticsController{
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static Future<void> sendAnalyticsEvent(String name, Map<String, dynamic> info) async {
    return analytics.logEvent(
      name: name ?? "???",
      parameters: info ?? {'Unkown' : -1}
    );
  }

  static Future<void> sendPurchaseEvent(String id, String description) async {
    return analytics.setUserId(id ?? "???").then((_){
      analytics.logEcommercePurchase(
        transactionId: description ?? "???"
      );
    });
  }
}