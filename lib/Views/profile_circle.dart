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

class ProfileCircle extends StatelessWidget {
  final User user;
  final double size;

  ProfileCircle(this.user, {this.size});

  @override
  Widget build(BuildContext context) {
    bool useNetworkPhoto = false;
    if(user != null){
      if(user.photoURL != null){
        useNetworkPhoto = true;
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: FoodFrenzyColors.tertiary,
        boxShadow: CommonAssets.shadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FadeInImage(
          image: (useNetworkPhoto) ? 
            NetworkImage(user.photoURL) :
            AssetImage('assets/images/icons/icon_placeholder.png'),
          placeholder: AssetImage('assets/images/icons/icon_placeholder.png'),
          width: size ?? Fib.f9.toDouble(),
          height: size ?? Fib.f9.toDouble(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}