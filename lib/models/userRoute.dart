import 'dart:collection';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'userRoute.g.dart';

@JsonSerializable(explicitToJson: true)
class UserRoute {
  String destinationIp = '';
  List<UserAddress> route = [];

  UserRoute(this.destinationIp, this.route);

  UserRoute.empty() {
    this.destinationIp = '';
    this.route = [];
  }

  factory UserRoute.fromJson(Map<String, dynamic> json) => _$UserRouteFromJson(json);
  Map<String, dynamic> toJson() => _$UserRouteToJson(this);

  // UserRoute.fromJson(Map<String, dynamic> json) {
  //   destinationIp = json['destinationIp'];
  //   route = json[route];
  // }

  // Map<String, dynamic> toJson() => {
  //       'destinationIp': destinationIp,
  //       'route': jsonEncode(route),
  //     };
}

@JsonSerializable()
class UserAddress {
  String id = '-1';
  String ip = '';

  UserAddress(this.id, this.ip);

  UserAddress.empty() {
    this.id = '-1';
    this.ip = '';
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) => _$UserAddressFromJson(json);
  Map<String, dynamic> toJson() => _$UserAddressToJson(this);
  // UserAddress.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   ip = json['ip'];
  // }

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'ip': ip,
  //     };
}
