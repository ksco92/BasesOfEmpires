create or replace procedure WAR_MASTER.defences(p_defense VARCHAR2, p_amount NUMBER, p_kingdom NUMBER) as

  v_wood        NUMBER;
  v_iron        NUMBER;
  v_gold        NUMBER;
  v_crowns	NUMBER;
  r_wood        NUMBER;
  r_iron        NUMBER;
  r_gold        NUMBER;
  r_wood_price  NUMBER(10, 3);
  r_iron_price  NUMBER(10, 3);
  tp_wood       NUMBER;
  tp_iron       NUMBER;
  tp_gold       NUMBER;
  BEGIN
    SELECT
      madera,
      hierro,
      oro,
      coronas
    INTO v_wood, v_iron, v_gold, v_crowns
    FROM war_master.reinos
    WHERE id_reino = p_kingdom;
    SELECT
      madera,
      hierro,
      oro,
      precio_madera,
      precio_hierro
    INTO
      r_wood,
      r_iron,
      r_gold,
      r_wood_price,
      r_iron_price
    FROM war_master.reserva_central;
    CASE p_defense
      WHEN 'canons'
      THEN
        tp_wood := 500;
        tp_iron := 2000;
        tp_gold := 1000;

        UPDATE war_master.reinos
        SET DEFENSA = DEFENSA + 450 * p_amount,
          CORONAS   = CORONAS + 20 * p_amount
        WHERE id_reino = p_kingdom;
      WHEN 'towers'
      THEN
        tp_wood := 1000;
        tp_iron := 800;
        tp_gold := 2000;

        UPDATE war_master.reinos
        SET DEFENSA = DEFENSA + 650 * p_amount,
          CORONAS   = CORONAS + 15 * p_amount
        WHERE id_reino = p_kingdom;

    END CASE;
    IF v_wood >= tp_wood * p_amount AND v_iron >= tp_iron * p_amount AND v_gold >= tp_gold * p_amount
    THEN
      UPDATE war_master.reinos
      SET madera = v_wood - tp_wood * p_amount,
        hierro   = v_iron - tp_iron * p_amount,
        oro      = v_gold - tp_gold * p_amount
      WHERE id_reino = p_kingdom;

      UPDATE war_master.reserva_central
      SET precio_madera = r_wood_price - round(r_wood_price * (p_amount * tp_wood / r_wood), 2),
        precio_hierro   = r_iron_price - round(r_iron_price * (p_amount * tp_iron / r_iron), 2),
        madera          = r_wood + tp_wood * p_amount,
        hierro          = r_iron + tp_iron * p_amount,
        oro             = r_gold + tp_gold * p_amount;
    ELSE
      DBMS_OUTPUT.PUT_LINE('NO tienes suficientes recursos para realizar la transaccion');
    END IF;
    insert into WAR_MASTER.TRANSACCIONES values (WAR_MASTER.TRANSAC_SEQ.nextval, 'DEF', p_kingdom);
  END;
/
