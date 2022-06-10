import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ootopia_app/clean_arch/core/di/inectable.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> init() async {
  $initGetIt(getIt);
}
