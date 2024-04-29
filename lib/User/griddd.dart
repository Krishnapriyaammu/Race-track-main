import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_grid/responsive_grid.dart';

class GridPageView1 extends StatefulWidget {
  const GridPageView1({super.key});

  @override
  State<GridPageView1> createState() => _GridPageView1State();
}

class _GridPageView1State extends State<GridPageView1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(),
body:ResponsiveGridList(
        desiredItemWidth: 100,
        minSpacing: 10,
        children: List.generate(20, (index)=> index+1).map((i) {
          return Container(
            height: 150,
            alignment: Alignment(0, 0),
            color: Colors.cyan,
            child: Text(i.toString()),
          );
        }).toList()
    )


    );
  }
}