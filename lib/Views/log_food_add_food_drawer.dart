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

class LogFoodAddFoodDrawerDefines {
  static const int main = 0;
  static const int ingredientEntry = 1;
  static const int ingredients = 2;
}

class LogFoodAddFoodDrawer extends StatefulWidget {
  final Function(List<Ingredient>) onExit;
  final double screenHeight;
  final double screenWidth;
  final double topButtonBarHeight;
  final double topButtonBarWidth;
  final double buttonWidth;
  final bool visable;
  final UserState state;
  final List<Ingredient> ingredients;

  LogFoodAddFoodDrawer({
    this.onExit,
    this.screenHeight,
    this.screenWidth,
    this.topButtonBarHeight,
    this.topButtonBarWidth,
    this.buttonWidth,
    this.state,
    this.visable,
    this.ingredients,
  });

  @override
  _LogFoodAddFoodDrawerState createState() => _LogFoodAddFoodDrawerState();
}

class _LogFoodAddFoodDrawerState extends State<LogFoodAddFoodDrawer> {
  ScrollController _scrollController = ScrollController();
  IngredientAggregate _aggregate;
  IngredientListStateBLoC _ingredientsBloc;
  SearchStateBLoC _searchBloc = SearchStateBLoC();
  UserCommonIngredients _commonIngredients = UserCommonIngredients();
  SelectedStateBLoC _selectedBloc = SelectedStateBLoC();
  BoolBLoC _sentRequest = BoolBLoC(false);
  IntBLoC _stateBloc = IntBLoC();

  bool _scrollShowing = false;
  String _upc;
  int _favListLength = 0;

  @override
  void initState() { 
    _ingredientsBloc = (widget.ingredients != null) ? IngredientListStateBLoC(widget.ingredients) : IngredientListStateBLoC();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for(Ingredient ingredient in widget.ingredients){
        _selectedBloc.add(SelectedStateToggleEvent(SelectedIngredient.fromIngredient(ingredient)));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _ingredientsBloc.dispose();
    _stateBloc.dispose();
    _searchBloc.dispose();
    _selectedBloc.dispose();
    _scrollController.dispose();
    _sentRequest.dispose();
    super.dispose();
  }

  void _addToStaging(){

    _sentRequest.add(BoolUpdateEvent(false));
    _searchBloc.add(SearchClearStateEvent());

    _selectedBloc.state.forEach((selected){
      var add = true;
      for (var item in _ingredientsBloc.state) {
        if(item.name == selected){add = false; break;}
        if(item.upc == selected){add = false; break;}
      }

      if(add){
        if(_commonIngredients.database.containsKey(selected.docName)){ //common
          _ingredientsBloc.add(IngredientListStateAddIngredientEvent(
            _commonIngredients.database[selected.docName], 
          ));

          UserCommonIngredients.updateIngredient(_commonIngredients.database[selected.docName]);
        } else { //grab from database
          Ingredient.firebase.getDocument(selected.docName).then((ingredient){
            _ingredientsBloc.add(IngredientListStateAddIngredientEvent(
              ingredient, 
            ));

            UserCommonIngredients.updateIngredient(ingredient);
          });
        }

        
      }
    });
  }


  Widget _buildMealIngredient(Ingredient ingredient, Color color){
    double amount = ingredient.amount;
    double householdAmount = ingredient.hsses;
    double cal = ingredient.cals;
    double fat = ingredient.fats;
    double carb = ingredient.carbs(useAlc: widget.state.convertAlc);
    double prot = ingredient.prots;

    return Container(
      decoration: BoxDecoration(
        color: FoodFrenzyColors.tertiary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: CommonAssets.shadow
      ),
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Container(
        child: Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(ingredient.name + "+" + "Add Food"),
          background: Container(
            decoration: BoxDecoration(
              color: FoodFrenzyColors.main,
              borderRadius: BorderRadius.circular(8),
              boxShadow: CommonAssets.shadow
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.fromLTRB(13, 13, 21, 13),
                child: Icon(
                  FontAwesomeIcons.trash,
                  color: FoodFrenzyColors.tertiary,
                  size: 34,
                ),
              ),
            ),
          ),
          dismissThresholds: {
            DismissDirection.startToEnd: 0.8,
            DismissDirection.endToStart: 0.8,
          },
          onDismissed: (direction){
            _selectedBloc.add(SelectedStateUnselectEvent(SelectedIngredient.fromIngredient(ingredient)));
            _ingredientsBloc.add(IngredientListStateRemoveIngredientEvent(
              ingredient,
            ));
          },
          child: Container(
            // color: FoodFrenzyColors.secondary,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    // _ingredient = ingredient;
                    // if(_drawerBloc.canOpen()){
                    //   _drawerBloc.add(DrawerStateSetEvent("Nutrition Label"));
                    // }
                  },
                  child: Container(
                    child: Container(
                      // padding: EdgeInsets.only(
                      //   left: 13,
                      //   right: 13,
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onHorizontalDragStart: (_){},
                            child: Container(
                              color: FoodFrenzyColors.jjTransparent,
                              height: 5,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onHorizontalDragStart: (_){},
                                child: Container(
                                  color: FoodFrenzyColors.jjTransparent,
                                  width: 13,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onHorizontalDragStart: (_){},
                                  child: Container(
                                    color: FoodFrenzyColors.jjTransparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: AST(
                                            ingredient.name,
                                            color: FoodFrenzyColors.secondary,
                                            textAlign: TextAlign.left,
                                            minSize: 15,
                                            size: 21,
                                          ),
                                        ),
                                        Expanded(
                                          child: AST(
                                            householdAmount.toStringAsFixed(1) + "*" + ingredient.hsu + " (${amount.round()}${(ingredient.usesml) ? 'ml' : 'g'})",
                                            color: FoodFrenzyColors.secondary,
                                            textAlign: TextAlign.right,
                                            size: 18,
                                          ),
                                        ),
                                        Container(width: 5),
                                      ]
                                    ),
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "Swipe left to delete",
                                preferBelow: false,
                                child: GestureDetector(
                                  onTap: (){
                                    CommonAssets.showSnackbar(context, "Swipe left to delete");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(

                                      color: FoodFrenzyColors.tertiary,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: CommonAssets.shadow
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.arrowFromRight,
                                          size: 18,
                                          color: FoodFrenzyColors.secondary,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.trash,
                                          size: 18,
                                          color: FoodFrenzyColors.secondary,
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: FoodFrenzyColors.jjTransparent,
                                width: 13,
                              ),
                            ]
                          ),
                          GestureDetector(
                            onHorizontalDragStart: (_){},
                            child: Container(
                              color: FoodFrenzyColors.jjTransparent,
                              height: 5,
                            ),
                          ),
                          GestureDetector(
                            onHorizontalDragStart: (_){},
                            child: Container(
                              padding: EdgeInsets.only(left: 13, right: 13),
                              color: FoodFrenzyColors.jjTransparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: AST(
                                      cal.round().toString() + "cal",
                                      color: FoodFrenzyColors.secondary,
                                      size: 21,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: AST(
                                      fat.round().toString() + "f",
                                      color: FoodFrenzyColors.secondary,
                                      size: 21,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: AST(
                                      carb.round().toString() + "c",
                                      color: FoodFrenzyColors.secondary,
                                      size: 21,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: AST(
                                      prot.round().toString() + "p",
                                      color: FoodFrenzyColors.secondary,
                                      size: 21,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ),
                          GestureDetector(
                            onHorizontalDragStart: (_){},
                            child: Container(
                              color: FoodFrenzyColors.jjTransparent,
                              height: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onHorizontalDragStart: (_){},
                  child: Container(
                    color: FoodFrenzyColors.jjTransparent,
                    child: SexyIngredientSlider(
                      ingredient: ingredient,
                      onChange: (newAmount){
                        _ingredientsBloc.add(
                          IngredientListStateUpdateIngredientAmountEvent(
                            newAmount,
                            ingredient,
                          )
                        );
                      },
                      min: 1.0,
                      max: Fib.f20.toDouble(),
                      mainColor: FoodFrenzyColors.main,
                      auxColor: FoodFrenzyColors.secondary.withAlpha(200),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainHub(){
    return Column(
      children: [
        Expanded(
          child: BlocBuilder(
            cubit:_ingredientsBloc,
            builder: (context, ingredients) {
              return Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: FoodFrenzyColors.tertiary,
                  //   borderRadius: BorderRadius.circular(8),
                  //   boxShadow: CommonAssets.shadow,
                  // ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: 
                              (ingredients.length != 0) ?
                              ShaderMask(
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
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  physics: ClampingScrollPhysics(),
                                  children: [
                                    for(var ingredient in ingredients) _buildMealIngredient(ingredient, FoodFrenzyColors.secondary),
                                  ],
                                ),
                              ) :
                              Container(
                                padding: EdgeInsets.all(21),
                                child: Center(
                                  child: AST(
                                    "Empty List",
                                    color: FoodFrenzyColors.secondary,
                                  ),
                                ),
                              ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(13),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    _stateBloc.add(IntUpdateEvent(LogFoodAddFoodDrawerDefines.ingredients));
                                  },
                                  child: Container(
                                    color: FoodFrenzyColors.jjTransparent,
                                    child: Center(
                                      child: Container(
                                        width: widget.buttonWidth / FoodFrenzyRatios.gold,
                                        decoration: BoxDecoration(
                                          boxShadow: CommonAssets.shadow,
                                          color: FoodFrenzyColors.tertiary,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        padding: EdgeInsets.fromLTRB(13, 8, 13, 8),
                                        child: Icon(
                                          FontAwesomeIcons.plus,
                                          color: FoodFrenzyColors.secondary,
                                          size: 34,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    // Scanner.scan(
                                    //   onCancel: (){
                                    //   },
                                    //   onError: (error){
                                    //     LOG.log(error, FoodFrenzyDebugging.crash);
                                    //     CommonAssets.showSnackbar(context, "Bad Barcode");
                                    //   },
                                    //   onNotFound: (upc){
                                    //     _upc = upc;
                                    //     _stateBloc.add(IntUpdateEvent(LogFoodAddFoodDrawerDefines.ingredientEntry));
                                    //   },
                                    //   onFound: (ingredient){
                                    //     _ingredientsBloc.add(IngredientListStateAddIngredientEvent(
                                    //       ingredient, 
                                    //     ));
                                    //     UserCommonIngredients.updateIngredient(ingredient);
                                    //   }
                                    // );
                                  },
                                  child: Container(
                                    color: FoodFrenzyColors.jjTransparent,
                                    child: Center(
                                      child: Container(
                                        width: widget.buttonWidth / FoodFrenzyRatios.gold,
                                        decoration: BoxDecoration(
                                          boxShadow: CommonAssets.shadow,
                                          color: FoodFrenzyColors.tertiary,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        padding: EdgeInsets.fromLTRB(13, 8, 13, 8),
                                        child: Icon(
                                          FontAwesomeIcons.barcode,
                                          color: FoodFrenzyColors.secondary,
                                          size: 34,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ),
                            ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
        Center(
          child: LogButton(
            icon: FontAwesomeIcons.check,
            text: "Done",
            color: FoodFrenzyColors.main,
            onTap: (){
              widget.onExit(_ingredientsBloc.state);
            },
            width: widget.buttonWidth,
          ),
        )
        // Center(
        //   child: LogSplitButton(
        //     colorLeft: FoodFrenzyColors.main,
        //     colorRight: FoodFrenzyColors.main,
        //     iconLeft: Icons.add,
        //     iconRight: FontAwesomeIcons.barcode,
        //     width: widget.buttonWidth,
        //     onTapLeft: (){
        //       _stateBloc.add(IntUpdateEvent(LogFoodAddFoodDrawerDefines.ingredients));
        //     },
        //     onTapRight: (){
        //       Scanner.scan(
        //         onCancel: (){
        //         },
        //         onError: (error){
        //           LOG.log(error, FoodFrenzyDebugging.crash);
        //         },
        //         onNotFound: (upc){
                  
        //           _upc = upc;
        //           _stateBloc.add(IntUpdateEvent(LogFoodAddFoodDrawerDefines.ingredientEntry));
        //         },
        //         onFound: (ingredient){
        //           _ingredientsBloc.add(IngredientListStateAddIngredientEvent(
        //             ingredient, 
        //           ));
        //           UserCommonIngredients.updateIngredient(ingredient);
        //         }
        //       );
        //     },
        //   )
        // ),
      ],
    );
  }


  List<Ingredient> _getCommonSearchResults(UserCommonIngredients ingredients){
    List<Ingredient> list = [];
    List<String> selectedTags = [];


    list.addAll(ingredients.database.values.where((ingredient){
      if(_searchBloc.state["Search"] == "All"){
        return true;
      } else {
        return TextHelpers.matchExactString(_searchBloc.state["Search"], ingredient.name);
      }
    }));

    if(selectedTags.length != 0){
      list.removeWhere((ingredient){
        return (!(
          selectedTags.contains(ingredient.tag1) ||
          selectedTags.contains(ingredient.tag2) ||
          selectedTags.contains(ingredient.tag3) ||
          selectedTags.contains(ingredient.tag4) ||
          selectedTags.contains(ingredient.tag5)
        ));
      });
    }

    return list..sort((a, b){
      return b.lastUsed.compareTo(a.lastUsed);
    });
  }

  List<Ingredient> _getSearchResults(UserCommonIngredients common){
    List<Ingredient> list = [];
    List<Ingredient> selectedList = [];
    List<Ingredient> commonBaseList = _getCommonSearchResults(common);
    List<Ingredient> commonList = [];
    List<Ingredient> commonSelectedList = [];

    _aggregate.database.values.forEach((ingredient) {
      if(!common.database.keys.contains(ingredient.name)){
        if(_searchBloc.state["Search"] == "All"){
          if(_selectedBloc.state.contains(ingredient.name)){
            selectedList.add(Ingredient.fromAggregate(ingredient));
          } else {
            list.add(Ingredient.fromAggregate(ingredient));
          }
        } else {
          if(TextHelpers.matchExactString(_searchBloc.state["Search"], ingredient.name)){
            if(_selectedBloc.state.contains(ingredient.name)){
              selectedList.add(Ingredient.fromAggregate(ingredient));
            } else {
              list.add(Ingredient.fromAggregate(ingredient));
            }
          }
        }
      }
    });

    //Generate Common List
    for (var ingredient in commonBaseList) {
      if(_selectedBloc.state.contains(SelectedIngredient.fromIngredient(ingredient))){
        commonSelectedList.add(ingredient);
      } else {
        commonList.add(ingredient);
      }
    }

    //Add to selected list
    selectedList.insertAll(0, commonSelectedList);

    //Alphabatise lists
    list.insertAll(0, commonList);
    // list.insertAll(0, selectedList);
    list.sort((a, b)=>a.name.compareTo(b.name));
    selectedList.sort((a, b) => a.name.compareTo(b.name));

    // //add last 9 common
    if(_searchBloc.state["Search"] == "All")
      list.insertAll(0, commonList);

    // //add all selected
    // if(_searchBloc.state["Search"] == "All")
    //   list.insertAll(0, selectedList);

    return list;
  }

  void _handleButton(String value){
    
    if(_scrollShowing) _scrollController.jumpTo(0);

    switch(value){
      case "Return":
      case '+ Add':
        _addToStaging();
        _stateBloc.add(IntUpdateEvent(LogFoodAddFoodDrawerDefines.main));
      break;
      case '❌':
        _searchBloc.add(SearchClearStateEvent());
      break;
      case '🔙':
        if(_searchBloc.state['Search'] == 'All') break;
        String backspace = _searchBloc.state['Search'].substring(0, _searchBloc.state['Search'].length - 1);
        
        _searchBloc.add(SearchStateSetEvent((backspace == '') ? 'All' : backspace));
      break;
      default:
        String search = (_searchBloc.state['Search'] != 'All') ? _searchBloc.state['Search'] : "";
        if(value == 'Space') value = " ";
        else if(search.length == 0 || search.codeUnits[search.length-1] == ' '.codeUnitAt(0)) value = value.toUpperCase();
        _searchBloc.add(SearchStateSetEvent(search + value));
      break;
    }
  }

  bool _getButtonEnabled(String button){
    return true;
    String search =((_searchBloc.state['Search'] != 'All') ? _searchBloc.state['Search'] : "") + button;

    if(_aggregate == null || _commonIngredients == null) return false;

    return (_aggregate.database.values.firstWhere((ingredient){
      return TextHelpers.matchString(search, ingredient.name);
    }, orElse: (){return null;}) != null) || 
    (_commonIngredients.database.values.firstWhere((ingredient){
      return TextHelpers.matchString(search, ingredient.name);
    }, orElse: (){return null;}) != null);

  }

  Widget _buildMiniFoodSquare(SelectedIngredient ingredient, double width){
    return Container(
      width: width,
      child: GestureDetector(
        onTap: (){
          CommonAssets.showSnackbar(context, "Double Tap to unselect ${ingredient.name}");
        },
        onDoubleTap: (){
          _selectedBloc.add(SelectedStateUnselectEvent(ingredient));
          _searchBloc.add(SearchClearStateEvent());
          HapticFeedback.heavyImpact();
        },
        child: Container(
          padding: EdgeInsets.all(2),
            child: Tooltip(
              message: "Double Tap to unselect ${ingredient.name}",
              preferBelow: false,
              child: Container(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: CommonAssets.shadow,
                      color: FoodFrenzyColors.main,
                    ),
                    padding: EdgeInsets.all(2),
                    child: Center(
                      child: AST(
                        TextHelpers.nameToShort(ingredient.name,),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        color: FoodFrenzyColors.tertiary,
                      ),
                    ),
                  ),
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildIngredientTile(Ingredient ingredient){
    String message = ingredient.affinityToMessage();

    return GestureDetector(
      onTap: (){
        HapticFeedback.heavyImpact();
        _selectedBloc.add(SelectedStateSetEvent(SelectedIngredient.fromIngredient(ingredient)));
        _searchBloc.add(SearchClearStateEvent());
      },
      child: Container(
        color: FoodFrenzyColors.jjTransparent,
        height: widget.screenHeight * 0.08,
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AST(
                    ingredient.name,
                    isBold: true,
                    color: FoodFrenzyColors.secondary,
                    minSize: 15,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
            Tooltip(
              message: message,
              preferBelow: false,
              child: GestureDetector(
                onTap: (){
                  CommonAssets.showSnackbar(context, message);
                },
                child: Container(
                  color: FoodFrenzyColors.jjTransparent,
                  width: widget.screenWidth * 0.21,
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: AST(
                      ingredient.affinity,
                      // TextHelpers.numberToShort(ingredient.cal.roundToDouble()) + "C",
                      color: FoodFrenzyColors.secondary,
                      size: 21,
                      isBold: true,
                    )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsHub(){
    return Column(
      children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 13),
        height: widget.screenHeight * 0.055,
        child: BlocBuilder(
          cubit: _searchBloc,
          builder: (context, search) {
            return Row(
              children: [
                // Center(
                //   child: Icon(
                //     FontAwesomeIcons.search,
                //     color: FoodFrenzyColors.secondary,
                //   ),
                // ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: AST(
                        search["Search"].toUpperCase(),
                        color: (search["Search"] != 'All') ?  FoodFrenzyColors.main : FoodFrenzyColors.secondary,
                        size: 55,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
        Expanded(
          child: (_aggregate == null) ? CommonAssets.buildLoader() :
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: FoodFrenzyColors.tertiary,
              boxShadow: CommonAssets.shadow
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: UserCommonIngredientStreamView(
                    (common){
                      return BlocBuilder(
                        cubit:_searchBloc,
                        builder: (context, search){

                          _commonIngredients = common;
                          List<Ingredient> ingredients = _getSearchResults(common);

                        if(ingredients.isEmpty){
                            _scrollShowing = false;
                            return BlocBuilder(
                              cubit: _sentRequest,
                              builder: (context, didSend) {
                                return Container(
                                  padding: EdgeInsets.all(21),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AST(
                                          "Looks like we don't have\n${search['Search']}\nTry Scanning?",
                                          maxLines: 3,
                                          color: FoodFrenzyColors.secondary,
                                          textAlign: TextAlign.center
                                        ),
                                        Container(height: 13,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                // Scanner.scan(
                                                //   onCancel: (){
                                                //   },
                                                //   onError: (error){
                                                //     LOG.log(error, FoodFrenzyDebugging.crash);
                                                //   },
                                                //   onNotFound: (upc){

                                                //     _upc = upc;
                                                //     _stateBloc.add(IntUpdateEvent(LogFoodAddFoodDrawerDefines.ingredientEntry));
                                                //   },
                                                //   onFound: (ingredient){
                                                //     _stateBloc.add(IntUpdateEvent(LogFoodAddFoodDrawerDefines.main));
                                                //     _ingredientsBloc.add(IngredientListStateAddIngredientEvent(
                                                //       ingredient, 
                                                //     ));
                                                //     UserCommonIngredients.updateIngredient(ingredient);
                                                //   }
                                                // );
                                              },
                                              child: Container(
                                                color: FoodFrenzyColors.jjTransparent,
                                                child: Center(
                                                  child: Container(
                                                    width: widget.buttonWidth / FoodFrenzyRatios.gold,
                                                    decoration: BoxDecoration(
                                                      boxShadow: CommonAssets.shadow,
                                                      color: FoodFrenzyColors.tertiary,
                                                      borderRadius: BorderRadius.circular(8)
                                                    ),
                                                    padding: EdgeInsets.fromLTRB(13, 8, 13, 8),
                                                    child: Icon(
                                                      FontAwesomeIcons.barcode,
                                                      color: FoodFrenzyColors.secondary,
                                                      size: 34,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if(!didSend) Expanded(child: Container(),),
                                          if(!didSend)
                                            GestureDetector(
                                              onTap: (){
                                                CommonAssets.showSnackbar(context, "Double Tap to request ${search['Search']}");
                                              },
                                              onDoubleTap: (){
                                                RequestIngredient(name: search['Search']).makeRecord();
                                                _sentRequest.add(BoolUpdateEvent(true));
                                              },
                                              child: Container(
                                                color: FoodFrenzyColors.jjTransparent,
                                                child: Center(
                                                  child: Container(
                                                    width: widget.buttonWidth / FoodFrenzyRatios.gold,
                                                    decoration: BoxDecoration(
                                                      boxShadow: CommonAssets.shadow,
                                                      color: FoodFrenzyColors.tertiary,
                                                      borderRadius: BorderRadius.circular(8)
                                                    ),
                                                    padding: EdgeInsets.fromLTRB(13, 8, 13, 8),
                                                    child: Icon(
                                                      FontAwesomeIcons.paperPlane,
                                                      color: FoodFrenzyColors.secondary,
                                                      size: 34,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(height: 13,),
                                        if(!didSend)
                                          AST(
                                            "Or request ingredient",
                                            maxLines: 1,
                                            color: FoodFrenzyColors.secondary,
                                            textAlign: TextAlign.center
                                          ),
                                        if(didSend)
                                          AST(
                                            "Request Sent",
                                            maxLines: 3,
                                            color: FoodFrenzyColors.secondary,
                                            textAlign: TextAlign.center
                                          ),
                                      ],
                                    )
                                  ),
                                );
                              }
                            );
                          }
                          _scrollShowing = true;
                          return ShaderMask(
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
                              padding: EdgeInsets.symmetric(vertical: 13),
                              controller: _scrollController,
                              children: [
                                for(Ingredient ingredient in ingredients)
                                  _buildIngredientTile(ingredient)
                              ]
                            ),
                          );

                        }
                      );
                    },
                    onLoading: (){
                      return CommonAssets.buildLoader();
                    },
                  ),
                ),
              ],
            ), 
          ),
        ),
        BlocBuilder(
          cubit: _selectedBloc,
          builder: (context, List<SelectedIngredient> selected) {
            return Container(
              margin: EdgeInsets.only(top: 8),
              height: selected.isEmpty ? 0 : widget.screenHeight * 0.06,
              child: Center(
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [FoodFrenzyColors.tertiary, Colors.transparent, Colors.transparent, FoodFrenzyColors.tertiary,],
                      stops: [0.0, 0.05, 0.95, 1.0], // 10% purple, 80% transparent, 10% purple
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                    children: [
                      for(int i = 0; i < selected.length; i++)
                        _buildMiniFoodSquare(selected[i], widget.screenHeight * 0.055),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          height: CommonAssets.keyboardLineHeight * 3,
          child: BlocBuilder(
            cubit: _selectedBloc,
            builder: (context, selected) {
              return CommonAssets.foodKeyboard(_handleButton, _getButtonEnabled, addString: (selected.isEmpty) ? "Return" : "+ Add");
            }
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientEntry(){
    return Container();
    // return IngredientEntry(
    //   upc: _upc,
    //   visable: true,
    //   buttonWidth: widget.buttonWidth,
    //   topButtonBarHeight: widget.topButtonBarHeight,
    //   topButtonBarWidth: widget.topButtonBarWidth,
    //   onClose: (ingredient){
    //     if(ingredient != null){
    //       _ingredientsBloc.add(IngredientListStateAddIngredientEvent(
    //         ingredient, 
    //       ));
    //       UserCommonIngredients.updateIngredient(ingredient);
    //     }

    //     _stateBloc.add(IntUpdateEvent(LogFoodAddFoodDrawerDefines.main));
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomDrawer(
      width: widget.screenWidth,
      height: widget.screenHeight * FoodFrenzyRatios.verticalTallDrawerWidthRatio,
      screenHeight: widget.screenHeight,
      buttonHeight: widget.topButtonBarHeight,
      child: IngredientAggregateView(
        (aggregate){

          _aggregate = aggregate;
          return BlocBuilder(
            cubit:_stateBloc,
            builder: (BuildContext context, int state){
              switch(state){
                case LogFoodAddFoodDrawerDefines.main: return _buildMainHub();
                case LogFoodAddFoodDrawerDefines.ingredientEntry: return _buildIngredientEntry();
                case LogFoodAddFoodDrawerDefines.ingredients: return _buildIngredientsHub();
                default: return Container();
              }
            },
          );
        },
        onLoading: (){
          return CommonAssets.buildLoader();
        },
      ),
      visable: widget.visable,
      onExit: (){
        widget.onExit(_ingredientsBloc.state);
      },
    );
  }
}