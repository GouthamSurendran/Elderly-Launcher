class Medicine {
  final int id;
  final String name;
  final int timeOfDayId;
  final int hasTaken;

  Medicine({this.id,this.name,this.timeOfDayId,this.hasTaken});

  Map<String, dynamic> toMap(){
    return {"id":id,"name":name,"timeOfDayId":timeOfDayId,"hasTaken":hasTaken};
  }
}