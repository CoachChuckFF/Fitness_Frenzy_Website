// /*
// * Christian Krueger Health LLC.
// * All Rights Reserved.
// *
// * Author: Christian Krueger
// * Date: 4.15.20
// *
// */

// class Unit{
//   static const String metric = "Metric";
//   static const String standard = "Standard";
// }

// class HeightUnit{
//   final double value;
//   final String unit;
//   static const String metricPostfix = "cm";
//   static const String standardMidfix = "'";
//   static const String standardPostfix = "\"";
//   static const double inchTocmRatio = 2.54;

//   HeightUnit(this.value, {this.unit = Unit.standard});

//   double get metric{
//     switch(unit){
//       case Unit.standard:
//         return value * inchTocmRatio;
//       default:
//         return value;
//     }
//   }

//   double get standard{
//     switch(unit){
//       case Unit.standard:
//         return value;
//       default:
//         return value / inchTocmRatio;
//     }
//   }

//   int get feet {
//     return (standard / 12).truncate();
//   }

//   int get subInches {
//     return (standard.truncate() % 12);
//   }

//   String get feetString{
//     int f = feet;
//     int i = subInches;

//     return f.toString() + standardMidfix + i.toString() + standardPostfix;
//   }

//   String get cmString{
//     return "${metric.truncate()}$metricPostfix";
//   }

//   @override
//   String toString([String toUnit]) {
//     if(toUnit == null){toUnit = unit;}

//     switch(toUnit){
//       case Unit.standard:
//         return feetString;
//       default:
//         return cmString;
//     }
//   }
// }

// class PersonWeight{
//   final double value;
//   final String unit;

//   static const double lbsTokgRatio = 0.45359;
//   static const String lbsPostfix = "lbs";
//   static const String kgPostfix = "kg";

//   PersonWeight(this.value, [this.unit = Unit.standard]);

//   double get metric{
//     switch(unit){
//       case Unit.standard:
//         return value * lbsTokgRatio;
//       default:
//         return value;
//     }
//   }

//   double get standard{
//     switch(unit){
//       case Unit.standard:
//         return value;
//       default:
//         return value / lbsTokgRatio;
//     }
//   }

//   double get kg{
//     return metric;
//   }

//   double get lbs{
//     return standard;
//   }

//   String get kgString{
//     return metric.toStringAsFixed(2) + kgPostfix;
//   }

//   String get lbsString{
//     return standard.toStringAsFixed(2) + lbsPostfix;
//   }

//   @override
//   String toString([String toUnit]) {
//     if(toUnit == null){toUnit = unit;}

//     switch(toUnit){
//       case Unit.standard:
//         return lbsString;
//       default:
//         return kgString;
//     }
//   }
// }

// /* 
//   3 classes of food
//   1. Generic - from USDA
//   2. Resturant - resturant data
//   3. Barcode - from barcode scanning
// */

// class TempFood{
//   static Ingredient oats = Ingredient(
//     name: "Oats",
//     servingSize: ServingSize(
//       40
//     ),
//     macros: Macros( //for 1 serving size
//       calories: 120,
//       fat: 0,
//       carbs: 27,
//       protein: 5,
//     ),
//     cost: 0.1,
//   );
//   static Ingredient proteinPowder = Ingredient(
//     name: "Protein Powder",
//     servingSize: ServingSize(
//       31
//     ),
//     macros: Macros( //for 1 serving size
//       calories: 140,
//       fat: 1,
//       carbs: 2,
//       protein: 27,
//     ),
//     cost: 0.15,
//   );
//   static Ingredient almondMilk = Ingredient(
//     name: "Almond Milk",
//     servingSize: ServingSize(
//       1,
//       unit: Unit.standard,
//       isBig: true,
//       isLiquid: true,
//     ),
//     macros: Macros( //for 1 serving size
//       calories: 30,
//       fat: 5,
//       carbs: 2,
//       protein: 1,
//     ),
//     cost: 0.13,
//   );
//   static Ingredient chocolateChips = Ingredient(
//     name: "Chocolate Chips",
//     servingSize: ServingSize(
//       18,
//     ),
//     macros: Macros( //for 1 serving size
//       calories: 80,
//       fat: 5,
//       carbs: 2,
//       protein: 5,
//     ),
//     cost: 0.08,
//   );
//   static Ingredient strawberrys = Ingredient(
//     name: "Strawberries",
//     servingSize: ServingSize(
//       30,
//     ),
//     macros: Macros( //for 1 serving size
//       calories: 80,
//       fat: 0,
//       carbs: 13,
//       protein: 3,
//     ),
//     cost: 0.08,
//   );
// }

// class FoodBlock{
//   final Ingredient ingredient;
//   final double amount;

//   FoodBlock(this.ingredient, this.amount);
// }

// class Ingredient{
//   final String name;
//   final ServingSize servingSize;
//   final Macros macros;
//   final String photoUrl;
//   final double cost;
//   final String barcode;
//   final String resturant;

//   Ingredient(
//     {
//       this.name, 
//       this.servingSize, 
//       this.macros,
//       this.photoUrl,
//       this.cost,
//       this.barcode,
//       this.resturant,
//     }
//   );

//   double get satietyFactor{
//     return macros.macroSatietyFactor * ((resturant != null) ? 0.8 : 1.0);
//   }
// }

// class Macros{
//   final double calories;
//   final double fat;
//   final double carbs;
//   final double protein;
//   final double fiber;
//   final double sugar;

//   static const double fatToCalRatio = 9.0;
//   static const double carbToCalRatio = 4.0;
//   static const double proteinToCalRatio = 4.0;

//   static const int calIndex = 0;
//   static const int fatIndex = 1;
//   static const int carbIndex = 2;
//   static const int proteinIndex = 3;

//   Macros({
//     this.calories = 0, 
//     this.fat = 0, 
//     this.carbs = 0, 
//     this.protein = 0,
//     this.fiber = 0,
//     this.sugar = 0,
//   });

//   double get macroSatietyFactor {
//     return 1;
//   }

//   double get cals {
//     double realAmount = (
//       fat * fatToCalRatio +
//       carbs * carbToCalRatio +
//       protein * proteinToCalRatio
//     );

//     return (realAmount > calories) ? realAmount : calories;
//   }

//   List<double> getPercentages(){ //calories, fat, carbs, protein
//     double totalCals = cals;
//     double fatCals = fat * fatToCalRatio;
//     double carbCals = carbs * carbToCalRatio;
//     double protienCals = protein * proteinToCalRatio;
//     double extraCals = totalCals - fatCals - carbCals - protienCals;

//     return [
//       extraCals / totalCals,
//       fatCals / totalCals,
//       carbCals / totalCals,
//       protienCals / totalCals
//     ];
//   }

//   List<double> getTotals([double mult]){
//     return [
//       cals * mult,
//       fat * mult,
//       carbs * mult,
//       protein * mult,
//     ];
//   }
// }

// class ServingSize{
//   final double value;
//   final String unit;
//   final String altUnit;
//   final bool isBig;
//   final bool isLiquid;

//   static const String smallStandardWeight = "oz";
//   static const String largeStandardWeight = "lbs";

//   static const String smallStandardLiquid = "tbsp";
//   static const String largeStandardLiquid = "cup";

//   static const String smallMetricWeight = "g"; //only stored as g
//   static const String largeMetricWeight = "kg";

//   static const String smallMetricLiquid = "mL"; //only stored as mL
//   static const String largeMetricLiquid = "L";

//   static const double cupTomlRatio = 236.588;
//   static const double tbspTomlRatio = 14.7868;

//   static const double lbsToozRatio = 16;
//   static const double lbsTogRatio = 453.592;
//   static const double ozTogRatio = lbsTogRatio / lbsToozRatio;

//   ServingSize(this.value, {this.altUnit, this.unit = Unit.metric, this.isBig = false, this.isLiquid = false});

//   double get metric{
//     if(altUnit != null) return value;

//     if(isLiquid){
//       if(isBig){
//         switch(unit){
//           case Unit.metric:
//             return value;
//           default:
//             return value * cupTomlRatio;
//         }
//       } else {
//         switch(unit){
//           case Unit.metric:
//             return value;
//           default:
//             return value * tbspTomlRatio;
//         }
//       }
//     } else {
//       if(isBig){
//         switch(unit){
//           case Unit.metric:
//             return value;
//           default:
//             return value * lbsTogRatio;
//         }
//       } else {
//         switch(unit){
//           case Unit.metric:
//             return value;
//           default:
//             return value * ozTogRatio;
//         }
//       }
//     }
//   }

//   double get standard{
//     if(altUnit != null) return value;

//     if(isLiquid){
//       if(isBig){
//         switch(unit){
//           case Unit.metric:
//             return value / cupTomlRatio;
//           default:
//             return value;
//         }
//       } else {
//         switch(unit){
//           case Unit.metric:
//             return value / tbspTomlRatio;
//           default:
//             return value;
//         }
//       }
//     } else {
//       if(isBig){
//         switch(unit){
//           case Unit.metric:
//             return value / lbsTogRatio;
//           default:
//             return value;
//         }
//       } else {
//         switch(unit){
//           case Unit.metric:
//             return value / ozTogRatio;
//           default:
//             return value;
//         }
//       }
//     }
//   }

//   String getStandardString([double mult]){ 
//     double newValue = standard * mult;
  
//     if(altUnit != null) return "$newValue $altUnit";

//     if(isLiquid){
//       if(isBig){
//         return "${newValue.toStringAsFixed(2)} $largeStandardLiquid";
//       } else {
//         return "${newValue.toStringAsFixed(2)} $smallStandardLiquid";
//       }
//     } else {
//       if(isBig){
//         return "${newValue.toStringAsFixed(2)} $largeStandardWeight";
//       } else {
//         return "${newValue.toStringAsFixed(2)} $smallStandardWeight";
//       }
//     }
//   }

//   String getMetricString([double mult]){ 
//     double newValue = metric * mult;
  
//     if(altUnit != null) return "$newValue $altUnit";

//     if(isLiquid){
//       if(newValue > 1000){
//         return "${(newValue / 1000).toStringAsFixed(2)} $largeMetricLiquid";
//       } else {
//         return "${newValue.toStringAsFixed(2)} $smallMetricLiquid";
//       }
//     } else {
//       if(newValue > 1000){
//         return "${(newValue / 1000).toStringAsFixed(2)} $largeMetricWeight";
//       } else {
//         return "${newValue.toStringAsFixed(2)} $smallMetricWeight";
//       }
//     }
//   }

//   String getDefalutString([double mult]){
//     double newValue = value * mult;

//     if(altUnit != null) return "$newValue $altUnit";

//     if(isLiquid){
//       if(isBig){
//         switch(unit){
//           case Unit.metric:
//             return "${newValue.toStringAsFixed(2)} $largeMetricLiquid";
//           default:
//             return "${newValue.toStringAsFixed(2)} $largeStandardLiquid";
//         }
//       } else {
//         switch(unit){
//           case Unit.metric:
//             return "${newValue.toStringAsFixed(2)} $smallMetricLiquid";
//           default:
//             return "${newValue.toStringAsFixed(2)} $smallStandardLiquid";
//         }
//       }
//     } else {
//       if(isBig){
//         switch(unit){
//           case Unit.metric:
//             return "${newValue.toStringAsFixed(2)} $largeMetricWeight";
//           default:
//             return "${newValue.toStringAsFixed(2)} $largeStandardWeight";
//         }
//       } else {
//         switch(unit){
//           case Unit.metric:
//             return "${newValue.toStringAsFixed(2)} $smallMetricWeight";
//           default:
//             return "${newValue.toStringAsFixed(2)} $smallStandardWeight";
//         }
//       }
//     }
//   }
// }