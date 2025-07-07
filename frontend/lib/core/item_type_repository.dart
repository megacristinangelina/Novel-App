
import 'package:flutter_pos/core/dio_client.dart';
import 'package:flutter_pos/data/create_response.dart';
import 'package:flutter_pos/data/edit_response.dart';
import 'package:flutter_pos/data/index_response.dart';

class ItemTypeRepository extends DioClient {
  Future<CreateResponse> create(Map<String, dynamic> params) async {
    var response = await dio.post("novel_type", data: params);
    return CreateResponse.fromJson(response.data);
  }

  Future<IndexResponse> index() async {
    var response = await dio.get("novel_type");

    return IndexResponse.fromJson(response.data);
  }

  Future<EditResponse> update(int id, Map<String, dynamic> data) async {
  final response = await dio.put("novel_type/$id", data: data);
  // return BaseResponse.fromJson(response.data);
  return EditResponse(message: response.data, status: true);
}

Future<EditResponse> delete(int id) async {
  final response = await dio.delete("novel_type/$id");
  return EditResponse.fromJson(response.data);
}


}
