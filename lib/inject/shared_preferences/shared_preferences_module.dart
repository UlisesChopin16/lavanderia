import 'package:lavanderia/inject/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Módulo de inyección de [SharedPreferences].
/// Se registra a mano porque la instancia se obtiene de forma asíncrona:
/// hay que llamar a [init] desde main() antes de usar el contenedor.
class SharedPreferencesModule {
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    instance.registerLazySingleton<SharedPreferences>(() => prefs);
  }
}
