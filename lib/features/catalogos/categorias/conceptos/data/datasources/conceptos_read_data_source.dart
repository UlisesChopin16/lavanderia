import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/data/models/concepto_model.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/domain/extensions/concepto_ext.dart';
import 'package:lavanderia/features/catalogos/entities/filtros_base.dart';

@lazySingleton
class ConceptosReadDataSource {
  final ItemServicioDao itemServicioDao;

  const ConceptosReadDataSource(this.itemServicioDao);

  Future<List<ConceptoModel>> getAllConceptos() async {
    final conceptos = await itemServicioDao.getAll();
    return conceptos.map((e) => e.toModel()).toList();
  }

  Future<ConceptoModel?> getConceptoById(int id) async {
    final concepto = await itemServicioDao.getById(id);
    return concepto?.toModel();
  }

  Stream<List<ConceptoModel>> watchAllConceptos({
    required int idCategoria,
    required FiltrosBase filtros,
  }) {
    final conceptosStream = itemServicioDao.watchAll(
      idCategoria: idCategoria,
      filtros: filtros,
    );
    return conceptosStream.map((conceptos) => conceptos.map((e) => e.toModel()).toList());
  }
}
