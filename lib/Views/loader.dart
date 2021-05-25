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

class Loader extends StatefulWidget {
  static const int differentAnimations = 9;
  static const int duration = Fib.f15;
  final double size;
  final Color color;

  Loader({this.size = 34, this.color});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin{
  Duration duration = Duration(milliseconds: Loader.duration);
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    animation = Tween<double>(
      begin: 0,
      end: (Loader.differentAnimations) * 50.0,
    ).animate(controller)..addListener((){
      setState((){
      });
    })..addStatusListener((status){
      switch(status){
        case AnimationStatus.completed:
          controller.value = controller.lowerBound;
          controller.forward();
          break;
        case AnimationStatus.dismissed:
          controller.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildTile(
    int index, 
    {
      bool tl = false, 
      bool tr = false,
      bool bl = false,
      bool br = false,
    }
  ){
    double start = index * 50.0;
    double end = start + 100.0;
    double diff = end - animation.value;
    double factor = 1.0;

    if(diff > 0.0 && diff <= 50.0){
      factor -= diff/50;
    } else if(diff > 50.0 && diff <= 100.0){
      diff -= 50;
      factor = diff/50;
    }

    Color color = (widget.color == null) ?
      FoodFrenzyColors.main.withAlpha((factor * 255).truncate()) :
      widget.color.withAlpha((factor * 255).truncate());
    
    return Container(
      padding: EdgeInsets.all(0),
      width: (widget.size/3),
      height: (widget.size/3),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(0),
          width: (widget.size/3) * factor,
          height: (widget.size/3) * factor,
          decoration: BoxDecoration(
            color: color,
            boxShadow: CommonAssets.shadow,
            borderRadius: BorderRadius.only(
              topLeft: (tl) ? Radius.circular(3) : Radius.zero,
              topRight: (tr) ? Radius.circular(3) : Radius.zero,
              bottomLeft: (bl) ? Radius.circular(3) : Radius.zero,
              bottomRight: (br) ? Radius.circular(3) : Radius.zero,
            )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      width: widget.size,
      height: widget.size,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTile(0, tl: true),
              _buildTile(3),
              _buildTile(6, tr: true),
            ]
          ),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTile(1),
              _buildTile(4),
              _buildTile(7),
            ]
          ),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTile(2, bl: true),
              _buildTile(5),
              _buildTile(8, br: true),
            ]
          ),
        ]
      )
    );
  }
}