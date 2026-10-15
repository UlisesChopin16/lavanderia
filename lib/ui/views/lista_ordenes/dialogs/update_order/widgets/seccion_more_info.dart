import 'package:flutter/material.dart';

class SeccionMoreInfo extends StatefulWidget {
  const SeccionMoreInfo({super.key});

  @override
  State<SeccionMoreInfo> createState() => _SeccionMoreInfoState();
}

class _SeccionMoreInfoState extends State<SeccionMoreInfo> {
  final ExpansibleController controller = ExpansibleController();

  @override
  Widget build(BuildContext context) {
    return Expansible(
      controller: controller,
      headerBuilder: (context, animation) => Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: controller.isExpanded ? controller.collapse : controller.expand,
          label: Text(controller.isExpanded ? 'Menos información' : 'Más información'),
          icon: Icon(controller.isExpanded ? Icons.expand_less : Icons.expand_more),
        ),
      ),
      bodyBuilder: (context, animation) => const Column(
        mainAxisSize: .min,
        children: [
          // Aquí va la información adicional que se desea mostrar u ocultar.
          Text('Aquí va la información adicional.'),
          Text('Aquí va la información adicional.'),
        ],
      ),
      expansibleBuilder: (context, header, body, animation) => Column(
        children: [
          header,
          SizeTransition(
            sizeFactor: animation,
            child: body,
          ),
        ],
      ),
    );
  }
}
