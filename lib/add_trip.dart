import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trippas/db_helper.dart';
import 'package:trippas/main.dart';
import 'package:trippas/trip.dart';



class AddTrip extends StatefulWidget{
  final Trip trip;
  bool boolean;
  AddTrip(this.trip,boolean);
    @override
    State<StatefulWidget> createState() => AddTripState(trip,boolean);
  }
  
  class AddTripState extends State<AddTrip>{
    int id = 1;
    Trip trip;
    AddTripState(this.trip,boolean);
    final _trip_types = ['Business', 'Vacation', 'Medical', 'Health'];
    String _value ;
    DateTime _currentDate = new DateTime.now();
    TextEditingController departureCityController = TextEditingController();
    TextEditingController destinationCityController = TextEditingController();
    TextEditingController departureDateController = TextEditingController();
    TextEditingController departureTimeController = TextEditingController();
    TextEditingController arrivalDateController = TextEditingController();
    TextEditingController arrivalTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {

  destinationCityController.text = trip.destinationCity;
  departureCityController.text = trip.departureCity;
  departureTimeController.text = trip.departureTime;
  departureDateController.text = trip.departureDate;
  arrivalDateController.text = trip.arrivalDate;
  arrivalTimeController.text = trip.arrivalTime;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50.0,),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value)=> this.updateCity(1),
                controller: departureCityController,
                decoration: InputDecoration(
                    labelText: 'Departure',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                keyboardType: TextInputType.text,
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child:TextField(
                        controller: departureDateController,
                        onTap: () {
                          _selectDate(context,2);
                        },
                        decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child:TextField(
                        controller: departureTimeController,
                        onTap: () {
                          _selectTime(context, 2);
                        },
                        decoration: InputDecoration(
                            labelText: 'Time',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ]
            ),
            Padding(padding: EdgeInsets.all(5.0),
              child: TextField(
                controller: destinationCityController,
                  onChanged: (value)=> this.updateCity(2),
                decoration: InputDecoration(
                    labelText: 'Destination',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
                keyboardType: TextInputType.text,
              ),),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child:TextField(
                        controller: arrivalDateController,
                        onTap: () {
                          _selectDate(context,1);
                        },
                        decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child:TextField(
                        controller: arrivalTimeController,
                        onTap: () {
                          _selectTime(context, 1);
                        },
                        decoration: InputDecoration(
                            labelText: 'Time',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ]
            ),
            Padding(padding: EdgeInsets.all(20.0),
              child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Trip type'),
                  items: _trip_types.map((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: _value,
                  onChanged: (String value){
                    _onTypeChanged(value);
                  }
              ),
            ),


            Padding(padding: EdgeInsets.all(15.0),
                child:  SizedBox(
                    width: double.infinity,
                    child:RaisedButton(child: Text('ADD TRIP'),
                        color: Colors.blue,
                        onPressed:(){
                          _addTrip(context);
                        }
                    )
                )
            ),
          ],
        ),
      )

    );
  }
  void _addTrip(BuildContext context){
    DbHelper helper = DbHelper();
      if(departureCityController.text.isEmpty || departureDateController.text.isEmpty || departureTimeController.text.isEmpty||
      destinationCityController.text.isEmpty || arrivalTimeController.text.isEmpty || arrivalDateController.text.isEmpty){
      var alert = AlertDialog(
        content: Text('Please fill empty field'),
      );
      showDialog(context: context,
      builder: (BuildContext context) => alert);
      }else {
        trip.departureCity = departureCityController.text;
          trip.destinationCity = destinationCityController.text;
          trip.tripType = getTriptype(_value);
          helper.insertTrip(trip);
          Navigator.pop(context, true);

      }

  }

  int getTriptype(String value){
      if(value == 'Business'){
        return 1;
      }else if(value == 'Vacation'){
        return 2;
      }else if(value == 'Medical'){
        return 3;
      }else if(value == 'Health'){
        return 4;
      }
  }

  _onTypeChanged(String val){
      setState(() {
        this._value = val;
        trip.tripType = getTriptype(_value);
      });
  }
    Future<Null>_selectDate(BuildContext context,int num) async{
      final DateTime _selDate = await showDatePicker(context: context, initialDate:_currentDate, firstDate: _currentDate,
          lastDate: DateTime(2030),
          builder: (context,child){
            return SingleChildScrollView(child: child);
          });
      if(_selDate != null){
        setState(() {
          String formatedDate = new DateFormat.yMMMd().format(_selDate);
          if(num == 1){
            trip.arrivalDate = formatedDate;
          }else if(num == 2){
            trip.departureDate = formatedDate;
          }
        });
      }
    }

    TimeOfDay timeOfDay = TimeOfDay.now();
    Future<Null>_selectTime(BuildContext context,int num) async{
      final TimeOfDay _selTime = await showTimePicker(context: context, initialTime: timeOfDay);

      if(_selTime != null){
        setState(() {
        if(num == 1){
          trip.arrivalTime =
          " ${_selTime.hour}:${_selTime.minute} ";
        }else if(num == 2){
          trip.departureTime =
          " ${_selTime.hour}:${_selTime.minute} ";
        }

        });
      }
    }


    void updateCity(int num){
      switch(num){
        case 1:
          trip.departureCity = departureCityController.text;
          break;
        case 2:
          trip.destinationCity = destinationCityController.text;

      }

    }




  }
