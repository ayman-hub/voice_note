class DataEntities{
  late DateTime date ;
  late String link;
  late String note;

  DataEntities({required this.date,required this.link,required this.note});

  DataEntities.fromJson(Map<String, dynamic> data ){
    date = DateTime.parse(data['time']);
    link = data['link'];
    note = data['note'];
  }
  toJson(){
    Map<String, dynamic> data = Map();
    data['time'] = date.toString();
    data['link'] = link;
    data['note'] = note;

    return data;
  }
}