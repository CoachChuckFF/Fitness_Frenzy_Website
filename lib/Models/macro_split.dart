/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal

class MacroSplit{

  static const String physique = "Physique";
  static const String keto = "Keto";
  static const String usda = "USDA";
  static const String custom = "Custom";


  static const List<String> splits = [
    physique,
    keto,
    usda,
    custom,
  ];

  final String name;
  final double fat;
  final double carb;
  final double prot;

  final bool fatIsPercent;
  final bool carbIsPercent;
  final bool protIsPercent;

  MacroSplit({
    this.name = "Custom",
    this.fat,
    this.carb,
    this.prot,
    this.fatIsPercent = true,
    this.carbIsPercent = true,
    this.protIsPercent = true,
  });

}