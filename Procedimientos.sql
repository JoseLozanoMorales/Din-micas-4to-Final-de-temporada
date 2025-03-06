----PROCEDIMIENTO QUE REGISTRA A UN CLIENTE
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
        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

--PROCEDIMIENTO QUE REGISTRA A UN ADMIN

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

        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
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

--PROCEDIMIENTO QUE REGISRA CATEGORÍA
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

---REGISTRAR VENTA
CREATE PROCEDURE RegistrarVenta
    @VentaID INT, @Fecha DATE,  @ClienteID INT, @AdministradorID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Venta (VentaID, Fecha, ClienteID, AdministradorID)
        VALUES (@VentaID, @Fecha, @ClienteID, @AdministradorID);

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
        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
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

        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
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


create PROCEDURE CompletarVentaAbonada
    @PlazoID INT,   
    @VentaID INT    
AS
BEGIN
    
    INSERT INTO Venta (VentaID, Fecha, Subtotal, Monto_final, ClienteID, AdministradorID)
    SELECT @VentaID, Fecha_Inicial, Subtotal, Monto_final, ClienteID, AdministradorID
    FROM Venta_Abonada
    WHERE PlazoID = @PlazoID;

    INSERT INTO Detalle_Venta (VentaID, ProductoID, Cantidad, Precio_VentaF, Descuento)
    SELECT @VentaID, ProductoID, Cantidad, Precio_VentaF, Descuento
    FROM Detalle_Abono
    WHERE PlazoID = @PlazoID;

    DELETE FROM Detalle_Abono WHERE PlazoID = @PlazoID;

    DELETE FROM Venta_Abonada WHERE PlazoID = @PlazoID;

    PRINT 'Venta abonada completada y transferida a la tabla Venta.';
END



-------------------------------------NUEVOS---------------------------------------
DROP PROCEDURE RegistrarPromoC
    @Nombre VARCHAR(60),
    @NuevoPromo INT,
	@fi DATE,
	@ff DATE
AS
BEGIN
    UPDATE Cliente
    SET promocion =  @NuevoPromo, Fecha_Inicial = @fi, Fecha_Limite = @ff
    WHERE Nombre = @Nombre;
END;


DROP PROCEDURE RegistrarPromoP
    @Nombre VARCHAR(110),
    @NuevoPromo INT,
	@fi DATE,
	@ff DATE
AS
BEGIN
    UPDATE Producto
    SET Promocion =  @NuevoPromo, Fecha_Inicial = @fi, Fecha_Limite = @ff
    WHERE Nombre = @Nombre;
END;


DROP PROCEDURE RegistrarPromoCt
    @Nombre varchar(60),
    @CategoriaID INT,
    @NuevoPromo INT,
    @fi DATE,
    @ff DATE
AS
BEGIN
    -- Manejo de errores
    BEGIN TRY
        UPDATE Categoria
        SET Promocion = @NuevoPromo, 
            Fecha_Inicial = @fi, 
            Fecha_Limite = @ff
        WHERE Nombre = @Nombre;

        UPDATE Producto
        SET Promocion = @NuevoPromo, 
            Fecha_Inicial = @fi, 
            Fecha_Limite = @ff
        WHERE CategoriaID = @CategoriaID;

        PRINT 'Actualización exitosa';

    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;


ALTER PROCEDURE CompletarVentaAbonada
    @PlazoID INT,   
    @VentaID INT    
AS
BEGIN
    INSERT INTO Venta (VentaID, Fecha, Subtotal, Monto_final, ClienteID, AdministradorID)
    SELECT @VentaID, Fecha_Inicial, Subtotal, Monto_final, ClienteID, AdministradorID
    FROM Venta_Abonada
    WHERE PlazoID = @PlazoID;

    INSERT INTO Detalle_Venta (VentaID, ProductoID, Cantidad, Precio_VentaF, Descuento, EsAbonada)
    SELECT @VentaID, ProductoID, Cantidad, Precio_VentaF, Descuento, 1 -- Marcamos 'EsAbonada' como 1
    FROM Detalle_Abono
    WHERE PlazoID = @PlazoID;

    
    DELETE FROM Detalle_Abono WHERE PlazoID = @PlazoID;

    DELETE FROM Venta_Abonada WHERE PlazoID = @PlazoID;

    PRINT 'Venta abonada completada y transferida a la tabla Venta.';
END;


DROP PROCEDURE RegistrarPromo
    @PromoID INT, @Promo INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Promocion (PromocionID, Promo)
        VALUES (@PromoID, @Promo);

        COMMIT TRANSACTION;
        SELECT 0 AS Codigo, 'La transacción fue un éxito' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

CREATE PROCEDURE EliminarVenta
    @VentaID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Eliminar detalles de venta
        DELETE FROM Detalle_Venta
        WHERE VentaID IN (SELECT VentaID FROM Venta WHERE VentaID = @VentaID);

        -- Eliminar ventas
        DELETE FROM Venta
        WHERE VentaID = @VentaID;


        COMMIT TRANSACTION;

        SELECT 0 AS Codigo, 'La Venta fue eliminada correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
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

CREATE PROCEDURE EliminarPlazo
    @PlazoID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        
        DELETE FROM Detalle_Abono
        WHERE PlazoID IN (SELECT PlazoID FROM Venta_Abonada WHERE PlazoID = @PlazoID);

        
        DELETE FROM Venta_Abonada
        WHERE PlazoID = @PlazoID;


        COMMIT TRANSACTION;

        SELECT 0 AS Codigo, 'El Plazo fue eliminado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;

-----------------------------------------------------------------------------------------------
ALTER PROCEDURE RegistrarPromocion
    @IDP INT,
    @tipo_descuento VARCHAR(50),
    @ID INT,
    @Descuento INT,
    @Fecha_I DATE,
    @Fecha_F DATE,
    @Activo BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM Descuentos WHERE IDRelacionado = @ID AND TipoDescuento = @tipo_descuento)
        BEGIN
            -- Actualizamos el descuento existente
            UPDATE Descuentos
            SET TipoDescuento = @tipo_descuento,
                IDRelacionado = @ID,
                Descuento = @Descuento,
                FechaInicio = @Fecha_I,
                FechaFin = @Fecha_F,
                Activo = @Activo
            WHERE IDRelacionado = @ID AND TipoDescuento = @tipo_descuento;

            SELECT 1 AS Codigo, 'El descuento ha sido actualizado con éxito' AS Mensaje;
        END
        ELSE
        BEGIN
            -- Insertamos un nuevo registro si no existe
            INSERT INTO Descuentos (PromocionID, TipoDescuento, IDRelacionado, Descuento, FechaInicio, FechaFin, Activo)
            VALUES (@IDP, @tipo_descuento, @ID, @Descuento, @Fecha_I, @Fecha_F, @Activo);

            SELECT 0 AS Codigo, 'La promoción ha sido registrada con éxito' AS Mensaje;
        END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Codigo, ERROR_MESSAGE() AS Mensaje_de_Error;
    END CATCH
END;




CREATE TABLE Descuentos (
    PromocionID INT PRIMARY KEY,
    TipoDescuento NVARCHAR(50),  -- 'Producto', 'Cliente', 'Categoria'
    IDRelacionado INT,  -- ID del producto, cliente o categoría según el tipo de descuento
    Descuento INT not null default 0,  -- Porcentaje de descuento
    FechaInicio DATE,
    FechaFin DATE,
    Activo BIT  -- 1 si el descuento está activo, 0 si está inactivo
);
