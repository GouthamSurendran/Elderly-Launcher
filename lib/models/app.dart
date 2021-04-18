class App {
  final int id;
  final String appName;

  App({this.id,this.appName});

  Map<String, dynamic> toMap(){
    return {"id":id,"appName":appName};
  }
}