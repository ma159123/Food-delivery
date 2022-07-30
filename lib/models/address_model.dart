class AddressModel{
   int? _id;
   String? _addressType;
   String? _contactPersonName;
   String? _contactPersonNumber;
   String? _address;
   String? _latitude;
   String? _longitude;

  AddressModel({
    id,
    required addressType,
    contactPersonName,
    contactPersonNumber,
    address,
    latitude,
    longitude,
}){
    _id=id;
    _addressType=addressType;
    _contactPersonName=contactPersonName;
    _contactPersonNumber=contactPersonNumber;
    _latitude=latitude;
    _longitude=longitude;
    _address=address;
  }

  String? get address=>_address;
  String? get latitude=>_latitude;
  String? get longitude=>_longitude;
  String? get addressType=>_addressType;
  String? get contactPersonNumber=>_contactPersonNumber;
  String? get contactPersonName=>_contactPersonName;


  AddressModel.fromJson(Map<String,dynamic>json){
    _id=json['id'];
    _addressType=json['address_type']??"";
    _address=json['address'];
    _contactPersonNumber=json['contact_person_number']??"";
    _contactPersonName=json['contact_person_name']??"";
    _latitude=json['latitude'];
    _longitude=json['longitude'];
  }

  Map<String ,dynamic>toJson(){
    final  Map<String ,dynamic> data =<String,dynamic>{};
    data['id']=_id;
    data['address_type']=_addressType;
    data['address']=_address;
    data['contact_person_number']=_contactPersonNumber;
    data['contact_person_name']=_contactPersonName;
    data['latitude']=_latitude;
    data['longitude']=_longitude;
    return data;
  }


}