/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/


import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class DrawingPoints {
  static const max = Fib.f13;

  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});

}

class DrawingPointsData {
  final num dx;
  final num dy;
  final num a;
  final num r;
  final num g;
  final num b;

  DrawingPoints toPoints({double scale = 1.0, double shiftX = 0}){

    return DrawingPoints(
      points: Offset((dx * scale) + shiftX, dy * scale),
      paint: Paint()
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..color = Color.fromARGB(a.round(), r.round(), g.round(), b.round())
        ..strokeWidth = LogHabit.strokeWidth * scale
    );
  }

  DrawingPointsData({
    this.dx,
    this.dy,
    this.a,
    this.r,
    this.g,
    this.b,
  });

  factory DrawingPointsData.fromMap(Map data){
    if(data == null) return null;

    return DrawingPointsData(
      dx: data['dx'] ?? 0,
      dy: data['dy'] ?? 0,
      a: data['a'] ?? 0,
      r: data['r'] ?? 0,
      g: data['g'] ?? 0,
      b: data['b'] ?? 0,
    );
  }

  factory DrawingPointsData.fromDrawingPoint(DrawingPoints point){
    if(point == null) return null;
    Color color = point.paint.color;

    return DrawingPointsData(
      dx: point.points.dx ?? 0,
      dy: point.points.dy ?? 0,
      a: color.alpha ?? 0,
      r: color.red ?? 0,
      g: color.green ?? 0,
      b: color.blue ?? 0,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'dx' : dx ?? 0, 
      'dy' : dy ?? 0, 
      'a' : a ?? 0, 
      'r' : r ?? 0, 
      'g' : g ?? 0, 
      'b' : b ?? 0, 
    };
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i +1].points ,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }
  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => oldDelegate.pointsList!=pointsList;
}

class LogHabit extends StatefulWidget {
  static const double strokeWidth = 13;

  final bool visable;
  final double middleWidth;
  final double buttonWidth;

  final double topButtonBarWidth;
  final double topButtonBarHeight;
  final double screenWidth;
  final double screenTopPadding;
  final double sideDrawerWidth;
  final double sideDrawerHeight;

  final int startingMenuIndex;
  final Function clearStartingIndex;

  final Function onExit;

  LogHabit({
    this.visable,
    this.middleWidth,
    this.buttonWidth,
    this.topButtonBarWidth,
    this.topButtonBarHeight,
    this.screenWidth,
    this.screenTopPadding,
    this.sideDrawerHeight,
    this.sideDrawerWidth,
    this.startingMenuIndex = -1,
    this.clearStartingIndex,
    this.onExit,
    Key key,
  }) : super(key: key);

  @override
  _LogHabitState createState() => _LogHabitState();
}

class _LogHabitState extends State<LogHabit> {
  List<DrawingPoints> _points = List();
  Color _doodleColor = FoodFrenzyColors.jjRed;
  GlobalKey _doodleKey = GlobalKey(debugLabel: "Doodler");
  double _doodleHeight = 0;
  double _doodleWidth = 0;
  IntBLoC _updateBloc = IntBLoC();
  DrawerStateBLoC _drawerBloc = DrawerStateBLoC();

  StringBLoC _editHabitBloc = StringBLoC();
  BoolBLoC _updateKeyboardBloc = BoolBLoC();
  BoolBLoC _editHabitStateBloc = BoolBLoC();

  UserState _userState;
  UserHabits _habits;

  TextEditingController _newHabitController = TextEditingController();

  //dimentions
  double _screenWidth;
  double _screenHeight;
  double _screenTopPadding;
  double _topButtonBarWidth;
  double _topButtonBarHeight;
  double _sideDrawerWidth;
  double _sideDrawerHeight;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStartingMenu(widget.startingMenuIndex);
    });
    super.initState();
  }

  @override
  void dispose() {
    _drawerBloc.dispose();
    _updateBloc.dispose();
    _newHabitController.dispose();
    _editHabitBloc.dispose();
    _updateKeyboardBloc.dispose();
    _editHabitStateBloc.dispose();
    super.dispose();
  }

  void _handleStartingMenu(int index){
    if(index.isNegative){
      // _drawerBloc.add(DrawerClearStateEvent());
      return;
    }

    // switch(index){
    //   case FoodFrenzyRoutes.menuIndexDashboardLogHabitSet:
    //     if(_drawerBloc.canOpen()){
    //       _drawerBloc.add(DrawerStateSetEvent("Right"));
    //     }
    //     break;
    // }

    if(widget.clearStartingIndex != null){
      widget.clearStartingIndex();
    }
  }

_onPanUpdate(DragUpdateDetails details) {

  if(_points.length >= DrawingPoints.max){
    _points.removeAt(0);
  }

  _points.add(
    DrawingPoints(
      points: _getOffset(details.globalPosition),
      paint: Paint()
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..color = _doodleColor
        ..strokeWidth = LogHabit.strokeWidth));

  _updateDrawingState();
}

_onPanStart(details) {

  if(_points.length >= DrawingPoints.max){
    _points.removeAt(0);
  }

  _points.add(DrawingPoints(
      points: _getOffset(details.globalPosition),
      paint: Paint()
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..color = _doodleColor
        ..strokeWidth = LogHabit.strokeWidth));
  
  _updateDrawingState();
}

Offset _getOffset(Offset global){
  RenderBox renderBox = _doodleKey.currentContext.findRenderObject();
  Offset local = renderBox.globalToLocal(global);
  double dx = local.dx;
  double dy = local.dy;
  double width = LogHabit.strokeWidth / 2;
  // print(global.toString() + " " + renderBox.globalToLocal(global).toString());

  if(dx < width) dx = width;
  if(dx > (_doodleWidth - width)) dx = (_doodleWidth - width);
  if(dy < width) dy = width;
  if(dy > (_doodleHeight - width)) dy = (_doodleHeight - width);


  return Offset(dx, dy);
} 

_onPanEnd(details) {
  if(_points.length >= DrawingPoints.max){
    _points.removeAt(0);
  }

  _points.add(null);
  _updateDrawingState();
}

_clearDoodle(){
  _points.clear();
  _updateDrawingState();
}

  _updateDrawingState(){
    _updateBloc.add(IntUpdateEvent(_updateBloc.state + 1));
  }

  Widget _buildColor(Color color){
    return Expanded(
      child: GestureDetector(
        onTap: (){
          if(_doodleColor != color){
              _doodleColor = color;
              _updateDrawingState();
          }
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (color == _doodleColor) ? color : FoodFrenzyColors.jjTransparent,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (color == _doodleColor) ? FoodFrenzyColors.secondary: FoodFrenzyColors.jjTransparent,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: color,
                  )
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _addPoint(Offset offset){
    if(offset == null){
      _points.add(null);
      return;
    }

    _points.add(DrawingPoints(
        points: offset,
        paint: Paint()
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..color = _doodleColor
          ..strokeWidth = LogHabit.strokeWidth));
  }

  void _drawMorale(int moral){
    double middleX = _doodleWidth / 2; 
    double middleY = _doodleHeight / 2; 

    switch(moral){
      case -1:
        _addPoint(null);
        break;
      case 0:
        _addPoint(null); //EYE 1
        _addPoint(Offset(middleX - 34 - 8, middleY - 21));
        _addPoint(Offset(middleX - 34, middleY - 34));
        _addPoint(Offset(middleX - 34 + 8, middleY - 21));
        _addPoint(null); //EYE 2
        _addPoint(Offset(middleX + 34 + 8, middleY - 21));
        _addPoint(Offset(middleX + 34, middleY - 34));
        _addPoint(Offset(middleX + 34 - 8, middleY - 21));
        _addPoint(null); //smile R
        for(int x = 0; x < 34 + 13; x++){
          _addPoint(Offset(middleX + x, (middleY + 55) - (0.013 * pow(x, 2))));
        }
        _addPoint(null); //smile L
        for(int x = 0; x < 34 + 13; x++){
          _addPoint(Offset(middleX - x, (middleY + 55) - (0.013 * pow(x, 2))));
        }
        _addPoint(null);
      break;
      case 1:
        _addPoint(null); //EYE 1
        _addPoint(Offset(middleX - 34, middleY - 21));
        _addPoint(Offset(middleX - 34, middleY - 34));
        _addPoint(null); //EYE 2
        _addPoint(Offset(middleX + 34, middleY - 21));
        _addPoint(Offset(middleX + 34, middleY - 34));
        _addPoint(null); //smile R
        for(int x = 0; x < 34 + 13; x++){
          _addPoint(Offset(middleX + x, (middleY + 55) - (0.013 * pow(x, 2))));
        }
        _addPoint(null); //smile L
        for(int x = 0; x < 34 + 13; x++){
          _addPoint(Offset(middleX - x, (middleY + 55) - (0.013 * pow(x, 2))));
        }
        _addPoint(null);
      break;
      case 2:
        _addPoint(null); //EYE 1
        _addPoint(Offset(middleX - 34, middleY - 21));
        _addPoint(Offset(middleX - 34, middleY - 34));
        _addPoint(null); //EYE 2
        _addPoint(Offset(middleX + 34, middleY - 21));
        _addPoint(Offset(middleX + 34, middleY - 34));
        _addPoint(null); //meh
        _addPoint(Offset(middleX + 34 + 13, middleY + 34));
        _addPoint(Offset(middleX - 34 - 13, middleY + 34));
        _addPoint(null);
      break;
      case 3:
        _addPoint(null); //EYE 1
        _addPoint(Offset(middleX - 34, middleY - 21));
        _addPoint(Offset(middleX - 34, middleY - 34));
        _addPoint(null); //EYE 2
        _addPoint(Offset(middleX + 34, middleY - 21));
        _addPoint(Offset(middleX + 34, middleY - 34));
        _addPoint(null); //smile R
        for(int x = 0; x < 34 + 13; x++){
          _addPoint(Offset(middleX + x, (middleY + 27) + (0.013 * pow(x, 2))));
        }
        _addPoint(null); //smile L
        for(int x = 0; x < 34 + 13; x++){
          _addPoint(Offset(middleX - x, (middleY + 27) + (0.013 * pow(x, 2))));
        }
        _addPoint(null);
      break;
      case 4:
        _addPoint(null); //EYE 1
        _addPoint(Offset(middleX - 34 - 8, middleY - 21));
        _addPoint(Offset(middleX - 34 + 8, middleY - 34));
        _addPoint(null); //EYE 2
        _addPoint(Offset(middleX + 34 + 8, middleY - 21));
        _addPoint(Offset(middleX + 34 - 8, middleY - 34));
        _addPoint(null); //smile R
        for(int x = 0; x < 34 + 13; x++){
          _addPoint(Offset(middleX + x, (middleY + 27) + (0.013 * pow(x, 2))));
        }
        _addPoint(null); //smile L
        for(int x = 0; x < 34 + 13; x++){
          _addPoint(Offset(middleX - x, (middleY + 27) + (0.013 * pow(x, 2))));
        }
        _addPoint(null);
      break;
    }
    
    _updateDrawingState();
  }

  Widget _buildCanvas(){
    return BlocBuilder(
      cubit:_updateBloc,
      builder: (context, tick) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                // color: FoodFrenzyColors.tertiary.withAlpha(200),
                color: FoodFrenzyColors.tertiary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, cons) {
                  _doodleHeight = cons.maxHeight;
                  _doodleWidth = cons.maxWidth;

                  return Container(
                    width: cons.maxWidth,
                    height: cons.maxHeight,
                    key: _doodleKey,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: GestureDetector(
                      onHorizontalDragStart: _onPanStart,
                      onHorizontalDragUpdate: _onPanUpdate,
                      onHorizontalDragEnd: _onPanEnd,
                      onPanUpdate: _onPanUpdate,
                      onPanStart: _onPanStart,
                      onPanEnd: _onPanEnd,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: DrawingPainter(
                            pointsList: _points,
                          ),
                        ),
                      ) ,
                    ),
                  );
                }
              ),
            ),
            if(_points.isEmpty) 
              Center(
                child: GestureDetector(
                  onTap: (){
                    _drawMorale(-1);
                    CommonAssets.showSnackbar(context, "Doodle away!");
                  },
                  child: Container(
                    color: FoodFrenzyColors.jjTransparent,
                    padding: EdgeInsets.all(13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IgnorePointer(
                          child: AST(
                            "How're you doing?",
                            color: FoodFrenzyColors.secondary,
                            size: 34,
                            maxLines: 2,
                          ),
                        ),
                        IgnorePointer(child: Container(height: 13)),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  _drawMorale(0);
                                },
                                child: Container(
                                  color: FoodFrenzyColors.jjTransparent,
                                  child: Icon(
                                    FontAwesomeIcons.smileBeam,
                                    color: FoodFrenzyColors.secondary,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  _drawMorale(1);
                                },
                                child: Container(
                                  color: FoodFrenzyColors.jjTransparent,
                                  child: Icon(
                                    FontAwesomeIcons.smile,
                                    color: FoodFrenzyColors.secondary,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  _drawMorale(2);
                                },
                                child: Container(
                                  color: FoodFrenzyColors.jjTransparent,
                                  child: Icon(
                                    FontAwesomeIcons.meh,
                                    color: FoodFrenzyColors.secondary,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  _drawMorale(3);
                                },
                                child: Container(
                                  color: FoodFrenzyColors.jjTransparent,
                                  child: Icon(
                                    FontAwesomeIcons.frown,
                                    color: FoodFrenzyColors.secondary,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  _drawMorale(4);
                                },
                                child: Container(
                                  color: FoodFrenzyColors.jjTransparent,
                                  child: Icon(
                                    FontAwesomeIcons.frownOpen,
                                    color: FoodFrenzyColors.secondary,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if(_points.isNotEmpty)
              Positioned(
                top: 13,
                left: 13, 
                child: GestureDetector(
                  child: Icon(
                    FontAwesomeIcons.trash,
                    color: FoodFrenzyColors.secondary,
                    size: 34,
                  ),
                  onTap: (){
                    _clearDoodle();
                  },
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0, 
              child: Container(
                width: widget.middleWidth,
                height: widget.topButtonBarHeight,
                child: Row(
                  children: [
                    _buildColor(FoodFrenzyColors.jj1),
                    _buildColor(FoodFrenzyColors.jj2),
                    _buildColor(FoodFrenzyColors.jj3),
                    _buildColor(FoodFrenzyColors.jj4),
                    _buildColor(FoodFrenzyColors.jj5),
                    _buildColor(FoodFrenzyColors.jj6),
                    _buildColor(FoodFrenzyColors.jj7),
                    _buildColor(FoodFrenzyColors.jj8),
                  ],
                ),
              )
            ),
          ],
        );
      }
    );
  }

  List<DrawingPointsData> _pointsToData(){
    List<DrawingPointsData> list = List<DrawingPointsData>();
    int count = 0;
    int max = DrawingPoints.max;

    //First Point dictated the H and W
    list.add(
      DrawingPointsData(
        dx: _doodleWidth,
        dy: _doodleHeight,
        a: 0,
        r: 0,
        g: 0,
        b: 0,
      )
    );
    //Cuts this segment short
    list.add(null);

    _points.forEach((point) {
      if(count++ < max){
        list.add(DrawingPointsData.fromDrawingPoint(point));
      }
    });

    return list;
  }

  bool _getButtonEnabled(String button){
    String text = _editHabitBloc.state;

    switch(button){
      case '🔙':
        return text.isNotEmpty;
      case '❌':
        return text.isNotEmpty;
      case ' ':
        if(text.length >= 55) return false;
        if(text.endsWith(' ')) return false;
        if(text.isEmpty) return false;
        break;
      case '.':
        if(text.length >= 55) return false;
        if(text.endsWith('.')) return false;
        if(text.endsWith(' ')) return false;
        if(text.isEmpty) return false;
        break;
      default:
        if(text.length >= 55){
          return false;
        }
    }

    return true;
  }

  bool _getButtonUppercase(){
    if(_editHabitBloc.state.endsWith('.') || _editHabitBloc.state.isEmpty){
      return true;
    }
    return false;
  }

  void _handleButton(String button){
    String text = _editHabitBloc.state;

    switch(button){
      case '🔙':
        text = text.substring(0, text.length-1);
        break;
      case '❌':
        text = '';
        break;
      case 'Space':
        text += ' ';
        break;
      case '✔️':
        if(text.length > 3){
          if(!_habits.log.containsKey(text)){
            _habits.log[text] = List<DateTime>();
            _habits.updateHabit();
          }
        }
        _editHabitStateBloc.add(BoolUpdateEvent(false));
        return;
      default:
        if(text.length < 55){
          text += button;
        }
        break;
    }

    if(text != _editHabitBloc.state){
      _editHabitBloc.add(StringUpdateEvent(text));
      _updateKeyboardBloc.add(BoolToggleEvent());
    }

  }

  Widget _buildKey(String value, {int flex: 1, bool enabled = true, uppercase = false}){

    if(uppercase) value = value.toUpperCase();

    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.all(1),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          color: FoodFrenzyColors.jjTransparent,
          splashColor: FoodFrenzyColors.jjTransparent,
          highlightColor: (enabled) ? FoodFrenzyColors.secondary : FoodFrenzyColors.tertiary,
          padding: EdgeInsets.all(3),
          child: Center(
            child: AST(
              value,
              color: (enabled) ? FoodFrenzyColors.secondary : FoodFrenzyColors.secondary.withAlpha(34),
              size: 34,
            ),
          ), 
          onPressed: (){
            if(enabled) _handleButton(value);
          },
        )
      ),
    );
  }

  Widget _buildKeyboard(){
    return BlocBuilder(
      cubit: _updateKeyboardBloc,
      builder: (context, rebuild) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  _buildKey("1", enabled: _getButtonEnabled("1")),
                  _buildKey("2", enabled: _getButtonEnabled("2")),
                  _buildKey("3", enabled: _getButtonEnabled("3")),
                  _buildKey("4", enabled: _getButtonEnabled("4")),
                  _buildKey("5", enabled: _getButtonEnabled("5")),
                  _buildKey("6", enabled: _getButtonEnabled("6")),
                  _buildKey("7", enabled: _getButtonEnabled("7")),
                  _buildKey("8", enabled: _getButtonEnabled("8")),
                  _buildKey("9", enabled: _getButtonEnabled("9")),
                  _buildKey("0", enabled: _getButtonEnabled("0")),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  _buildKey("q", enabled: _getButtonEnabled("q"), uppercase: _getButtonUppercase()),
                  _buildKey("w", enabled: _getButtonEnabled("w"), uppercase: _getButtonUppercase()),
                  _buildKey("e", enabled: _getButtonEnabled("e"), uppercase: _getButtonUppercase()),
                  _buildKey("r", enabled: _getButtonEnabled("r"), uppercase: _getButtonUppercase()),
                  _buildKey("t", enabled: _getButtonEnabled("t"), uppercase: _getButtonUppercase()),
                  _buildKey("y", enabled: _getButtonEnabled("y"), uppercase: _getButtonUppercase()),
                  _buildKey("u", enabled: _getButtonEnabled("u"), uppercase: _getButtonUppercase()),
                  _buildKey("i", enabled: _getButtonEnabled("i"), uppercase: _getButtonUppercase()),
                  _buildKey("o", enabled: _getButtonEnabled("o"), uppercase: _getButtonUppercase()),
                  _buildKey("p", enabled: _getButtonEnabled("p"), uppercase: _getButtonUppercase()),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  _buildKey("a", enabled: _getButtonEnabled("a"), uppercase: _getButtonUppercase()),
                  _buildKey("s", enabled: _getButtonEnabled("s"), uppercase: _getButtonUppercase()),
                  _buildKey("d", enabled: _getButtonEnabled("d"), uppercase: _getButtonUppercase()),
                  _buildKey("f", enabled: _getButtonEnabled("f"), uppercase: _getButtonUppercase()),
                  _buildKey("g", enabled: _getButtonEnabled("g"), uppercase: _getButtonUppercase()),
                  _buildKey("h", enabled: _getButtonEnabled("h"), uppercase: _getButtonUppercase()),
                  _buildKey("j", enabled: _getButtonEnabled("j"), uppercase: _getButtonUppercase()),
                  _buildKey("k", enabled: _getButtonEnabled("k"), uppercase: _getButtonUppercase()),
                  _buildKey("l", enabled: _getButtonEnabled("l"), uppercase: _getButtonUppercase()),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  _buildKey("❌", flex: 2, enabled: _getButtonEnabled("❌")),
                  _buildKey("z", enabled: _getButtonEnabled("z"), uppercase: _getButtonUppercase()),
                  _buildKey("x", enabled: _getButtonEnabled("x"), uppercase: _getButtonUppercase()),
                  _buildKey("c", enabled: _getButtonEnabled("c"), uppercase: _getButtonUppercase()),
                  _buildKey("v", enabled: _getButtonEnabled("v"), uppercase: _getButtonUppercase()),
                  _buildKey("b", enabled: _getButtonEnabled("b"), uppercase: _getButtonUppercase()),
                  _buildKey("n", enabled: _getButtonEnabled("n"), uppercase: _getButtonUppercase()),
                  _buildKey("m", enabled: _getButtonEnabled("m"), uppercase: _getButtonUppercase()),
                  _buildKey("🔙", flex: 2, enabled: _getButtonEnabled("🔙")),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  _buildKey(".", enabled: _getButtonEnabled(".")),
                  _buildKey("Space", flex: 2, enabled: _getButtonEnabled(" ")),
                  _buildKey("✔️", enabled: _getButtonEnabled("✔️")),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildHub(){
    return UserStateStreamView(
      (state){
        return Column(
          children: [
            // Expanded(
            //   child: GestureDetector(
            //     onTap: (){
            //       if(_drawerBloc.canOpen()){
            //         _drawerBloc.add(DrawerStateSetEvent("Right"));
            //       }
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: FoodFrenzyColors.tertiary,
            //         borderRadius: BorderRadius.circular(8),
            //         boxShadow: CommonAssets.shadow,
            //       ),
            //       margin: EdgeInsets.only(bottom: 8),
            //       padding: EdgeInsets.all(8),
            //       child: Center(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: [
            //             Expanded(
            //               child: Container(
            //                 color: FoodFrenzyColors.jjTransparent,
            //                 child: AST(
            //                   "Today I...",
            //                   textAlign: TextAlign.left,
            //                   color: FoodFrenzyColors.secondary,
            //                   isBold: true,
            //                   size: 55,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 2,
            //               child: Center(
            //                 child: Container(
            //                   padding: EdgeInsets.all(13),
            //                   child: AST(
            //                     "${_userState.currentHabit}",
            //                     textAlign: TextAlign.center,
            //                     color: FoodFrenzyColors.secondary,
            //                     maxLines: 5,
            //                     size: 55,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: FoodFrenzyColors.tertiary,
                  boxShadow: CommonAssets.shadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildCanvas()
                ),
              ),
            )
          ]
        );
      }, onLoading: (){
        return CommonAssets.buildLoader();
      }
    );
  }

  void _setDimentions(){
    MediaQueryData query = MediaQuery.of(context);
    _screenWidth = query.size.width;
    _screenHeight = query.size.height;
    _screenTopPadding = query.padding.top;
    _topButtonBarWidth = _screenWidth;
    _topButtonBarHeight = _topButtonBarWidth * FoodFrenzyRatios.topButtonBarHeightRatio;
    _sideDrawerWidth = _screenWidth * FoodFrenzyRatios.sideDrawerWidthRatio;
    _sideDrawerHeight = _screenHeight - _screenTopPadding;
  }

  Widget _buildHabit(String habit, int count){
    bool isSelected = (habit == _userState.currentHabit);

    return Container(
      decoration: BoxDecoration(
        color: (isSelected) ? FoodFrenzyColors.main : FoodFrenzyColors.tertiary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: CommonAssets.shadow,
        
      ),
      margin: EdgeInsets.only(bottom: 13),
      padding: EdgeInsets.only(top: 3, bottom: 5),
      child: ListTile(
        onTap: (){
          _editHabitStateBloc.add(BoolUpdateEvent(false));
          if(!isSelected){
            _userState.updateCurrentHabit(habit);
            _drawerBloc.add(DrawerClearStateEvent());
          }
        },
        leading: Tooltip(
          preferBelow: false,
          message: "Logged $count times!",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  (count >= 67) ? Icons.check_box : Icons.check_box_outline_blank,
                  color: (isSelected) ? FoodFrenzyColors.tertiary : FoodFrenzyColors.secondary,
                ),
              ),
              Container(width: 8),
              AST(
                TextHelpers.numberToShort(count),
                color: (isSelected) ? FoodFrenzyColors.tertiary : FoodFrenzyColors.secondary,
                isBold: true,
              ),
            ],
          ),
        ),
        title: AST(
          habit, 
          color: (isSelected) ? FoodFrenzyColors.tertiary : FoodFrenzyColors.secondary,
          maxLines: 2,
        ),
        trailing: Tooltip(
          message: (isSelected) ? "You can't delete your current habit" : "Double Tap to Delete.",
          preferBelow: false,
          child: GestureDetector(
            onDoubleTap: (){
              if(_habits.log.keys.length > 1){
                if(!isSelected){
                  _habits.log.remove(habit);
                  _habits.updateHabit();
                }
              }
            },
            child: Icon(
              FontAwesomeIcons.trash,
              color: (isSelected) ? FoodFrenzyColors.jjTransparent : FoodFrenzyColors.secondary,
            ),
          ),
        )
      )
    );
  }

  Widget _buildNewHabit(){
    return Container(
      decoration: BoxDecoration(
        // color: FoodFrenzyColors.tertiary,
        // borderRadius: BorderRadius.circular(8),
        // boxShadow: CommonAssets.shadow,
        
      ),
      padding: EdgeInsets.only(top: 3, bottom: 5),
      margin: EdgeInsets.only(bottom: 13),
      child: BlocBuilder(
        cubit: _editHabitStateBloc,
        builder: (context, isEditing) {
          if(isEditing){
            return ListTile(
              onTap: (){
                _editHabitStateBloc.add(BoolToggleEvent());
              },
              leading: Icon(
                FontAwesomeIcons.plus,
                color: FoodFrenzyColors.main,
              ),
              title: BlocBuilder(
                cubit: _editHabitBloc,
                builder: (context, habit) {
                  return AST(
                    "Today I... " + habit, 
                    color: FoodFrenzyColors.secondary,
                    isBold: true,
                    maxLines: 3,
                  );
                }
              ),
            );
          }

          return ListTile(
            onTap: (){
              _editHabitStateBloc.add(BoolToggleEvent());
            },
            leading: Icon(
              FontAwesomeIcons.plus,
              color: FoodFrenzyColors.secondary,
            ),
            title: AST(
              "Add New Habit", 
              color: FoodFrenzyColors.secondary,
              isBold: true,
              maxLines: 3,
            ),
          );
        }
      )
    );
  }

  Widget _buildHabitList(){
    return UserHabitStreamView(
      (habits){
        _habits = habits;
        return BlocBuilder(
          cubit: _editHabitStateBloc,
          builder: (context, isEditing) {
            return Column(
              children: [
                Center(
                  child: AST(
                    "67 Days To Build A Habit",
                    color: FoodFrenzyColors.secondary,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(),
                _buildNewHabit(),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      _editHabitStateBloc.add(BoolUpdateEvent(false));
                    },
                    child: ListView(
                      padding: EdgeInsets.all(3),
                      children: [
                        for(String key in habits.log.keys)
                          _buildHabit(key,  habits.log[key].length),
                      ],
                    ),
                  ),
                ),
                if(isEditing)
                  BlocBuilder(
                    cubit: _updateKeyboardBloc,
                    builder: (context, updated) {
                      return CommonAssets.fullKeyboard(
                        _handleButton, 
                        _getButtonEnabled, 
                        uppercase: _getButtonUppercase(), 
                        height: CommonAssets.keyboardLineHeight * 3.4,
                        period: true,
                      );
                    }
                  ),
              ],
            );
          }
        );
      }, onLoading: (){
        return CommonAssets.buildLoader();
      },
    );
  }

  Widget _buildRightDrawer(){

    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){

        if(!visable["Right"]) return Container();

        return CustomRightDrawer(
          width: _sideDrawerWidth,
          screenWidth: _screenWidth,
          height: _sideDrawerHeight,
          topPadding: _screenTopPadding,
          buttonHeight: _topButtonBarHeight,

          child: _buildHabitList(),
          title: "Habits",
          onExit: (){
            _drawerBloc.add(DrawerClearStateEvent());
          },
          visable: true,

        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    _setDimentions();
    return UserLogStreamView(
      (log){

        _points.clear();
        _points.addAll(
          [
            for(DrawingPointsData point in log.signature) (point == null) ? null : point.toPoints()
          ]
        );

        return UserStateStreamView(
          (state){
            _userState = state;

            return GestureDetector(
              onHorizontalDragStart: (_){},
              child: Container(
                color: FoodFrenzyColors.jjTransparent,
                child: Stack(
                  children: [
                    CustomPopupWhole(
                      visable: widget.visable,
                      middleWidth: widget.middleWidth,
                      buttonWidth: widget.buttonWidth,
                      topButtonBarHeight: widget.topButtonBarHeight,
                      topButtonBarWidth: widget.topButtonBarWidth,
                      topButtonBarHasShadow: false,
                      iconLeft: FontAwesomeIcons.abacus,
                      iconLeftEnable: false,
                      title: "Log Morale",
                      message: "How you doing today",
                      // iconRight: FontAwesomeIcons.plus,
                      // onRight: (){
                      //   if(_drawerBloc.canOpen()){
                      //     _drawerBloc.add(DrawerStateSetEvent("Right"));
                      //   }
                      // },
                      mainWidget: _buildHub(),
                      bottomButtonTitle: "Log",
                      bottomButtonIcon: FontAwesomeIcons.save,
                      onExit: () {
                        if(_points.isNotEmpty){
                          //Points
                          UserLog.getTodaysLog().then((log){
                            if(!log.didLogHabit){
                              UserLog.updateTodaysDidLogHabit(true);
                              UserPoints.firebase.getDocument().then((points){
                                points.addPointsHabit();
                              });
                            }
                          });
                          
                          UserHabits.firebase.getDocument().then((UserHabits habits){
                            UserLog.updateSignature(_pointsToData(), _userState.currentHabit);
                            if(habits.log.containsKey(_userState.currentHabit)){
                              if(!habits.log[_userState.currentHabit].contains(Calculations.getTopOfTheMorning())){
                                habits.log[_userState.currentHabit].add(Calculations.getTopOfTheMorning());
                                habits.updateHabit();
                              }
                            } else {
                              habits.log[_userState.currentHabit] = List<DateTime>();
                              habits.log[_userState.currentHabit].add(Calculations.getTopOfTheMorning());
                              habits.updateHabit();
                            }
                          });
                        } else {
                          UserHabits.firebase.getDocument().then((UserHabits habits){
                            UserLog.updateSignature([], null);
                            if(habits.log.containsKey(_userState.currentHabit)){
                              habits.log[_userState.currentHabit].removeWhere((date){
                                return date.isAtSameMomentAs(Calculations.getTopOfTheMorning());
                              });
                              habits.updateHabit();
                            }
                          });
                        }
                        widget.onExit();
                      },
                    ),
                    // _buildRightDrawer(),
                  ],
                ),
              ),
            );
          }, onLoading: (){
            return CommonAssets.buildLoader();
          },
        );

      }, onLoading: (){
        return CommonAssets.buildLoader();
      }
    );
  }
} 