

CREATE TABLE Usuario (
    Id_Usuario SERIAL PRIMARY KEY,
    Correo VARCHAR(255) NOT NULL,
    Nombre_Usuario VARCHAR(255) NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    Es_Admin BOOLEAN DEFAULT FALSE,
    Fecha_Nac DATE,
    Genero VARCHAR(6)
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
    Precio DECIMAL(10, 2) NOT NULL,
    Cantidad INT NOT NULL,
    Mostrar BOOLEAN DEFAULT TRUE,
    Imagen VARCHAR(255)
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
    Cantidad INT NOT NULL,
    Id_Carrito INT,
    Id_Producto INT,
    CONSTRAINT fk_carrito_item_carrito FOREIGN KEY (Id_Carrito) REFERENCES Carrito(Id_Carrito),
    CONSTRAINT fk_carrito_item_producto FOREIGN KEY (Id_Producto) REFERENCES Producto(Id_Producto)
);
