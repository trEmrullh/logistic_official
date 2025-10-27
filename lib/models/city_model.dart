class City {
  City({
    required this.plateNo,
    required this.cityName,
  });

  String plateNo;
  String cityName;

  factory City.fromJson(Map<String, dynamic> map) {
    return City(
      plateNo: map['plateNo'],
      cityName: map['cityName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plateNo': plateNo,
      'cityName': cityName,
    };
  }

  factory City.empty() {
    return City(
      plateNo: '',
      cityName: '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is City && runtimeType == other.runtimeType && cityName == other.cityName;

  @override
  int get hashCode => cityName.hashCode;
}

List<City> cities = [
  City(plateNo: '01', cityName: "Adana"),
  City(plateNo: '02', cityName: "Adıyaman"),
  City(plateNo: '03', cityName: "Afyonkarahisar"),
  City(plateNo: '04', cityName: "Ağrı"),
  City(plateNo: '05', cityName: "Amasya"),
  City(plateNo: '06', cityName: "Ankara"),
  City(plateNo: '07', cityName: "Antalya"),
  City(plateNo: '08', cityName: "Artvin"),
  City(plateNo: '09', cityName: "Aydın"),
  City(plateNo: '10', cityName: "Balıkesir"),
  City(plateNo: '11', cityName: "Bilecik"),
  City(plateNo: '12', cityName: "Bingöl"),
  City(plateNo: '13', cityName: "Bitlis"),
  City(plateNo: '14', cityName: "Bolu"),
  City(plateNo: '15', cityName: "Burdur"),
  City(plateNo: '16', cityName: "Bursa"),
  City(plateNo: '17', cityName: "Çanakkale"),
  City(plateNo: '18', cityName: "Çankırı"),
  City(plateNo: '19', cityName: "Çorum"),
  City(plateNo: '20', cityName: "Denizli"),
  City(plateNo: '21', cityName: "Diyarbakır"),
  City(plateNo: '22', cityName: "Edirne"),
  City(plateNo: '23', cityName: "Elazığ"),
  City(plateNo: '24', cityName: "Erzincan"),
  City(plateNo: '25', cityName: "Erzurum"),
  City(plateNo: '26', cityName: "Eskişehir"),
  City(plateNo: '27', cityName: "Gaziantep"),
  City(plateNo: '28', cityName: "Giresun"),
  City(plateNo: '29', cityName: "Gümüşhane"),
  City(plateNo: '30', cityName: "Hakkari"),
  City(plateNo: '31', cityName: "Hatay"),
  City(plateNo: '32', cityName: "Isparta"),
  City(plateNo: '33', cityName: "Mersin"),
  City(plateNo: '34', cityName: "İstanbul"),
  City(plateNo: '35', cityName: "İzmir"),
  City(plateNo: '36', cityName: "Kars"),
  City(plateNo: '37', cityName: "Kastamonu"),
  City(plateNo: '38', cityName: "Kayseri"),
  City(plateNo: '39', cityName: "Kırklareli"),
  City(plateNo: '40', cityName: "Kırşehir"),
  City(plateNo: '41', cityName: "Kocaeli"),
  City(plateNo: '42', cityName: "Konya"),
  City(plateNo: '43', cityName: "Kütahya"),
  City(plateNo: '44', cityName: "Malatya"),
  City(plateNo: '45', cityName: "Manisa"),
  City(plateNo: '46', cityName: "Kahramanmaraş"),
  City(plateNo: '47', cityName: "Mardin"),
  City(plateNo: '48', cityName: "Muğla"),
  City(plateNo: '49', cityName: "Muş"),
  City(plateNo: '50', cityName: "Nevşehir"),
  City(plateNo: '51', cityName: "Niğde"),
  City(plateNo: '52', cityName: "Ordu"),
  City(plateNo: '53', cityName: "Rize"),
  City(plateNo: '54', cityName: "Sakarya"),
  City(plateNo: '55', cityName: "Samsun"),
  City(plateNo: '56', cityName: "Siirt"),
  City(plateNo: '57', cityName: "Sinop"),
  City(plateNo: '58', cityName: "Sivas"),
  City(plateNo: '59', cityName: "Tekirdağ"),
  City(plateNo: '60', cityName: "Tokat"),
  City(plateNo: '61', cityName: "Trabzon"),
  City(plateNo: '62', cityName: "Tunceli"),
  City(plateNo: '63', cityName: "Şanlıurfa"),
  City(plateNo: '64', cityName: "Uşak"),
  City(plateNo: '65', cityName: "Van"),
  City(plateNo: '66', cityName: "Yozgat"),
  City(plateNo: '67', cityName: "Zonguldak"),
  City(plateNo: '68', cityName: "Aksaray"),
  City(plateNo: '69', cityName: "Bayburt"),
  City(plateNo: '70', cityName: "Karaman"),
  City(plateNo: '71', cityName: "Kırıkkale"),
  City(plateNo: '72', cityName: "Batman"),
  City(plateNo: '73', cityName: "Şırnak"),
  City(plateNo: '74', cityName: "Bartın"),
  City(plateNo: '75', cityName: "Ardahan"),
  City(plateNo: '76', cityName: "Iğdır"),
  City(plateNo: '77', cityName: "Yalova"),
  City(plateNo: '78', cityName: "Karabük"),
  City(plateNo: '79', cityName: "Kilis"),
  City(plateNo: '80', cityName: "Osmaniye"),
  City(plateNo: '81', cityName: "Düzce"),
];
