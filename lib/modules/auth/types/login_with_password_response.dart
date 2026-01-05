import 'package:json_annotation/json_annotation.dart';

part 'login_with_password_response.g.dart';

@JsonSerializable()
class LoginWithPasswordResponse {
  final String token;
  final String? plant;
  final Ecomconfig? ecomconfig;

  const LoginWithPasswordResponse({
    required this.token,
    this.plant,
    this.ecomconfig,
  });

  factory LoginWithPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginWithPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginWithPasswordResponseToJson(this);
}

@JsonSerializable()
class Ecomconfig {
  final String? plant;
  final String? plntDesc;
  final String? numberOfDecimal;
  final String? isLowStockThreshold;
  final String? whatsappNumber;
  final String? defaultInquiryMessage;
  final String? facebook;
  final String? instagram;
  final String? tiktok;
  final String? snapchat;
  final String? twitter;
  final String? linkedin;
  final String? youtube;
  final String? crAt;
  final String? crBy;
  final String? upAt;
  final String? upBy;
  final String? LOCATION;
  final bool? isTwoFactorEnabled;
  final String? twilioAccountSid;
  final String? twilioAuthToken;
  final String? twilioOutgoingSmsNumber;
  final String? fast2SmsApiKey;
  final String? delhiveryApiKey;
  final String? whatsappBusinessApiKey;

  const Ecomconfig({
    this.plant,
    this.plntDesc,
    this.numberOfDecimal,
    this.isLowStockThreshold,
    this.whatsappNumber,
    this.defaultInquiryMessage,
    this.facebook,
    this.instagram,
    this.tiktok,
    this.snapchat,
    this.twitter,
    this.linkedin,
    this.youtube,
    this.crAt,
    this.crBy,
    this.upAt,
    this.upBy,
    this.LOCATION,
    this.isTwoFactorEnabled,
    this.twilioAccountSid,
    this.twilioAuthToken,
    this.twilioOutgoingSmsNumber,
    this.fast2SmsApiKey,
    this.delhiveryApiKey,
    this.whatsappBusinessApiKey,
  });

  factory Ecomconfig.fromJson(Map<String, dynamic> json) =>
      _$EcomconfigFromJson(json);

  Map<String, dynamic> toJson() => _$EcomconfigToJson(this);
}
