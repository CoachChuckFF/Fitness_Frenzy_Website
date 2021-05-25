import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class WeightScale extends StatefulWidget {
  static const double tickContainerWidth = 55;
  static const double tickWidth = 5;
  static const double smallTickHeight = 8;
  static const double largeTickHeight = 34;
  static const double tickToTopPadding = 50;
  static const double topPadding = 50;
  static const double radius = 1;
  static const int jumpStep = 100;

  final bool visable;
  final double middleWidth;
  final double buttonWidth;
  final double topButtonBarWidth;
  final double topButtonBarHeight;

  final UserState userState;

  final Function onExit;

  WeightScale({
    this.visable,
    this.middleWidth,
    this.buttonWidth,
    this.topButtonBarWidth,
    this.topButtonBarHeight,
    this.userState,
    this.onExit,
    Key key,
  }) : super(key: key);

  @override
  _WeightScaleState createState() => _WeightScaleState();
}

class _WeightScaleState extends State<WeightScale> {
  DoubleBLoC _weightBloc = DoubleBLoC();
  ScrollController _controller = ScrollController();
  bool _canTick = false;
  Timer _settleTimer;
  int _startingWeight;
  int _weight;

  @override
  void initState() {
    _startingWeight = _weight = (widget.userState.lastWeight * 10).truncate();
    _canTick = false;

    WidgetsBinding.instance.addPostFrameCallback((_){
      animateToWeight(_startingWeight, Fib.f14);
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

  void _tickTimer([int weight]){
    if(!_canTick) return;
    if(_settleTimer != null)
      if(_settleTimer.isActive) 
        _settleTimer.cancel();

    _settleTimer = Timer(Duration(milliseconds: Fib.f10), (){
      animateToWeight(weight ?? getWeightfromOffset());
    });
  }

  int getWeightfromOffset(){
    double offset = _controller.offset;

    offset -= _getZeroOffset();

    return (offset / WeightScale.tickContainerWidth).round();
  }

  double _getZeroOffset(){
    double microRemainder = ((widget.middleWidth/2) % (WeightScale.tickContainerWidth));
    double microStep = (WeightScale.tickContainerWidth/2) - microRemainder;

    double midStep = microStep + (10 * WeightScale.tickContainerWidth);

    double macroStep = (59 % ((midStep + widget.middleWidth/2) / WeightScale.tickContainerWidth).truncate()) * WeightScale.tickContainerWidth;

    return midStep + macroStep;
  }

  double _getWeightOffset(int weight){
    return _getZeroOffset() + (weight * WeightScale.tickContainerWidth);
  }

  void animateToWeight(int weight, [int millis = Fib.f11]) async{
    if(weight > 9000) weight = 9000;
    if(weight < 80) weight = 80;
    await _controller.animateTo(
      _getWeightOffset(weight),
      duration: Duration(milliseconds: millis),
      curve: Curves.decelerate
    );
  }

  void changeWeight(int newWeight){
    if(newWeight >= 0){
      _weight = newWeight;
    }
    
    HapticFeedback.selectionClick();

    double visableWeight = (_weight.toDouble() / 10);
    // if(!widget.userState.prefersMetric){
    //   visableWeight = Calculations.kgToLbs(visableWeight);
    // }

    _weightBloc.add(DoubleUpdateEvent(visableWeight));

  }

  void _logWeight() {
    double loggedWeight = _weight.toDouble() / 10;

    UserLog.getTodaysLog().then((log) async{
      await widget.userState.updateLastWeight(loggedWeight);
      await UserPoints.updateLastWeight(loggedWeight);
      await UserLog.updateTodaysWeight(loggedWeight).then((_) async{
        if(log.weight == null){ //Only Update Points when log is updated
          await UserPoints.handlePoints(log, UserPoints.lwIndex);
        }
      });
    });
  }

  Widget _buildLogWeightTopButtonBar(){
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 13, right: 13),
        width: widget.topButtonBarWidth,
        height: widget.topButtonBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.kitchen, color: FoodFrenzyColors.jjTransparent),
              onPressed: (){}
            ),
            Expanded(
              child: Center(
                child: AST(
                  "Log Weight (lbs)",//"Log Weight (${widget.userState.prefersMetric ? "Kg" : "Lbs"})", 
                  color: FoodFrenzyColors.secondary,
                  isBold: true,
                  size: 21,
                ),
              ),
            ),
            IconButton(
              //TODO get a kg and lbs icon
              icon: Icon(Icons.kitchen, color: FoodFrenzyColors.jjTransparent),
              onPressed: (){
                //widget.userState.updatePrefersMetric(!widget.userState.prefersMetric);
              }
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildScale(){
    return Listener(
      onPointerUp: (ev) {
      },
      child: NotificationListener(
        child: Container(
          child: Column(
            children: [
              Container(height: WeightScale.topPadding),
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      itemCount: 10000,
                      itemBuilder: (BuildContext context, int index){
                        bool isTen = (index % 10 == 0);

                        BoxDecoration decoration = BoxDecoration(
                          color: FoodFrenzyColors.secondary,
                          borderRadius: BorderRadius.circular(WeightScale.radius),
                        );

                        BoxDecoration decorationTop = BoxDecoration(
                          color: FoodFrenzyColors.secondary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(WeightScale.radius),
                            topRight: Radius.circular(WeightScale.radius),
                          ),
                        );

                        BoxDecoration decorationBottom = BoxDecoration(
                          color: FoodFrenzyColors.secondary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(WeightScale.radius),
                            bottomRight: Radius.circular(WeightScale.radius),
                          ),
                        );

                        return Container(
                          width: WeightScale.tickContainerWidth,
                          child: Column(
                            children: <Widget>[
                              Container(height: WeightScale.tickToTopPadding),
                              (isTen) ? 
                                Center(
                                  child: Container(
                                    width: WeightScale.tickWidth,
                                    height: WeightScale.largeTickHeight,
                                    decoration: decorationTop
                                  ),
                                ) : 
                                Container(
                                  height: WeightScale.largeTickHeight - WeightScale.smallTickHeight
                                ),
                              (isTen) ? 
                                Container() :
                                Center(
                                  child: Container(
                                    width: WeightScale.tickWidth,
                                    height: WeightScale.smallTickHeight,
                                    decoration: decoration
                                  ),
                                ),
                              (isTen) ? 
                                Center(
                                  child: Container(
                                    width: WeightScale.tickWidth,
                                    height: WeightScale.smallTickHeight * 3,
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
                        width: WeightScale.tickWidth,
                        decoration: BoxDecoration(
                          color: FoodFrenzyColors.main,
                          borderRadius: BorderRadius.circular(WeightScale.radius),
                        )
                      )
                    ),
                  ]
                ),
              ),
              Expanded(child: Container(),),
              // Expanded(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       IconButton(
              //         icon: Icon(
              //           FontAwesomeIcons.minus,
              //           color: FoodFrenzyColors.main,
              //         ), 
              //         onPressed: (){
              //           int step = _weight % WeightScale.jumpStep;
              //           if(step == 0) step = WeightScale.jumpStep;

              //           animateToWeight(_weight - step);
              //         }
              //       ),
              //       IconButton(
              //         icon: Icon(
              //           FontAwesomeIcons.alignCenter,
              //           color: FoodFrenzyColors.main,
              //         ), 
              //         onPressed: (){
              //           animateToWeight(_startingWeight);
              //         }
              //       ),
              //       IconButton(
              //         icon: Icon(
              //           FontAwesomeIcons.plus,
              //           color: FoodFrenzyColors.main,
              //         ), 
              //         onPressed: (){
              //           int step = WeightScale.jumpStep - (_weight % WeightScale.jumpStep);
              //           if(step == 0) step = WeightScale.jumpStep;

              //           animateToWeight(_weight + step);
              //         }
              //       ),
              //     ]
              //   ),
              // )
            ],
          ),
        ),
        onNotification: (note){
          if(note is ScrollUpdateNotification){
            int newWeight = getWeightfromOffset();
            if(_weight != newWeight){
              changeWeight(newWeight);
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

    return GestureDetector(
      onHorizontalDragStart: (_){},
      child: Container(
        color: FoodFrenzyColors.jjTransparent,
        child: CustomPopupSplit(
          visable: widget.visable,
          middleWidth: widget.middleWidth,
          buttonWidth: widget.buttonWidth,
          topButtonBar: _buildLogWeightTopButtonBar(),
          topWidget: 
          Center(
            child: BlocBuilder(
              cubit:_weightBloc,
              builder: (context, weight) {
                return AST(
                  weight.toStringAsFixed(1),
                  color: FoodFrenzyColors.secondary,
                  size: 72,
                );
              }
            ),
          ),
          bottomWidget: _buildScale(),
          bottomButtonTitle: "Log",
          bottomButtonIcon: FontAwesomeIcons.save,
          onExit: (){
            _logWeight();
            widget.onExit();
          },
        ),
      ),
    );
  }
} 