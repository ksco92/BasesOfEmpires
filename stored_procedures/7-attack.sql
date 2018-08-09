create or replace procedure war_master.attack(attaking_kd_id number, defending_kd_id number) is
  total_av     number;
  total_dv     number;
  gold_pot     number;
  wood_pot     number;
  iron_pot     number;
  crowns_added number := 2;
  atk_kd_gold  number;
  gold_cost    number := 1000;
  begin

    select GOLD
    into atk_kd_gold
    from war_master.KINGDOMS
    where ID_KINGDOM = attaking_kd_id;

    if atk_kd_gold >= gold_cost
    then
      select ((ARCHERS * 20) * .8) +
             ((PIKEMEN * 30) * .8) +
             ((KNIGHTS * 50) * .8) +
             ((WIZARDS * 40) * .8) +
             (ATTACK * .6)
      into total_av
      from war_master.KINGDOMS
      where ID_KINGDOM = attaking_kd_id;

      select (DEFENSE * .7) +
             (CANNONS * 450) +
             (TOWERS * 650)
      into total_dv
      from war_master.KINGDOMS
      where ID_KINGDOM = defending_kd_id;

      if total_av > total_dv
      then

        select
          GOLD * .65,
          WOOD * .65,
          IRON * .65
        into
          gold_pot,
          wood_pot,
          iron_pot
        from war_master.KINGDOMS
        where ID_KINGDOM = defending_kd_id;

        update war_master.KINGDOMS
        set
          ARCHERS = ARCHERS * .7,
          PIKEMEN = PIKEMEN * .7,
          KNIGHTS = KNIGHTS * .7,
          WIZARDS = WIZARDS * .7,
          GOLD    = GOLD + gold_pot,
          WOOD    = WOOD + wood_pot,
          IRON    = IRON + iron_pot,
          ATTACK  = ATTACK * .5,
          CROWNS  = CROWNS + crowns_added
        where ID_KINGDOM = attaking_kd_id;

        update war_master.KINGDOMS
        set
          ARCHERS = ARCHERS * .8,
          PIKEMEN = PIKEMEN * .8,
          KNIGHTS = KNIGHTS * .8,
          WIZARDS = WIZARDS * .8,
          GOLD    = GOLD - gold_pot,
          WOOD    = WOOD - wood_pot,
          IRON    = IRON - iron_pot,
          DEFENSE = DEFENSE * .9,
          TOWERS  = TOWERS * .75,
          CANNONS = CANNONS * .75
        where ID_KINGDOM = defending_kd_id;

      else
        select GOLD * .30
        into
          gold_pot
        from war_master.KINGDOMS
        where ID_KINGDOM = attaking_kd_id;

        update war_master.KINGDOMS
        set
          ARCHERS = ARCHERS * .6,
          PIKEMEN = PIKEMEN * .6,
          KNIGHTS = KNIGHTS * .6,
          WIZARDS = WIZARDS * .6,
          GOLD    = GOLD - gold_pot,
          ATTACK  = ATTACK * .8,
          CROWNS  = CROWNS + crowns_added
        where ID_KINGDOM = attaking_kd_id;

        update war_master.KINGDOMS
        set
          ARCHERS = ARCHERS * .8,
          PIKEMEN = PIKEMEN * .8,
          KNIGHTS = KNIGHTS * .8,
          WIZARDS = WIZARDS * .8,
          GOLD    = GOLD + gold_pot,
          DEFENSE = DEFENSE * .9,
          TOWERS  = TOWERS * .75,
          CANNONS = CANNONS * .75
        where ID_KINGDOM = defending_kd_id;
      end if;

      insert into WAR_MASTER.TRANSACTIONS (TRANSACTION_ID, TRANSACTION_TYPE, GOLD, CROWNS, TRANSACTION_DATETIME, ID_KINGDOM)
      values
        (WAR_MASTER.TRANSAC_SEQ.nextval, 'ATK', gold_cost, crowns_added, current_timestamp,
         attaking_kd_id);

    else
      dbms_output.put_line('Need at least 1000 gold to attack another kingdom.');
    end if;

  end;