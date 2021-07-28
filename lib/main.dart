import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  // String query = "Meet";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _itemCount = 0;
  var jsonResponse;
  String Query;

  Future<void> getQuote(query) async {
    String url = "http://10.0.2.2:5000/api/v1/?query=$query";
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = convert.jsonDecode(response.body);
        _itemCount = jsonResponse.length;
        print("Number of quotes found: $_itemCount");
      });
    } else {
      print("Request failed with statues: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.purple[800],
          Colors.purple[600],
          Colors.purple[300]
        ])),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                  child: Center(
                child: Text("Quotes for you",
                    style: GoogleFonts.tangerine(
                        textStyle: TextStyle(
                            fontSize: 60,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
              )),
            ),
            Padding(
              padding: EdgeInsets.all(22),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: TextField(
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "❝ Search quotes here..."),
                        onChanged: (value) {
                          Query = value;
                        },
                      ),
                    )),
                    IconButton(
                        onPressed: () {
                          getQuote(Query);
                          setState(() {
                            _itemCount = 0;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.purple[800],
                          size: 30,
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Container(
                child: _itemCount == 0
                    ? Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.purple[800],
                        )),
                      )
                    : Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(jsonResponse[index]["quote"],
                                    style: GoogleFonts.openSans(
                                        textStyle:
                                            TextStyle(color: Colors.black))),
                                subtitle: Text(jsonResponse[index]["author"],
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.end));
                          },
                          itemCount: _itemCount,
                        )),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
