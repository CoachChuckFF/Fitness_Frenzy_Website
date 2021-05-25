/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal
import 'package:fitnessFrenzyWebsite/Models/models.dart';
import 'package:fitnessFrenzyWebsite/Controllers/controllers.dart';

class Meal{
  static final GlobalData<Meal> firebase = GlobalData(mealCollection);
  static const String mealCollection = "Meal";

  static const List<String> allTags = [
    "High Protein",
    "High Carbs",
    "High Fat",
    "Carnivore",
    "Keto",
    "Whole30",
    "Pescatarian",
    "Dairy-Free",
    "Vegan",
    "Vegetarian",
    "Gluten Free",
    "Paleo",
    "Anti-Inflammatory",
  ];

  String createdBy;
  String documentName;
  DateTime createdOn;
  String name;
  int loves;
  List<String> tags;
  List<Ingredient> ingredients;
  String photoURL;
  String uid;

  Meal({
    this.createdBy,
    this.documentName,
    this.createdOn,
    this.name,
    this.loves,
    this.tags,
    this.ingredients,
    this.photoURL,
    this.uid
  }){
    if(uid == null){
      this.uid = Calculations.getUuid();
    }
  }

  Ingredient toIngredient(){
    return Ingredient.fromList(name, ingredients);
  }

  factory Meal.fromMap(Map data){
    return Meal(
      documentName: data['document name'],
      createdBy: data['createdBy'] ?? '',
      createdOn: (data['created on'] != null) ? (data['created on'] is Timestamp) ? (data['created on'] as Timestamp).toDate() : data['created on'] : DateTime.now(),
      name: data['name'] ?? '',
      loves: data['loves'] ?? 0,
      tags: (data['tags'] != null) ? [for(var item in data['tags']) item] : <String>[],
      ingredients: (data['ingredients'] != null) ? [for(var item in data['ingredients']) Ingredient.fromMap(item)] : <Ingredient>[],
      photoURL: data['photo url'] ?? "",
      uid: data['uid'] ?? Calculations.getUuid(),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'document name' : documentName ?? "",
      'createdBy' : createdBy ?? "",
      'created on' : createdOn ?? "",
      'name' : name ?? "",
      'loves' : loves ?? 0,
      'tags' : (tags != null) ? [for(var tag in tags) tag] : [],
      'ingredients' : (ingredients != null) ? [for(var ingredient in ingredients) ingredient.toMap()] : [],
      'photo url' : photoURL ?? "",
      'uid' : uid ?? Calculations.getUuid()
    };
  }

  

}