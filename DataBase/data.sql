INSERT INTO clientes (nombre, direccion, telefono)
VALUES ('Shalom', 'Av. Arequipa 123, Lima', '01-234-5678');

INSERT INTO clientes (nombre, direccion, telefono)
VALUES ('ABC Company', 'Calle Lima 456, Arequipa', '054-321-654');

INSERT INTO encomiendas (numero, fecha, destino, peso, cliente_id)
VALUES ('123456789', '2023-07-20', 'Arequipa', 50, 1);

INSERT INTO encomiendas (numero, fecha, destino, peso, cliente_id)
VALUES ('987654321', '2023-07-21', 'Lima', 100, 2);

INSERT INTO rutas (origen, destino, distancia)
VALUES ('Lima', 'Arequipa', 1000);

INSERT INTO rutas (origen, destino, distancia)
VALUES ('Arequipa', 'Cusco', 500);

INSERT INTO vehiculos (tipo, placa)
VALUES ('Camión', 'ABC-1234');

INSERT INTO vehiculos (tipo, placa)
VALUES ('Furgoneta', 'DEF-5678');

INSERT INTO conductores (nombre, licencia)
VALUES ('Juan Pérez', '123456789');

INSERT INTO conductores (nombre, licencia)
VALUES ('María González', '987654321');
