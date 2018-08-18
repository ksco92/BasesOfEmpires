create or replace procedure WAR_MASTER.buy(p_material varchar2, p_amount_bought number, p_kingdom number) as

    p_reserve_material number;
    p_material_price   number(10, 3);
    p_kingdom_gold     number;

    begin

        select GOLD
        into p_kingdom_gold
        from WAR_MASTER.KINGDOMS
        where ID_KINGDOM = p_kingdom;

        if p_amount_bought > 0
        then

            case p_material
                when 'MADERA'
                then
                    select
                        WOOD,
                        WOOD_PRICE
                    into p_reserve_material, p_material_price
                    from WAR_MASTER.CENTRAL_RESERVE;

                    if p_kingdom_gold > (p_material_price * p_amount_bought)
                    then
                        update WAR_MASTER.KINGDOMS
                        set WOOD   = WOOD + p_amount_bought,
                            gold   = gold - (p_material_price * p_amount_bought),
                            CROWNS = CROWNS + 5
                        where ID_KINGDOM = p_kingdom;

                        update WAR_MASTER.CENTRAL_RESERVE
                        set GOLD = GOLD + (p_material_price * p_amount_bought),
                            WOOD = WOOD - p_amount_bought;

                        p_material_price :=
                        p_material_price + (p_material_price * round(p_amount_bought / p_reserve_material, 2));

                        update WAR_MASTER.CENTRAL_RESERVE
                        set WOOD_PRICE = p_material_price;

                        insert into WAR_MASTER.TRANSACTIONS (TRANSACTION_ID, TRANSACTION_TYPE, ID_KINGDOM, WOOD, CROWNS)
                        values (WAR_MASTER.TRANSAC_SEQ.nextval, 'CMP', p_kingdom, p_amount_bought, 5);

                    else
                        dbms_output.put_line('No tiene suficiente oro para completar la transaccion.');
                    end if;


                when 'HIERRO'
                then
                    select
                        IRON,
                        IRON_PRICE
                    into p_reserve_material, p_material_price
                    from WAR_MASTER.CENTRAL_RESERVE;

                    if p_kingdom_gold > (p_material_price * p_amount_bought)
                    then
                        update WAR_MASTER.KINGDOMS
                        set IRON   = IRON + p_amount_bought,
                            gold   = gold - (p_material_price * p_amount_bought),
                            CROWNS = CROWNS + 5
                        where ID_KINGDOM = p_kingdom;

                        update WAR_MASTER.CENTRAL_RESERVE
                        set GOLD = GOLD + (p_material_price * p_amount_bought),
                            IRON = IRON - p_amount_bought;

                        p_material_price :=
                        p_material_price + (p_material_price * round(p_amount_bought / p_reserve_material, 2));

                        update WAR_MASTER.CENTRAL_RESERVE
                        set IRON_PRICE = p_material_price;

                        insert into WAR_MASTER.TRANSACTIONS (TRANSACTION_ID, TRANSACTION_TYPE, ID_KINGDOM, IRON, CROWNS)
                        values (WAR_MASTER.TRANSAC_SEQ.nextval, 'CMP', p_kingdom, p_amount_bought, 5);
                    else
                        dbms_output.put_line('No tiene suficiente oro para completar la transaccion.');
                    end if;


            end case;

        else
            dbms_output.put_line('La cantidad a comprar debe ser mayor que 0.');

        end if;

    end;
/