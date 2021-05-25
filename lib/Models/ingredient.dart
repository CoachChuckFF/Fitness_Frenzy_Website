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

class IngredientAggregateTags{
  static final StaticGlobalData<IngredientAggregateTags> firebase = StaticGlobalData(ingredientAggregateTagsCollection, ingredientAggregateTagsDocument);
  static const String ingredientAggregateTagsCollection = "Aggregate";
  static const String ingredientAggregateTagsDocument = "Ingredient Tags";
  final List<dynamic> tags;

  IngredientAggregateTags({this.tags});

  factory IngredientAggregateTags.fromMap(Map data){
    return IngredientAggregateTags(
      tags : data['tags'] ?? []
    );
  }
}

class IngredientAggregateEntry{
  final String name;
  final String tag1;
  final String tag2;
  final String tag3;
  final String tag4;
  final String tag5;
  final String note;
  final double cal;
  final double fat;
  final double carb;
  final double prot;

  IngredientAggregateEntry({
    this.name,
    this.note,
    this.tag1,
    this.tag2,
    this.tag3,
    this.tag4,
    this.tag5,
    this.cal,
    this.fat,
    this.carb,
    this.prot,
  });

  factory IngredientAggregateEntry.fromMap(String name, Map data){
    return IngredientAggregateEntry(
      name: name,
      tag1: data['tag 1'] ?? "",
      tag2: data['tag 2'] ?? "",
      tag3: data['tag 3'] ?? "",
      tag4: data['tag 4'] ?? "",
      tag5: data['tag 5'] ?? "",
      note: data['note'] ?? "",
      cal: ((data['cal'] != null) ? data['cal'].toDouble() : 0.0),
      fat: ((data['fat'] != null) ? data['fat'].toDouble() : 0.0),
      carb: ((data['carb'] != null) ? data['carb'].toDouble() : 0.0),
      prot: ((data['prot'] != null) ? data['prot'].toDouble() : 0.0),
    );
  }
}

class IngredientAggregate{
  static final StaticGlobalData<IngredientAggregate> firebase = StaticGlobalData(ingredientAggregateCollection, ingredientAggregateDocument);
  static const String ingredientAggregateCollection = "Aggregate";
  static const String ingredientAggregateDocument = "Ingredients";

  Map<String, IngredientAggregateEntry> database = Map<String, IngredientAggregateEntry>();

  IngredientAggregate();

  IngredientAggregate.fromMap(Map data){
    data.forEach((key, value){
      database[key] = IngredientAggregateEntry.fromMap(key, value);
    });
  }

  int get length => database.keys.length;
  IngredientAggregateEntry getFromIndex(int index){
    if(index.abs() < database.keys.length){
      return database[database.keys.elementAt(index.abs())];
    }

    return null;
  }
}

class Ingredient{
  static const String ingredientCollection = "Ingredients";
  static const String barcodeCollection = "Barcodes";
  static const String toBeValidatedCollection = "To Be Validated";
  static final GlobalData<Ingredient> firebase = GlobalData(ingredientCollection);
  static final GlobalData<Ingredient> barcodeFirebase = GlobalData(barcodeCollection);
  static final GlobalData<Ingredient> toBeValidatedFirebase = GlobalData(toBeValidatedCollection);

  static const String ingredientLogType = "ingredient";
  static const String noteLogType = "note";

  String name;
  String upc;
  String tag1;
  String tag2;
  String tag3;
  String tag4;
  String tag5;
  bool usesml;
  double ss;
  double hss;
  String hsu;
  double cal;
  double fat;
  double na;
  double k;
  double carb;
  double fiber;
  double sugar;
  double prot;
  double alc;
  String note;
  String logType;
  DateTime lastUsed;

  double amount;

  Ingredient({
    this.name,
    this.upc,
    this.tag1,
    this.tag2,
    this.tag3,
    this.tag4,
    this.tag5,
    this.usesml,
    this.ss,
    this.hss,
    this.hsu,
    this.cal,
    this.fat,
    this.na,
    this.k,
    this.carb,
    this.fiber,
    this.sugar,
    this.prot,
    this.alc,
    this.note,
    this.amount,
    this.logType = ingredientLogType,
    this.lastUsed,
  });

  String affinityToMessage(){
    switch(this.affinity){
      case "0": return "This ingredient has little to no macros";
      case "a": return "This ingredient is mostly alcohol";
      case "f": return "This ingredient is mostly fat (${TextHelpers.numberToShort(this.percentFat * 100)}%f)";
      case "fc": return "This ingredient is mostly fat (${TextHelpers.numberToShort(this.percentFat * 100)}%f) and carbs (${TextHelpers.numberToShort(this.percentCarb * 100)}%c)";
      case "fp": return "This ingredient is mostly fat (${TextHelpers.numberToShort(this.percentFat * 100)}%f) and protein (${TextHelpers.numberToShort(this.percentProt * 100)}%p)";
      case "c": return "This ingredient is mostly carbs (${TextHelpers.numberToShort(this.percentCarb * 100)}%c)";
      case "cp": return "This ingredient is mostly carbs (${TextHelpers.numberToShort(this.percentCarb * 100)}%c) and protein (${TextHelpers.numberToShort(this.percentProt * 100)}%p)";
      case "p": return "This ingredient is mostly protein (${TextHelpers.numberToShort(this.percentProt * 100)}%p)";
      default: return "This ingredient has balanced macros";
    }

  }

  String get affinity {
    double _total = this.totalMacroLevel;
    double _fatLevel = this.percentFat;
    double _carbLevel = this.percentCarb;
    double _protLevel = this.percentProt;

    String affinity = "";

    if(this.alc != null && this.alc != 0) return "a";

    if(_total < 10) return "0";


    if(_fatLevel < 0.02){
      if((_carbLevel - _protLevel).abs() < 0.20){
        affinity = "cp";
      } else if(_carbLevel >= 0.50){
        affinity = "c";
      } else if(_protLevel >= 0.50){
         affinity = "p";
      }
    } else if(_carbLevel < 0.02){
      if((_fatLevel - _protLevel).abs() < 0.20){
        affinity = "fp";
      } else if(_fatLevel >= 0.50){
        affinity = "f";
      } else if(_protLevel >= 0.50){
         affinity = "p";
      }
    } else if(_protLevel < 0.02){
      if((_fatLevel - _carbLevel).abs() < 0.20){
        affinity = "fc";
      } else if(_fatLevel >= 0.50){
        affinity = "f";
      } else if(_carbLevel >= 0.50){
         affinity = "c";
      }
    } else {
      if(_fatLevel >= 0.34) affinity += "f";
      if(_carbLevel >= 0.34) affinity += "c";
      if(_protLevel >= 0.34) affinity += "p";
    }


    if(affinity.isEmpty) affinity = "b";

    return affinity;
  }

  double get alcCarbs {
    return ((this.alc ?? 0) * 7) / 4;
  }

  bool get isIngredient {
    return this.logType == ingredientLogType;
  }

  bool get isNote {
    return this.logType == noteLogType;
  }

  double get fatLevel {
    return this.fat * 9;
  }

  double get carbLevel {
    return this.carb * 4;
  }

  double get protLevel {
    return this.prot * 4;
  }

  double get totalMacroLevel {
    return this.fatLevel + this.carbLevel + this.protLevel;
  }

  double get percentFat {
    double total = this.totalMacroLevel;

    if(total == 0) return 0;
    return this.fatLevel/total;
  }

  double get percentCarb {
    double total = this.totalMacroLevel;

    if(total == 0) return 0;
    return this.carbLevel/total;
  }

  double get percentProt {
    double total = this.totalMacroLevel;

    if(total == 0) return 0;
    return this.protLevel/total;
  }

  double get weight{
    return amount;
  }

  double get hsses{
    if(ss == 0) return 0;

    return ((hss / ss) * amount) * hss;
  }

  double get cals{
    if(ss == 0) return 0;

    return cal / ss * amount;
  }

  double get fats{
    if(ss == 0) return 0;

    return fat / ss * amount;
  }

  double carbs({bool useAlc = false}){
    if(ss == 0) return 0;

    return (carb + ((useAlc) ? alcCarbs : 0))/ ss * amount;
  }

  double get prots{
    if(ss == 0) return 0;

    return prot / ss * amount;
  }

  double get sodiums{
    if(ss == 0) return 0;

    return na / ss * amount;
  }

  double get bananas{
    if(ss == 0) return 0;

    return k / ss * amount;
  }

  double get sugars{
    if(ss == 0) return 0;

    return sugar / ss * amount;
  }

  double get fibers{
    if(ss == 0) return 0;

    return fiber / ss * amount;
  }

  double get alcohols{
    if(ss == 0) return 0;

    return alc / ss * amount;
  }

  factory Ingredient.logTypeHeader(String logType){
    return Ingredient.fromMap({
      'name' : 'HEADER',
      'log type' : logType
    });
  }

  factory Ingredient.note(String note){
    return Ingredient.fromMap({
      'name' : 'NOTE',
      'log type' : noteLogType,
      'note' : note
    });
  }

  static int calsFromList(List<Ingredient> list){
    double cals = 0;


    list.forEach((ingredient) { 
      if(ingredient.isIngredient && cals != null){
        cals += ingredient.cals;
      }
    });

    return cals.round();
  }

  static Macro macrosFromList(List<Ingredient> list, bool useAlc){
    Macro macros = Macro();


    list.forEach((ingredient) { 
      if(ingredient.isIngredient){
        macros.cal += ingredient.cals;
        macros.fat += ingredient.fats;
        macros.carb += ingredient.carbs(useAlc: useAlc);
        macros.prot += ingredient.prots;
      }
    });

    return macros;
  }

  static Micro microsFromList(List<Ingredient> list){
    Micro micros = Micro();


    list.forEach((ingredient) { 
      if(ingredient.isIngredient){
        micros.sodium += ingredient.sodiums;
        micros.sugar += ingredient.sugars;
        micros.fiber += ingredient.fibers;
        micros.alcohol += ingredient.alcohols;
      }
    });

    return micros;
  }

  factory Ingredient.fromList(String name, List<Ingredient> list){
    double ss = 0;
    double cal = 0;
    double fat = 0;
    double na = 0;
    double k = 0;
    double carb = 0;
    double fiber = 0;
    double sugar = 0;
    double prot = 0;
    double alc = 0;

    list.forEach((ingredient) { 
      if(ingredient.isIngredient){
        ss += ingredient.amount;
        cal += ingredient.cal * (ingredient.amount / ingredient.ss);
        fat += ingredient.fat * (ingredient.amount / ingredient.ss);
        na += ingredient.na * (ingredient.amount / ingredient.ss);
        k += ingredient.k * (ingredient.amount / ingredient.ss);
        carb += ingredient.carb * (ingredient.amount / ingredient.ss);
        fiber += ingredient.fiber * (ingredient.amount / ingredient.ss);
        sugar += ingredient.sugar * (ingredient.amount / ingredient.ss);
        prot += ingredient.prot * (ingredient.amount / ingredient.ss);
        alc += ingredient.alc * (ingredient.amount / ingredient.ss);
      }
    });

    return Ingredient(
      name: name,
      upc: '',
      tag1: '',
      tag2: '',
      tag3: '',
      tag4: '',
      tag5: '',
      usesml: false,
      ss: ss,
      hss: 1,
      hsu: name,
      cal: cal,
      fat: fat,
      na: na,
      k: k,
      carb: carb,
      fiber: fiber,
      sugar: sugar,
      prot: prot,
      alc: alc,
      amount: ss,
      note: '',
      lastUsed: DateTime.now()
    );
  }

  factory Ingredient.fromMap(Map data){
    if(data == null) return Ingredient.fromMap({});
    
    return Ingredient(
      name: data['name'] ?? data['description'] ?? '',
      upc: data['upc'] ?? '',
      tag1: data['tag 1'] ?? '',
      tag2: data['tag 2'] ?? '',
      tag3: data['tag 3'] ?? '',
      tag4: data['tag 4'] ?? '',
      tag5: data['tag 5'] ?? '',
      usesml: data['uses ml'] ?? false,
      ss: (data['serving size'] != null) ? (data['serving size'].toDouble() == 0 ? 1.0 : data['serving size'].toDouble()) : 1.0,
      hss: (data['household serving size'] != null) ? (data['household serving size'].toDouble() == 0 ? 1.0 : data['household serving size'].toDouble()) : 1.0,
      hsu: data['household serving unit'] ?? data['household unit'] ?? '',
      cal: (data['cal'] != null) ? data['cal'].toDouble() : 0.0,
      fat: (data['fat'] != null) ? data['fat'].toDouble() : 0.0,
      na: (data['na'] != null) ? data['na'].toDouble() : 0.0,
      k: (data['k'] != null) ? data['k'].toDouble() : 0.0,
      carb: (data['carb'] != null) ? data['carb'].toDouble() : 0.0,
      fiber: (data['fiber'] != null) ? data['fiber'].toDouble() : 0.0,
      sugar: (data['sugar'] != null) ? data['sugar'].toDouble() : 0.0,
      prot: (data['prot'] != null) ? data['prot'].toDouble() : 0.0,
      alc: (data['alc'] != null) ? data['alc'].toDouble() : 0.0,
      amount: data['amount'] ?? ((data['serving size'] != null) ? data['serving size'].toDouble() : 1.0),
      note: data['note'] ?? '',
      logType: data['log type'] ?? ingredientLogType,
      lastUsed: (data['last used'] != null) ? ((data['last used'] is Timestamp) ? (data['last used'] as Timestamp).toDate() : (data['last used'] as DateTime)) : null,
    );
  }

  factory Ingredient.fromAggregate(IngredientAggregateEntry data){
    return Ingredient(
      name: data.name,
      upc: '',
      tag1: data.tag1 ?? '',
      tag2: data.tag2 ?? '',
      tag3: data.tag3 ?? '',
      tag4: data.tag4 ?? '',
      tag5: data.tag5 ?? '',
      cal: data.cal,
      fat: data.fat,
      carb: data.carb,
      prot: data.prot,
      logType: ingredientLogType,
      note: data.note ?? '',
    );
  }

  factory Ingredient.toUserIngredient(Ingredient ingredient){
    return Ingredient(
      name: ingredient.name,
      upc: ingredient.upc,
      tag1: ingredient.tag1,
      tag2: ingredient.tag2,
      tag3: ingredient.tag3,
      tag4: ingredient.tag4,
      tag5: ingredient.tag5,
      usesml: ingredient.usesml,
      ss: ingredient.ss,
      hss: ingredient.hss,
      hsu: ingredient.hsu,
      cal: ingredient.cal,
      fat: ingredient.fat,
      na: ingredient.na,
      k: ingredient.k,
      carb: ingredient.carb,
      fiber: ingredient.fiber,
      sugar: ingredient.sugar,
      prot: ingredient.prot,
      alc: ingredient.alc,
      amount: ingredient.amount,
      note: ingredient.note,
      logType: ingredientLogType,
      lastUsed: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name' : this.name ?? "",
      'upc' : this.upc ?? "",
      'tag1' : this.tag1 ?? "",
      'tag2' : this.tag2 ?? "",
      'tag3' : this.tag3 ?? "",
      'tag4' : this.tag4 ?? "",
      'tag5' : this.tag5 ?? "",
      'household serving size' : this.hss ?? 0.0,
      'household serving unit' : this.hsu ?? '',
      'uses ml' : this.usesml ?? false,
      'serving size' : this.ss ?? 0.0,
      'cal' : this.cal ?? 0.0,
      'fat' : this.fat ?? 0.0,
      'na' : this.na ?? 0.0,
      'k' : this.k ?? 0.0,
      'carb' : this.carb ?? 0.0,
      'fiber' : this.fiber ?? 0.0,
      'sugar' : this.sugar ?? 0.0,
      'prot' : this.prot ?? 0.0,
      'alc' : this.alc ?? 0.0,
      'amount' : this.amount ?? 0.0,
      'note' : this.note ?? '',
      'log type' : this.logType ?? ingredientLogType,
      'last used' : this.lastUsed,
    };
  }

  @override
  String toString() {
    return "Ingredient: " + this.name + " " + this.upc;
  }

  bool operator == (o){
    return(
      o is Ingredient &&
      o.name == name &&
      o.upc == upc &&
      o.ss == ss &&
      o.logType == logType
    );
  }
}

class SelectedIngredient{
  final String name;
  final String upc;

  SelectedIngredient({
    this.name,
    this.upc = '',
  });

  String get docName {
    return (this.upc == '') ? this.name : this.upc;
  }

  factory SelectedIngredient.fromIngredient(Ingredient ingredient){
    return SelectedIngredient(name: ingredient.name, upc: ingredient.upc);
  }

  bool operator == (o){
    return(
      o is SelectedIngredient &&
      o.name == name &&
      o.upc == upc
    );
  }
}

class RequestIngredient{
  static final GlobalData<RequestIngredient> firebase = GlobalData(requestedIngredientCollection);
  static const String requestedIngredientCollection = "RequestedIngredients";

  final String name;
  String _docName;
  String _uid;

  RequestIngredient({
    this.name = "",
  }){
    this._uid = Calculations.getUuid();
    _docName = this._uid + "_" + this.name;
  }

  Future<void> makeRecord(){return firebase.upsert(this.toMap(), this.docName, merge: false);}

  String get docName => _docName;

  Map<String, dynamic> toMap(){
    return {
      'name': this.name,
      'timestamp': DateTime.now()
    };
  }
}

