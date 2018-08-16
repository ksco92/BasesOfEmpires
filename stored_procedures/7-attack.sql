create or replace procedure war_master.attack(attaking_kd_id number, defending_kd_id number) is
  total_av     number;
  total_dv     number;
  gold_pot     number;
  wood_pot     number;
  iron_pot     number;
  atk_kd_gold  number;
  crowns_added number := 2;
  gold_cost    number := 1000;
  begin

    select GOLD
    into atk_kd_gold
    from war_master.KINGDOMS
    where ID_KINGDOM = attaking_kd_id;

    if atk_kd_gold >= gold_cost
    then

      update KINGDOMS
      set GOLD = GOLD - gold_cost
      where ID_KINGDOM = attaking_kd_id;

      select trunc((ARCHERS * 20) * .8) +
             trunc((PIKEMEN * 30) * .8) +
             trunc((KNIGHTS * 50) * .8) +
             trunc((WIZARDS * 40) * .8) +
             round(ATTACK * .6)
      into total_av
      from war_master.KINGDOMS
      where ID_KINGDOM = attaking_kd_id;

      select round(DEFENSE * .7) +
             (CANNONS * 450) +
             (TOWERS * 650)
      into total_dv
      from war_master.KINGDOMS
      where ID_KINGDOM = defending_kd_id;

      if total_av > total_dv
      then

        select
          round(GOLD * .65, -2),
          round(WOOD * .65),
          round(IRON * .65)
        into
          gold_pot,
          wood_pot,
          iron_pot
        from war_master.KINGDOMS
        where ID_KINGDOM = defending_kd_id;

        update war_master.KINGDOMS
        set
          ARCHERS = trunc(ARCHERS * .7),
          PIKEMEN = trunc(PIKEMEN * .7),
          KNIGHTS = trunc(KNIGHTS * .7),
          WIZARDS = trunc(WIZARDS * .7),
          GOLD    = GOLD + gold_pot,
          WOOD    = WOOD + wood_pot,
          IRON    = IRON + iron_pot,
          ATTACK  = round(ATTACK * .5),
          CROWNS  = CROWNS + crowns_added
        where ID_KINGDOM = attaking_kd_id;

        update war_master.KINGDOMS
        set
          ARCHERS = trunc(ARCHERS * .8),
          PIKEMEN = trunc(PIKEMEN * .8),
          KNIGHTS = trunc(KNIGHTS * .8),
          WIZARDS = trunc(WIZARDS * .8),
          GOLD    = GOLD - gold_pot,
          WOOD    = WOOD - wood_pot,
          IRON    = IRON - iron_pot,
          DEFENSE = round(DEFENSE * .9),
          TOWERS  = trunc(TOWERS * .75),
          CANNONS = trunc(CANNONS * .75)
        where ID_KINGDOM = defending_kd_id;

      else
        select round(GOLD * .30, -2)
        into
          gold_pot
        from war_master.KINGDOMS
        where ID_KINGDOM = attaking_kd_id;

        update war_master.KINGDOMS
        set
          ARCHERS = trunc(ARCHERS * .6),
          PIKEMEN = trunc(PIKEMEN * .6),
          KNIGHTS = trunc(KNIGHTS * .6),
          WIZARDS = trunc(WIZARDS * .6),
          GOLD    = GOLD - gold_pot,
          ATTACK  = round(ATTACK * .8),
          CROWNS  = CROWNS + crowns_added
        where ID_KINGDOM = attaking_kd_id;

        update war_master.KINGDOMS
        set
          ARCHERS = trunc(ARCHERS * .8),
          PIKEMEN = trunc(PIKEMEN * .8),
          KNIGHTS = trunc(KNIGHTS * .8),
          WIZARDS = trunc(WIZARDS * .8),
          GOLD    = GOLD + gold_pot,
          DEFENSE = round(DEFENSE * .9),
          TOWERS  = trunc(TOWERS * .75),
          CANNONS = trunc(CANNONS * .75)
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
/