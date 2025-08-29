import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatelessWidget{
   HomePage({super.key});

  TextEditingController searchController =TextEditingController() ;
  String response = '';
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
            SizedBox(
              height: 11,
            ),
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                  onPressed: (){

                  },
                  child: Text("Search"),

              ),

            ),
            SizedBox(
              height: 11,
            ),
            Text(
                response,
              style: TextStyle(
                fontSize: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }

}