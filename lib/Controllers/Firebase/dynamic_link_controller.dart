/*
* Christian Krueger Health LLC
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//External
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';

class DynamicLinkController{
  static Future<Uri> createDynamicLink(String slug) async {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://christiankruegerhealth.page.link',
        link: Uri.parse('https://christiankruegerhealth.page.link/$slug'),
        androidParameters: AndroidParameters(
          packageName: 'your_android_package_name',
          minimumVersion: 1,
        ),
        iosParameters: IosParameters(
          bundleId: 'io.christiankruegerhealth.foodfrenzy',
          minimumVersion: '1',
          appStoreId: '1533708714',
        ),
      );
      var dynamicUrl = await parameters.buildUrl();

      return dynamicUrl;
  }

    static Future<Uri> createBuddyLink(String id) async {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://christiankruegerhealth.page.link',
        link: Uri.parse('https://fitnessfrenzy.io/buddy$id'),
        androidParameters: AndroidParameters(
          packageName: 'io.christiankruegerhealth.foodfrenzy',
          minimumVersion: 1,
        ),
        iosParameters: IosParameters(
          bundleId: 'io.christiankruegerhealth.foodfrenzy',
          minimumVersion: '1.0',
          appStoreId: '1533708714',
        ),
      );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl;
  }
}