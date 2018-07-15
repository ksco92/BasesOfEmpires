create or replace procedure WAR_MASTER.sell(p_material varchar2, p_cantidad_vendida number, p_reino number) as

    p_reserva_material number;
    p_precio_material  number(10, 3);

    begin

        case p_material
            when 'MADERA'
            then
                select
                    MADERA,
                    PRECIO_MADERA
                into p_reserva_material, p_precio_material
                from WAR_MASTER.RESERVA_CENTRAL;

                update WAR_MASTER.REINOS
                set MADERA  = MADERA - p_cantidad_vendida,
                    ORO     = ORO + p_precio_material,
                    CORONAS = CORONAS + 5
                where ID_REINO = p_reino;

                update WAR_MASTER.RESERVA_CENTRAL
                set ORO    = ORO - p_precio_material,
                    MADERA = MADERA + p_cantidad_vendida;

                p_precio_material :=
                p_precio_material - (p_precio_material * round(p_cantidad_vendida / p_reserva_material, 2));

                update WAR_MASTER.RESERVA_CENTRAL
                set PRECIO_MADERA = p_precio_material;

            when 'HIERRO'
            then
                select
                    HIERRO,
                    PRECIO_HIERRO
                into p_reserva_material, p_precio_material
                from WAR_MASTER.RESERVA_CENTRAL;

                update WAR_MASTER.REINOS
                set HIERRO  = HIERRO - p_cantidad_vendida,
                    ORO     = ORO + p_precio_material,
                    CORONAS = CORONAS + 5
                where ID_REINO = p_reino;

                update WAR_MASTER.RESERVA_CENTRAL
                set ORO    = ORO - p_precio_material,
                    HIERRO = HIERRO + p_cantidad_vendida;

                p_precio_material :=
                p_precio_material - (p_precio_material * round(p_cantidad_vendida / p_reserva_material, 2));

                update WAR_MASTER.RESERVA_CENTRAL
                set PRECIO_HIERRO = p_precio_material;

        end case;

        insert into WAR_MASTER.TRANSACCIONES values (WAR_MASTER.TRANSAC_SEQ.nextval, 'VTA', p_reino);

    end;