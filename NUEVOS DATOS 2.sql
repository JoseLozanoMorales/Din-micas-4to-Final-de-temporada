Use [Sistema de Venta Dinamica]

CREATE PROCEDURE RegistrarCliente
    @ClienteID INT, @Nombre VARCHAR(55), @Apellido VARCHAR(55), @Correo_electronico VARCHAR(50), @Cedula CHAR(10),  
    @Telefono CHAR(10), @Direccion VARCHAR(255), @Ciudad VARCHAR(20),@Pais VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Cliente (ClienteID, Nombre, Apellido, Correo_electronico, Cedula, Telefono, Direccion, Ciudad, Pais)
        VALUES (@ClienteID, @Nombre, @Apellido, @Correo_electronico, @Cedula, @Telefono, @Direccion, @Ciudad, @Pais);

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'La transacci fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;


CREATE PROCEDURE RegistrarAdministrador 
    @AdministradorID INT,@Nombre VARCHAR(55), @Apellido VARCHAR(55),  @Correo_electronico VARCHAR(50),   @Cedula CHAR(10), 
    @Telefono CHAR(10), @Direccion VARCHAR(255), @Ciudad VARCHAR(20),  @Pais VARCHAR(20), @Nombreusuario VARCHAR(50), @Contraseña NVARCHAR(30)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Administrador (AdministradorID, Nombre, Apellido, Correo_electronico, Cedula, Telefono, Direccion, Ciudad, Pais, Nombreusuario, Contraseña)
        VALUES (@AdministradorID, @Nombre, @Apellido, @Correo_electronico, @Cedula, @Telefono, @Direccion, @Ciudad, @Pais, @Nombreusuario, ENCRYPTBYPASSPHRASE('password', @Contraseña));

        COMMIT TRANSACTION;

        SELECT 0 AS Codigo, 'La transacci fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

--PROCEDIMIENTO QUE REGISTRA A UN PROVEEDOR
CREATE PROCEDURE RegistrarProveedor
    @ProveedorID INT,@Nombre VARCHAR(40), @Ruc CHAR(13),  @Ciudad VARCHAR(20),  
    @Direccion VARCHAR(255), @Telefono VARCHAR(12),   @Correo_electronico VARCHAR(50),  @Pais VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Proveedor (ProveedorID, Nombre, Ruc, Ciudad, Direccion, Telefono, Correo_electronico, Pais)
        VALUES (@ProveedorID, @Nombre, @Ruc, @Ciudad, @Direccion, @Telefono, @Correo_electronico, @Pais);

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;


--PROCEDIMIENTO QUE REGISRA CATEGORﾍA
CREATE PROCEDURE RegistrarCategoria
    @CategoriaID INT, @Nombre VARCHAR(60)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Categoria (CategoriaID, Nombre)
        VALUES (@CategoriaID, @Nombre);

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

EXEC RegistrarCategoria 1, 'Tarjetas Gráficas';
EXEC RegistrarCategoria 2, 'Discos Duros';

---PROCEDIMIENTO QUE CREA EL IVA
CREATE PROCEDURE RegistrarIVA
    @IvaID INT, @Porcentaje INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO IVA (IvaID, Porcentaje)
        VALUES (@IvaID, @Porcentaje);

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

EXEC RegistrarIVA 1, 12;  -- 12% de IVA
EXEC RegistrarIVA 2, 0;   -- 0% de IVA (productos exentos)

--REGISTRO PRODUCTO 
CREATE PROCEDURE RegistrarProducto
    @ProductoID INT,@Nombre VARCHAR(50), @Precio_Venta DECIMAL(12, 2),
    @Descripcion VARCHAR(355),@CategoriaID INT,@IVAID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Producto (ProductoID, Nombre, Precio_Venta, Descripcion, CategoriaID, IVAID)
        VALUES (@ProductoID, @Nombre, @Precio_Venta, @Descripcion, @CategoriaID, @IVAID);

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

--REGISTRAR ORDEN CONTRACTUAL
CREATE PROCEDURE RegistrarOrdenContractual
    @OrdenID INT, @Fecha_Emision DATE, @Fecha_Entrega DATE,@ProveedorID INT, @AdministradorID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Orden_Contractual (OrdenID, Fecha_Emision, Fecha_Entrega, ProveedorID, AdministradorID)
        VALUES (@OrdenID, @Fecha_Emision, @Fecha_Entrega, @ProveedorID, @AdministradorID);

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'La transacci fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;


--REGISTRAR DETALLE ORDEN
CREATE PROCEDURE RegistrarDetalleOrden
    @OrdenID INT,
    @ProductoID INT,
    @Cantidad_Pedida INT,
    @Cantidad_Entregada INT,
    @Precio_Compra DECIMAL(12, 2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Detalle_Orden (OrdenID, ProductoID, Cantidad_Pedida, Cantidad_Entregada, Precio_Compra)
        VALUES (@OrdenID, @ProductoID, @Cantidad_Pedida, @Cantidad_Entregada, @Precio_Compra);

        COMMIT TRANSACTION;

        SELECT 0 AS Codigo, 'La transacci fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

----TRIGGER QUE CONTROLA EL STOCK DEL PRODUCTO (FUNCIONA EN BASE A LA CANTIDAD ENTREGADA DEL PROVEEDOR)
CREATE TRIGGER ActualizarStock
ON Detalle_Orden
AFTER INSERT
AS
BEGIN
    UPDATE Producto
    SET 
        Stock = Stock + i.Cantidad_Entregada
    FROM 
        Producto p
    INNER JOIN 
        inserted i ON p.ProductoID = i.ProductoID;
END;

---TRIGGER QUE HAGA EL CﾁLCULO PARA OBTENER EL COSTO_PROMEDIO (TABLA PRODUCTO)-->(PRECIO COMPRA * CANTIDAD ENTREGADA)/CANTIDAD ENTREGADA
CREATE TRIGGER CalcularCostoPromedio
ON Detalle_Orden
AFTER INSERT
AS
BEGIN

    UPDATE Producto
    SET 
        Costo_promedio = 
            (i.Precio_Compra * i.Cantidad_Entregada) / i.Cantidad_Entregada
    FROM 
        Producto p
    INNER JOIN 
        inserted i ON p.ProductoID = i.ProductoID;
END;

------TRIGGER QUE CALCULE EL VALOR TOTAL EN ORDEN_CONTRACTUAL(ES LA SUMA DE : TODOS LOS PRECIOS DEL PRODUCTO DE DETALLE_ORDEN
-----* CANTIDAD ENTREGADA DE DETALLE DE ORDEN)

CREATE TRIGGER CalcularValorTotalOrden
ON Detalle_Orden
AFTER INSERT, UPDATE
AS
BEGIN

    -- Declaramos una variable para almacenar el valor total de la orden contractual
    DECLARE @ValorTotal DECIMAL(12,2);
    
    -- Calculamos el valor total para la orden contractual espec凬ica
    SELECT @ValorTotal = SUM(dv.Precio_Compra * dv.Cantidad_Entregada)
    FROM Detalle_Orden dv
    WHERE dv.OrdenID IN (SELECT DISTINCT OrdenID FROM inserted);
    
    -- Actualizamos el campo Valor_Total en la tabla Orden_Contractual
    UPDATE Orden_Contractual
    SET Valor_Total = @ValorTotal
    WHERE OrdenID IN (SELECT DISTINCT OrdenID FROM inserted);
END;


----PRODUCTOS AGOTADOS
Create FUNCTION ProductosAgotados()
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @ProductoAgotado NVARCHAR(100);
    
    SELECT TOP 1 @ProductoAgotado = Nombre
    FROM Producto
    ORDER BY Stock ASC;
    
    RETURN @ProductoAgotado;
END;

---REGISTRAR VENTA
create PROCEDURE RegistrarVenta
    @VentaID INT, @Fecha DATE,  @ClienteID INT, @AdministradorID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Venta (VentaID, Fecha, ClienteID, AdministradorID)
        VALUES (@VentaID, @Fecha, @ClienteID, @AdministradorID);

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'La transacci fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;


CREATE PROCEDURE RegistrarDetalleVenta
    @VentaID INT,
    @ProductoID INT,
    @Cantidad INT,
    @Descuento INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Detalle_Venta (VentaID, ProductoID, Cantidad, Descuento)
        VALUES (@VentaID, @ProductoID, @Cantidad, @Descuento);

        COMMIT TRANSACTION;

        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;


CREATE TRIGGER CalcularMontoFinalVenta
ON Detalle_Venta
AFTER INSERT
AS
BEGIN
    -- Calculamos el Monto_final sumando el precio con cantidad
    UPDATE v
    SET 
        v.Monto_final = ISNULL((
            SELECT SUM(dv.Precio_VentaF * dv.Cantidad)  -- Multiplicamos Precio_VentaF por la Cantidad
            FROM Detalle_Venta dv
            WHERE dv.VentaID = v.VentaID
        ), 0)  -- Si el cálculo es NULL, asigna 0
    FROM Venta v
    INNER JOIN inserted i ON v.VentaID = i.VentaID
    WHERE v.VentaID IN (SELECT VentaID FROM inserted);
    
    -- Si Monto_final sigue siendo NULL, asignar un valor por defecto
    IF EXISTS (SELECT 1 FROM Venta WHERE VentaID IN (SELECT VentaID FROM inserted) AND Monto_final IS NULL)
    BEGIN
        UPDATE Venta
        SET Monto_final = 0  -- Asigna un valor por defecto si Monto_final es NULL
        WHERE VentaID IN (SELECT VentaID FROM inserted) AND Monto_final IS NULL;
    END
END;

DROP TRIGGER CalcularMontoFinalVenta

---TRIGGER QUE CALCULA Y CONTROLA EL PRECIO_VENTAF(FINAL) UNITARIO DEL PRODUCTO PERO CON IVA Y DESCUENTO INCLUﾍDO
CREATE TRIGGER CalcularPrecioVentaFinal
ON Detalle_Venta
AFTER INSERT
AS
BEGIN
    -- Actualizar Precio_VentaF con el precio con IVA incluido
    UPDATE dv
    SET 
        -- Calcular el precio de venta final con IVA incluido
        Precio_VentaF = ROUND(p.Precio_Venta * (1 + iva.Porcentaje / 100.0), 2)  -- Aseguramos que el cálculo del IVA sea correcto
    FROM 
        Detalle_Venta dv
    INNER JOIN 
        Producto p ON dv.ProductoID = p.ProductoID
    INNER JOIN 
        IVA iva ON p.IVAID = iva.IvaID
    INNER JOIN 
        inserted i ON dv.VentaID = i.VentaID AND dv.ProductoID = i.ProductoID
    WHERE 
        dv.VentaID IN (SELECT VentaID FROM inserted)
        AND dv.ProductoID IN (SELECT ProductoID FROM inserted);
END;

DROP TRIGGER CalcularPrecioVentaFinal

----TRIGGER QUE REDUCE EL STOCK AL HACER LA VENTA DEL PRODUCTO(ADEMﾁS, CONTROLA QUE EL STOCK NO SEA NEGATIVO)
CREATE TRIGGER ReducirStock
ON Detalle_Venta
AFTER INSERT
AS
BEGIN
    -- Verifica si hay suficiente stock para los productos de la venta actual (basado en VentaID)
    IF EXISTS (
        SELECT 1
        FROM Producto p
        INNER JOIN inserted dv ON p.ProductoID = dv.ProductoID
        WHERE p.Stock < dv.Cantidad
        AND dv.VentaID IN (SELECT VentaID FROM inserted)  -- Verifica la VentaID en la venta actual
    )
    BEGIN
        -- Si hay productos con stock insuficiente, se cancela la transacci
        ROLLBACK TRANSACTION;
        RAISERROR ('El stock no es suficiente para realizar la venta', 16, 1);
        RETURN;
    END

    -- Actualiza el stock de los productos vendidos, solo para la venta actual y para cada producto
    UPDATE p
    SET p.Stock = p.Stock - dv.Cantidad
    FROM Producto p
    INNER JOIN inserted dv ON p.ProductoID = dv.ProductoID
    WHERE dv.VentaID IN (SELECT VentaID FROM inserted);  -- Solo actualiza los productos de la venta actual
END;




---TRIGGER QUE CALCULA EL SUBTOTAL DE LA VENTA(ES DECIR, QUE TOMA EL PRECIO NETO UNITARIO DE LA TABLA PRODUCTO Y LO MULTIPLICA POR 
---LA CANTIDAD DE DETALLE_DE_VENTA, AL FINAL SUMA TODO ESO)
CREATE TRIGGER CalcularSubtotalVenta
ON Detalle_Venta
AFTER INSERT, UPDATE
AS
BEGIN
    -- Calcular el subtotal para todas las ventas afectadas
    UPDATE Venta
    SET Subtotal = (
        SELECT ISNULL(SUM(p.Precio_Venta * dv.Cantidad), 0)
        FROM Detalle_Venta dv
        INNER JOIN Producto p ON dv.ProductoID = p.ProductoID
        WHERE dv.VentaID = Venta.VentaID
    )
    WHERE VentaID IN (SELECT VentaID FROM inserted);
END;
DROP TRIGGER CalcularSubtotalVenta

------TRIGGER QUE CALCULA EL MONTO FINAL DE VENTA(ESTO YA INCLUYE LA SUMA DE TODOS LOS PRODUCTOS QUE YA FUERON AFECTADOS POR EL IVA,
------EL DESCUENTO(ES DECIR, EL PRECIO_VENTAF) MULTIPLICADOS POR LA CANTIDAD)
CREATE TRIGGER CalcularPrecioVentaFinal
ON Detalle_Venta
AFTER INSERT
AS
BEGIN
    -- Actualizar Precio_VentaF con el precio con IVA
    UPDATE dv
    SET 
        Precio_VentaF = ROUND(p.Precio_Venta * (1 + iva.Porcentaje / 100), 2)
    FROM 
        Detalle_Venta dv
    INNER JOIN 
        Producto p ON dv.ProductoID = p.ProductoID
    INNER JOIN 
        IVA iva ON p.IVAID = iva.IvaID
    INNER JOIN 
        inserted i ON dv.VentaID = i.VentaID AND dv.ProductoID = i.ProductoID
    WHERE 
        dv.VentaID IN (SELECT VentaID FROM inserted)
        AND dv.ProductoID IN (SELECT ProductoID FROM inserted);
END;


CREATE PROCEDURE EliminarOrden
    @OrdenID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Eliminar detalles de venta
        DELETE FROM Detalle_Orden
        WHERE OrdenID IN (SELECT OrdenID FROM Orden_Contractual WHERE OrdenID = @OrdenID);

        -- Eliminar ventas
        DELETE FROM Orden_Contractual
        WHERE OrdenID = @OrdenID;


        COMMIT TRANSACTION;

        SELECT 0 AS Codigo, 'La Orden fue eliminada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;


CREATE TRIGGER trg_CalcularSubtotal
ON Detalle_Venta
AFTER INSERT, UPDATE
AS
BEGIN
    -- Actualiza la columna Subtotal utilizando el precio de venta de la tabla Producto
    UPDATE dv
    SET dv.Subtotal = dv.Cantidad * p.Precio_Venta
    FROM Detalle_Venta dv
    INNER JOIN inserted i 
        ON dv.VentaID = i.VentaID 
        AND dv.ProductoID = i.ProductoID
    INNER JOIN Producto p
        ON dv.ProductoID = p.ProductoID;
END;





------PROCEDIMIENTO QUE ELIMINA DE LA FAZ DE LA TIERRA A UN PRODUCTO
CREATE PROCEDURE EliminarProducto
    @ProductoID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Eliminar registros de Detalle_Venta relacionados con el Producto
        DELETE FROM Detalle_Venta
        WHERE ProductoID = @ProductoID;

        -- Eliminar registros de Detalle_Orden relacionados con el Producto
        DELETE FROM Detalle_Orden
        WHERE ProductoID = @ProductoID;

        -- Eliminar el Producto
        DELETE FROM Producto
        WHERE ProductoID = @ProductoID;

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'El producto fue eliminado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;


------PROCEDIMIENTO QUE ELIMINA DE LA FAZ DE LA TIERRA A UN PROVEEDOR
CREATE PROCEDURE EliminarProveedor
    @ProveedorID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM Detalle_Orden
        WHERE OrdenID IN (SELECT OrdenID FROM Orden_Contractual WHERE ProveedorID = @ProveedorID);

        DELETE FROM Orden_Contractual
        WHERE ProveedorID = @ProveedorID;

        DELETE FROM Proveedor
        WHERE ProveedorID = @ProveedorID;

        COMMIT TRANSACTION;

        SELECT 0 AS Codigo, 'El proveedor fue eliminado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

--- PROCEDIMIENTO PARA ELIMINAR UN CLIENTE
CREATE PROCEDURE EliminarCliente
    @ClienteID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Eliminar detalles de venta
        DELETE FROM Detalle_Venta
        WHERE VentaID IN (SELECT VentaID FROM Venta WHERE ClienteID = @ClienteID);

        -- Eliminar ventas
        DELETE FROM Venta
        WHERE ClienteID = @ClienteID;

        -- Eliminar cliente
        DELETE FROM Cliente
        WHERE ClienteID = @ClienteID;

        COMMIT TRANSACTION;

        SELECT 0 AS Codigo, 'El cliente fue eliminado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;



CREATE TABLE Administrador (
    AdministradorID INT PRIMARY KEY,
    Nombre VARCHAR(55) NOT NULL,
    Apellido VARCHAR(55) NOT NULL,
    Correo_electronico VARCHAR(50) NOT NULL,
    Cedula CHAR(10) NOT NULL,
    Telefono CHAR(10) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Ciudad VARCHAR(20) NOT NULL,
    Pais VARCHAR(20) NOT NULL,
    Nombreusuario VARCHAR(50) NOT NULL,
    Contraseña VARBINARY(8000)
);

CREATE TABLE Cliente (
    ClienteID INT PRIMARY KEY,
    Nombre VARCHAR(55) NOT NULL,
    Apellido VARCHAR(55) NOT NULL,
    Correo_electronico VARCHAR(50) NOT NULL,
    Cedula CHAR(10) NOT NULL,
    Telefono CHAR(10) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Ciudad VARCHAR(20) NOT NULL,
    Pais VARCHAR(20) NOT NULL
);

CREATE TABLE Proveedor (
    ProveedorID INT PRIMARY KEY,
    Nombre VARCHAR(40) NOT NULL,
    Ruc CHAR(13) NOT NULL,
    Ciudad VARCHAR(20) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Telefono VARCHAR(12) NOT NULL,
    Correo_electronico VARCHAR(50) NOT NULL,
    Pais VARCHAR(20) NOT NULL
);

CREATE TABLE Categoria (
    CategoriaID INT PRIMARY KEY,
    Nombre VARCHAR(60) NOT NULL,
);

CREATE TABLE IVA (
    IvaID INT PRIMARY KEY,      
    Porcentaje INT NOT NULL DEFAULT 0
);

-----------------------------------------
CREATE TABLE Producto (   -------TRATADO
    ProductoID INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    Precio_Venta DECIMAL(12, 2) NOT NULL DEFAULT 0,
    Costo_promedio DECIMAL(12, 2) NOT NULL DEFAULT 0,
	Descripcion VARCHAR(355) NOT NULL,
    CategoriaID INT NOT NULL,
    IVAID INT NOT NULL,  
    FOREIGN KEY (CategoriaID) REFERENCES Categoria(CategoriaID),
    FOREIGN KEY (IvaID) REFERENCES IVA(IvaID)
);

CREATE TABLE Venta (              
    VentaID INT PRIMARY KEY,         
    Fecha DATE NOT NULL,
	Subtotal Decimal(12,2)NOT NULL DEFAULT 0,
    Monto_final DECIMAL(12, 2)NOT NULL DEFAULT 0,
    ClienteID INT NOT NULL,
    AdministradorID INT NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
    FOREIGN KEY (AdministradorID) REFERENCES Administrador(AdministradorID)
);


CREATE TABLE Orden_Contractual (       --TRATADO, AHORA CALCULA EL MONTO FINAL DE ORDEN_CONTRACTUAL EN BASE A DETALLE_ORDEN
    OrdenID INT  PRIMARY KEY,          
    Fecha_Emision DATE NOT NULL,
    Fecha_Entrega DATE NOT NULL,
    Valor_Total DECIMAL(12, 2) NOT NULL DEFAULT 0,
    ProveedorID INT NOT NULL,
    AdministradorID INT NOT NULL,
    FOREIGN KEY (ProveedorID) REFERENCES Proveedor(ProveedorID),
    FOREIGN KEY (AdministradorID) REFERENCES Administrador(AdministradorID)
);

CREATE TABLE Detalle_Orden (     --TRATADO (LA CANTIDAD ENTREGADA SE REFLEJA EN EL STOCK DEL PRODUCTO, ASﾍ COMO EL 
    OrdenID INT NOT NULL,        --PRECIO_COMPRA SE REFLEJA EN PRODUCTO
    ProductoID INT NOT NULL,
    Cantidad_Pedida INT NOT NULL DEFAULT 0,
    Cantidad_Entregada INT NOT NULL DEFAULT 0,
    Precio_Compra DECIMAL(12, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (OrdenID) REFERENCES Orden_Contractual(OrdenID),
    FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID)
);

CREATE TABLE Detalle_Venta (  
    VentaID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 0,
	Subtotal DECIMAL (10,2) NOT NULL DEFAULT 0,
    Precio_VentaF DECIMAL(12, 2) NOT NULL DEFAULT 0,
    Descuento INT NOT NULL DEFAULT 0,
    FOREIGN KEY (VentaID) REFERENCES Venta(VentaID),
    FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID)
);

select V.VentaID, P.ProductoID, P.Nombre, C.Nombre, V.Cantidad, I.Porcentaje, P.Precio_Venta , V.Precio_VentaF from IVA I inner join Producto P on I.IvaID=P.IVAID inner join Categoria C on P.CategoriaID=C.CategoriaID inner join Detalle_Venta V on P.ProductoID=V.ProductoID

INSERT INTO IVA (IvaID, Porcentaje) VALUES
(1, 12),
(2, 0);

INSERT INTO Categoria (CategoriaID, Nombre) VALUES
(1, 'Electrónicos'),
(2, 'Accesorios');

INSERT INTO Producto (ProductoID, Nombre, Stock, Precio_Venta, Costo_promedio, Descripcion, CategoriaID, IVAID) VALUES
(1, 'Laptop', 10, 1200.00, 900.00, 'Laptop gamer', 1, 1),
(2, 'Mouse', 50, 25.00, 15.00, 'Mouse óptico', 2, 2),
(3, 'Teclado', 30, 45.00, 30.00, 'Teclado mecánico', 2, 1);

INSERT INTO Cliente (ClienteID, Nombre, Apellido, Correo_electronico, Cedula, Telefono, Direccion, Ciudad, Pais) VALUES
(1, 'Juan', 'Pérez', 'juan@example.com', '1234567890', '0987654321', 'Av. Siempre Viva 742', 'Quito', 'Ecuador');

INSERT INTO Administrador (AdministradorID, Nombre, Apellido, Correo_electronico, Cedula, Telefono, Direccion, Ciudad, Pais, Nombreusuario, Contraseña) VALUES
(1, 'María', 'Gómez', 'maria@example.com', '0987654321', '0998765432', 'Av. Amazonas 123', 'Quito', 'Ecuador', 'admin1', CONVERT(VARBINARY, 'secreta'));

INSERT INTO Venta (VentaID, Fecha, ClienteID, AdministradorID) VALUES
(1, '2024-03-03', 1, 1),
(2, '2024-03-04', 1, 1);

INSERT INTO Detalle_Venta (VentaID, ProductoID, Cantidad)
VALUES
(1, 1, 2),
(1, 2, 3),
(1, 2, 3),
(2, 3, 1),
(2, 1, 1);

DELETE FROM detalle_venta;
DELETE FROM Venta;
DELETE FROM Producto

SELECT * FROM Venta

SELECT * FROM Producto

Select * from Detalle_Venta
