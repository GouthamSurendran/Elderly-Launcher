class Medicine {
  final int id;
  final String name;
  final int timeOfDayId;
  final int hasTaken;
  final String desc;

  Medicine({this.id,this.name,this.desc,this.timeOfDayId,this.hasTaken});

  Map<String, dynamic> toMap(){
    return {"id":id,"name":name,"desc":desc,"timeOfDayId":timeOfDayId,"hasTaken":hasTaken};
  }
}