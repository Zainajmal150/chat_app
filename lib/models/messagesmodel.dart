class Message {
  Message({
    required this.msg,
    required this.formid,
    required this.toid,
    required this.read,
    required this.type,
    required this.sent,
  });
  late final String msg;
  late final String formid;
  late final String toid;
  late final String read;
  late final Type type;
  late final String sent;
  
  Message.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    formid = json['formid'];
    toid = json['toid'];
    read = json['read'];
    type = json['type'] == Type.image.name?Type.image:Type.text;
    sent = json['sent'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['formid'] = formid;
    data['toid'] = toid;
    data['read'] = read;
    data['type'] = type.name;
    data['sent'] = sent;
    return data;
  }
}
enum Type{text,image}