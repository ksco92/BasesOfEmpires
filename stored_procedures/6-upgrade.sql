create or replace procedure war_master.upgrade(upgrade_type VARCHAR2, kingdom_id NUMBER) is
  gold_cost    number;
  wood_cost    number;
  iron_cost    number;
  crowns_added number;
  stat_added   number;
  kd_gold      number;
  kd_wood      number;
  kd_iron      number;
  begin
    select
      GOLD,
      WOOD,
      IRON
    into
      kd_gold,
      kd_wood,
      kd_iron
    from war_master.kingdoms
    where ID_KINGDOM = kingdom_id;

    case upgrade_type
      when 'DEFENSE'
      then
        gold_cost := 2000;
        wood_cost := 100;
        iron_cost := 150;
        crowns_added := 40;

        select (DEFENSE * 1.1) + 500
        into stat_added
        from KINGDOMS
        where ID_KINGDOM = kingdom_id;

        if kd_gold >= gold_cost and
           kd_wood >= wood_cost and
           kd_iron >= iron_cost
        then

          update war_master.kingdoms
          set
            DEFENSE = stat_added,
            GOLD    = GOLD - gold_cost,
            WOOD    = WOOD - wood_cost,
            IRON    = IRON - iron_cost,
            CROWNS  = CROWNS + crowns_added
          where ID_KINGDOM = kingdom_id;

          update war_master.central_reserve
          set
            GOLD       = GOLD + gold_cost,
            WOOD       = WOOD + wood_cost,
            IRON       = IRON + iron_cost,
            WOOD_PRICE = WOOD_PRICE - round(WOOD_PRICE * (wood_cost / WOOD), 2),
            IRON_PRICE = IRON_PRICE - round(IRON_PRICE * (iron_cost / IRON), 2);

          insert into WAR_MASTER.TRANSACTIONS (TRANSACTION_ID, TRANSACTION_TYPE, GOLD, WOOD, IRON, CROWNS, TRANSACTION_DATETIME, ID_KINGDOM)
          values
            (WAR_MASTER.TRANSAC_SEQ.nextval, 'M+D', gold_cost, wood_cost, iron_cost, crowns_added, current_timestamp,
             kingdom_id);

        else
          dbms_output.put_line('Need at least 2000 gold, 100 wood and 150 iron to improve a kingdoms defense.');
        end if;

      when 'ATTACK'
      then
        gold_cost := 1500;
        wood_cost := 300;
        iron_cost := 200;
        crowns_added := 5;

        select (ATTACK * 1.1) + 500
        into stat_added
        from KINGDOMS
        where ID_KINGDOM = kingdom_id;

        if kd_gold >= gold_cost and
           kd_wood >= wood_cost and
           kd_iron >= iron_cost
        then

          update war_master.kingdoms
          set
            ATTACK = stat_added,
            GOLD   = GOLD - gold_cost,
            WOOD   = WOOD - wood_cost,
            IRON   = IRON - iron_cost,
            CROWNS = CROWNS + crowns_added
          where ID_KINGDOM = kingdom_id;

          update war_master.central_reserve
          set
            GOLD       = GOLD + gold_cost,
            WOOD       = WOOD + wood_cost,
            IRON       = IRON + iron_cost,
            WOOD_PRICE = WOOD_PRICE - round(WOOD_PRICE * (wood_cost / WOOD), 2),
            IRON_PRICE = IRON_PRICE - round(IRON_PRICE * (iron_cost / IRON), 2);

          insert into WAR_MASTER.TRANSACTIONS (TRANSACTION_ID, TRANSACTION_TYPE, GOLD, WOOD, IRON, CROWNS, TRANSACTION_DATETIME, ID_KINGDOM)
          values
            (WAR_MASTER.TRANSAC_SEQ.nextval, 'M+A', gold_cost, wood_cost, iron_cost, crowns_added, current_timestamp,
             kingdom_id);

        else
          dbms_output.put_line('Need at least 1500 gold, 300 wood and 200 iron to improve a kingdoms attack.');
        end if;

    end case;
  end;
/