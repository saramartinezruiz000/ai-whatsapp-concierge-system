-- =====================================================================================
-- SCRIPT DE DESPLIEGUE - BASE DE DATOS INCOMEL (MÓDULOS RRHH Y COMERCIAL)
-- Descripción: Creación de esquema, tablas de seguridad y datos de prueba.
-- Motor: PostgreSQL
-- =====================================================================================

CREATE SCHEMA IF NOT EXISTS hr;

-- 1. Usuarios Principales
CREATE TABLE IF NOT EXISTS hr.users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dpi VARCHAR(13) UNIQUE NOT NULL,
    pin VARCHAR(4) NOT NULL,
    phone_number VARCHAR(20),
    department VARCHAR(50)
);

-- 2. Vacaciones (Módulo RRHH)
CREATE TABLE IF NOT EXISTS hr.vacations (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES hr.users(id) ON DELETE CASCADE UNIQUE,
    total_days INTEGER NOT NULL DEFAULT 15,
    used_days INTEGER NOT NULL DEFAULT 0,
    available_days GENERATED ALWAYS AS (total_days - used_days) STORED
);

-- 3. Catálogo de Productos
CREATE TABLE IF NOT EXISTS hr.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    discount_percentage INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

-- 4. Seguridad y Mapeo de WhatsApp
CREATE TABLE IF NOT EXISTS hr.user_status (
    remote_jid VARCHAR(255) PRIMARY KEY,       
    status VARCHAR(20) DEFAULT 'UNAUTHORIZED', 
    attempts INTEGER DEFAULT 0,                
    blocked_until TIMESTAMP,                   
    user_id INTEGER REFERENCES hr.users(id),   
    last_interaction TIMESTAMP DEFAULT NOW()   
);

-- =====================================================================================
-- DATOS DE PRUEBA (MOCK DATA)
-- =====================================================================================

INSERT INTO hr.users (name, dpi, pin, phone_number, department) VALUES 
('Usuario Prueba 1', '1234567890101', '1234', '50211112222', 'Recursos Humanos'),
('Usuario Prueba 2', '9876543210101', '4321', '50233334444', 'Sistemas')
ON CONFLICT (dpi) DO NOTHING;

INSERT INTO hr.vacations (user_id, total_days, used_days) VALUES 
(1, 15, 3), 
(2, 15, 0)  
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO hr.products (name, description, price, discount_percentage) VALUES 
('Seguro Médico Premium', 'Cobertura completa de salud para empleado y familia.', 250.00, 20),
('Bono de Alimentación', 'Tarjeta canjeable en supermercados', 50.00, 0),
('Kit de Uniformes INCOMEL', 'Camisa polo y pantalón corporativo', 150.00, 100),
('Membresía Gimnasio SmartFit', 'Suscripción mensual plan Black', 30.00, 50)
ON CONFLICT DO NOTHING;

-- Mensaje de validación rápida
SELECT 'Despliegue de Base de Datos finalizado con éxito.' AS Status;
