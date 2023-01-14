import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/rendering.dart';

Size? screenSize;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

List<Map> sidebar_jsondata_att_list =
[
  {"ws_select_formatt_Desc" : "test att desc 1",
    "ws_select_formatt_idx" : 0,
    "attHeroTag": "testAttHeroTag1"
  },

  {"ws_select_formatt_Desc" : "test att desc 2",
    "ws_select_formatt_idx" : 1,
    "attHeroTag": "testAttHeroTag2"
  }
];
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
gen_hero_list_item( List<Map> side_att_json_data, int s_att_idx, Size screenSize ){
return Container(child: GestureDetector(
        child: Hero(
          tag: side_att_json_data[s_att_idx]["attHeroTag"],
          child:
          // needed to prevent render overflow with text
          Material(
              type: MaterialType.transparency,
              child:
          Container(
              width: screenSize.width*.3,
              height: screenSize.width*.07,
              color: Colors.green,
              child: Center(child:
                  // Icon(Icons.ac_unit)
              Text(
                  side_att_json_data[s_att_idx]["ws_select_formatt_Desc"],
                  style: TextStyle(overflow: TextOverflow.fade,
                  fontSize: 12.0
                  ),
              ),

              ),

            ))
        ),
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_) {
          //   return DetailScreen(side_att_json_data[s_att_idx]);
          // }));
          Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(milliseconds:900),
              pageBuilder: (_,__,___) {
            return DetailScreen(side_att_json_data[s_att_idx]);
          }));

        },
      )
      );
}
 


  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    Widget col_1_sidebar_listview_builder = ListView.builder(itemCount: sidebar_jsondata_att_list.length,
        itemBuilder: (context, col_1_idx ){
          return gen_hero_list_item(sidebar_jsondata_att_list, col_1_idx,
              screenSize!);
        });

    return Scaffold(
      body: 
      Container(
        height: screenSize!.height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
      Container(
        child:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
            Container(
                height: screenSize!.height,
                width: screenSize!.width * .8,
                        child: col_1_sidebar_listview_builder)
              ],)),
        ])),
        );
  }
}

class DetailScreen extends StatelessWidget {
  
  DetailScreen(this.dsh_data);
  Map dsh_data;

  Widget build(BuildContext context) {

    // Tween<Rect?> _createRectTween(Rect? begin, Rect? end) {
    //   return CustomRectTween(begin: begin, end: end);
    // }

    // Tween<Rect?> _createRectTween(Rect? begin, Rect? end) {
    //      return CustomMaterialRectCenterArcTween(begin: begin, end: end);
    //   }

    Tween<Rect?> _createRectTween(Rect? begin, Rect? end) {
      return CustomMaterialRectCenterArcTween2(begin: begin, end: end);
    }

    return Scaffold(
      appBar:AppBar(),
      body: GestureDetector(
        child:Container(
            // color: Colors.blue,
            child: Center(
          child: Hero(
            // createRectTween: CustomMaterialRectCenterArcTween(begin: begin, end: end),

              // flightShuttleBuilder:(flightContext, animation, flightDirection, fromHeroContext, toHeroContext){
              //   return custom_flightShuttleBuilder(flightContext, animation, flightDirection, fromHeroContext,toHeroContext);},

            createRectTween: _createRectTween,
            tag: dsh_data["attHeroTag"],
            child: Material(
              type: MaterialType.transparency,
              child: Container(
              width: screenSize!.width*.3,
              height: screenSize!.width*.07,
              color: Colors.green,
              child: Center(child:
              // Icon(Icons.ac_unit)
              Text(dsh_data["ws_select_formatt_Desc"],
              style: TextStyle(overflow: TextOverflow.fade,
                  fontSize: 12.0
              )
              )
                ,),
            ))
          ),
        )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class QuadraticOffsetTween2 extends Tween<Offset> {
  QuadraticOffsetTween2( {
    Offset? begin,
    Offset? end,
  }) : super(begin: begin, end: end);

  @override
  Offset lerp(double t) {
    if (t == 0.0) return begin ?? Offset(0, 0);
    if (t == 1.0) return end ?? Offset(0, 0);
    final double x =  (begin!.dx  +
        (end!.dx )  ) - (end!.dx * math.pow(t,3));
    final double y = ( begin!.dy * math.pow(t, 3) +
        (end!.dy  ) * t ) - math.pow(t,3) ;
    return Offset(x, y);
  }
}

class CustomMaterialRectCenterArcTween2 extends RectTween {
  /// Creates a [Tween] for animating [Rect]s along a circular arc.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is
  /// first used, but the arguments can be null if the values are going to be
  /// filled in later.
  CustomMaterialRectCenterArcTween2({
    Rect? begin,
    Rect? end,
  }) : super(begin: begin, end: end);

  bool _dirty = true;

  void _initialize() {
    assert(begin != null);
    assert(end != null);
    _centerArc = QuadraticOffsetTween2(
      begin: begin?.center,
      end: end?.center,
    );
    _dirty = false;
  }

  /// If [begin] and [end] are non-null, returns a tween that interpolates along
  /// a circular arc between [begin]'s [Rect.center] and [end]'s [Rect.center].
  QuadraticOffsetTween2? get centerArc {
    if (begin == null || end == null) return null;
    if (_dirty) _initialize();
    return _centerArc;
  }

  QuadraticOffsetTween2? _centerArc;

  @override
  set begin(Rect? value) {
    if (value != begin) {
      super.begin = value;
      _dirty = true;
    }
  }

  @override
  set end(Rect? value) {
    if (value != end) {
      super.end = value;
      _dirty = true;
    }
  }

  @override
  Rect? lerp(double t) {
    if (_dirty) _initialize();
    if (t == 0.0) return begin;
    if (t == 1.0) return end;
    final Offset center = _centerArc!.lerp(t);
    final double? width = lerpDouble(begin!.width, end!.width, t);
    final double? height = lerpDouble(begin!.height, end!.height, t);
    return Rect.fromLTWH(
        center.dx - width! / 2.0, center.dy - height! / 2.0, width, height);
  }

  @override
  String toString() {
    return '$runtimeType($begin \u2192 $end; centerArc=$centerArc)';
  }
}

// class MyCurve extends Curve {
//   @override
//   double transform(double t) {
//     assert(t >= 0.0 && t <= 1.0);
//     return -15 * math.pow(t, 2) + 15 * t + 1;
//   }
// }
//
// class ValleyQuadraticCurve extends Curve {
//   @override
//   double transform(double t) {
//     assert(t >= 0.0 && t <= 1.0);
//     return 4 * math.pow(t - 0.5, 2).toDouble();
//   }
// }
//
// class PeakQuadraticCurve extends Curve {
//   @override
//   double transform(double t) {
//     assert(t >= 0.0 && t <= 1.0);
//     return -15 * math.pow(t, 2) + 15 * t + 1;
//   }
// }

// class CustomMaterialRectCenterArcTween extends RectTween {
//   /// Creates a [Tween] for animating [Rect]s along a circular arc.
//   ///
//   /// The [begin] and [end] properties must be non-null before the tween is
//   /// first used, but the arguments can be null if the values are going to be
//   /// filled in later.
//   CustomMaterialRectCenterArcTween({
//     Rect? begin,
//     Rect? end,
//   }) : super(begin: begin, end: end);
//
//   bool _dirty = true;
//
//   void _initialize() {
//     assert(begin != null);
//     assert(end != null);
//     _centerArc = QuadraticOffsetTween(
//       begin: begin?.center,
//       end: end?.center,
//     );
//     _dirty = false;
//   }
//
//   /// If [begin] and [end] are non-null, returns a tween that interpolates along
//   /// a circular arc between [begin]'s [Rect.center] and [end]'s [Rect.center].
//   QuadraticOffsetTween? get centerArc {
//     if (begin == null || end == null) return null;
//     if (_dirty) _initialize();
//     return _centerArc;
//   }
//
//   QuadraticOffsetTween? _centerArc;
//
//   @override
//   set begin(Rect? value) {
//     if (value != begin) {
//       super.begin = value;
//       _dirty = true;
//     }
//   }
//
//   @override
//   set end(Rect? value) {
//     if (value != end) {
//       super.end = value;
//       _dirty = true;
//     }
//   }
//
//   @override
//   Rect? lerp(double t) {
//     if (_dirty) _initialize();
//     if (t == 0.0) return begin;
//     if (t == 1.0) return end;
//     final Offset center = _centerArc!.lerp(t);
//     final double? width = lerpDouble(begin!.width, end!.width, t);
//     final double? height = lerpDouble(begin!.height, end!.height, t);
//     return Rect.fromLTWH(
//         center.dx - width! / 2.0, center.dy - height! / 2.0, width, height);
//   }
//
//   @override
//   String toString() {
//     return '$runtimeType($begin \u2192 $end; centerArc=$centerArc)';
//   }
// }

// class QuadraticOffsetTween extends Tween<Offset> {
//   QuadraticOffsetTween({
//     Offset? begin,
//     Offset? end,
//   }) : super(begin: begin, end: end);
//
//   @override
//   Offset lerp(double t) {
//     if (t == 0.0) return begin ?? Offset(0, 0);
//     if (t == 1.0) return end ?? Offset(0, 0);
//     final double x = -11 * begin!.dx * math.pow(t, 2) +
//         (end!.dx + 10 * begin!.dx) * t +
//         begin!.dx;
//     final double y = -2 * begin!.dy * math.pow(t, 2) +
//         (end!.dy + 1 * begin!.dy) * t +
//         begin!.dy;
//     return Offset(x, y);
//   }
// }


// class CustomRectTween extends Tween<Rect> {
//   CustomRectTween({Rect? begin, Rect? end})
//       : super(begin: begin, end: end) {}
//
//   @override
//   Rect lerp(double t) {
//
//     double height = end!.top - begin!.top;
//     double width = end!.left - begin!.left;
//
//     double startheight = begin!.top - begin!.bottom;
//     double startwidth = begin!.right - begin!.left;
//
//     // double animatedX = ((begin!.left - begin!.right) /t )* t;
//     // double animatedY = ((begin!.top -begin!.bottom) /t ) * t;
//
//     Cubic easeOutQuad = Cubic(0.25, 0.46, 0.45, 0.94);
//
//     double transformedY = easeOutQuad.transform(t);
//
//     // double animatedX = begin!.left + (t * width);
//     // double animatedY = begin!.top + (transformedY * height);
//
//     // double animatedX =  t;
//     // double animatedY = t;
//
//       double animatedX = easeOutQuad;
//       double animatedY = easeOutQuad;
//     return Rect.fromLTWH(animatedX, animatedY, begin!.left * 5, height*5);
//   }
// }



// class CustomRectTween extends Tween<Rect> {
//   CustomRectTween({Rect? begin, Rect? end})
//       : super(begin: begin, end: end) {}
//
//   @override
//   Rect lerp(double t) {
//
//     double height = end!.top - begin!.top;
//     double width = end!.left - begin!.left;
//
//     double animatedX = begin!.left + (t * width);
//     double animatedY = begin!.top + (t * height);
//
//     return Rect.fromLTWH(animatedX, animatedY, 1, 1);
//   }
// }


// class CustomRectTween extends Tween<Rect> {
//   CustomRectTween({this.begin, this.end}) : super(begin: begin, end: end);
//   Rect? begin;
//   Rect? end;
//
//   @override
//   Rect lerp(double t) {
//     Curves.elasticOut.transform(t);
//     //any curve can be applied here e.g. Curve.elasticOut.transform(t);
//     final verticalDist = Cubic(0.72, 0.15, 0.5, 1.23).transform(t);
//
//     final top = lerpDouble(begin!.top, end!.top, t) * (1 - verticalDist);
//     return Rect.fromLTRB(
//       lerpDouble(begin!.left, end!.left, t),
//       top,
//       lerpDouble(begin!.right, end!.right, t),
//       lerpDouble(begin!.bottom, end!.bottom, t),
//     );
//   }
//
//   double lerpDouble(num a, num b, double t) {
//     // if (a == null && b == null) return null;
//     a ??= 0.0;
//     b ??= 0.0;
//     return a + (b - a) * t;
//   }
// }


// custom_flightShuttleBuilder(flightContext, animation, flightDirection,
//     fromHeroContext, toHeroContext) {
//   {
//     final toHero = toHeroContext.widget as Hero;
//     return ScaleTransition(
//       scale: animation.drive(
//         Tween<double>(begin: 0.0, end: 1.0).chain(
//           CurveTween(
//             curve: Interval(0.0, 1.0, curve: PeakQuadraticCurve()),
//           ),
//         ),
//       ),
//       child: flightDirection == HeroFlightDirection.push
//           ? RotationTransition(
//         turns: animation,
//         child: toHero.child,
//       )
//           : FadeTransition(
//         opacity: animation.drive(
//           Tween<double>(begin: 0.0, end: 1.0).chain(
//             CurveTween(
//               curve: Interval(0.0, 1.0,
//                   curve: ValleyQuadraticCurve()),
//             ),
//           ),
//         ),
//         child: toHero.child,
//       ),
//     );
//   }
// }