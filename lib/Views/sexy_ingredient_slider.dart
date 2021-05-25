import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

//TODO fix the starting at "0" thing - it comes from the 56 % in macro step

class SexyIngredientSlider extends StatefulWidget {
  static const double tickContainerWidth = 55;
  static const double tickWidth = 5;
  static const double smallTickHeight = 0.3;
  static const double largeTickHeight = 0.8 - smallTickHeight;
  static const double tickToTopPadding = 0.1;
  static const double topPadding = 50;
  static const double radius = 1;
  static const int jumpStep = 100;

  final double height;
  final Ingredient ingredient;
  final double min;
  final double max;
  final double step;
  final Color mainColor;
  final Color auxColor;
  final double jumpAmount;
  final double overrideAnimateTo;
  final Function(double) onChange;

  SexyIngredientSlider(
    {
      @required this.ingredient,
      @required this.onChange, 
      this.height = 50, 
      this.min = 0, 
      this.max = 500, 
      this.step = 1.0, 
      this.mainColor,
      this.auxColor,
      this.jumpAmount = 100,
      this.overrideAnimateTo = -1,
      Key key
    }
  ) : super(key: key);

  @override
  SexyIngredientSliderState createState() => SexyIngredientSliderState();
}

class SexyIngredientSliderState extends State<SexyIngredientSlider> {
  ScrollController _controller = ScrollController();
  bool _canTick = false;
  bool _canUpdate = false;
  double _width = 0;
  Timer _settleTimer;
  int _startingNumber;
  int _sexySliderValue;

  @override
  void initState() {
    _startingNumber = _sexySliderValue = (widget.ingredient.amount * (1 / widget.step)).truncate() + 80;
    _canTick = false;

    WidgetsBinding.instance.addPostFrameCallback((_){
      double duration = Fib.f11.toDouble();
      if(widget.overrideAnimateTo != -1){
        duration = widget.overrideAnimateTo;
      } else if(widget.ingredient.amount > widget.ingredient.ss){
        duration = widget.ingredient.amount / widget.ingredient.ss * Fib.f11.toDouble();
      }
      _animateToSexyIngredientSliderValue(_startingNumber, duration.round());
      Timer(Duration(milliseconds: duration.round() + 1), (){
        _canUpdate = true;
        _canTick = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    if(_settleTimer != null){
      _settleTimer.cancel();
    }
    super.dispose();
  }

  void _tickTimer([int sexySliderValue]){
    if(!_canTick) return;
    if(_settleTimer != null)
      if(_settleTimer.isActive) 
        _settleTimer.cancel();

    _settleTimer = Timer(Duration(milliseconds: Fib.f10), (){
      _animateToSexyIngredientSliderValue(sexySliderValue ?? getSexyIngredientSliderValuefromOffset());
    });
  }

  int getSexyIngredientSliderValuefromOffset(){
    double offset = _controller.offset;

    offset -= _getZeroOffset();

    return (offset / SexyIngredientSlider.tickContainerWidth).round();
  }

  double _getZeroOffset(){
    double microRemainder = ((_width/2) % (SexyIngredientSlider.tickContainerWidth));
    double microStep = (SexyIngredientSlider.tickContainerWidth/2) - microRemainder;

    double midStep = microStep + (10 * SexyIngredientSlider.tickContainerWidth);

    double macroStep = (56 % ((midStep + _width/2) / SexyIngredientSlider.tickContainerWidth).truncate()) * SexyIngredientSlider.tickContainerWidth;

    return midStep + macroStep;
  }

  double _getSexyIngredientSliderValueOffset(int sexySliderValue){
    return _getZeroOffset() + (sexySliderValue * SexyIngredientSlider.tickContainerWidth);
  }

  void _animateToSexyIngredientSliderValue(int sexySliderValue, [int millis = Fib.f11]) async{
    if(sexySliderValue > (widget.max ~/ widget.step)) sexySliderValue = (widget.max * widget.step).toInt();
    if(sexySliderValue < (80 + (widget.min * widget.step))) sexySliderValue = (80 + (widget.min * widget.step)).round();

    try {
      if(mounted)
        await _controller.animateTo(
          _getSexyIngredientSliderValueOffset(sexySliderValue),
          duration: Duration(milliseconds: millis),
          curve: Curves.decelerate
        );
    } catch (e) {
      LOG.log("Sexy slider error: ${e.toString()}", FoodFrenzyDebugging.crash);
    }

  }

  void _changeSexyIngredientSliderValue(int newSexyIngredientSliderValue){

    HapticFeedback.selectionClick();

    if(newSexyIngredientSliderValue >= 0){
      _sexySliderValue = newSexyIngredientSliderValue;
    }
    if(newSexyIngredientSliderValue >= 80){

      widget.onChange(((_sexySliderValue - 80) * widget.step));
    } else {
      widget.onChange(0);
    }
  }

  Widget _buildSlider() {

    return Listener(
      onPointerUp: (ev) {
      },
      child: NotificationListener(
        child: Container(
          child: Stack(
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                itemCount: (widget.max ~/ widget.step) + 80,
                itemBuilder: (BuildContext context, int index){
                  bool isTen = (index % 10 == 0);

                  BoxDecoration decoration = BoxDecoration(
                    color: (widget.auxColor != null) ? widget.auxColor : FoodFrenzyColors.secondary,
                    borderRadius: BorderRadius.circular(SexyIngredientSlider.radius),
                  );

                  BoxDecoration decorationTop = BoxDecoration(
                    color: (widget.auxColor != null) ? widget.auxColor : FoodFrenzyColors.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SexyIngredientSlider.radius),
                      topRight: Radius.circular(SexyIngredientSlider.radius),
                    ),
                  );

                  BoxDecoration decorationBottom = BoxDecoration(
                    color: (widget.auxColor != null) ? widget.auxColor : FoodFrenzyColors.secondary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(SexyIngredientSlider.radius),
                      bottomRight: Radius.circular(SexyIngredientSlider.radius),
                    ),
                  );

                  return Container(
                    width: SexyIngredientSlider.tickContainerWidth,
                    child: Column(
                      children: <Widget>[
                        Container(height: widget.height * SexyIngredientSlider.tickToTopPadding),
                        (isTen) ? 
                          Center(
                            child: Container(
                              width: SexyIngredientSlider.tickWidth,
                              height: widget.height * SexyIngredientSlider.largeTickHeight,
                              decoration: decorationTop
                            ),
                          ) : 
                          Container(
                            height: widget.height * SexyIngredientSlider.smallTickHeight
                          ),
                        (isTen) ? 
                          Container() :
                          Center(
                            child: Container(
                              width: SexyIngredientSlider.tickWidth,
                              height: widget.height * SexyIngredientSlider.smallTickHeight,
                              decoration: decoration
                            ),
                          ),
                        (isTen) ? 
                          Center(
                            child: Container(
                              width: SexyIngredientSlider.tickWidth,
                              height: widget.height * SexyIngredientSlider.smallTickHeight,
                              decoration: decorationBottom
                            ),
                          ) : 
                          Container(),
                      ],
                    ),
                  );
                }
              ),
              Center(
                child: Container(
                  width: SexyIngredientSlider.tickWidth * 1.1,
                  decoration: BoxDecoration(
                    color: (widget.mainColor != null) ? widget.mainColor : FoodFrenzyColors.main,
                    borderRadius: BorderRadius.circular(SexyIngredientSlider.radius),
                  )
                )
              ),
            ]
          ),
        ),
        onNotification: (note){
          if(note is ScrollUpdateNotification){
            int newSexyIngredientSliderValue = getSexyIngredientSliderValuefromOffset();
            if(_sexySliderValue != newSexyIngredientSliderValue && _canUpdate){
              _changeSexyIngredientSliderValue(newSexyIngredientSliderValue);
            }
            _tickTimer();
          }
          return true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.minusSquare,
              color: (widget.auxColor != null) ? widget.auxColor : FoodFrenzyColors.secondary,
            ),
            onPressed: (){
              _animateToSexyIngredientSliderValue(_sexySliderValue - widget.ingredient.ss.round(), Fib.f12);
            }
          ),
          Expanded(
            child: GestureDetector(
              onDoubleTap: (){
                double duration = Fib.f12.toDouble();
                if(widget.ingredient.amount > widget.ingredient.ss){
                  duration = widget.ingredient.amount / widget.ingredient.ss * Fib.f12.toDouble();
                }

                _animateToSexyIngredientSliderValue(widget.ingredient.ss.round() + 80, duration.round());
              },
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){

                  _width = constraints.maxWidth;

                  return Container(
                    height: 55,
                    padding: EdgeInsets.only(bottom: 5),
                    child: _buildSlider(),
                  );
                }
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.plusSquare,
              color: (widget.auxColor != null) ? widget.auxColor : FoodFrenzyColors.secondary,
            ),
            onPressed: (){
              _animateToSexyIngredientSliderValue(_sexySliderValue + widget.ingredient.ss.round(), Fib.f12);
            }
          ),
        ],
      ),
    );
  }
}
