import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prime_ballet/initial/loader/models/initial_device_request.dart';
import 'package:retrofit/http.dart';

part 'device_remote_repository.g.dart';

@RestApi()
@injectable
abstract class DeviceRemoteRepository {
  @factoryMethod
  factory DeviceRemoteRepository(Dio dio) => _DeviceRemoteRepository(dio);

  @POST('/api/mobile/devices/initial/')
  Future<void> initial(
    @Body() InitialDeviceRequest initialDeviceRequest,
  );
}
