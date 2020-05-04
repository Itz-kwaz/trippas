import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:trippas/trip.dart';

class DbHelper{
  static final DbHelper _dbHelper = DbHelper._internal();
    String tblTrip = "Trip";
    String colId = "Id";
    String colDepartureCity = "departureCity";
    String colDestinationCity = "destinationCity";
    String colDepartureTime = "departureTime";
    String colDepartureDate = "departureDate";
    String colArrivalDate = "arrivalDate";
    String colArrivalTime  = "arrivalTime";
    String colTripType  = "tripType";

  DbHelper._internal();

  factory DbHelper() => _dbHelper;

  static Database _db;

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "trips.db";
    var dbTrips = await openDatabase(path,version: 1, onCreate:  _createDb);
    return dbTrips;
  }

  Future<Database> get db async{
    if(_db == null){
      _db = await initializeDb();
    }
    return _db;
  }



  void _createDb(Database db,int newVersion) async{
    await db.execute(
        "CREATE TABLE $tblTrip($colId INTEGER  PRIMARY KEY AUTOINCREMENT,  $colDepartureCity TEXT, $colDestinationCity TEXT, $colDepartureDate TEXT, $colDepartureTime TEXT, $colArrivalDate TEXT,  $colArrivalTime TEXT, $colTripType INTEGER)");
  }

  Future<int> insertTrip (Trip trip) async {
    Database db = await this.db;
     var result = await db.insert(tblTrip, trip.toMap());
    return result;
  }

  Future<List> getTrips() async{
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblTrip order by $colId ASC");
    return result;
  }


  Future<int> getCount() async{
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from $tblTrip")
    );
    return result;
  }

  Future<int> updateTrip(Trip trip)async{
    Database db = await this.db;
    var result = await db.update(tblTrip, trip.toMap(),
    where: "$colId = ?", whereArgs: [trip.id]);
    return result;
  }

  Future<int> deleteTrip(String departureCity) async{
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblTrip  WHERE $colDepartureCity  = $colDepartureCity');
    return result;
  }

  Future<List> getId() async{
    Database db = await this.db;
    var result  = await db.rawQuery('SELECT $colId FROM $tblTrip ');
    return result;
  }
}


