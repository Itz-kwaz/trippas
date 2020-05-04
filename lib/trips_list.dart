import 'package:flutter/cupertino.dart';
import 'package:trippas/db_helper.dart';
import 'package:trippas/trip.dart';
import 'package:flutter/material.dart';
import 'package:trippas/add_trip.dart';

class TripsList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TripsListState();
  }


}

class TripsListState extends State {
  static const  popItem = <String>['Delete', 'Update'];
  static List<PopupMenuItem<String>> _pop  = popItem.map((String val) =>
    PopupMenuItem<String>(
      value: val,
      child: Text(val),
    )).toList();

  String value;

  DbHelper helper = DbHelper();
  List<Trip> trips;
  int count = 0;
  bool boolean;
  @override
  Widget build(BuildContext context) {
    if(trips == null){
      trips = List<Trip>();
      getData();
    }
    return Scaffold(floatingActionButton: FloatingActionButton(onPressed:(){
      Trip trip = Trip('','','','','','',1);
      boolean = false;
      navigateTo(trip,boolean);
    },
      child:Icon(Icons.add) ,
    ),
      body: ListView.builder(
          itemCount: count,
          itemBuilder:(context,index){
            return  Container(
              padding:EdgeInsets.all(10.0),
              child: Card(elevation: 10.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5.0),
                          Text(this.trips[index].departureCity,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Text(this.trips[index].departureDate,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize:15.0
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Text(this.trips[index].departureTime,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize:15.0
                            ),
                          ),
                          SizedBox(height: 15.0
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              color: getColor(trips[index].tripType),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            padding: EdgeInsets.all(5.0),
                            child: Text(getTripType(trips[index].tripType),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:ImageIcon(AssetImage('assets/airplane.png')),
                      width: 30.0,
                      height: 30.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(height: 15.0),
                          Text(this.trips[index].destinationCity,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Text(this.trips[index].arrivalDate,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize:15.0
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Text(this.trips[index].arrivalTime,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize:15.0
                            ),
                          ),
                          SizedBox(height: 15.0
                          ),
                          PopupMenuButton(
                              onSelected: (String val) async {
                                value = val;
                                int result;
                                switch (value) {
                                  case "Update":
                                    debugPrint(this.trips[index].id.toString());
                                    boolean = true;
                                    navigateTo(this.trips[index],boolean);
                                    break;
                                  case 'Delete':
                                    result = await helper.deleteTrip(trips[index].destinationCity);
                                    if (result != 0) {
                                      AlertDialog alertDialog = AlertDialog(
                                        title: Text("Delete trip"),
                                        content: Text("The Trip has been deleted"),
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (_) => alertDialog);
                                      getData();
                                    }
                                    break;
                                }

                              },
                              itemBuilder:(BuildContext context) =>_pop)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );

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
  Color getColor(int _triptype) {
    switch (_triptype) {
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.redAccent;
        break;
      case 4:
        return Colors.lightBlue;
        break;

      default:
        return Colors.blue;
    }
  }

  String getTripType( int _triptype){
    switch (_triptype) {
      case 1:
        return 'Business';
        break;
      case 2:
        return 'Vacation';
        break;
      case 3:
        return 'Medical';
        break;
      case 4:
        return 'Health';
        break;

      default:
        return 'Business';
    }
  }
  void navigateTo(Trip trip,bool boolean) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
        builder: (context)  => AddTrip(trip,boolean),
    )
    );
    if(result == true){
      getData();
    }
  }
}