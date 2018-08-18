create or replace procedure WAR_MASTER.defenses(p_defense VARCHAR2, p_amount NUMBER, p_kingdom NUMBER) as

  v_wood        NUMBER;
  v_iron        NUMBER;
  v_gold        NUMBER;
  v_crowns	    NUMBER;
  r_wood        NUMBER;
  r_iron        NUMBER;
  r_gold        NUMBER;
  r_wood_price  NUMBER(10, 3);
  r_iron_price  NUMBER(10, 3);
  tp_wood       NUMBER;
  tp_iron       NUMBER;
  tp_gold       NUMBER;
  tct_crowns	  NUMBER;
  BEGIN
    SELECT
      wood,
      iron,
      gold,
      crowns
    INTO v_wood, v_iron, v_gold, v_crowns
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
    CASE p_defense
      WHEN 'cannons'
      THEN
        tp_wood := 500;
        tp_iron := 2000;
        tp_gold := 1000;

        UPDATE war_master.kingdoms
        SET CANNONS = CANNONS + p_amount,
          crowns   = crowns + 20 * p_amount
        WHERE id_kingdom = p_kingdom;
	      tct_crowns := 20*p_amount;
      WHEN 'towers'
      THEN
        tp_wood := 1000;
        tp_iron := 800;
        tp_gold := 2000;

        UPDATE war_master.kingdoms
        SET TOWERS = TOWERS + p_amount,
          crowns   = crowns + 15 * p_amount
        WHERE id_kingdom = p_kingdom;
	      tct_crowns := 20*p_amount;

    END CASE;
    IF v_wood >= tp_wood * p_amount AND v_iron >= tp_iron * p_amount AND v_gold >= tp_gold * p_amount AND p_amount > 0
    THEN
      UPDATE war_master.kingdoms
      SET wood = v_wood - tp_wood * p_amount,
        iron   = v_iron - tp_iron * p_amount,
        gold      = v_gold - tp_gold * p_amount
      WHERE id_kingdom = p_kingdom;

      UPDATE war_master.central_reserve
      SET wood_price = r_wood_price - round(r_wood_price * (p_amount * tp_wood / r_wood), 2),
        iron_price   = r_iron_price - round(r_iron_price * (p_amount * tp_iron / r_iron), 2),
        wood          = r_wood + tp_wood * p_amount,
        iron          = r_iron + tp_iron * p_amount,
        gold             = r_gold + tp_gold * p_amount;

      insert into WAR_MASTER.transactions(TRANSACTION_ID, TRANSACTION_TYPE, ID_KINGDOM, WOOD,IRON, GOLD, CROWNS)
      values (WAR_MASTER.TRANSAC_SEQ.nextval, 'DEF', p_kingdom,tp_wood*p_amount,tp_iron*p_amount,tp_gold*p_amount,tct_crowns);
    ELSE
      DBMS_OUTPUT.PUT_LINE('NO tienes suficientes recursos para realizar la transaccion o la cantidad construida es invalida');
      CASE p_defense
      WHEN 'cannons'
      THEN

        UPDATE war_master.kingdoms
        SET CANNONS = CANNONS - p_amount,
          crowns   = crowns - 20 * p_amount
        WHERE id_kingdom = p_kingdom;
      WHEN 'towers'
      THEN

        UPDATE war_master.KINGDOMS
        SET TOWERS = TOWERS - p_amount,
          crowns   = crowns - 15 * p_amount
        WHERE id_kingdom = p_kingdom;

    END CASE;
    END IF;
  END;
/
