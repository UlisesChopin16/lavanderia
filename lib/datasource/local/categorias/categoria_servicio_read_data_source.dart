import 'package:injectable/injectable.dart';
import 'package:lavanderia/data/local/daos.dart';
import 'package:lavanderia/models/dto/categorias/categoria_servicio_model.dart';
import 'package:lavanderia/models/data/categorias/filtros_categoria.dart';
import 'package:lavanderia/extensions/categoria_servicio_ext.dart';

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

  Stream<List<CategoriaServicioModel>> watchAllCategorias(FiltrosCategoria filtros) {
    final categoriasStream = categoriaDao.watchAll(filtros);
    return categoriasStream.map((categorias) => categorias.map((e) => e.toModel()).toList());
  }
}
