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

class CustomAlphabetSlider extends StatelessWidget {
  final double value;
  final String label;
  final String title;
  final List<String> options;
  final Function(double) onChanged;


  CustomAlphabetSlider({
    this.value,
    this.title,
    this.label,
    this.options,
    this.onChanged,
  });
  

  @override
  Widget build(BuildContext context) {
    double thumbWidth = 69.0;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: FoodFrenzyColors.jjBlack.withAlpha(0x00),
        inactiveTrackColor: FoodFrenzyColors.jjBlack.withAlpha(0x00),
        // activeTrackColor: FoodFrenzyColors.secondary,
        // inactiveTickMarkColor: FoodFrenzyColors.secondary,
        overlayColor: FoodFrenzyColors.jjBlack,
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
        activeTickMarkColor: FoodFrenzyColors.main,
        valueIndicatorColor: FoodFrenzyColors.main,
        valueIndicatorShape: NullValueIndicator(),
        // trackHeight: 10,
        trackHeight: thumbWidth / FoodFrenzyRatios.gold,
        thumbShape: (this.options == null) ?
          CustomSliderThumbRect(
            thumbRadius: 5,
            thumbWidth: thumbWidth,
            min: 0,
            max: 26,
            isAlph: true,
          ) : 
          CustomChoiceSliderThumbRect(
            thumbRadius: 5,
            options: options,
            thumbWidth: thumbWidth,
            min: 0,
            max: 26,
          )
      ),
      child: Container(
        decoration: BoxDecoration(
          color: FoodFrenzyColors.tertiary,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        padding: EdgeInsets.only(right: 34),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(width: thumbWidth/2 + 21,),
                Expanded(
                  flex: 5,
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 26,
                    divisions: 26,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final String title;
  final List<String> options;
  final Function(double) onChanged;


  CustomSlider({
    this.value,
    this.min,
    this.max,
    this.divisions,
    this.title,
    this.label,
    this.options,
    this.onChanged,
  });
  

  @override
  Widget build(BuildContext context) {
    double thumbWidth = 69.0;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: FoodFrenzyColors.jjBlack.withAlpha(0x00),
        inactiveTrackColor: FoodFrenzyColors.jjBlack.withAlpha(0x00),
        // activeTrackColor: FoodFrenzyColors.secondary,
        // inactiveTickMarkColor: FoodFrenzyColors.secondary,
        overlayColor: FoodFrenzyColors.jjBlack,
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
        activeTickMarkColor: FoodFrenzyColors.main,
        valueIndicatorColor: FoodFrenzyColors.main,
        valueIndicatorShape: NullValueIndicator(),
        // trackHeight: 10,
        trackHeight: thumbWidth / FoodFrenzyRatios.gold,
        thumbShape: (this.options == null) ?
          CustomSliderThumbRect(
            thumbRadius: 5,
            thumbWidth: thumbWidth,
            min: min.toInt(),
            max: max.toInt(),
          ) : 
          CustomChoiceSliderThumbRect(
            thumbRadius: 5,
            options: options,
            thumbWidth: thumbWidth,
            min: min.toInt(),
            max: max.toInt(),
          )
      ),
      child: Container(
        decoration: BoxDecoration(
          color: FoodFrenzyColors.tertiary,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        padding: EdgeInsets.only(right: 34),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: thumbWidth / FoodFrenzyRatios.gold / 2,
                        child: AST(
                          title,
                          textAlign: TextAlign.right,
                          color: FoodFrenzyColors.secondary,
                          size: 50,
                        ),
                      ),
                      Container(
                        height: thumbWidth / FoodFrenzyRatios.gold / 2,
                        child: AST(
                          label,
                          textAlign: TextAlign.right,
                          color: FoodFrenzyColors.main,
                          size: 50,
                        ),
                      ),
                    ],
                  )
                ),
                Container(width: thumbWidth/2 + 21,),
                Expanded(
                  flex: 5,
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    label: label,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final double thumbWidth;
  final int min;
  final int max;
  final bool isAlph;

  const CustomSliderThumbRect({
    this.thumbRadius,
    this.thumbWidth,
    this.min,
    this.max,
    this.isAlph = false,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint (
    PaintingContext context,
    Offset center,
    {Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow}
  ){
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbWidth, height: thumbWidth / FoodFrenzyRatios.gold),
      Radius.circular(thumbRadius),
    );

    final paint = Paint()
      ..color = FoodFrenzyColors.main
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontSize: thumbWidth * .3,
            fontWeight: FontWeight.w700,
            color: FoodFrenzyColors.tertiary,
            height: 0.9),
        text: isAlph ? (TextHelpers.alphabet[double.tryParse(getValue(value)).round()]) : getValue(value));
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (((max) * (value)) + ((value == 1) ? 0 : min)).truncate().toString();
  }
}

class CustomChoiceSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final double thumbWidth;
  final List<String> options;
  final int min;
  final int max;
  final bool isAlph;

  const CustomChoiceSliderThumbRect({
    this.thumbRadius,
    this.thumbWidth,
    this.options,
    this.min,
    this.max,
    this.isAlph = false,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint (
    PaintingContext context,
    Offset center,
    {Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow}
  ){
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbWidth, height: thumbWidth / FoodFrenzyRatios.gold),
      Radius.circular(thumbRadius),
    );

    final paint = Paint()
      ..color = FoodFrenzyColors.main
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontSize: thumbWidth * .3,
            fontWeight: FontWeight.w700,
            color: FoodFrenzyColors.tertiary,
            height: 0.9),
        text: isAlph ? (TextHelpers.alphabet[double.tryParse(getValue(value)).round()]) : getValue(value));
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return options[(((max) * (value)) + ((value == 1.0) ? 0 : min)).truncate()];
  }
}

class NullValueIndicator extends SliderComponentShape {

  const NullValueIndicator();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(0);
  }

  @override
  void paint (
    PaintingContext context,
    Offset center,
    {Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow}
  ){}
}