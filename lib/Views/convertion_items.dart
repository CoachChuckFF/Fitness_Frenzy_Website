/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.15.20
*
*/

// Used Packages
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';
import 'package:fitnessFrenzyWebsite/Views/views.dart';
import 'package:flutter/material.dart';

class ConversionLists{
  static Widget usefulCheatSheet(){
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          AST("Useful Conversions", isBold: true, textAlign: TextAlign.left,),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 pound (lb)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("16 ounces (oz)", textAlign: TextAlign.right, maxLines: 1,))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 cup (c)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("16 tablespoons (tbl, tbs, tbsp)", textAlign: TextAlign.right, maxLines: 1,)),
            ],
          ),
        ]
      ),
    );
  }

  static Widget buildStandardWeightCheatSheet(){
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          AST("Standard Weights", isBold: true, textAlign: TextAlign.left,),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 pound (lb, #)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("16 ounces (oz)", textAlign: TextAlign.right, maxLines: 1,))
            ],
          ),
        ]
      ),
    );
  }

  static Widget buildStandardLiquidCheatSheet(){
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          AST("Standard Liquids", isBold: true, textAlign: TextAlign.left,),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 tablespoon (T, tbl, tbs, tbsp)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("3 teaspoons (t, tsp)", textAlign: TextAlign.right, maxLines: 1,))
            ],
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 fluid ounce (fl oz)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("2 tablespoons", textAlign: TextAlign.right, maxLines: 1,)),
            ],
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 cup (c)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("8 fluid onces", textAlign: TextAlign.right, maxLines: 1,)),
            ],
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 pint (p, pt, fl pt)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("2 cups", textAlign: TextAlign.right, maxLines: 1,)),
            ],
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 quart (q, qt, fl qt)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("2 pints", textAlign: TextAlign.right, maxLines: 1,)),
            ],
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 gallon (gal)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("4 quarts", textAlign: TextAlign.right, maxLines: 1,)),
            ],
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 gallon (gal)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("16 cups", textAlign: TextAlign.right, maxLines: 1,)),
            ],
          ),
        ]
      ),
    );
  }

  static Widget buildMetricWeightCheatSheet(){
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          AST("Metric Liquids", isBold: true, textAlign: TextAlign.left,),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 liter (L, l)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("1000 milliliters (mL, ml, cc)", textAlign: TextAlign.right, maxLines: 1,))
            ],
          ),
        ]
      ),
    );
  }

  static Widget buildMetricLiquidCheatSheet(){
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          AST("Metric Weights", isBold: true, textAlign: TextAlign.left,),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 gram (g)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("1000 milligrams (mg)", textAlign: TextAlign.right, maxLines: 1,))
            ],
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: AST("1 kilogram (kg)", textAlign: TextAlign.left, maxLines: 1,)),
              AST("=", textAlign: TextAlign.center, maxLines: 1,),
              Expanded(child: AST("1000 grams", textAlign: TextAlign.right, maxLines: 1,))
            ],
          ),
        ]
      ),
    );
  }
}