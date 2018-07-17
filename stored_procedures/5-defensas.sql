create or replace procedure WAR_MASTER.defensas(p_defensa VARCHAR2, p_cantidad NUMBER, p_reino NUMBER) as

  v_madera        NUMBER;
  v_hierro        NUMBER;
  v_oro           NUMBER;
  v_coronas	  NUMBER;
  r_madera        NUMBER;
  r_hierro        NUMBER;
  r_oro           NUMBER;
  r_madera_precio NUMBER(10, 3);
  r_hierro_precio NUMBER(10, 3);
  tp_madera       NUMBER;
  tp_hierro       NUMBER;
  tp_oro NUMBER;
  BEGIN
    SELECT
      madera,
      hierro,
      oro,
      coronas
    INTO v_madera, v_hierro, v_oro, v_coronas
    FROM war_master.reinos
    WHERE id_reino = p_reino;
    SELECT
      madera,
      hierro,
      oro,
      precio_madera,
      precio_hierro
    INTO
      r_madera,
      r_hierro,
      r_oro,
      r_madera_precio,
      r_hierro_precio
    FROM war_master.reserva_central;
    CASE p_defensa
      WHEN 'canons'
      THEN
        tp_madera := 500;
        tp_hierro := 2000;
        tp_oro := 1000;

        UPDATE war_master.reinos
        SET DEFENSA = DEFENSA + 450 * p_cantidad,
          CORONAS   = CORONAS + 20 * p_cantidad
        WHERE id_reino = p_reino;
      WHEN 'towers'
      THEN
        tp_madera := 1000;
        tp_hierro := 800;
        tp_oro := 2000;

        UPDATE war_master.reinos
        SET DEFENSA = DEFENSA + 650 * p_cantidad,
          CORONAS   = CORONAS + 15 * p_cantidad
        WHERE id_reino = p_reino;

    END CASE;
    IF v_madera >= tp_madera * p_cantidad AND v_hierro >= tp_hierro * p_cantidad AND v_oro >= tp_oro * p_cantidad
    THEN
      UPDATE war_master.reinos
      SET madera = v_madera - tp_madera * p_cantidad,
        hierro   = v_hierro - tp_hierro * p_cantidad,
        oro      = v_oro - tp_oro * p_cantidad
      WHERE id_reino = p_reino;

      UPDATE war_master.reserva_central
      SET precio_madera = r_madera_precio - round(r_madera_precio * (p_cantidad * tp_madera / r_madera), 2),
        precio_hierro   = r_hierro_precio - round(r_hierro_precio * (p_cantidad * tp_hierro / r_hierro), 2),
        madera          = r_madera + tp_madera * p_cantidad,
        hierro          = r_hierro + tp_hierro * p_cantidad,
        oro             = r_oro + tp_oro * p_cantidad;
    ELSE
      DBMS_OUTPUT.PUT_LINE('NO tienes suficientes recursos para realizar la transaccion');
    END IF;
    insert into WAR_MASTER.TRANSACCIONES values (WAR_MASTER.TRANSAC_SEQ.nextval, 'DEF', p_reino);
  END;
/
