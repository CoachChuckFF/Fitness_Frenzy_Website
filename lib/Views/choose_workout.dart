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

class ChooseWorkout extends StatefulWidget {
  final Function onExit;

  ChooseWorkout({
    this.onExit,
  });

  @override
  _StatsPageState createState() => _StatsPageState();
}

//TODO sort by type and name

class _StatsPageState extends State<ChooseWorkout> {
  DrawerStateBLoC _drawerBloc = DrawerStateBLoC();

  double _screenWidth;
  double _screenHeight;
  double _middleWidth;
  double _topButtonBarWidth;
  double _topButtonBarHeight;
  double _buttonWidth;

  StringBLoC _selectedUserBloc = StringBLoC();

  UserState _userState;

  @override
  void initState() { 

    super.initState();
  }

  @override
  void dispose() {
    _drawerBloc.dispose();
    _selectedUserBloc.dispose();
    super.dispose();
  }

  void _setDimentions(){
    MediaQueryData query = MediaQuery.of(context);
    _screenWidth = query.size.width;
    _screenHeight = query.size.height;
    _middleWidth = _screenWidth * FoodFrenzyRatios.middleScreenWidthRatio;
    _topButtonBarWidth = _screenWidth;
    _topButtonBarHeight = _topButtonBarWidth * FoodFrenzyRatios.topButtonBarHeightRatio;
    _buttonWidth = _middleWidth / FoodFrenzyRatios.gold;
  }

  Widget _buildWorkoutTile(Workout workout){
    int exerciseCount = 0;

    for(Exercise exercise in workout.exercises){
      if(exercise.type != "Note" && exercise.type != "Rest"){
        exerciseCount++;
      }
    }

    return Center(
      child: GestureDetector(
        onTap: (){
          Navigator.pushReplacementNamed(
            context, 
            (workout.type == Workout.countdownType) ?
              FoodFrenzyRoutes.countdownWorkoutPlayer : 
              FoodFrenzyRoutes.traditionalWorkoutPlayer,
            arguments: workout,
          );
        },
        child: Container(
          height: _screenHeight * 0.1,
          width: _screenWidth * 0.8,
          margin: EdgeInsets.only(bottom: 13),
          decoration: BoxDecoration(
            color: FoodFrenzyColors.tertiary,
            boxShadow: CommonAssets.shadow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Container(
              child: Row(
                children: [
                  Container(width: 15,),
                  Icon(
                    (workout.type == Workout.countdownType) ?
                      FontAwesomeIcons.stopwatch :
                      FontAwesomeIcons.dumbbell,
                    color: FoodFrenzyColors.secondary,
                    size: 34,
                  ),
                  Container(width: 15,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: AST(
                            workout.name,
                            color: FoodFrenzyColors.secondary,
                            isBold: true,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: AST(
                                  exerciseCount.toString() + " Exercise${exerciseCount == 1 ? '' : 's'}",
                                  color: FoodFrenzyColors.secondary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: AST(
                                  (workout.type == Workout.countdownType) ? TextHelpers.secondsToTimerString((workout.time == -1) ? 0 : workout.time) : '',
                                  color: FoodFrenzyColors.secondary,
                                  textAlign: TextAlign.center
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  )),
                  Container(width: 15,),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutList(bool isMe, List<Workout> workouts, String name, {bool isMine = false, bool isBuddy = false, bool isGlobal = false}){

    String title = "";

    if(isMe){
      if(name == "Me" && isMine){
        title = "My Workouts";
      } else if(name == "Global" && isGlobal){
        title = "Fitness Frenzy Training\nD1-D5 1/Week\nCardio 3/Week";
      } else if(name != "Me" && name != "Global" && isBuddy){
        title = "Workouts $name made for me";
      } else {
        return Container();
      }
    } else {
      title = "$name's Workouts";
    }


    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: AST(
            title,
            color: FoodFrenzyColors.secondary,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ),
        for(Workout workout in workouts)
          _buildWorkoutTile(workout)
      ],
    );
  }

  Widget _buildHub(){
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: BlocBuilder(
          cubit: _selectedUserBloc,
          builder: (context, String buddy) {
            return Column(
              children: [
                CommonAssets.buildAccountabilibuddyBar(_userState, buddy, (uid){
                  _selectedUserBloc.add(StringUpdateEvent(uid));
                }),
                Container(height: 8,),
                Expanded(
                  child: LoggableWorkoutsView(
                    (workoutMap){
                      return Column(
                        children: [
                          if(workoutMap.isNotEmpty)
                            Expanded(
                              child: ShaderMask(
                              shaderCallback: (Rect rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [FoodFrenzyColors.tertiary, Colors.transparent, Colors.transparent, FoodFrenzyColors.tertiary,],
                                  stops: [0.0, 0.05, 0.95, 1.0], // 10% purple, 80% transparent, 10% purple
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstOut,
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                  children: [
                                    if(workoutMap.keys.contains("Me"))
                                      if(workoutMap["Me"].isNotEmpty)
                                        _buildWorkoutList(buddy.isEmpty, workoutMap["Me"], "Me", isMine: true),
                                    for(String key in workoutMap.keys)
                                      _buildWorkoutList(buddy.isEmpty, workoutMap[key], key, isBuddy: true),
                                    if(workoutMap.keys.contains('Global'))
                                      if(workoutMap["Global"].isNotEmpty)
                                        _buildWorkoutList(buddy.isEmpty, workoutMap['Global'], 'Global', isGlobal: true)
                                  ]
                                ),
                              ),
                            ),
                          if(workoutMap.isEmpty)
                            Expanded(
                              child: Center(
                                child: AST(
                                  (_selectedUserBloc.state.isEmpty) ?
                                    "You have no workouts saved!" :
                                    "${_userState.accountabilibuddies[_selectedUserBloc.state]} has no saved workouts!",
                                    color: FoodFrenzyColors.secondary,
                                )
                              ),
                            ),
                        ],
                      );
                    }, 
                    _userState.accountabilibuddies, 
                    _userState.uid,
                    buddy: (buddy.isEmpty) ? null : buddy,
                    onLoading: (){
                      return CommonAssets.buildLoader();
                    },
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildMain(){
    return BlocBuilder(
      cubit:_drawerBloc,
      builder: (BuildContext context, Map<String, bool> visable){
        if(visable.containsValue(true)){return Container();}

        return GestureDetector(
          onHorizontalDragStart: (_){},
          child: Container(
            color: FoodFrenzyColors.jjTransparent,
            child: CustomPopupWhole(
              visable: true,
              topButtonBarHeight: _topButtonBarHeight,
              topButtonBarWidth: _topButtonBarWidth,
              topButtonBarHasShadow: false,
              iconLeft: FontAwesomeIcons.sortAlphaDown,
              iconLeftEnable: false,
              title: "Log Workout",
              message: "You fount +5 GAINZ",
              iconRight: FontAwesomeIcons.sortAlphaDown,
              iconRightEnable: false,
              mainWidget: _buildHub(),
              bottomButtonIcon: FontAwesomeIcons.arrowLeft,
              onExit: (){
                widget.onExit();
              },
              bottomButtonTitle: "Return",
              buttonWidth: _buttonWidth,
              middleWidth: _middleWidth,
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    _setDimentions();

    return UserStateStreamView((userState){
      _userState = userState;

      return _buildMain();

    },onLoading: (){
      return CommonAssets.buildLoader();
    });
  }
}