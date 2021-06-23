// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userRoute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRoute _$UserRouteFromJson(Map<String, dynamic> json) {
  return UserRoute(
    json['destinationIp'] as String,
    (json['route'] as List<dynamic>)
        .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$UserRouteToJson(UserRoute instance) => <String, dynamic>{
      'destinationIp': instance.destinationIp,
      'route': instance.route.map((e) => e.toJson()).toList(),
    };

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) {
  return UserAddress(
    json['id'] as String,
    json['ip'] as String,
  );
}

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ip': instance.ip,
    };
