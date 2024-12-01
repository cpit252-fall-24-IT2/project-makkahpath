import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: 'assets/.env') // Specify the correct path if it's in assets

abstract class Env {
  @EnviedField(varName: 'SERVICE_ID')
  static const String serviceId = _Env.serviceId;

  @EnviedField(varName: 'TEMPLATE_ID')
  static const String templateId = _Env.templateId;

  @EnviedField(varName: 'USER_ID')
  static const String userId = _Env.userId;
}
