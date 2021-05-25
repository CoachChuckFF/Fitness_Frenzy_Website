/*
* Christian Krueger Health LLC.
* All Rights Reserved.
*
* Author: Christian Krueger
* Date: 4.16.20
*
*/
//Internal


class Macro{

  double cal;
  double fat;
  double carb;
  double prot;

  Macro({
    this.cal = 0,
    this.fat = 0,
    this.carb = 0,
    this.prot = 0,
  });

  void addMacro(Macro other){
    if(other == null) return;

    this.cal += other.cal;
    this.fat += other.fat;
    this.carb += other.carb;
    this.prot += other.prot;
  }

  void averageMacro(int count){
    if(count == 0) return;

    this.cal /= count;
    this.fat /= count;
    this.carb /= count;
    this.prot /= count;
  }
}

class Micro{

  double sodium;
  double sugar;
  double fiber;
  double alcohol;

  Micro({
    this.sodium = 0,
    this.sugar = 0,
    this.fiber = 0,
    this.alcohol = 0,
  });

  void addMicro(Micro other){
    if(other == null) return;

    this.sodium += other.sodium;
    this.sugar += other.sugar;
    this.fiber += other.fiber;
    this.alcohol += other.alcohol;
  }
}