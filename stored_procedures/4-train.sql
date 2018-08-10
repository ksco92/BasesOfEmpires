create or replace procedure WAR_MASTER.train(p_troop VARCHAR2, p_amount NUMBER, p_kingdom NUMBER) as

  v_wood          NUMBER;
  v_iron          NUMBER;
  v_gold          NUMBER;
  v_troop         NUMBER;
  r_wood          NUMBER;
  r_iron          NUMBER;
  r_gold          NUMBER;
  r_wood_price    NUMBER(10, 3);
  r_iron_price    NUMBER(10, 3);
  tp_wood   NUMBER;
  tp_iron   NUMBER;
  tp_gold   NUMBER;
  tct_crowns      NUMBER;
BEGIN
    SELECT
      wood,
      iron,
      gold
    INTO v_wood, v_iron, v_gold
    FROM war_master.kingdoms
    WHERE id_kingdom = p_kingdom;

    SELECT
      wood,
      iron,
      gold,
      wood_price,
      iron_price
    INTO
      r_wood,
      r_iron,
      r_gold,
      r_wood_price,
      r_iron_price
    FROM war_master.central_reserve;

    CASE p_troop
      WHEN 'archers'
      THEN
        tp_wood := 100;
        tp_iron := 40;
        tp_gold := 20;

      WHEN 'pikemen'
      THEN
        tp_wood := 70;
        tp_iron := 60;
        tp_gold := 25;

      WHEN 'knight'
      THEN
        tp_wood := 20;
        tp_iron := 30;
        tp_gold := 100;

      WHEN 'wizards'
      THEN
        tp_wood := 50;
        tp_iron := 50;
        tp_gold := 50;

    END CASE;
    IF v_wood >= tp_wood * p_amount AND v_iron >= tp_iron * p_amount AND v_gold >= tp_gold * p_amount
      THEN
        CASE p_troop
          WHEN 'archers'
            THEN
              UPDATE war_master.kingdoms
              SET archers = archers + p_amount,
                  crowns    = crowns + 2 * p_amount
              WHERE id_kingdom = p_kingdom;
              tct_crowns := 2*p_amount;

          WHEN 'pikemen'
           THEN
              UPDATE war_master.kingdoms
              SET PIKEMEN = PIKEMEN + p_amount,
                  crowns    = crowns + 3* p_amount
              WHERE id_kingdom = p_kingdom;
              tct_crowns := 3*p_amount;

          WHEN 'knight'
           THEN
              UPDATE war_master.kingdoms
              SET knights = knights + p_amount,
                  crowns  = crowns  + 5 * p_amount
              WHERE id_kingdom = p_kingdom;
              tct_crowns := 5*p_amount;

          WHEN 'wizards'
            THEN
              UPDATE war_master.kingdoms
              SET WIZARDS = WIZARDS + p_amount,
                  crowns    = crowns + 1 * p_amount
              WHERE id_kingdom = p_kingdom;
              tct_crowns:=p_amount;
        END CASE;
        UPDATE war_master.kingdoms
        SET wood = wood - tp_wood * p_amount,
            iron   = iron - tp_iron * p_amount,
            gold      = gold - tp_gold * p_amount
        WHERE id_kingdom = p_kingdom;

        UPDATE war_master.CENTRAL_RESERVE
        SET wood_price = r_wood_price - round(r_wood_price * (p_amount * tp_wood / r_wood), 2),
          iron_price   = r_iron_price - round(r_iron_price * (p_amount * tp_iron / r_iron), 2),
          wood          = r_wood + tp_wood * p_amount,
          iron          = r_iron + tp_iron * p_amount,
          gold             = r_gold + tp_gold * p_amount;
        insert into WAR_MASTER.transactions(TRANSACTION_ID, TRANSACTION_TYPE, ID_KINGDOM, WOOD,IRON, GOLD, CROWNS)
        values (WAR_MASTER.TRANSAC_SEQ.nextval, 'TRP', p_kingdom, tp_wood*p_amount,tp_iron*p_amount,tp_gold*p_amount,tct_crowns);
    ELSE
      dbms_output.put_line('You do not have enough materials to execute this transaction');
    END IF;
END;