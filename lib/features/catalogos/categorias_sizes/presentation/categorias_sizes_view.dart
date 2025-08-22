import 'package:flutter/material.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/categorias/presentation/views/categorias_view.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/presentation/views/sizes_view.dart';

class CategoriasSizesView extends StatefulWidget {
  const CategoriasSizesView({super.key});

  @override
  State<CategoriasSizesView> createState() => _CategoriasSizesViewState();
}

class _CategoriasSizesViewState extends State<CategoriasSizesView> {
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        controller: scrollController,
        child: const Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 20,
          runSpacing: 20,
          children: [
            SizedBox(
              width: 700,
              child: CategoriasView(),
            ),
            SizedBox(
              width: 700,
              child: SizesView(),
            ),
          ],
        ),
      ),
    );
  }
}
