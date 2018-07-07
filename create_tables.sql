create table REINOS
(
    ID_REINO           NUMBER       not null
        primary key,
    NOMBRE             VARCHAR2(20) not null,
    LOGOTIPO           VARCHAR2(100) default '',
    MES_REPRESENTATIVO VARCHAR2(3)  not null,
    ORO                NUMBER(12, 3) default 0,
    HIERRO             NUMBER(12, 3) default 0,
    MADERA             NUMBER(12, 3) default 0,
    DEFENSA            NUMBER(12, 3) default 0,
    ATAQUE             NUMBER        default 0,
    ARQUEROS           NUMBER        default 0,
    PIQUEROS           NUMBER        default 0,
    CABALLEROS         NUMBER        default 0,
    MAGOS              NUMBER        default 0,
    CORONAS            NUMBER        default 0
);

create table RESERVA_CENTRAL
(
    ORO           NUMBER        default 0,
    MADERA        NUMBER        default 0,
    HIERRO        NUMBER        default 0,
    PRECIO_MADERA NUMBER(10, 3) default 0,
    PRECIO_HIERRO NUMBER(10, 3) default 0
);

