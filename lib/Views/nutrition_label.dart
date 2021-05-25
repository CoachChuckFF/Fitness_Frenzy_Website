
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class NutritionLabel extends StatelessWidget {
  final double widthRatio = 0.69;

  final Ingredient entry;
  final double height;
  final bool showOnly;

  final Function onSS;
  final Function onHSS;
  final Function onCal;
  final Function onFat;
  final Function onNA;
  final Function onK;
  final Function onCarb;
  final Function onFiber;
  final Function onSugar;
  final Function onAlc;
  final Function onProt;
  final String barcode;

  const NutritionLabel(
    this.entry,
    this.height,
    {
      this.showOnly = true,
      this.onSS,
      this.onHSS,
      this.onCal,
      this.onFat,
      this.onNA,
      this.onK,
      this.onCarb,
      this.onFiber,
      this.onSugar,
      this.onAlc,
      this.onProt,
      this.barcode,
      Key key,
    }
  ) : super(key: key);

  Widget _buildBar({int flex = 1}){
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.only(
          left: 13,
          right: 13,
        ),
        child: Container(
          color: FoodFrenzyColors.jjBlack
        ),
      )
    );
  }

  Widget _buildSection({Widget child, int flex = 1, Function onTap, Function onLongPress}){

    if(onTap != null || onLongPress != null){
      return Expanded(
        flex: flex,
        child: GestureDetector(
          onLongPress: onLongPress,
          onTap: onTap,
          child: Container(
            color: FoodFrenzyColors.jjTransparent,
            padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 13,
              right: 13,
            ),
            child: child
          ),
        )
      );

    }

    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 13,
          right: 13,
        ),
        child: child
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = height * widthRatio;

    double amount = entry.amount;
    double householdAmount = entry.hss / entry.ss * amount * entry.hss;
    double cal = entry.cal / entry.ss * amount;
    double fat = entry.fat / entry.ss * amount;
    double na = entry.na / entry.ss * amount;
    double k = entry.k / entry.ss * amount;
    double carb = entry.carb / entry.ss * amount;
    double fiber = entry.fiber / entry.ss * amount;
    double sugar = entry.sugar / entry.ss * amount;
    double alc = entry.alc / entry.ss * amount;
    double prot = entry.prot / entry.ss * amount;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: FoodFrenzyColors.jjWhite,
        boxShadow: [
          BoxShadow(
            color: FoodFrenzyColors.jjBlack.withAlpha(55),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(3,3)
          ),
        ],
        border: Border.all(
          width: 2.0,
          color: FoodFrenzyColors.jjBlack,
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSection(
            flex: 8,
            child: AST(
              entry.name,
              textAlign: TextAlign.center,
              isBold: true,
              size: 233,
            ),
          ),
          _buildSection(
            flex: 15,
            child: AST(
              "Nutrition Facts",
              textAlign: TextAlign.center,
              isBold: true,
              size: 233,
            ),
          ),
          _buildBar(),
          _buildSection(
            flex: 8,
            onTap: onSS,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: AST(
                    "Serving size",
                    isBold: true,
                    size: 55,
                  ),
                ),
                Expanded(
                  child: AST(
                    "(" + amount.toStringAsFixed(0) + ((entry.usesml) ? "ml" : "g") + ")",
                    textAlign: TextAlign.right,
                    isBold: true,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),
          _buildSection(
            flex: 8,
            onTap: onHSS,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: AST(
                    "Household Size",
                    isBold: true,
                    size: 55,
                  ),
                ),
                Expanded(
                  child: AST(
                    (entry.hss != 0) ? "${householdAmount.toStringAsFixed(1)} ${entry.hsu}" : entry.hsu,
                    textAlign: TextAlign.right,
                    isBold: true,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),
          _buildBar(
            flex: 5
          ),
          _buildSection(
            flex: 13,
            onTap: onCal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: AST(
                    "Cals",
                    isBold: true,
                    size: 89,
                  ),
                ),
                Expanded(
                  child: AST(
                    cal.toStringAsFixed(0),
                    textAlign: TextAlign.right,
                    isBold: true,
                    size: 233,
                  ),
                ),
              ],
            ),
          ),
          _buildBar(
            flex: 4
          ),
          _buildSection(
            flex: 8,
            onTap: onFat,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AST(
                  "Total Fat ",
                  isBold: true,
                  size: 34,
                ),
                AST(
                  fat.toStringAsFixed(1) + "g",
                  textAlign: TextAlign.right,
                  size: 34,
                ),
              ],
            ),
          ),
          _buildBar(),
          _buildSection(
            flex: 8,
            onTap: onNA,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AST(
                  "Sodium ",
                  isBold: true,
                  size: 34,
                ),
                AST(
                  na.toStringAsFixed(0) + "mg",
                  textAlign: TextAlign.right,
                  size: 34,
                ),
              ],
            ),
          ),
          _buildBar(),
          _buildSection(
            flex: 8,
            onTap: onK,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AST(
                  "Potassium ",
                  isBold: true,
                  size: 34,
                ),
                AST(
                  k.toStringAsFixed(0) + "mg",
                  textAlign: TextAlign.right,
                  size: 34,
                ),
              ],
            ),
          ),
          _buildBar(),
          _buildSection(
            flex: 8,
            onTap: onCarb,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AST(
                  "Total Carbohydrate ",
                  isBold: true,
                  size: 34,
                ),
                AST(
                  carb.toStringAsFixed(1) + "g",
                  textAlign: TextAlign.right,
                  size: 34,
                ),
              ],
            ),
          ),
          _buildBar(),
          _buildSection(
            flex: 8,
            onTap: onFiber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Container()),
                Expanded(
                  flex: 8,
                  child: Row(
                    children: <Widget>[
                      AST(
                        "Dietary Fiber ",
                        size: 34,
                      ),
                      AST(
                        fiber.toStringAsFixed(1) + "g",
                        textAlign: TextAlign.right,
                        size: 34,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBar(),
          _buildSection(
            flex: 8,
            onTap: onSugar,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Container()),
                Expanded(
                  flex: 8,
                  child: Row(
                    children: <Widget>[
                      AST(
                        "Total Sugars ",
                        size: 34,
                      ),
                      AST(
                        sugar.toStringAsFixed(1) + "g",
                        textAlign: TextAlign.right,
                        size: 34,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBar(),
          _buildSection(
            flex: 8,
            onTap: onAlc,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Container()),
                Expanded(
                  flex: 8,
                  child: Row(
                    children: <Widget>[
                      AST(
                        "Total Alcohol ",
                        size: 34,
                      ),
                      AST(
                        alc.toStringAsFixed(1) + "g",
                        textAlign: TextAlign.right,
                        size: 34,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBar(),
          _buildSection(
            flex: 8,
            onTap: onProt,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AST(
                  "Protein ",
                  isBold: true,
                  size: 34,
                ),
                AST(
                  prot.toStringAsFixed(1) + "g",
                  textAlign: TextAlign.right,
                  size: 34,
                ),
              ],
            ),
          ),
          if(entry.note.isNotEmpty || (barcode != null && barcode.length == 13))... [

            _buildBar(
              flex: 4
            ),
            if((barcode == null || barcode.length != 13) && entry.note.isNotEmpty)
              _buildSection(
                flex: 8,
                onTap: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AST(
                      "Notes: ",
                      isBold: true,
                      size: 34,
                    ),
                    AST(
                      entry.note,
                      textAlign: TextAlign.right,
                      size: 34,
                    ),
                  ],
                ),
              ),
            // if(barcode != null && barcode.length == 13)
            //   _buildSection(
            //     flex: 16,
            //     onLongPress: (){
            //       FlutterClipboard.copy(barcode);
            //     },
            //     child: Center(
            //       child: BarcodeWidget(
            //         barcode: Barcode.ean13(),
            //         data: barcode,
            //         errorBuilder: (context, error) => Center(child: Text(error)),
            //       ),
            //     )
            //   ),
          ]
        ]
      ),
    );
  }
}