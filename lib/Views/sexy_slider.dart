import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';

//TODO fix the starting at "0" thing - it comes from the 56 % in macro step

class SexySlider extends StatefulWidget {
  static const double tickContainerWidth = 55;
  static const double tickWidth = 5;
  static const double smallTickHeight = 0.3;
  static const double largeTickHeight = 0.8 - smallTickHeight;
  static const double tickToTopPadding = 0.1;
  static const double topPadding = 50;
  static const double radius = 1;
  static const int jumpStep = 100;

  final double width;
  final double height;
  final double startingNumber;
  final double min;
  final double max;
  final double step;
  final Color mainColor;
  final Color auxColor;
  final Function(double) onChange;

  SexySlider(
    this.width, 
    this. startingNumber,
    this.onChange, 
    {
      this.height = 50, 
      this.min = 0, 
      this.max = 500, 
      this.step = 0.1, 
      this.mainColor,
      this.auxColor,
      Key key
    }
  ) : super(key: key);

  @override
  SexySliderValueScaleState createState() => SexySliderValueScaleState();
}

class SexySliderValueScaleState extends State<SexySlider> {
  ScrollController _controller = ScrollController();
  bool _canTick = false;
  Timer _settleTimer;
  int _startingNumber;
  int _sexySliderValue;

  @override
  void initState() {
    _startingNumber = _sexySliderValue = (widget.startingNumber * (1 / widget.step)).truncate() + 80;
    _canTick = false;

    WidgetsBinding.instance.addPostFrameCallback((_){
      _animateToSexySliderValue(_startingNumber, Fib.f14);
      Timer(Duration(milliseconds: Fib.f14 + 1), (){
        _canTick = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _settleTimer.cancel();
    super.dispose();
  }

  void _tickTimer([int sexySliderValue]){
    if(!_canTick) return;
    if(_settleTimer != null)
      if(_settleTimer.isActive) 
        _settleTimer.cancel();

    _settleTimer = Timer(Duration(milliseconds: Fib.f10), (){
      _animateToSexySliderValue(sexySliderValue ?? getSexySliderValuefromOffset());
    });
  }

  int getSexySliderValuefromOffset(){
    double offset = _controller.offset;

    offset -= _getZeroOffset();

    return (offset / SexySlider.tickContainerWidth).round();
  }

  double _getZeroOffset(){
    double microRemainder = ((widget.width/2) % (SexySlider.tickContainerWidth));
    double microStep = (SexySlider.tickContainerWidth/2) - microRemainder;

    double midStep = microStep + (10 * SexySlider.tickContainerWidth);

    double macroStep = (56 % ((midStep + widget.width/2) / SexySlider.tickContainerWidth).truncate()) * SexySlider.tickContainerWidth;

    return midStep + macroStep;
  }

  double _getSexySliderValueOffset(int sexySliderValue){
    return _getZeroOffset() + (sexySliderValue * SexySlider.tickContainerWidth);
  }

  void _animateToSexySliderValue(int sexySliderValue, [int millis = Fib.f11]) async{
    if(sexySliderValue > (widget.max ~/ widget.step)) sexySliderValue = (widget.max * widget.step).toInt();
    if(sexySliderValue < 80) sexySliderValue = 80;
    await _controller.animateTo(
      _getSexySliderValueOffset(sexySliderValue),
      duration: Duration(milliseconds: millis),
      curve: Curves.decelerate
    );
  }

  void animateToSexySliderValue(double value){
    double diffrence = widget.startingNumber - value;

    if(diffrence == 0) return;

    int sliderValue = (diffrence * (1 / widget.step)).truncate() + 80;
    _animateToSexySliderValue(sliderValue);
  }

  void changeSexySliderValue(int newSexySliderValue){

    HapticFeedback.selectionClick();

    if(newSexySliderValue >= 0){
      _sexySliderValue = newSexySliderValue;
    }
    if(newSexySliderValue >= 80){
      widget.onChange(((_sexySliderValue - 80) * widget.step) + widget.min);
    } else {
      widget.onChange(0 + widget.min);
    }
  }

  @override
  Widget build(BuildContext context) {

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
                    borderRadius: BorderRadius.circular(SexySlider.radius),
                  );

                  BoxDecoration decorationTop = BoxDecoration(
                    color: (widget.auxColor != null) ? widget.auxColor : FoodFrenzyColors.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SexySlider.radius),
                      topRight: Radius.circular(SexySlider.radius),
                    ),
                  );

                  BoxDecoration decorationBottom = BoxDecoration(
                    color: (widget.auxColor != null) ? widget.auxColor : FoodFrenzyColors.secondary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(SexySlider.radius),
                      bottomRight: Radius.circular(SexySlider.radius),
                    ),
                  );

                  return Container(
                    width: SexySlider.tickContainerWidth,
                    child: Column(
                      children: <Widget>[
                        Container(height: widget.height * SexySlider.tickToTopPadding),
                        (isTen) ? 
                          Center(
                            child: Container(
                              width: SexySlider.tickWidth,
                              height: widget.height * SexySlider.largeTickHeight,
                              decoration: decorationTop
                            ),
                          ) : 
                          Container(
                            height: widget.height * SexySlider.smallTickHeight
                          ),
                        (isTen) ? 
                          Container() :
                          Center(
                            child: Container(
                              width: SexySlider.tickWidth,
                              height: widget.height * SexySlider.smallTickHeight,
                              decoration: decoration
                            ),
                          ),
                        (isTen) ? 
                          Center(
                            child: Container(
                              width: SexySlider.tickWidth,
                              height: widget.height * SexySlider.smallTickHeight,
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
                  width: SexySlider.tickWidth * 1.1,
                  decoration: BoxDecoration(
                    color: (widget.mainColor != null) ? widget.mainColor : FoodFrenzyColors.main,
                    borderRadius: BorderRadius.circular(SexySlider.radius),
                  )
                )
              ),
            ]
          ),
        ),
        onNotification: (note){
          if(note is ScrollUpdateNotification){
            int newSexySliderValue = getSexySliderValuefromOffset();
            if(_sexySliderValue != newSexySliderValue){
              changeSexySliderValue(newSexySliderValue);
            }
            _tickTimer();
          }
          return true;
        },
      ),
    );
  }
}
