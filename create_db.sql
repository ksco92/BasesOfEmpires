/*
-----------------------------------------------------
To create the tables.
*/

create table WAR_MASTER.REINOS
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

create table WAR_MASTER.RESERVA_CENTRAL
(
    ORO           NUMBER        default 0,
    MADERA        NUMBER        default 0,
    HIERRO        NUMBER        default 0,
    PRECIO_MADERA NUMBER(10, 3) default 0,
    PRECIO_HIERRO NUMBER(10, 3) default 0
);

create table WAR_MASTER.TRANSACCIONES
(
    ID_TRANSACCION   NUMBER default NULL not null
        constraint TRANSAC_ID_TRANSAC_PK
        primary key,
    TIPO_TRANSACCION VARCHAR2(15),
    ID_REINO         NUMBER
        constraint TRANSAC_REINOS_ID_REINO_FK
        references REINOS
);

CREATE SEQUENCE WAR_MASTER.TRANSAC_SEQ
    START WITH 1;

/*
-----------------------------------------------------
To insert reinos.
*/

insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (1, 'Acuario', 'Jan');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (2, 'Piscis', 'Feb');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (3, 'Aries', 'Mar');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (4, 'Tauro', 'Apr');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (5, 'Geminis', 'May');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (6, 'Cancer', 'Jun');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (7, 'Leo', 'Jul');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (8, 'Virgo', 'Aug');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (9, 'Libra', 'Sep');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (10, 'Escorpio', 'Oct');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (11, 'Sagitario', 'Nov');
insert into WAR_MASTER.REINOS (ID_REINO, NOMBRE, MES_REPRESENTATIVO) values (12, 'Capricornio', 'Dec');

/*
-----------------------------------------------------
To insert reserve values.
*/

insert into WAR_MASTER.RESERVA_CENTRAL (ORO, MADERA, HIERRO, PRECIO_MADERA, PRECIO_HIERRO)
values (5000000, 2000000, 2000000, 2, 4);