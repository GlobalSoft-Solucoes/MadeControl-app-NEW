class Response {
  String? status;
  String? token;
  List? result;

  Response({this.result, this.status, this.token});
  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    result = json['result'];
  }
}
