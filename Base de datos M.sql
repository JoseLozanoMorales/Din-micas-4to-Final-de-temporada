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

CREATE TABLE Detalle_Orden (     --TRATADO (LA CANTIDAD ENTREGADA SE REFLEJA EN EL STOCK DEL PRODUCTO, ASÍ COMO EL 
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
    Precio_VentaF DECIMAL(12, 2) NOT NULL DEFAULT 0,
    Descuento INT NOT NULL DEFAULT 0,
	DescuentoEx DECIMAL(12, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (VentaID) REFERENCES Venta(VentaID),
    FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID)
);

Create TABLE Venta_Abonada (              
    PlazoID INT PRIMARY KEY,         
    Fecha_Inicial DATE NOT NULL,
	Fecha_Limite DATE NOT NULL,
	Abono DECIMAL(12, 2)NOT NULL DEFAULT 0,
	Subtotal Decimal(12,2)NOT NULL DEFAULT 0,
    Monto_final DECIMAL(12, 2)NOT NULL DEFAULT 0,
    ClienteID INT NOT NULL,
    AdministradorID INT NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
    FOREIGN KEY (AdministradorID) REFERENCES Administrador(AdministradorID)
);
CREATE TABLE Detalle_Abono (  
    PlazoID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 0,
    Precio_VentaF DECIMAL(12, 2) NOT NULL DEFAULT 0,
    Descuento INT NOT NULL DEFAULT 0,
    FOREIGN KEY (PlazoID) REFERENCES Venta_Abonada(PlazoID),
    FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID)
);

delete from Venta_Abonada
delete from Venta