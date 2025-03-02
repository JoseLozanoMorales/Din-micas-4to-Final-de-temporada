
create TABLE Estudiantes (
    IdEstudiante INT PRIMARY KEY, 
    Nombre NVARCHAR(50) NOT NULL,              
    Apellido NVARCHAR(50) NOT NULL,           
    Cedula CHAR(10) NOT NULL,                  
    FechaNacimiento DATE NOT NULL,             
    Grado NVARCHAR(50) NOT NULL,               
    Promedio DECIMAL(5, 2) NOT NULL           
);

Create PROCEDURE RegistrarEstudiante
    @ID INT,
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Cedula CHAR(10),
    @FechaNacimiento DATE,
    @Grado NVARCHAR(50),
    @Promedio DECIMAL(5, 2)
AS
BEGIN
    -- Verificar si la cédula ya está registrada
    IF EXISTS (SELECT 1 FROM Estudiantes WHERE Cedula = @Cedula)
    BEGIN
        -- Si la cédula ya existe, generar un error
        RAISERROR ('La cédula ya está registrada', 16, 1);
        RETURN;  -- Detener la ejecución del procedimiento
    END
    
    -- Si la cédula no existe, insertar el nuevo estudiante
    INSERT INTO Estudiantes (IdEstudiante, Nombre, Apellido, Cedula, FechaNacimiento, Grado, Promedio)
    VALUES (@ID, @Nombre, @Apellido, @Cedula, @FechaNacimiento, @Grado, @Promedio);
END;

///////////////////////////////////////////////////////////////
CREATE PROCEDURE ActualizarEstudiante
    @IdEstudiante INT,
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Cedula CHAR(10),
    @FechaNacimiento DATE,
    @Grado NVARCHAR(50),
    @Promedio DECIMAL(5, 2)
AS
BEGIN
    UPDATE Estudiantes
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        Cedula = @Cedula,
        FechaNacimiento = @FechaNacimiento,
        Grado = @Grado,
        Promedio = @Promedio
    WHERE IdEstudiante = @IdEstudiante;
END;

/////////////////////////////////////////////////////////////////////////////

CREATE PROCEDURE EliminarEstudiante
    @IdEstudiante INT
AS
BEGIN
    DELETE FROM Estudiantes
    WHERE IdEstudiante = @IdEstudiante;
END;


////////////////////////////////////////////////////////////////////////////////
CREATE PROCEDURE BuscarEstudiantes
    @Busqueda NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Estudiantes
    WHERE Nombre LIKE '%' + @Busqueda + '%'
       OR Apellido LIKE '%' + @Busqueda + '%'
       OR Grado LIKE '%' + @Busqueda + '%';
END;


