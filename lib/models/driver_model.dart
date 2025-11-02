class DriverModel {
  DriverModel({
    this.id,
    this.name,
    this.surname,
    this.phoneNo,
    this.password,
    this.driverDefaultTruck,
    this.company,
    this.mobileAuthorized,
    this.isDeleted,
    this.createDate,
    this.createID,
    this.updateDate,
    this.updateID,
  });

  String? id;
  String? name;
  String? surname;
  String? phoneNo;
  String? password;
  DriverDefaultTruck? driverDefaultTruck;
  String? company;
  bool? mobileAuthorized;
  bool? isDeleted;
  String? createDate;
  String? createID;
  String? updateDate;
  String? updateID;

  DriverModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    phoneNo = json['phoneNo'];
    password = json['password'];
    driverDefaultTruck = json['driverDefaultTruck'] != null ? DriverDefaultTruck.fromJson(json['driverDefaultTruck']) : null;
    company = json['company'];
    mobileAuthorized = json['mobileAuthorized'];
    isDeleted = json['isDeleted'];
    createDate = json['createDate'];
    createID = json['createID'];
    updateDate = json['updateDate'];
    updateID = json['updateID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['phoneNo'] = phoneNo;
    data['password'] = password;
    if (driverDefaultTruck != null) {
      data['driverDefaultTruck'] = driverDefaultTruck!.toJson();
    }
    data['company'] = company;
    data['mobileAuthorized'] = mobileAuthorized;
    data['isDeleted'] = isDeleted;
    data['createDate'] = createDate;
    data['createID'] = createID;
    data['updateDate'] = updateDate;
    data['updateID'] = updateID;
    return data;
  }

  factory DriverModel.empty() {
    return DriverModel(
      id: '',
      name: '',
      surname: '',
      phoneNo: '',
      password: '',
      driverDefaultTruck: DriverDefaultTruck.empty(),
      company: '',
      mobileAuthorized: true,
      isDeleted: false,
      createDate: '',
      updateDate: '',
      createID: '',
      updateID: '',
    );
  }
}

class DriverDefaultTruck {
  DriverDefaultTruck({
    required this.id,
    required this.plate,
  });

  late String id;
  late String plate;

  DriverDefaultTruck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plate = json['plate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['plate'] = plate;
    return data;
  }

  factory DriverDefaultTruck.empty() {
    return DriverDefaultTruck(
      id: '',
      plate: '',
    );
  }
}
