import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
   HomePage({super.key});

  TextEditingController searchController =TextEditingController() ;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body:  Padding(
        padding: EdgeInsets.all(11),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(Icons.search),
                hintText: "Whats on your mind",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}