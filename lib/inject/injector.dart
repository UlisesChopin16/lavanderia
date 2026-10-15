import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart';

export 'package:lavanderia/inject/database/database_module.dart';
export 'package:lavanderia/inject/shared_preferences/shared_preferences_module.dart';

final instance = GetIt.instance;

@InjectableInit()
void configureDependencies() => instance.init();
