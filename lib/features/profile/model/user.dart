class UserModel {
  final int? userId;
  final String? first;
  final String? last;
  final String? email;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? phone;
  final int? sped;
  final int? role;
  final String? roleDescription;
  final int? schoolId;
  final String? password;
  final String? avatar;
  final String? gender;
  final int active;
  final int c3;
  final int graduated;
  final int? ethnicity;
  final int? race1;
  final int? race2;
  final int? housing;
  final int? nslp;
  final int? ssid;
  final String? about;

  UserModel({
    this.userId,
    this.first,
    this.last,
    this.email,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.phone,
    this.sped,
    this.role,
    this.roleDescription,
    this.schoolId,
    this.password,
    this.avatar,
    this.gender = '0',
    this.active = 0,
    this.c3 = 0,
    this.graduated = 0,
    this.ethnicity,
    this.race1,
    this.race2,
    this.housing,
    this.nslp,
    this.ssid,
    this.about,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userid'],
      first: json['first'],
      last: json['last'],
      email: json['email'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      phone: json['phone'],
      sped: json['sped'],
      role: json['role'],
      roleDescription: json['roles']?['description'],
      schoolId: json['schoolid'],
      password: json['password'],
      avatar: json['avatar'],
      gender: json['gender'] ?? '0',
      active: json['active'] ?? 0,
      c3: json['c3'] ?? 0,
      graduated: json['graduated'] ?? 0,
      ethnicity: json['ethnicity'],
      race1: json['race1'],
      race2: json['race2'],
      housing: json['housing'],
      nslp: json['nslp'],
      ssid: json['ssid'],
      about: json['about'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'first': first,
      'last': last,
      'email': email,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'phone': phone,
      'sped': sped,
      'role': role,
      'roles': {'description': roleDescription},
      'schoolid': schoolId,
      'password': password,
      'avatar': avatar,
      'gender': gender,
      'active': active,
      'c3': c3,
      'graduated': graduated,
      'ethnicity': ethnicity,
      'race1': race1,
      'race2': race2,
      'housing': housing,
      'nslp': nslp,
      'ssid': ssid,
      'about': about,
    };
  }
}
