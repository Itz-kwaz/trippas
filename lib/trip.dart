class Trip{
   int _id;
  String _departureCity;
  String _destinationCity;
  String _departureDate;
  String _departureTime;
  String _arrivalDate;
  String _arrivalTime;
  int _tripType;

  Trip(this._departureCity,this._departureDate,this._departureTime,this._destinationCity,
      this._arrivalTime,this._arrivalDate,this._tripType);

  Trip.withId(this._id,this._departureCity,this._departureDate,this._departureTime,this._destinationCity,
   this._arrivalTime,this._arrivalDate,this._tripType);

  int get id => _id;
  String get departureCity => _departureCity;
  String get departureDate => _departureDate;
  String get departureTime => _departureTime;
  String get destinationCity => _destinationCity;
  String get arrivalDate => _arrivalDate;
  String get arrivalTime => _arrivalTime;
  int get tripType => _tripType;

  set departureCity(String departureCity){
    if(departureCity.length != 0){
      _departureCity = departureCity;
    }
  }

   set destinationCity(String destinationCity){
     if(destinationCity.length != 0){
       _destinationCity = destinationCity;
     }
     }

   set tripType(int tripType){
    if(tripType>0 && tripType < 5){
      _tripType = tripType;
    }
   }

   set departureDate( String departureDate){
    _departureDate = departureDate;
   }

   set departureTime(String departureTime){
    _departureTime = departureTime;
   }

   set arrivalDate(String arrivalDate){
    _arrivalDate = arrivalDate;
   }
   set id(int id){
    _id = id;
   }
   set arrivalTime(String arrivalTime){
    _arrivalTime = arrivalTime;
   }

   Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['departureCity'] = _departureCity;
    map['destinationCity'] = _destinationCity;
    map['departureDate'] = _departureDate;
    map['departureTime'] = _departureTime;
    map['arrivalDate'] =_arrivalDate;
    map['arrivalTime'] = _arrivalTime;
    map['tripType'] = _tripType;
      map["Id"] = _id;

    return map;
   }

   Trip.fromObject(dynamic o){
    this._id = o['id'];
    this._departureCity = o['departureCity'];
    this._destinationCity = o['destinationCity'];
    this._departureDate = o['departureDate'];
    this._departureTime = o['departureTime'];
    this._arrivalDate = o['arrivalDate'];
    this._arrivalTime = o['arrivalTime'];
    this._tripType = o['tripType'];
   }

}