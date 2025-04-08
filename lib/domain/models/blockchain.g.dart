// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blockchain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockchainImpl _$$BlockchainImplFromJson(Map<String, dynamic> json) =>
    _$BlockchainImpl(
      name: json['name'] as String? ?? '',
      env: json['env'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      urlExplorerAddress: json['urlExplorerAddress'] as String? ?? '',
      urlExplorerTransaction: json['urlExplorerTransaction'] as String? ?? '',
      urlExplorerChain: json['urlExplorerChain'] as String? ?? '',
      nativeCurrency: json['nativeCurrency'] as String? ?? '',
    );

Map<String, dynamic> _$$BlockchainImplToJson(_$BlockchainImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'env': instance.env,
      'icon': instance.icon,
      'urlExplorerAddress': instance.urlExplorerAddress,
      'urlExplorerTransaction': instance.urlExplorerTransaction,
      'urlExplorerChain': instance.urlExplorerChain,
      'nativeCurrency': instance.nativeCurrency,
    };
