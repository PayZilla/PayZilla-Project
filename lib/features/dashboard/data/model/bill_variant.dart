import 'package:equatable/equatable.dart';

class BillVariantModel extends Equatable {
  const BillVariantModel({
    required this.serviceId,
    required this.serviceName,
    required this.convenienceFee,
    required this.variations,
  });

  factory BillVariantModel.empty() {
    return const BillVariantModel(
      serviceId: '',
      serviceName: '',
      convenienceFee: '',
      variations: [],
    );
  }

  factory BillVariantModel.fromJson(Map<String, dynamic> json) {
    return BillVariantModel(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      convenienceFee: json['convenienceFee'] ?? '',
      variations: List<Variations>.from(
        (json['variations'] as List).map(
          (e) => Variations.fromJson(e as Map<String, dynamic>),
        ),
      ),
    );
  }

  BillVariantModel copyWith({
    String? serviceId,
    String? serviceName,
    String? convenienceFee,
    List<Variations>? variations,
  }) {
    return BillVariantModel(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      convenienceFee: convenienceFee ?? this.convenienceFee,
      variations: variations ?? this.variations,
    );
  }

  final String serviceId;
  final String serviceName;
  final String convenienceFee;
  final List<Variations> variations;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['serviceId'] = serviceId;
    data['serviceName'] = serviceName;
    data['convenienceFee'] = convenienceFee;
    data['variations'] = variations.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  List<Object?> get props =>
      [serviceId, serviceName, convenienceFee, variations];
}

class Variations extends Equatable {
  const Variations({
    required this.variationCode,
    required this.name,
    required this.variationAmount,
    required this.fixedPrice,
  });

  factory Variations.fromJson(Map<String, dynamic> json) {
    return Variations(
      variationCode: json['variationCode'] ?? '',
      name: json['billName'] ?? '',
      variationAmount: json['variationAmount'] ?? '',
      fixedPrice: json['fixedPrice'] ?? '',
    );
  }
  final String variationCode;
  final String name;
  final String variationAmount;
  final String fixedPrice;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['variationCode'] = variationCode;
    data['billName'] = name;
    data['variationAmount'] = variationAmount;
    data['fixedPrice'] = fixedPrice;
    return data;
  }

  @override
  List<Object?> get props => [variationCode, name, variationAmount, fixedPrice];
}
