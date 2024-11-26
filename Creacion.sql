

CREATE TABLE Usuario (
    Id_Usuario SERIAL PRIMARY KEY,
    Nombre_Usuario VARCHAR(255) NOT NULL,
    Correo VARCHAR(255) NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    Direccion VARCHAR(255) NOT NULL,
    Es_Admin BOOLEAN DEFAULT FALSE
);

CREATE TABLE Pedido (
    Id_Pedido SERIAL PRIMARY KEY,
    Fecha_Pedido TIMESTAMP NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    Total DECIMAL(10, 2),
    Id_Usuario INT,
    CONSTRAINT fk_usuario_pedido FOREIGN KEY (Id_Usuario) REFERENCES Usuario(Id_Usuario)
);

CREATE TABLE Producto (
    Id_Producto SERIAL PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Descripcion VARCHAR(500),
    Precio DECIMAL(10, 2) NOT NULL,
    Cantidad INT NOT NULL,
    Mostrar BOOLEAN DEFAULT TRUE,
    ImagenUrl VARCHAR(255)
);

CREATE TABLE Pedido_Detalle (
    Id_Pedido_Detalle SERIAL PRIMARY KEY,
    Id_Pedido INT,
    Id_Producto INT,
    CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (Id_Pedido) REFERENCES Pedido(Id_Pedido),
    CONSTRAINT fk_pedido_detalle_producto FOREIGN KEY (Id_Producto) REFERENCES Producto(Id_Producto)
);

CREATE TABLE Carrito (
    Id_Carrito SERIAL PRIMARY KEY,
    Id_Usuario INT,
    CONSTRAINT fk_usuario_carrito FOREIGN KEY (Id_Usuario) REFERENCES Usuario(Id_Usuario)
);

CREATE TABLE Carrito_Item (
    Id_Carrito_Item SERIAL PRIMARY KEY,
    Id_Carrito INT,
    Id_Producto INT,
    CONSTRAINT fk_carrito_item_carrito FOREIGN KEY (Id_Carrito) REFERENCES Carrito(Id_Carrito),
    CONSTRAINT fk_carrito_item_producto FOREIGN KEY (Id_Producto) REFERENCES Producto(Id_Producto)
);

-- Crear la función que será llamada por el trigger
CREATE OR REPLACE FUNCTION crear_carrito()
RETURNS TRIGGER AS $$
BEGIN
    -- Insertar un nuevo carrito para el usuario recién creado
    INSERT INTO Carrito (Id_Usuario)
    VALUES (NEW.Id_Usuario);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger asociado a la tabla Usuario
CREATE TRIGGER trigger_crear_carrito
AFTER INSERT ON Usuario
FOR EACH ROW
EXECUTE FUNCTION crear_carrito();

CREATE OR REPLACE PROCEDURE vaciarcarritocompra(IN p_id_carrito INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    record RECORD; -- Declarar una variable para iterar sobre los productos en el carrito
BEGIN
    -- Iterar sobre los productos asociados al carrito
    FOR record IN SELECT Id_Producto FROM Carrito_Item WHERE Id_Carrito = p_id_carrito
    LOOP
        -- Actualizar la cantidad del producto restando 1
        UPDATE Producto
        SET Cantidad = Cantidad - 1
        WHERE Id_Producto = record.Id_Producto;

        -- Validar que la cantidad no sea negativa
        UPDATE Producto
        SET Cantidad = 0
        WHERE Cantidad < 0 AND Id_Producto = record.Id_Producto;
    END LOOP;

    -- Eliminar los registros del carrito
    DELETE FROM Carrito_Item WHERE Id_Carrito = p_id_carrito;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminaritemsdelcarrito(IN p_id_carrito INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Eliminar todos los registros del carrito sin modificar la cantidad en productos
    DELETE FROM Carrito_Item WHERE Id_Carrito = p_id_carrito;
END;
$$;