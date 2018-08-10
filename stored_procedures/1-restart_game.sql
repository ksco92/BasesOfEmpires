create or replace procedure WAR_MASTER.restart_game as

    begin

        update WAR_MASTER.KINGDOMS
        set gold    = 40000,
            WOOD    = 20000,
            IRON    = 10000,
            CROWNS  = 0,
            DEFENSE = 0,
            ATTACK  = 0,
            ARCHERS = 0,
            PIKEMEN = 0,
            KNIGHTS = 0,
            WIZARDS = 0,
            TOWERS  = 0,
            CANNONS = 0;

        update WAR_MASTER.CENTRAL_RESERVE
        set GOLD       = 5000000,
            WOOD       = 2000000,
            IRON       = 2000000,
            WOOD_PRICE = 2.000,
            IRON_PRICE = 4.000;

        execute immediate 'truncate table WAR_MASTER.TRANSACTIONS';

    end;
/