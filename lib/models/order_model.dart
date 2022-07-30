import 'package:food_delivery/models/address_model.dart';

class OrderModel {
  late int id;
  late int userId;
  double? orderAmount;
  String? orderStatus;
  String? paymentStatus;
  double? totalTaxAmount;
  String? orderNote;
  String? createdAt;
  String? updatedAt;
  double? deliveryCharge;
  String? scheduleAt;
  String? otp;
  String? pending;
  String? accepted;
  String? confirmed;
  String? processing;
  String? handover;
  String? pickedUp;
  String? delivered;
  String? canceled;
  String? refundRequested;
  String? refunded;
  int? scheduled;
  String? failed;
  int? detailsCount;

  AddressModel? deliveryAddress;

  OrderModel({
    required this.id,
    required this.userId,
    this.createdAt,
    this.accepted,
    this.canceled,
    this.confirmed,
    this.delivered,
    this.deliveryAddress,
    this.deliveryCharge,
    this.detailsCount,
    this.failed,
    this.handover,
    this.orderAmount,
    this.orderNote,
    this.orderStatus,
    this.otp,
    this.paymentStatus,
    this.pending,
    this.pickedUp,
    this.processing,
    this.refunded,
    this.refundRequested,
    this.scheduleAt,
    this.scheduled,
    this.totalTaxAmount,
    this.updatedAt,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderAmount = json['order_amount'].toDouble();
    paymentStatus = json['payment_status'] ?? 'pending';
    totalTaxAmount = 10.0;
    orderNote = json['orderNote'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderStatus = json['order_status'];
    deliveryCharge = 10.0;
    scheduleAt = json['schedule_at'] ?? '';
    otp = json['otp'];
    pending = json['pending'] ?? '';
    accepted = json['accepted'] ?? '';
    confirmed = json['confirmed'] ?? '';
    processing = json['processing'] ?? '';
    handover = json['handover'] ?? '';
    pickedUp = json['picked_up'] ?? '';
    delivered = json['delivered'] ?? '';
    canceled = json['canceled'] ?? '';
    scheduled = json['scheduled'] ?? '';
    failed = json['failed'] ?? '';
    detailsCount = json['details_count'];

    deliveryAddress = (json['delivery_address'] != null
        ? new AddressModel.fromJson(json['delivery_address'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
   data['id']=id;
     data['user_id']=userId;
     data['order_amount']=orderAmount;
   data['payment_status'] =paymentStatus;
    data['total_tax_amount']=totalTaxAmount ;
    data['orderNote']=orderNote;
    data['created_at']=createdAt;
   data['updated_at']=updatedAt;
    data['order_status']=orderStatus;
    data['delivery_charge']=deliveryCharge ;
    data['schedule_at']=scheduleAt;
    data['otp']=otp;
    data['pending'] =pending;
   data['accepted'] =accepted;
    data['confirmed'] =confirmed;
    data['processing']= processing;
    data['handover'] =handover;
    data['picked_up'] =pickedUp;
    data['delivered'] =delivered;
    data['canceled'] =canceled;
    data['scheduled'] =scheduled;
    data['failed'] =failed;
    data['details_count']=detailsCount;

     if(deliveryAddress!=null){
       data['delivery_address']=deliveryAddress?.toJson();
     }
    return data;
  }
}
