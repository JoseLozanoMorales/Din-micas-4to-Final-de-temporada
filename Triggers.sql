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

---TRIGGER QUE HAGA EL CÁLCULO PARA OBTENER EL COSTO_PROMEDIO (TABLA PRODUCTO)-->(PRECIO COMPRA * CANTIDAD ENTREGADA)/CANTIDAD ENTREGADA
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

	---TRIGGER QUE CALCULA Y CONTROLA EL PRECIO_VENTAF(FINAL) UNITARIO DEL PRODUCTO PERO CON IVA Y DESCUENTO INCLUÍDO
CREATE TRIGGER CalcularPrecioVentaFinalPlazo
ON Detalle_Abono
AFTER INSERT
AS
BEGIN
    DECLARE @PrecioVenta DECIMAL(12,2), @IvaPorcentaje DECIMAL(5,2), @DescuentoPorcentaje DECIMAL(5,2), @PrecioFinal DECIMAL(12,2);
    
    SELECT @PrecioVenta = p.Precio_Venta, 
           @IvaPorcentaje = iva.Porcentaje,
           @DescuentoPorcentaje = i.Descuento
    FROM Producto p
    INNER JOIN IVA iva ON p.IVAID = iva.IvaID
    INNER JOIN inserted i ON p.ProductoID = i.ProductoID;
    
    -- Cálculo del Precio Final
    SET @PrecioFinal = ROUND((@PrecioVenta * (1 + @IvaPorcentaje / 100)) * (1 - @DescuentoPorcentaje / 100), 2);
  

    UPDATE Detalle_Abono
    SET 
        Precio_VentaF = @PrecioFinal
    FROM 
        Detalle_Abono dv
    INNER JOIN 
        Producto p ON dv.ProductoID = p.ProductoID
    INNER JOIN 
        IVA iva ON p.IVAID = iva.IvaID
    INNER JOIN 
        inserted i ON dv.PlazoID = i.PlazoID AND dv.ProductoID = i.ProductoID;
END;

---TRIGGER QUE CALCULA EL SUBTOTAL DE LA VENTA en plazo(ES DECIR, QUE TOMA EL PRECIO NETO UNITARIO DE LA TABLA PRODUCTO Y LO MULTIPLICA POR 
---LA CANTIDAD DE DETALLE_DE_VENTA, AL FINAL SUMA TODO ESO)
CREATE TRIGGER CalcularSubtotalPlazo
ON Detalle_Abono
AFTER INSERT, UPDATE
AS
BEGIN

    DECLARE @Subtotal DECIMAL(12,2);
    
    SELECT @Subtotal = SUM(p.Precio_Venta * dv.Cantidad)
    FROM Detalle_Abono dv
    INNER JOIN Producto p ON dv.ProductoID = p.ProductoID
    WHERE dv.PlazoID IN (SELECT DISTINCT PlazoID FROM inserted);
    
    UPDATE Venta_Abonada
    SET Subtotal = @Subtotal
    WHERE PlazoID IN (SELECT DISTINCT PlazoID FROM inserted);
END;

------TRIGGER QUE CALCULA EL MONTO FINAL DE PLAZO(ESTO YA INCLUYE LA SUMA DE TODOS LOS PRODUCTOS QUE YA FUERON AFECTADOS POR EL IVA,
------EL DESCUENTO(ES DECIR, EL PRECIO_VENTAF) MULTIPLICADOS POR LA CANTIDAD)

CREATE TRIGGER CalcularMontoFinalPlazo
ON Detalle_Abono
AFTER INSERT, UPDATE
AS
BEGIN

    -- Declaramos una variable para almacenar el monto final de la venta
    DECLARE @MontoFinal DECIMAL(12,2);
    
    -- Calculamos el monto final para la venta específica
    SELECT @MontoFinal = SUM(dv.Precio_VentaF * dv.Cantidad)
    FROM Detalle_Abono dv
    WHERE dv.PlazoID IN (SELECT DISTINCT PlazoID FROM inserted);
    
    -- Actualizamos el campo Monto_final en la tabla Venta
    UPDATE Venta_Abonada
    SET Monto_final = @MontoFinal
    WHERE PlazoID IN (SELECT DISTINCT PlazoID FROM inserted);
END;

---TRIGGER QUE CALCULA Y CONTROLA EL PRECIO_VENTAF(FINAL) UNITARIO DEL PRODUCTO PERO CON IVA Y DESCUENTO INCLUÍDO
CREATE TRIGGER CalcularPrecioVentaFinal
ON Detalle_Venta
AFTER INSERT
AS
BEGIN
    DECLARE @PrecioVenta DECIMAL(12,2), @IvaPorcentaje DECIMAL(5,2), @DescuentoPorcentaje DECIMAL(5,2), @PrecioFinal DECIMAL(12,2);
    
    SELECT @PrecioVenta = p.Precio_Venta, 
           @IvaPorcentaje = iva.Porcentaje,
           @DescuentoPorcentaje = i.Descuento
    FROM Producto p
    INNER JOIN IVA iva ON p.IVAID = iva.IvaID
    INNER JOIN inserted i ON p.ProductoID = i.ProductoID;
    
    -- Cálculo del Precio Final
    SET @PrecioFinal = ROUND((@PrecioVenta * (1 + @IvaPorcentaje / 100)) * (1 - @DescuentoPorcentaje / 100), 2);
  

    UPDATE Detalle_Venta
    SET 
        Precio_VentaF = @PrecioFinal
    FROM 
        Detalle_Venta dv
    INNER JOIN 
        Producto p ON dv.ProductoID = p.ProductoID
    INNER JOIN 
        IVA iva ON p.IVAID = iva.IvaID
    INNER JOIN 
        inserted i ON dv.VentaID = i.VentaID AND dv.ProductoID = i.ProductoID;
END;

----TRIGGER QUE REDUCE EL STOCK AL HACER LA VENTA DEL PRODUCTO(ADEMÁS, CONTROLA QUE EL STOCK NO SEA NEGATIVO)
DROP TRIGGER ReducirStock
ON Detalle_Venta
AFTER INSERT, UPDATE
AS
BEGIN
    -- Verifica si la cantidad solicitada supera el stock disponible antes de realizar la actualización
    IF EXISTS (
        SELECT 1
        FROM Producto p
        INNER JOIN Detalle_Venta dv ON p.ProductoID = dv.ProductoID
        WHERE p.Stock < dv.Cantidad
    )
    BEGIN
        -- Si se encuentra algún producto con stock insuficiente, se cancela la transacción
        ROLLBACK TRANSACTION;
        RAISERROR ('El stock no es suficiente para realizar la venta', 16, 1);
        RETURN;
    END

    -- Si hay suficiente stock, reduce la cantidad solicitada del stock disponible
    UPDATE Producto
    SET Stock = Stock - dv.Cantidad
    FROM Producto p
    INNER JOIN Detalle_Venta dv ON p.ProductoID = dv.ProductoID;

END;

---TRIGGER QUE CALCULA EL SUBTOTAL DE LA VENTA(ES DECIR, QUE TOMA EL PRECIO NETO UNITARIO DE LA TABLA PRODUCTO Y LO MULTIPLICA POR 
---LA CANTIDAD DE DETALLE_DE_VENTA, AL FINAL SUMA TODO ESO)
CREATE TRIGGER CalcularSubtotalVenta
ON Detalle_Venta
AFTER INSERT, UPDATE
AS
BEGIN

    DECLARE @Subtotal DECIMAL(12,2);
    
    SELECT @Subtotal = SUM(p.Precio_Venta * dv.Cantidad)
    FROM Detalle_Venta dv
    INNER JOIN Producto p ON dv.ProductoID = p.ProductoID
    WHERE dv.VentaID IN (SELECT DISTINCT VentaID FROM inserted);
    
    UPDATE Venta
    SET Subtotal = @Subtotal
    WHERE VentaID IN (SELECT DISTINCT VentaID FROM inserted);
END;

------TRIGGER QUE CALCULA EL MONTO FINAL DE VENTA(ESTO YA INCLUYE LA SUMA DE TODOS LOS PRODUCTOS QUE YA FUERON AFECTADOS POR EL IVA,
------EL DESCUENTO(ES DECIR, EL PRECIO_VENTAF) MULTIPLICADOS POR LA CANTIDAD)
CREATE TRIGGER CalcularMontoFinalVenta
ON Detalle_Venta
AFTER INSERT, UPDATE
AS
BEGIN

    -- Declaramos una variable para almacenar el monto final de la venta
    DECLARE @MontoFinal DECIMAL(12,2);
    
    -- Calculamos el monto final para la venta específica
    SELECT @MontoFinal = SUM(dv.Precio_VentaF * dv.Cantidad)
    FROM Detalle_Venta dv
    WHERE dv.VentaID IN (SELECT DISTINCT VentaID FROM inserted);
    
    -- Actualizamos el campo Monto_final en la tabla Venta
    UPDATE Venta
    SET Monto_final = @MontoFinal
    WHERE VentaID IN (SELECT DISTINCT VentaID FROM inserted);
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
    
    -- Calculamos el valor total para la orden contractual específica
    SELECT @ValorTotal = SUM(dv.Precio_Compra * dv.Cantidad_Entregada)
    FROM Detalle_Orden dv
    WHERE dv.OrdenID IN (SELECT DISTINCT OrdenID FROM inserted);
    
    -- Actualizamos el campo Valor_Total en la tabla Orden_Contractual
    UPDATE Orden_Contractual
    SET Valor_Total = @ValorTotal
    WHERE OrdenID IN (SELECT DISTINCT OrdenID FROM inserted);
END;


----TRIGGER QUE CONTROLA LA SITUACIÓN DE QUE NO SE PUEDE TENER MÁS CANTIDAD_ENTREGADA QUE CANTIDAD_SOLICITADA
CREATE TRIGGER ControlarCantidadEntregada
ON Detalle_Orden
AFTER INSERT, UPDATE
AS
BEGIN

    -- Verificar si la cantidad entregada es mayor que la cantidad solicitada
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.Cantidad_Entregada > i.Cantidad_Pedida
    )
    BEGIN
        -- Si la cantidad entregada es mayor que la solicitada, se lanza un error
        RAISERROR ('La cantidad entregada no puede ser mayor que la cantidad solicitada.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--- TRIGGER QUE CONTROLA QUE EL PRECIO COMPRA DE UN PRODUCTO NO SUPERE EL PRECIO DE VENTA DE UN PRODUCTO
CREATE TRIGGER CompararPrecioCompra_Venta
ON Detalle_Orden
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica si el precio de compra es mayor que el precio de venta del producto
    IF EXISTS (
        SELECT 1
        FROM Detalle_Orden do
        INNER JOIN Producto p ON do.ProductoID = p.ProductoID
        WHERE do.Precio_Compra > p.Precio_Venta
    )
    BEGIN
        -- Si se encuentra que el precio de compra es mayor al de venta, cancela la transacción
        ROLLBACK TRANSACTION;
        RAISERROR ('El precio de compra no puede ser mayor al precio de venta del producto.', 16, 1);
        RETURN;
    END
END;

CREATE PROCEDURE SumarAbono
    @PlazoID INT,
    @NuevoAbono DECIMAL(12, 2)
AS
BEGIN
    
    UPDATE Venta_Abonada
    SET Abono = Abono + @NuevoAbono
    WHERE PlazoID = @PlazoID;
END;

--------------------------------------------------------------------------------------------------------------
------------------------------------------------  FUNCIONES    -----------------------------------------------     
--------------------------------------------------------------------------------------------------------------
CREATE FUNCTION ContarRegistrosCliente()
RETURNS INT
AS
BEGIN
    DECLARE @TotalRegistros INT;
    
    SELECT @TotalRegistros = COUNT(*) 
    FROM Cliente;
    
    RETURN @TotalRegistros;
END;

SELECT dbo.ContarRegistrosCliente();


Create FUNCTION ContarRegistrosAdministrador()
RETURNS INT
AS
BEGIN
    DECLARE @TotalRegistros INT;
    
    SELECT @TotalRegistros = COUNT(*)
    FROM Administrador;
    
    RETURN @TotalRegistros;
END;

SELECT dbo.ContarRegistrosAdministrador();

Create FUNCTION ContarRegistrosProveedor()
RETURNS INT
AS
BEGIN
    DECLARE @TotalRegistros INT;
    
    SELECT @TotalRegistros = COUNT(*)
    FROM Proveedor;
    
    RETURN @TotalRegistros;
END;

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

------------------------------NUEVOS-------------------------------------
ALTER TRIGGER CalcularPrecioVentaFinal
ON Detalle_Venta
AFTER INSERT
AS
BEGIN
    DECLARE @EsAbonada BIT;

    -- Verificar si la venta es abonada (columna EsAbonada = 1)
    SELECT TOP 1 @EsAbonada = EsAbonada
    FROM inserted;

    IF @EsAbonada = 0
    BEGIN
        DECLARE @PrecioVenta DECIMAL(12,2), 
                @IvaPorcentaje DECIMAL(5,2), 
                @DescuentoPorcentaje DECIMAL(5,2), 
                @DescuentoP DECIMAL(5,2), 
                @DescuentoC DECIMAL(5,2), 
                @PrecioFinal DECIMAL(12,2), 
                @PrecioSinDescuento DECIMAL(12,2);

        -- Obtener los valores
        SELECT @PrecioVenta = p.Precio_Venta, 
               @IvaPorcentaje = iva.Porcentaje,
               @DescuentoP = p.Promocion,  
               @DescuentoC = c.Promocion,  
               @DescuentoPorcentaje = i.Descuento  -- Descuento general
        FROM Producto p
        INNER JOIN IVA iva ON p.IVAID = iva.IvaID
        INNER JOIN inserted i ON p.ProductoID = i.ProductoID
        INNER JOIN Venta v ON i.VentaID = v.VentaID
        INNER JOIN Cliente c ON v.ClienteID = c.ClienteID;

        -- Cálculo 
        SET @PrecioSinDescuento = ROUND((@PrecioVenta * (1 + @IvaPorcentaje / 100)) * (1 - @DescuentoPorcentaje / 100), 2);

        -- Cálculo 
        SET @PrecioFinal = ROUND(
            (@PrecioVenta * (1 + @IvaPorcentaje / 100)) *  
            (1 - @DescuentoPorcentaje / 100) *             
            (1 - @DescuentoP / 100) *                       
            (1 - @DescuentoC / 100), 2);                    

        -- Actualizar
        UPDATE Detalle_Venta
        SET 
            Precio_VentaF = @PrecioFinal,
            DescuentoEx = @PrecioSinDescuento
        FROM 
            Detalle_Venta dv
        INNER JOIN inserted i ON dv.VentaID = i.VentaID AND dv.ProductoID = i.ProductoID;
    END
    ELSE
    BEGIN
        
        PRINT 'Venta abonada, no se aplica descuento.';
    END
END;
---------------------------------------------------------------------------------------
create TRIGGER AplicarDescuentosTrigger
ON Descuentos
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @FechaActual DATE;
    SET @FechaActual = GETDATE();  -- Obtiene la fecha actual

    UPDATE P
    SET P.Promocion = D.Descuento
    FROM Producto P
    INNER JOIN Descuentos D ON P.ProductoID = D.IDRelacionado
    WHERE D.TipoDescuento = 'Producto'
    AND D.Activo = 1
    AND @FechaActual BETWEEN D.FechaInicio AND D.FechaFin;

    
    UPDATE P
    SET P.Promocion = D.Descuento
    FROM Producto P
    INNER JOIN Descuentos D ON P.CategoriaID = D.IDRelacionado
    WHERE D.TipoDescuento = 'Categoria'
    AND D.Activo = 1
    AND @FechaActual BETWEEN D.FechaInicio AND D.FechaFin;

    UPDATE C
    SET C.Promocion = D.Descuento
    FROM Cliente C
    INNER JOIN Descuentos D ON C.ClienteID = D.IDRelacionado
    WHERE D.TipoDescuento = 'Cliente'
    AND D.Activo = 1
    AND @FechaActual BETWEEN D.FechaInicio AND D.FechaFin;

    -- Mostrar mensaje de éxito
    PRINT 'Descuentos aplicados correctamente a productos y clientes.'
END;