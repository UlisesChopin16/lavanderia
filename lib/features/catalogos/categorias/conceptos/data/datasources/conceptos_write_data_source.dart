import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/data/models/concepto_model.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/extensions/concepto_ext.dart';

@lazySingleton
class ConceptosWriteDataSource {
  final ItemServicioDao itemServicioDao;

  const ConceptosWriteDataSource(this.itemServicioDao);

  Future<int> insertCategoria(ConceptoModel concepto) async {
    return await itemServicioDao.insertItem(concepto.toCompanion());
  }

  Future<void> updateCategoria(ConceptoModel concepto) async {
    await itemServicioDao.updateItem(concepto.toEntry());
  }

  Future<void> deleteCategoria(ConceptoModel concepto) async {
    final entry = concepto.toEntry();
    await itemServicioDao.deleteItem(entry);
  }
}
