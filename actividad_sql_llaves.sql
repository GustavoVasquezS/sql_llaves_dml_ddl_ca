-- PASO 1: crear tablas

-- tabla clientes
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL,
    edad       INT          NOT NULL CHECK (edad BETWEEN 18 AND 85)
);

-- tabla cuentas con llave foranea a clientes
CREATE TABLE Cuentas (
    id_cuenta  INT            PRIMARY KEY,
    id_cliente INT            NOT NULL,
    saldo      NUMERIC(10, 2) NOT NULL CHECK (saldo BETWEEN -5000.00 AND 100000.00),
    CONSTRAINT fk_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Clientes(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- secuencias para autogenerar IDs
CREATE SEQUENCE seq_cliente_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cuenta_id  START WITH 1 INCREMENT BY 1;


-- PASO 2: insertar datos

-- 5 clientes
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (1, 'Ana García',   78);
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (2, 'Luis Pérez',   25);
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (3, 'Maria Soto',   40);
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (4, 'Carlos Ruiz',  80);
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (5, 'Elena Torres', 32);

-- 15 cuentas
-- Ana (id 1)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (101, 1,  50000.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (102, 1,  -1200.50);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (103, 1,    100.00);

-- Luis (id 2)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (201, 2,    850.75);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (202, 2,   -500.00);

-- Maria (id 3)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (301, 3,  15000.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (302, 3,    200.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (303, 3,  -4999.99);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (304, 3,  75000.00);

-- Carlos (id 4)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (401, 4,   1000.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (402, 4,   2000.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (403, 4,   3000.00);

-- Elena (id 5)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (501, 5,     50.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (502, 5,    120.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (503, 5,    900.00);


-- PASO 3: update y delete

-- aumentar saldo de cuenta 402 en 500
UPDATE Cuentas
SET    saldo = saldo + 500.00
WHERE  id_cuenta = 402;

-- borrar cuenta 503 de Elena
DELETE FROM Cuentas
WHERE id_cuenta = 503;


-- PASO 4: Consultas solicitadas

-- Q3: saldo de cada cuenta del cliente con mas edad
SELECT
    cl.nombre,
    cl.edad,
    cu.id_cuenta,
    cu.saldo
FROM Cuentas  cu
JOIN Clientes cl ON cu.id_cliente = cl.id_cliente
WHERE cl.edad = (SELECT MAX(edad) FROM Clientes);


-- Q4: promedio de edad de clientes con saldo negativo
SELECT
    ROUND(AVG(cl.edad), 2) AS promedio_edad
FROM Clientes cl
WHERE cl.id_cliente IN (
    SELECT DISTINCT id_cliente
    FROM   Cuentas
    WHERE  saldo < 0
);


-- Q5: nombre y cantidad de cuentas de quienes tienen mas de una
SELECT
    cl.nombre,
    COUNT(cu.id_cuenta) AS cantidad_cuentas
FROM Clientes cl
JOIN Cuentas  cu ON cl.id_cliente = cu.id_cliente
GROUP BY cl.id_cliente, cl.nombre
HAVING COUNT(cu.id_cuenta) > 1
ORDER BY cl.nombre;


-- Q6: saldo combinado por cliente con mas de una cuenta
SELECT
    cl.nombre,
    SUM(cu.saldo) AS saldo_combinado
FROM Clientes cl
JOIN Cuentas  cu ON cl.id_cliente = cu.id_cliente
GROUP BY cl.id_cliente, cl.nombre
HAVING COUNT(cu.id_cuenta) > 1
ORDER BY cl.nombre;


-- Q7: clientes con al menos una cuenta negativa y su saldo combinado total
SELECT
    cl.nombre,
    SUM(cu.saldo) AS saldo_combinado
FROM Clientes cl
JOIN Cuentas  cu ON cl.id_cliente = cu.id_cliente
WHERE cl.id_cliente IN (
    SELECT DISTINCT id_cliente
    FROM   Cuentas
    WHERE  saldo < 0
)
GROUP BY cl.id_cliente, cl.nombre
ORDER BY cl.nombre;
