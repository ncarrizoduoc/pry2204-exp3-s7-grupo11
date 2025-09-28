-- Eliminacion de tablas
DROP TABLE DOMINIO PURGE;
DROP TABLE IDIOMA PURGE;
DROP TABLE TITULACION PURGE;
DROP TABLE TITULO PURGE;
DROP TABLE PERSONAL PURGE;
DROP TABLE GENERO PURGE;
DROP TABLE ESTADO_CIVIL PURGE;
DROP TABLE COMPANIA PURGE;
DROP TABLE COMUNA PURGE;
DROP TABLE REGION PURGE;

-- Eliminacion de secuencias
DROP SEQUENCE SEQ_COMUNA;
DROP SEQUENCE SEQ_COMPANIA;

-- Tabla Region
CREATE TABLE REGION (
    -- ID de la region se genera como identidad
    id_region NUMBER(2) GENERATED ALWAYS AS IDENTITY
        START WITH 7
        INCREMENT BY 2,
    nombre_region VARCHAR2(25)
        CONSTRAINT NOMBRE_REGION_NNULL NOT NULL,
--Constraints
CONSTRAINT REGION_PK PRIMARY KEY (id_region)
);

-- Tabla Comuna
CREATE TABLE COMUNA (
    id_comuna NUMBER(5),
    comuna_nombre VARCHAR2(25)
        CONSTRAINT nombre_comuna_nnull NOT NULL,
    cod_region NUMBER(2)
        CONSTRAINT comuna_region_nnull NOT NULL,
-- Constraints
CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna, cod_region),
CONSTRAINT COMUNA_REGION_FK FOREIGN KEY (cod_region) 
    REFERENCES region (id_region)
);

-- Tabla Compania
CREATE TABLE COMPANIA(
    id_empresa NUMBER(2),
    nombre_empresa VARCHAR2(25)
        CONSTRAINT NOMBRE_EMPRESA_NNULL NOT NULL,
    calle VARCHAR2(25)
        CONSTRAINT CALLE_COMP_NNULL NOT NULL,
    numeracion NUMBER(5)
        CONSTRAINT NUMERACION_NNULL NOT NULL,
    renta_promedio NUMBER(10)
        CONSTRAINT RENTA_COMP_NNULL NOT NULL,
    pct_aumento NUMBER(4,3),
    cod_comuna NUMBER(5)
        CONSTRAINT COMPANIA_COMUNA_NNULL NOT NULL,
    cod_region NUMBER(2)
        CONSTRAINT COMPANIA_REGION_NNULL NOT NULL,
-- Constraints
CONSTRAINT COMPANIA_PK PRIMARY KEY (id_empresa), -- ID empresa es clave primaria
CONSTRAINT NOMBRE_EMPRESA_UN UNIQUE (nombre_empresa), -- Nombre empresa es unico
CONSTRAINT COMPANIA_COMUNA_FK FOREIGN KEY (cod_comuna, cod_region) 
    REFERENCES COMUNA (id_comuna, cod_region)
) ;

-- Tabla Estado civil
CREATE TABLE ESTADO_CIVIL (
    id_estado_civil VARCHAR2(2),
    descripcion_est_civil VARCHAR2(25)
--Constraints
CONSTRAINT DESC_EST_CIV_NNULL NOT NULL,
CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY (id_estado_civil)
);

-- Tabla Genero
CREATE TABLE GENERO (
    id_genero VARCHAR2(3),
    descripcion_genero VARCHAR2(25)
    CONSTRAINT DESC_GENERO_NNULL NOT NULL,
--Constraints
CONSTRAINT GENERO_PK PRIMARY KEY (id_genero)
);

-- Tabla Personal
CREATE TABLE PERSONAL (
    rut_persona NUMBER(8),
    dv_persona CHAR(1)
        CONSTRAINT DV_PERSONA_NNULL NOT NULL,
    primer_nombre VARCHAR2(25)
        CONSTRAINT PRIMER_NOMBRE_NNULL NOT NULL,
    segundo_nombre VARCHAR2(25),
    primer_apellido VARCHAR2(25)
        CONSTRAINT PRIMER_APELLIDO_NNULL NOT NULL,
    segundo_apellido VARCHAR2(25)
        CONSTRAINT SEGUNDO_APELLIDO_NNULL NOT NULL,
    fecha_contratacion DATE
        CONSTRAINT FECHA_CONTRATACION_NNULL NOT NULL,
    fecha_nacimiento DATE
        CONSTRAINT FECHA_NACIMIENTO_NNULL NOT NULL,
    email VARCHAR2(100), -- El email es opcional
    calle VARCHAR2(50)
        CONSTRAINT CALLE_PERS_NNULL NOT NULL,
    numeracion NUMBER(5)
        CONSTRAINT NUMERACION_PERS_NNULL NOT NULL,
    sueldo NUMBER(10)
        CONSTRAINT SUELDO_NNULL NOT NULL,
    cod_comuna NUMBER(5)
        CONSTRAINT PERSONAL_COMUNA_NNULL NOT NULL,
    cod_region NUMBER(2)
        CONSTRAINT PERSONAL_REGION_NNULL NOT NULL,
    cod_genero VARCHAR2(3),
    cod_estado_civil VARCHAR2(2),
    cod_empresa NUMBER(2)
        CONSTRAINT PERSONAL_EMPRESA_NNULL NOT NULL,
    encargado_rut NUMBER(8),

--Constraints
CONSTRAINT PERSONAL_PK PRIMARY KEY (rut_persona),
CONSTRAINT PERSONAL_COMPANIA_FK FOREIGN KEY (cod_empresa) 
    REFERENCES COMPANIA (id_empresa),
CONSTRAINT PERSONAL_COMUNA_FK FOREIGN KEY (cod_comuna, cod_region) 
    REFERENCES COMUNA (id_comuna, cod_region),
CONSTRAINT PERSONAL_ESTADO_CIVIL_FK FOREIGN KEY (cod_estado_civil) 
    REFERENCES ESTADO_CIVIL (id_estado_civil),
CONSTRAINT PERSONAL_GENERO_FK FOREIGN KEY (cod_genero)
    REFERENCES GENERO (id_genero),
CONSTRAINT PERSONAL_PERSONAL_FK FOREIGN KEY (encargado_rut) 
    REFERENCES PERSONAL (rut_persona)
);

-- Tabla Titulo
CREATE TABLE TITULO (
    id_titulo VARCHAR2(3),
    descripcion_titulo VARCHAR2(60)
        CONSTRAINT DESC_TITULO_NNULL NOT NULL,
--Constraints
CONSTRAINT TITULO_PK PRIMARY KEY (id_titulo)
);

-- Tabla Titulacion
CREATE TABLE TITULACION (
    cod_titulo VARCHAR2(3),
    persona_rut NUMBER(8),
    fecha_titulacion DATE
        CONSTRAINT FECHA_TITULACION_NNULL NOT NULL,
--Constraints
CONSTRAINT TITULACION_PK PRIMARY KEY (cod_titulo, persona_rut),
CONSTRAINT TITULACION_PERSONAL_FK FOREIGN KEY (persona_rut) 
    REFERENCES PERSONAL (rut_persona),
CONSTRAINT TITULACION_TITULO_FK FOREIGN KEY (cod_titulo) 
    REFERENCES TITULO (id_titulo)
);

-- Tabla Idioma
CREATE TABLE IDIOMA (
    id_idioma NUMBER(3) GENERATED ALWAYS AS IDENTITY
        START WITH 25
        INCREMENT BY 3,
    nombre_idioma VARCHAR2(30)
        CONSTRAINT NOMBRE_IDIOMA_NNULL NOT NULL,
--Constraints
CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma) 
);

-- Tabla dominio (de un idioma)
CREATE TABLE DOMINIO (
    id_idioma NUMBER(3),
    persona_rut NUMBER(8),
    nivel VARCHAR2(25)
        CONSTRAINT NIVEL_NNULL NOT NULL,
--Constraints
CONSTRAINT DOMINIO_PK PRIMARY KEY (id_idioma, persona_rut),
CONSTRAINT DOMINIO_IDIOMA_FK FOREIGN KEY (id_idioma) 
    REFERENCES IDIOMA (id_idioma),
CONSTRAINT DOMINIO_PERSONAL_FK FOREIGN KEY (persona_rut) 
    REFERENCES PERSONAL (rut_persona)
);

-- Modificaciones al modelo

-- Restriccion que asegura que el email del personal sea unico
ALTER TABLE PERSONAL ADD CONSTRAINT EMAIL_UN UNIQUE (email);
-- Restriccion que verifica que el digito verificador del rut del personal sea 
-- un caracter valido (numero o K)
ALTER TABLE PERSONAL ADD CONSTRAINT DV_PERSONA_CK
    CHECK ((dv_persona) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
        'K', 'k'));
-- Restriccion que verifica que el sueldo del personal sea minimo 450000
ALTER TABLE PERSONAL ADD CONSTRAINT SUELDO_MINIMO_CK
    CHECK (sueldo >= 450000);
  
-- Creacion de secuencias
    
-- Secuencia para generar el id_comuna de COMUNA
CREATE SEQUENCE SEQ_COMUNA
    START WITH 1101
    INCREMENT BY 6;

-- Secuencia para generar el id_empresa de COMPANIA
CREATE SEQUENCE SEQ_COMPANIA
    START WITH 10
    INCREMENT BY 5;

-- Poblar Tablas

-- Poblar tabla IDIOMA
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Ingles');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Chino');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Aleman');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Espanol');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Frances');

-- Poblar tabla REGION
INSERT INTO REGION (nombre_region) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION (nombre_region) VALUES ('METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('LA ARAUCANIA');

-- Poblar tabla COMUNA
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
    VALUES (SEQ_COMUNA.NEXTVAL, 'Arica', 7);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
    VALUES (SEQ_COMUNA.NEXTVAL, 'Santiago', 9);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) 
    VALUES (SEQ_COMUNA.NEXTVAL, 'Temuco', 11);
    
-- Poblar tabla COMPANIA
INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'CCyRojas',
    'Amapolas',
    506,
    1857000,
    0.5,
    1101,
    7
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'SenTTy',
    'Los Alamos',
    3490,
    897000,
    0.025,
    1101,
    7
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'Praxia LTDA',
    'Las Camelias',
    11098,
    2157000,
    0.035,
    1107,
    9
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'TIC spa',
    'FLORES S.A.',
    4357,
    857000,
    null,
    1107,
    9
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'SANTADA LTDA',
    'AVDA VIC. MACKENA',
    106,
    757000,
    0.015,
    1101,
    7
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'FLORES Y ASOCIADOS',
    'PEDRO LATORRE',
    557,
    589000,
    0.015,
    1107,
    9
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'J.A. HOFFMAN',
    'LATINA D.32',
    509,
    1857000,
    0.025,
    1113,
    11
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'CAGLIARI D.',
    'ALAMEDA',
    206,
    1857000,
    null,
    1107,
    9
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'ROJAS HNOS LTDA',
    'SUCRE',
    106,
    957000,
    0.005,
    1113,
    11
);

INSERT INTO COMPANIA (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    SEQ_COMPANIA.NEXTVAL,
    'FRIENDS P. S.A',
    'SUECIA',
    506,
    857000,
    0.015,
    1113,
    11
);

-- Generacion de informes

-- Informe 1
SELECT
    nombre_empresa AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Direccion",
    renta_promedio AS "Renta Promedio",
    renta_promedio + (renta_promedio * pct_aumento) AS "Simulacion de Renta"
FROM COMPANIA
ORDER BY "Renta Promedio" DESC, "Nombre Empresa" ASC;

-- Informe 2
SELECT
    id_empresa AS "CODIGO",
    nombre_empresa AS "EMPRESA",
    renta_promedio AS "PROM RENTA ACTUAL",
    pct_aumento + 0.15 AS "PCT AUMENTADO EN 15%",
    renta_promedio + (renta_promedio * (pct_aumento + 0.15)) AS "RENTA AUMENTADA"
FROM COMPANIA
ORDER BY renta_promedio ASC, nombre_empresa DESC;
    
    











