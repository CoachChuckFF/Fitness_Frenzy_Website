/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/
import 'dart:math' as math;
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';

class PerspectiveSlideRouteDown<T> extends MaterialPageRoute<T> {
  PerspectiveSlideRouteDown(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => widget,
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == FoodFrenzyRoutes.login) return child;
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(
            0.0,
            0.3,
            curve: Curves.decelerate,
          ),
        ),
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(
            Tween<double>(
              begin: (0.2 * math.pi),
              end: 0.0,
            )
            .animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(0.3, 0.8, curve: Curves.easeIn),
              ),
            )
            .value
          ),
        alignment: FractionalOffset.center,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.75, 
            end: 1.0
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(0.6, 1.0, curve: Curves.easeOut),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PerspectiveSlideRouteLeft<T> extends MaterialPageRoute<T> {
  PerspectiveSlideRouteLeft(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => widget,
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == FoodFrenzyRoutes.login) return child;
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(
            0.0,
            0.4, 
            curve: Curves.fastLinearToSlowEaseIn,
          ),
        ),
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(
            Tween<double>(
              begin: (0.2 * math.pi),
              end: 0.0,
            )
            .animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.3,
                  0.8,
                  curve: Curves.easeIn
                ),
              ),
            )
            .value
          ),
        alignment: FractionalOffset.center,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.75,
            end: 1.0
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.6,
                1.0, 
                curve: Curves.easeOut
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class SlideRightRoute<T> extends MaterialPageRoute<T> {
  SlideRightRoute(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => widget,
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == FoodFrenzyRoutes.login) return child;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class SlideLeftRoute<T> extends MaterialPageRoute<T> {
  SlideLeftRoute(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => widget,
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == FoodFrenzyRoutes.login) return child;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => widget,
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == FoodFrenzyRoutes.login) return child;
    return FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1
        ).animate(animation),
        child: child);
  }
}