import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(FFWebsite());
}

class FFWebsite extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Frenzy',
      debugShowCheckedModeBanner: false,
      theme: FoodFrenzyTheme.main(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double _screenWidth;
  double _screenHeight;
  double _screenTopPadding;
  double _middleWidth;
  double _topButtonBarWidth;
  double _topButtonBarHeight;
  double _sideDrawerWidth;
  double _sideDrawerHeight;
  double _bottomDrawerHeight;
  double _buttonWidth;

  @override
  void initState() {
    
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void _setDimentions(){
    MediaQueryData query = MediaQuery.of(context);
    _screenWidth = query.size.width;
    _screenHeight = query.size.height;
    _screenTopPadding = query.padding.top;
    _middleWidth = _screenWidth * FoodFrenzyRatios.middleScreenWidthRatio;
    _topButtonBarWidth = _screenWidth;
    _topButtonBarHeight = _topButtonBarWidth * FoodFrenzyRatios.topButtonBarHeightRatio;
    _sideDrawerWidth = _screenWidth * FoodFrenzyRatios.sideDrawerWidthRatio;
    _sideDrawerHeight = _screenHeight - _screenTopPadding;
    _bottomDrawerHeight = _screenHeight * FoodFrenzyRatios.verticalDrawerWidthRatio;
    _buttonWidth = _middleWidth / FoodFrenzyRatios.gold;
  }


  @override
  Widget build(BuildContext context) {


    _setDimentions();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomPopupWhole(
          visable: true,
          topButtonBarWidth: _topButtonBarWidth,
          topButtonBarHeight: _topButtonBarHeight, 
          iconLeft: FontAwesomeIcons.times, 
          onLeft: (){
            CommonAssets.showSnackbar(context, "Double Tap to exit without saving");
          },
          title: "Fitness Frenzy", 
          message: "Hello there", 
          iconRight: FontAwesomeIcons.abacus,
          iconRightEnable: false,
          mainWidget: Container(),
          shouldAnimate: false,
          hasButton: false,
        ),
      ),
    );
  }
}
