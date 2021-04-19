class App {
  final int id;
  final String packageName;

  App({this.id,this.packageName});

  Map<String, dynamic> toMap(){
    return {"id":id,"packageName":packageName};
  }
}