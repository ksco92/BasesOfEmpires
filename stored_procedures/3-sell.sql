create or replace procedure WAR_MASTER.sell(p_material varchar2, p_amount_sold number, p_kingdom number) as

    p_reserve_material number;
    p_material_price   number(10, 3);
    p_kingdom_material number;

    begin

        if p_amount_sold > 0
        then

            case p_material
                when 'MADERA'
                then
                    select
                        WOOD,
                        WOOD_PRICE
                    into p_reserve_material, p_material_price
                    from WAR_MASTER.CENTRAL_RESERVE;

                    select WOOD
                    into p_kingdom_material
                    from WAR_MASTER.KINGDOMS
                    where ID_KINGDOM = p_kingdom;

                    if p_kingdom_material > p_amount_sold
                    then
                        update WAR_MASTER.KINGDOMS
                        set WOOD   = WOOD - p_amount_sold,
                            gold   = gold + (p_material_price * p_amount_sold),
                            CROWNS = CROWNS + 10
                        where ID_KINGDOM = p_kingdom;

                        update WAR_MASTER.CENTRAL_RESERVE
                        set GOLD = GOLD - (p_material_price * p_amount_sold),
                            WOOD = WOOD + p_amount_sold;

                        p_material_price :=
                        p_material_price - (p_material_price * round(p_amount_sold / p_reserve_material, 2));

                        update WAR_MASTER.CENTRAL_RESERVE
                        set WOOD_PRICE = p_material_price;

                        insert into WAR_MASTER.TRANSACTIONS (TRANSACTION_ID, TRANSACTION_TYPE, ID_KINGDOM, WOOD, CROWNS)
                        values (WAR_MASTER.TRANSAC_SEQ.nextval, 'VTA', p_kingdom, p_amount_sold, 10);
                    else
                        dbms_output.put_line('No tiene suficientes recursos para vender');
                    end if;


                when 'HIERRO'
                then
                    select
                        IRON,
                        IRON_PRICE
                    into p_reserve_material, p_material_price
                    from WAR_MASTER.CENTRAL_RESERVE;

                    select IRON
                    into p_kingdom_material
                    from WAR_MASTER.KINGDOMS
                    where ID_KINGDOM = p_kingdom;

                    if p_kingdom_material > p_amount_sold
                    then
                        update WAR_MASTER.KINGDOMS
                        set IRON   = IRON - p_amount_sold,
                            gold   = gold + (p_material_price * p_amount_sold),
                            CROWNS = CROWNS + 10
                        where ID_KINGDOM = p_kingdom;

                        update WAR_MASTER.CENTRAL_RESERVE
                        set GOLD = GOLD - (p_material_price * p_amount_sold),
                            IRON = IRON + p_amount_sold;

                        p_material_price :=
                        p_material_price - (p_material_price * round(p_amount_sold / p_reserve_material, 2));

                        update WAR_MASTER.CENTRAL_RESERVE
                        set IRON_PRICE = p_material_price;

                        insert into WAR_MASTER.TRANSACTIONS (TRANSACTION_ID, TRANSACTION_TYPE, ID_KINGDOM, IRON, CROWNS)
                        values (WAR_MASTER.TRANSAC_SEQ.nextval, 'VTA', p_kingdom, p_amount_sold, 10);
                    else
                        dbms_output.put_line('No tiene suficientes recursos para vender');
                    end if;

            end case;

        else
            dbms_output.put_line('La cantidad a vender debe ser mayor que 0.');
        end if;

    end;
/