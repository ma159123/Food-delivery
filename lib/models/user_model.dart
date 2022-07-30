class UserModel {
  var id=0;
  var name;
  var email;
  var phone;
  var orderCount=0;

  UserModel(
      {required this.id, required this.name, required this.phone, required this.email, required this.orderCount});

  factory UserModel.fromJson(Map<String, dynamic>json){
    return UserModel(id: json['id'],
        name: json['f_name'],
        phone: json['phone'],
        email: json['email'],
        orderCount: json['order_count'],
    );
  }

}