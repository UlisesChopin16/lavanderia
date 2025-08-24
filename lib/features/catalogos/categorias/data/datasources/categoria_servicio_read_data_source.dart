import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/categorias/data/models/categoria_servicio_model.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/extensions/categoria_servicio_ext.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

@lazySingleton
class CategoriaServicioReadDataSource {
  final CategoriaServicioDao categoriaDao;

  const CategoriaServicioReadDataSource(this.categoriaDao);

  Future<List<CategoriaServicioModel>> getAllCategorias() async {
    final categorias = await categoriaDao.getAll();
    return categorias.map((e) => e.toModel()).toList();
  }

  Future<CategoriaServicioModel?> getCategoriaById(int id) async {
    final categoria = await categoriaDao.getById(id);
    return categoria?.toModel();
  }

  Stream<List<CategoriaServicioModel>> watchAllCategorias(FiltrosBase filtros) {
    final categoriasStream = categoriaDao.watchAll(filtros);
    return categoriasStream.map((categorias) => categorias.map((e) => e.toModel()).toList());
  }
}
