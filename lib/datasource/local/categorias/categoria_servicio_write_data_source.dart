import 'package:injectable/injectable.dart';
import 'package:lavanderia/data/local/daos.dart';
import 'package:lavanderia/models/dto/categorias/categoria_servicio_model.dart';
import 'package:lavanderia/extensions/categoria_servicio_ext.dart';

@lazySingleton
class CategoriaServicioWriteDataSource {
  final CategoriaServicioDao categoriaDao;

  const CategoriaServicioWriteDataSource(this.categoriaDao);

  Future<int> insertCategoria(CategoriaServicioModel categoria) async {
    return await categoriaDao.insertCategoria(categoria.toCompanion());
  }

  Future<void> updateCategoria(CategoriaServicioModel categoria) async {
    await categoriaDao.updateCategoria(categoria.toEntry());
  }

  Future<void> deleteCategoria(CategoriaServicioModel categoria) async {
    final entry = categoria.toEntry();
    await categoriaDao.deleteCategoria(entry);
  }
}
