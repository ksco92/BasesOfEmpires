create or replace procedure WAR_MASTER.restart_game as

    begin

        update WAR_MASTER.REINOS
        set ORO        = 40000,
            MADERA     = 20000,
            HIERRO     = 10000,
            CORONAS    = 0,
            DEFENSA    = 0,
            ATAQUE     = 0,
            ARQUEROS   = 0,
            PIQUEROS   = 0,
            CABALLEROS = 0,
            MAGOS      = 0;

        update WAR_MASTER.RESERVA_CENTRAL
        set ORO           = 5000000,
            MADERA        = 2000000,
            HIERRO        = 2000000,
            PRECIO_MADERA = 2.000,
            PRECIO_HIERRO = 4.000;

        execute immediate 'truncate table WAR_MASTER.TRANSACCIONES';

    end;