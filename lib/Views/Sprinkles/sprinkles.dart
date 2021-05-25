/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
// Sprinkles.dart is a flutter animation
// it is largely a modified version of Felix Blaschke's flutter particle effects
// https://medium.com/@felixblaschke/particle-animations-with-flutter-756a23dba027
//Internal
import 'dart:ui';

import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';


class Sprinkles extends StatefulWidget {
  final int numberOfSprinkles;
  final List<Color> colors;
  final double size;
  final String name;

  static List<Color> _defaultColors = <Color>[
    FoodFrenzyColors.main,
    FoodFrenzyColors.tertiary,
  ];

  Sprinkles(this.numberOfSprinkles, {this.colors, this.size = 8.0, this.name});

  @override
  _SprinklesState createState() => _SprinklesState();
}

class _SprinklesState extends State<Sprinkles> {
  final Random random = Random();

  final List<SprinklesModel> sprinkles = [];

  @override
  void initState() {
    List.generate(widget.numberOfSprinkles, (index) {
      sprinkles.add(SprinklesModel(random, widget.size, widget.colors ?? Sprinkles._defaultColors, widget.name));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Rendering(
      startTime: Duration(seconds: 30),
      onTick: _simulateSprinkles,
      builder: (context, time) {
        return CustomPaint(
          painter: SprinklesPainter(sprinkles, time),
        );
      },
    );
  }

  _simulateSprinkles(Duration time) {
    sprinkles.forEach((particle) => particle.maintainRestart(time));
  }
}

class SprinklesModel {
  Animatable tween;
  double size;
  double width;
  double height;
  Color color;
  String name;
  List<Color> colors;
  double _ratio = FoodFrenzyRatios.gold;
  AnimationProgress animationProgress;
  Random random;

  int counter = 0;

  void incCount(){
    this.counter++;
  }

  SprinklesModel(this.random, this.size, this.colors, this.name) {
    restart();
  }

  restart({Duration time = Duration.zero}) {
    final startPosition = Offset(1.2 - (1.4 * random.nextDouble()), -0.2);
    final endPosition = Offset(1.2 - (1.4 * random.nextDouble()), 1.2);
    // final startRad = ((random.nextBool()) ? -1 : 1) * random.nextDouble() * 3 * pi;
    // final endRad = ((random.nextBool()) ? -1 : 1) * random.nextDouble() * 3 * pi;
    final duration = Duration(milliseconds: 4181 + random.nextInt(6765));

    tween = MultiTrackTween([
      Track("x").add(
          duration, Tween(begin: startPosition.dx, end: endPosition.dx),
          curve: Curves.easeInOutSine),
      Track("y").add(
          duration, Tween(begin: startPosition.dy, end: endPosition.dy),
          curve: Curves.easeIn),
      Track("f").add(
          duration, Tween<double>(begin: 0, end: 100),
          curve: Curves.linear),
    ]);

    animationProgress = AnimationProgress(duration: duration, startTime: time);

    height = size;
    width = size * (_ratio * _ratio);
    color = colors[random.nextInt(colors.length)];
  }

  maintainRestart(Duration time) {
    if (animationProgress.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class SprinklesPainter extends CustomPainter {
  List<SprinklesModel> sprinkles;
  Duration time;

  SprinklesPainter(this.sprinkles, this.time);


  Color _getColor(SprinklesModel model){
    switch(model.name){
      case "Flame":
        model.incCount();

        // if(model.counter % 5 == 0)
        //   model.color = Color.fromARGB(
        //     0xFF, 
        //     Calculations.rng.nextInt(120) + 135, 
        //     Calculations.rng.nextInt(120) + 135, 
        //     Calculations.rng.nextInt(120) + 135
        //   );

        return model.color;
      case "Water":
        return model.color;
      case "Earth":
        return model.color;
      case "Acid":

        return model.color;
      case "Ether":
        model.incCount();

        if(model.counter % 5 == 0){
          model.color = model.colors[
            Calculations.rng.nextInt(model.colors.length)
          ];
        }

        return model.color;
      default:
        return model.color;
    }
  }

  Path _getPath(String name, Offset position, double width, double height){
    Path path = Path();

    switch(name){
      // case "???":
      //   path.lineTo(position.dx, position.dy);
      //   path.lineTo(position.dx + 10, position.dy + 10);
      //   break;
      case "???":
        double scale = FoodFrenzyRatios.gold;

        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx + 10 * scale, position.dy);
        path.lineTo(position.dx + 13 * scale, position.dy - 8 * scale);
        path.lineTo(position.dx + 8 * scale, position.dy - 5 * scale);
        path.lineTo(position.dx + 5 * scale, position.dy - 13 * scale);
        path.lineTo(position.dx + 2 * scale, position.dy - 5 * scale);
        path.lineTo(position.dx - 3 * scale, position.dy - 8 * scale);
        path.close();
        break;
      default:
      path.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(position.dx, position.dy, width, height), 
          topLeft: Radius.circular(3),
          topRight: Radius.circular(3),
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
          ), 
        );
        break;
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    
    sprinkles.forEach((particle) {
      var progress = particle.animationProgress.progress(time);
      final animation = particle.tween.transform(progress);
      final paint = Paint()..color = _getColor(particle);
      final position = Offset(animation["x"] * size.width, animation["y"] * size.height);

      Path path = _getPath(particle.name, position, particle.width, particle.height);

      canvas.drawShadow(path, FoodFrenzyColors.secondary, 3, true);
      canvas.drawPath(path, paint);

    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
