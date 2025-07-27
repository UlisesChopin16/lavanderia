# lavanderia

A new Flutter project.

## Clientes de lavandería
### Campos requeridos:
- ID
- Nombres
- Apellidos
- Correo
- Teléfono
- Fecha de creación
- Fecha de actualización (opcional)
- Fecha de eliminación (opcional)

## Items para servicios
### Campos requeridos:
- ID
- Nombre
- Descripción
- Importe
- Tipo de unidad (Kg, Unidad)
- Estatus (Activo, Inactivo)
- Tiempo de entrega (en días, entero)
- Fecha de creación
- Fecha de actualización (opcional)
- Fecha de eliminación (opcional)

## Estatus de urgencia
### Campos requeridos:
- ID
- Nombre
- Descripción
- Estatus (Activo, Inactivo)
- Porcentaje de recargo (entero, 0-100)
- Fecha de creación
- Fecha de actualización (opcional)
- Fecha de eliminación (opcional)

## Orden de servicio
### Campos requeridos:
- ID del cliente
- ID de la orden de servicio
- Folio
- Fecha en la que se estuvo lista la ropa
- Fecha de recogida
- Lista de items (Ligados a la orden de servicio)
- Descripción (opcional)
- Estatus (Pendiente, Completado)
- Total (Importe total de los items de servicio)
- Método de pago (Efectivo, Tarjeta, Transferencia)
- Pago (opcional)
- Fecha de creación
- Fecha de actualización (opcional)
- Fecha de eliminación (opcional)

## Items de orden de servicio
### Campos requeridos:
- ID
- ID de la orden de servicio
- ID del item
- Cantidad
- Importe
- Fecha de entrega
- Fecha de creación
- Fecha de actualización (opcional)
- Fecha de eliminación (opcional)

## Configuración de la empresa
### Campos requeridos:
- ID
- Nombre de la empresa
- Dirección
- Teléfono
- Correo electrónico
- Página web
- Logo (opcional, ruta de la imagen)
- Color
- Hora de apertura
- Hora de cierre
- Fecha de creación
- Fecha de actualización (opcional)
- Fecha de eliminación (opcional)

## Direcciones
### Campos requeridos:
- ID
- Nombre de la calle
- Número exterior
- Número interior (opcional)
- Colonia
- Código postal
- Ciudad
- Estado


