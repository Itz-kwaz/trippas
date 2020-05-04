
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:trippas/add_trip.dart';
import 'package:trippas/trip.dart';
import 'package:trippas/db_helper.dart';
import 'package:trippas/trips_list.dart';


void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
    home:MyApp(),
  )
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}
class   _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      title: Text('Tripass',
        style:TextStyle(color: Colors.blueAccent,
            fontSize: 35.0,
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      navigateAfterSeconds: MainScreen(),

    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState () => new MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  DbHelper helper = DbHelper();
  int count = 0;
  List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Padding(padding: EdgeInsets.only(top: 50.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left:8.0),
                      child: Text('Hello there',
                        style:TextStyle(
                          fontSize: 25.0,
                        ) ,
                      ),
                    ),
                    SizedBox(width: 130.0
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      padding: EdgeInsets.all(5.0),
                      child: Text("$count trips",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Padding(padding: EdgeInsets.only(left: 10.0),
                  child:Text("Create your",
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
                Padding(padding: EdgeInsets.only(left: 10.0),
                  child:Text("trips with us",
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
                Expanded(
                  child:TripsList(),
                ),
              ],
            )
        )
    );

  }

  @override
  void setState(VoidCallback fn) {
    getData();
  }


  void getData(){
    final dbFuture  = helper.initializeDb();
    dbFuture.then(
            (result){
          final tripsFuture = helper.getTrips();
          tripsFuture.then((result){
            List<Trip> tripsList = List<Trip>();
            count = result.length;
            for(int i = 0;i<count;i++){
              tripsList.add(Trip.fromObject(result[i]));
            }
            setState(() {
              trips = tripsList;
              count = count;
              debugPrint("Items"+ count.toString());
            });
          });
        }
    );
  }

  @override
  void initState() {
    getData();
  }
}




