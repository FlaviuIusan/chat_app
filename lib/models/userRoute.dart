import 'dart:collection';
import 'package:chat_app/models/userAddress.dart';

class UserRoute {
  String destinationIp = '';
  DoubleLinkedQueue<UserAddress> route = DoubleLinkedQueue<UserAddress>();

  UserRoute(this.destinationIp, this.route);

  UserRoute.empty() {
    this.destinationIp = '';
    this.route = DoubleLinkedQueue<UserAddress>();
  }
}
