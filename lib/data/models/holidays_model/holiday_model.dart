class HolidayModel {
  HolidayModel({
    required this.items,
  });
  late final List<Items> items;
  
  HolidayModel.fromJson(Map<String, dynamic> json){
    items = List.from(json['items']).map((e)=>Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = items.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Items {
  Items({
    required this.summary,
    required this.description,
    required this.start,
    required this.end,
  });
  late final String summary;
  late final String description;
  late final Start start;
  late final End end;
  
  Items.fromJson(Map<String, dynamic> json){
    summary = json['summary'];
    description = json['description'];
    start = Start.fromJson(json['start']);
    end = End.fromJson(json['end']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['summary'] = summary;
    _data['description'] = description;
    _data['start'] = start.toJson();
    _data['end'] = end.toJson();
    return _data;
  }
}

class Start {
  Start({
    required this.date,
  });
  late final String date;
  
  Start.fromJson(Map<String, dynamic> json){
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    return _data;
  }
}

class End {
  End({
    required this.date,
  });
  late final String date;
  
  End.fromJson(Map<String, dynamic> json){
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    return _data;
  }
}