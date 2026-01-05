// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_with_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginWithPasswordResponse _$LoginWithPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    LoginWithPasswordResponse(
      token: json['token'] as String,
      plant: json['plant'] as String?,
      ecomconfig: json['ecomconfig'] == null
          ? null
          : Ecomconfig.fromJson(json['ecomconfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginWithPasswordResponseToJson(
        LoginWithPasswordResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'plant': instance.plant,
      'ecomconfig': instance.ecomconfig,
    };

Ecomconfig _$EcomconfigFromJson(Map<String, dynamic> json) => Ecomconfig(
      plant: json['plant'] as String?,
      plntDesc: json['plntDesc'] as String?,
      numberOfDecimal: json['numberOfDecimal'] as String?,
      isLowStockThreshold: json['isLowStockThreshold'] as String?,
      whatsappNumber: json['whatsappNumber'] as String?,
      defaultInquiryMessage: json['defaultInquiryMessage'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      tiktok: json['tiktok'] as String?,
      snapchat: json['snapchat'] as String?,
      twitter: json['twitter'] as String?,
      linkedin: json['linkedin'] as String?,
      youtube: json['youtube'] as String?,
      crAt: json['crAt'] as String?,
      crBy: json['crBy'] as String?,
      upAt: json['upAt'] as String?,
      upBy: json['upBy'] as String?,
      LOCATION: json['LOCATION'] as String?,
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool?,
      twilioAccountSid: json['twilioAccountSid'] as String?,
      twilioAuthToken: json['twilioAuthToken'] as String?,
      twilioOutgoingSmsNumber: json['twilioOutgoingSmsNumber'] as String?,
      fast2SmsApiKey: json['fast2SmsApiKey'] as String?,
      delhiveryApiKey: json['delhiveryApiKey'] as String?,
      whatsappBusinessApiKey: json['whatsappBusinessApiKey'] as String?,
    );

Map<String, dynamic> _$EcomconfigToJson(Ecomconfig instance) =>
    <String, dynamic>{
      'plant': instance.plant,
      'plntDesc': instance.plntDesc,
      'numberOfDecimal': instance.numberOfDecimal,
      'isLowStockThreshold': instance.isLowStockThreshold,
      'whatsappNumber': instance.whatsappNumber,
      'defaultInquiryMessage': instance.defaultInquiryMessage,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'tiktok': instance.tiktok,
      'snapchat': instance.snapchat,
      'twitter': instance.twitter,
      'linkedin': instance.linkedin,
      'youtube': instance.youtube,
      'crAt': instance.crAt,
      'crBy': instance.crBy,
      'upAt': instance.upAt,
      'upBy': instance.upBy,
      'LOCATION': instance.LOCATION,
      'isTwoFactorEnabled': instance.isTwoFactorEnabled,
      'twilioAccountSid': instance.twilioAccountSid,
      'twilioAuthToken': instance.twilioAuthToken,
      'twilioOutgoingSmsNumber': instance.twilioOutgoingSmsNumber,
      'fast2SmsApiKey': instance.fast2SmsApiKey,
      'delhiveryApiKey': instance.delhiveryApiKey,
      'whatsappBusinessApiKey': instance.whatsappBusinessApiKey,
    };
