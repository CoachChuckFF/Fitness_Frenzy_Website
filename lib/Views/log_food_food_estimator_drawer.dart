/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class LogFoodFoodEstimatorDefines {
  static const feelingUnselected = 0;
  static const feelingHungry = 1;
  static const feelingSatiated = 2;
  static const feelingFull = 3;
  static const feelingStuffed = 4;
  static const feelingSick = 5;

  static const waterUnselected = 0;
  static const water0 = 1;
  static const water1 = 2;
  static const water2 = 3;
  static const water3 = 4;
  static const water4 = 5;
  static const water5 = 6;

  static const alcoholUnselected = 0;
  static const alcoholYes = 1;
  static const alcoholNo = 2;

  static const sweetsUnselected = 0;
  static const sweetsYes = 1;
  static const sweetsNo = 2;

  static const stressedUnselected = 0;
  static const stressedYes = 1;
  static const stressedNo = 2;
}

class LogFoodFoodEstimator extends StatefulWidget {
  final Function(List<Ingredient>) onExit;
  final double screenHeight;
  final double screenWidth;
  final double topButtonBarHeight;
  final double topButtonBarWidth;
  final double buttonWidth;
  final bool visable;

  LogFoodFoodEstimator({
    this.onExit,
    this.screenHeight,
    this.screenWidth,
    this.topButtonBarHeight,
    this.topButtonBarWidth,
    this.buttonWidth,
    this.visable,
  });

  @override
  _LogFoodFoodEstimatorState createState() => _LogFoodFoodEstimatorState();
}

class _LogFoodFoodEstimatorState extends State<LogFoodFoodEstimator> {
  UserState _userState;

  IntBLoC _feelingBloc = IntBLoC();
  IntBLoC _waterBloc = IntBLoC();
  IntBLoC _alcoholBloc = IntBLoC();
  IntBLoC _sweetsBloc = IntBLoC();
  IntBLoC _stressedBloc = IntBLoC();

  @override
  void initState() { 
    
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
    super.initState();
  }

  @override
  void dispose() {
    _feelingBloc.dispose();
    _waterBloc.dispose();
    _alcoholBloc.dispose();
    _sweetsBloc.dispose();
    _stressedBloc.dispose();

    super.dispose();
  }

  List<Ingredient> answersToAmount(){
    if(
      _feelingBloc.state == 0 ||
      _waterBloc.state == 0 ||
      _alcoholBloc.state == 0 ||
      _sweetsBloc.state == 0 ||
      _stressedBloc.state == 0
    ) return [];

    List<Ingredient> ingredients = [];

    double bmr = Calculations.getTDEE(
      isFemale: _userState.isFemale,
      lbs: _userState.lastWeight ?? 150,
      cm: _userState.height,
      yrs: _userState.age,
    );

    //Feeling calc
    Ingredient feeling = Ingredient(
      name: "Feeling ",
      hsu: "",
      hss: 1,
      ss: 1,
      amount: 1,
      cal: 0,
      fat: 0,
      carb: 0,
      prot: 0,
      usesml: false,
    );

    switch(_feelingBloc.state){
      case LogFoodFoodEstimatorDefines.feelingHungry:
        feeling.name += "Hungry";
        feeling.cal = bmr * 0.25;
        break;
      case LogFoodFoodEstimatorDefines.feelingSatiated:
        feeling.name += "Satisfied";
        feeling.cal = bmr * 0.5;
        break;
      case LogFoodFoodEstimatorDefines.feelingFull:
        feeling.name += "Full";
        feeling.cal = bmr * 1;
        break;
      case LogFoodFoodEstimatorDefines.feelingStuffed:
        feeling.name += "Stuffed";
        feeling.cal = bmr * 2;
        break;
      case LogFoodFoodEstimatorDefines.feelingSick:
        feeling.name += "Sick";
        feeling.cal = bmr * 3;
        break;
    }

    ingredients.add(feeling);

    //Water calc
    Ingredient water = Ingredient(
      name: "Water ",
      hsu: "",
      hss: 1,
      ss: 1,
      amount: 1,
      cal: 0,
      fat: 0,
      carb: 0,
      prot: 0,
      usesml: false,
    );

    water.name += (_waterBloc.state - 1).toString() + " Glasses";
    water.cal = ((_waterBloc.state - 1) * 0.05) * feeling.cal * -1;

    ingredients.add(water);

    //Alcohol calc
    Ingredient alcohol = Ingredient(
      name: "Alcohol - ",
      hsu: "",
      hss: 1,
      ss: 1,
      amount: 1,
      cal: 0,
      fat: 0,
      carb: 0,
      prot: 0,
      usesml: false,
    );

    alcohol.name += (_alcoholBloc.state == LogFoodFoodEstimatorDefines.alcoholYes) ? "Yes" : "No";
    alcohol.cal = (_alcoholBloc.state == LogFoodFoodEstimatorDefines.alcoholYes) ? bmr * 0.1 : 0;

    ingredients.add(alcohol);

    //Sweets calc
    Ingredient sweets = Ingredient(
      name: "Sweets - ",
      hsu: "",
      hss: 1,
      ss: 1,
      amount: 1,
      cal: 0,
      fat: 0,
      carb: 0,
      prot: 0,
      usesml: false,
    );

    sweets.name += (_sweetsBloc.state == LogFoodFoodEstimatorDefines.sweetsYes) ? "Yes" : "No";
    sweets.cal = (_sweetsBloc.state == LogFoodFoodEstimatorDefines.sweetsYes) ? bmr * 0.1 : 0;

    ingredients.add(sweets);

    //Sweets calc
    Ingredient stressed = Ingredient(
      name: "Stressed - ",
      hsu: "",
      hss: 1,
      ss: 1,
      amount: 1,
      cal: 0,
      fat: 0,
      carb: 0,
      prot: 0,
      usesml: false,
    );

    stressed.name += (_stressedBloc.state == LogFoodFoodEstimatorDefines.stressedYes) ? "Yes" : "No";
    stressed.cal = (_stressedBloc.state == LogFoodFoodEstimatorDefines.stressedYes) ? bmr * 0.1 : 0;

    ingredients.add(stressed);

    return ingredients;
  }

  Widget _buildBox({bool visable = true, Widget child, Color color, Function onTap, String message}){
    if(!visable) return Container();

    return Container(
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.all(3),
      child: Tooltip(
        preferBelow: false,
        message: message,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: (color == FoodFrenzyColors.jjTransparent) ? [] : CommonAssets.shadow,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion1({int state, Color color}){
    String message = "";

    switch(state){
      case LogFoodFoodEstimatorDefines.feelingHungry:
        message = "Hungry";
        break;
      case LogFoodFoodEstimatorDefines.feelingSatiated:
        message = "Satiated";
        break;
      case LogFoodFoodEstimatorDefines.feelingFull:
        message = "Full";
        break;
      case LogFoodFoodEstimatorDefines.feelingStuffed:
        message = "Stuffed";
        break;
      case LogFoodFoodEstimatorDefines.feelingSick:
        message = "Sick";
        break;
    }

    return Column(
      children: [
        AST(
          "How full do you feel?",
          isBold: true,
          color: FoodFrenzyColors.secondary,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildBox(
                  message: "Hungry",
                  color: (state == LogFoodFoodEstimatorDefines.feelingHungry) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.feelingHungry){
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingUnselected));
                    } else {
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingHungry));
                    }
                  },
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.signalAlt1,
                      color: FoodFrenzyColors.secondary,
                    ),
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "Satiated",
                  color: (state == LogFoodFoodEstimatorDefines.feelingSatiated) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.feelingSatiated){
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingUnselected));
                    } else {
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingSatiated));
                    }
                  },
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.signalAlt2,
                      color: FoodFrenzyColors.secondary,
                    ),
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "Full",
                  color: (state == LogFoodFoodEstimatorDefines.feelingFull) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.feelingFull){
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingUnselected));
                    } else {
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingFull));
                    }
                  },
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.signalAlt3,
                      color: FoodFrenzyColors.secondary,
                    ),
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "Stuffed",
                  color: (state == LogFoodFoodEstimatorDefines.feelingStuffed) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.feelingStuffed){
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingUnselected));
                    } else {
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingStuffed));
                    }
                  },
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.signalAlt,
                      color: FoodFrenzyColors.secondary,
                    ),
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "Sick",
                  color: (state == LogFoodFoodEstimatorDefines.feelingSick) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.feelingSick){
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingUnselected));
                    } else {
                      _feelingBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.feelingSick));
                    }
                  },
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.exclamationTriangle,
                      color: FoodFrenzyColors.secondary,
                    ),
                  )
                ),
              ),
            ]
          ),
        ),
        AST(
          message,
          color: FoodFrenzyColors.secondary,
        ),
        Divider(),
      ],
    );
  }
  
  Widget _buildQuestion2({int state, Color color, bool visable = true}){
    if(!visable) return Container();

    String message = (state == 0) ? "" : "Drinking water helps you feel full!";

    return Column(
      children: [
        AST(
          "How many glasses of water did you drink?",
          isBold: true,
          color: FoodFrenzyColors.secondary,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildBox(
                  message: "No water",
                  color: (state == LogFoodFoodEstimatorDefines.water0) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.water0){
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.waterUnselected));
                    } else {
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.water0));
                    }
                  },
                  child: Center(
                    child: AST(
                      "0",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "1 Glass",
                  color: (state == LogFoodFoodEstimatorDefines.water1) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.water1){
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.waterUnselected));
                    } else {
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.water1));
                    }
                  },
                  child: Center(
                    child: AST(
                      "1",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "2 Glasses",
                  color: (state == LogFoodFoodEstimatorDefines.water2) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.water2){
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.waterUnselected));
                    } else {
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.water2));
                    }
                  },
                  child: Center(
                    child: AST(
                      "2",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "3 Glasses",
                  color: (state == LogFoodFoodEstimatorDefines.water3) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.water3){
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.waterUnselected));
                    } else {
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.water3));
                    }
                  },
                  child: Center(
                    child: AST(
                      "3",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "4 Glasses",
                  color: (state == LogFoodFoodEstimatorDefines.water4) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.water4){
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.waterUnselected));
                    } else {
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.water4));
                    }
                  },
                  child: Center(
                    child: AST(
                      "4",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "5 Glasses",
                  color: (state == LogFoodFoodEstimatorDefines.water5) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.water5){
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.waterUnselected));
                    } else {
                      _waterBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.water5));
                    }
                  },
                  child: Center(
                    child: AST(
                      "5",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
            ]
          ),
        ),
        AST(
          message,
          color: FoodFrenzyColors.secondary,
        ),
        Divider(),
      ],
    );
  }

  Widget _buildQuestion3({int state, Color color, bool visable = true}){
    if(!visable) return Container();

    String message = state == 0 ? "" : "Alcohol makes it easier to eat more";

    return Column(
      children: [
        AST(
          "Was alcohol consumed?",
          isBold: true,
          color: FoodFrenzyColors.secondary,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildBox(
                  message: "Yes",
                  color: (state == LogFoodFoodEstimatorDefines.alcoholYes) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.alcoholYes){
                      _alcoholBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.alcoholUnselected));
                    } else {
                      _alcoholBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.alcoholYes));
                    }
                  },
                  child: Center(
                    child: AST(
                      "Yes",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "No",
                  color: (state == LogFoodFoodEstimatorDefines.alcoholNo) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.alcoholNo){
                      _alcoholBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.alcoholUnselected));
                    } else {
                      _alcoholBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.alcoholNo));
                    }
                  },
                  child: Center(
                    child: AST(
                      "No",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
            ]
          ),
        ),
        AST(
          message,
          color: FoodFrenzyColors.secondary,
        ),
        Divider(),
      ],
    );
  }

  Widget _buildQuestion4({int state, Color color, bool visable = true}){
    if(!visable) return Container();

    String message = state == 0 ? "" : "Sugar can overide your 'Full' hormone";

    return Column(
      children: [
        AST(
          "Sweets, baked goods or sugary drinks?",
          isBold: true,
          color: FoodFrenzyColors.secondary,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildBox(
                  message: "Yes",
                  color: (state == LogFoodFoodEstimatorDefines.sweetsYes) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.sweetsYes){
                      _sweetsBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.sweetsUnselected));
                    } else {
                      _sweetsBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.sweetsYes));
                    }
                  },
                  child: Center(
                    child: AST(
                      "Yes",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "No",
                  color: (state == LogFoodFoodEstimatorDefines.sweetsNo) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.sweetsNo){
                      _sweetsBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.sweetsUnselected));
                    } else {
                      _sweetsBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.sweetsNo));
                    }
                  },
                  child: Center(
                    child: AST(
                      "No",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
            ]
          ),
        ),
        AST(
          message,
          color: FoodFrenzyColors.secondary,
        ),
        Divider(),
      ],
    );
  }

  Widget _buildQuestion5({int state, Color color, bool visable = true}){
    if(!visable) return Container();

    String message = "";

    switch(state){
      case LogFoodFoodEstimatorDefines.stressedNo:
        message = "Great to hear!";
        break;
      case LogFoodFoodEstimatorDefines.stressedYes:
        message = "Deep breaths, you've got this!";
        break;
    }

    return Column(
      children: [
        AST(
          "Have you been feeling stressed out?",
          isBold: true,
          color: FoodFrenzyColors.secondary,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildBox(
                  message: "Yes",
                  color: (state == LogFoodFoodEstimatorDefines.stressedYes) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.stressedYes){
                      _stressedBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.stressedUnselected));
                    } else {
                      _stressedBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.stressedYes));
                    }
                  },
                  child: Center(
                    child: AST(
                      "Yeah",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
              Expanded(
                child: _buildBox(
                  message: "No",
                  color: (state == LogFoodFoodEstimatorDefines.stressedNo) ? color : FoodFrenzyColors.jjTransparent,
                  onTap: (){
                    if(state == LogFoodFoodEstimatorDefines.stressedNo){
                      _stressedBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.stressedUnselected));
                    } else {
                      _stressedBloc.add(IntUpdateEvent(LogFoodFoodEstimatorDefines.stressedNo));
                    }
                  },
                  child: Center(
                    child: AST(
                      "No",
                      color: FoodFrenzyColors.secondary,
                    )
                  )
                ),
              ),
            ]
          ),
        ),
        AST(
          message,
          color: FoodFrenzyColors.secondary,
        ),
        Divider(),
      ],
    );
  }

  Widget _buildAnswer({bool visable = true}){
    if(!visable) return Container();

    return Center(
      child: AST(
        "Almost Done! Dismiss this menu, and drag the arrows icon over to when you started eating!",
        isBold: true,
        color: FoodFrenzyColors.secondary,
        textAlign: TextAlign.center,
        maxLines: 3,
      ),
    );
  }

  Widget _buildHub(){
    return BlocBuilder(
      cubit:_feelingBloc,
      builder: (context, feelingState) {
        return BlocBuilder(
          cubit:_waterBloc,
          builder: (context, waterState) {
            return BlocBuilder(
              cubit:_alcoholBloc,
              builder: (context, alcoholState) {
                return BlocBuilder(
                  cubit:_sweetsBloc,
                  builder: (context, sweetsState) {
                    return BlocBuilder(
                      cubit:_stressedBloc,
                      builder: (context, stressedState) {
                        return Column(
                          children: [
                            Expanded(flex: 2, child: _buildQuestion1(
                              state: feelingState,
                              color: FoodFrenzyColors.jjGreen2,
                            )),
                            Expanded(flex: 2, child: _buildQuestion2(
                              state: waterState,
                              color: FoodFrenzyColors.jjBlue,
                              visable: 
                                feelingState != 0
                            )),
                            Expanded(flex: 2, child: _buildQuestion3(
                              state: alcoholState,
                              color: FoodFrenzyColors.jjYellow,
                              visable: 
                                feelingState != 0 &&
                                waterState != 0
                            )),
                            Expanded(flex: 2, child: _buildQuestion4(
                              state: sweetsState,
                              color: FoodFrenzyColors.jjRed,
                              visable: 
                                feelingState != 0 &&
                                waterState != 0 &&
                                alcoholState != 0
                            )),
                            Expanded(flex: 2, child: _buildQuestion5(
                              state: stressedState,
                              color: FoodFrenzyColors.jjPurple,
                              visable: 
                                feelingState != 0 &&
                                waterState != 0 &&
                                alcoholState != 0 &&
                                sweetsState != 0
                            )),
                            LogButton(
                              icon: FontAwesomeIcons.check,
                              text: "Done",//FoodFrenzyColors.tertiary.withAlpha(100)
                              // disabled: !(feelingState != 0 &&
                              //   waterState != 0 &&
                              //   alcoholState != 0 &&
                              //   sweetsState != 0 &&
                              //   stressedState != 0),
                              color: FoodFrenzyColors.main,
                              onTap: (){
                                if(feelingState != 0 &&
                                waterState != 0 &&
                                alcoholState != 0 &&
                                sweetsState != 0 &&
                                stressedState != 0){
                                  widget.onExit(answersToAmount());
                                } else {
                                  widget.onExit([]);
                                }
                              },
                              width: widget.buttonWidth,
                            ),
                          ],
                        );
                      }
                    );
                  }
                );
              }
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomDrawer(
      width: widget.screenWidth,
      height: widget.screenHeight * FoodFrenzyRatios.verticalTallDrawerWidthRatio,
      screenHeight: widget.screenHeight,
      buttonHeight: widget.topButtonBarHeight,
      child: UserStateView(
        (userState){
          _userState = userState;

          return _buildHub();
        }, onLoading: (){
          return CommonAssets.buildLoader();
        }
      ),
      visable: widget.visable,
      onExit: (){
        widget.onExit(answersToAmount());
      },
    );
  }
}