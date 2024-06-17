import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class FieldValueConverter implements JsonConverter<FieldValue, Object?> {
  const FieldValueConverter();

  @override
  FieldValue fromJson(Object? json) {
    // Returning a placeholder value since FieldValue is not meant to be deserialized
    return FieldValue.serverTimestamp();
  }

  @override
  Object? toJson(FieldValue fieldValue) {
    if (fieldValue == FieldValue.serverTimestamp()) {
      return {'__type__': 'serverTimestamp'};
    }
    return null; // Handle other cases if needed
  }
}
