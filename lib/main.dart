import 'package:flutter/material.dart';
import 'dart:ui';
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
    "ws_select_formatt_XYZPos" : [1,1],
    "attHeroTag": "testAttHeroTag1"
  },

  {"ws_select_formatt_Desc" : "test att desc 2",
    "ws_select_formatt_XYZPos" : [2,2],
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
    return Scaffold(
      appBar:AppBar(),
      body: GestureDetector(
        child:Container(
            color: Colors.blue,
            child: Center(
          child: Hero(
            // createRectTween: CustomMaterialRectCenterArcTween(begin: begin, end: end),
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
