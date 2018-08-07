/*
-----------------------------------------------------
To create the tables.
*/

create table WAR_MASTER.KINGDOMS
(
    ID_KINGDOM NUMBER       not null
        primary key,
    NAME       VARCHAR2(20) not null,
    LOGO       VARCHAR2(100) default '',
    MONTH      VARCHAR2(3)  not null,
    GOLD       NUMBER(12, 3) default 0,
    IRON       NUMBER(12, 3) default 0,
    WOOD       NUMBER(12, 3) default 0,
    DEFENSE    NUMBER(12, 3) default 0,
    ATTACK     NUMBER        default 0,
    ARCHERS    NUMBER        default 0,
    PIKEMEN    NUMBER        default 0,
    KNIGHTS    NUMBER        default 0,
    WIZARDS    NUMBER        default 0,
    CROWNS     NUMBER        default 0,
    TOWERS     NUMBER        default 0,
    CANNONS    NUMBER        default 0
);

create table WAR_MASTER.CENTRAL_RESERVE
(
    GOLD       NUMBER        default 0,
    WOOD       NUMBER        default 0,
    IRON       NUMBER        default 0,
    WOOD_PRICE NUMBER(10, 3) default 0,
    IRON_PRICE NUMBER(10, 3) default 0
);

create table WAR_MASTER.TRANSACTIONS
(
    TRANSACTION_ID       NUMBER default NULL not null
        constraint TRANSAC_ID_TRANSAC_PK
        primary key,
    TRANSACTION_TYPE     VARCHAR2(15),
    UNIT_TYPE            VARCHAR2(15),
    TRANSACTION_DATETIME TIMESTAMP(6) default CURRENT_TIMESTAMP,
    ID_KINGDOM           NUMBER
        constraint TRANSAC_REINOS_ID_REINO_FK
        references WAR_MASTER.KINGDOMS
);

CREATE SEQUENCE WAR_MASTER.TRANSAC_SEQ
    START WITH 1;

/*
-----------------------------------------------------
To insert reinos.
*/

insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (1, 'Acuario', 'Jan');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (2, 'Piscis', 'Feb');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (3, 'Aries', 'Mar');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (4, 'Tauro', 'Apr');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (5, 'Geminis', 'May');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (6, 'Cancer', 'Jun');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (7, 'Leo', 'Jul');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (8, 'Virgo', 'Aug');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (9, 'Libra', 'Sep');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (10, 'Escorpio', 'Oct');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (11, 'Sagitario', 'Nov');
insert into WAR_MASTER.KINGDOMS (ID_KINGDOM, NAME, MONTH) values (12, 'Capricornio', 'Dec');

/*
-----------------------------------------------------
To insert reserve values.
*/

insert into WAR_MASTER.CENTRAL_RESERVE (GOLD, WOOD, IRON, WOOD_PRICE, IRON_PRICE)
values (5000000, 2000000, 2000000, 2, 4);