

class Contacts {


  late final int? id;
  late final String? firstName;
  late final String? lastName;
  late final String? email;
  late final String? phoneNumber;
  late final String action;

  Contacts({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.action = "",
  });

  Contacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    action = json['action'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['action'] = action;

    return data;
  }
}

