create or replace procedure war_master.monitor is

  r_wood       number;
  r_gold       number;
  r_iron       number;
  r_wood_price NUMBER(10, 3);
  r_iron_price NUMBER(10, 3);
  kd_name      varchar2(12);

  cursor kds_cursor is
    select
      NAME,
      GOLD +
      ((IRON * r_iron_price) * .5) +
      ((WOOD * r_wood_price) * .5) +
      ((ARCHERS * 20) * 1.5) +
      ((PIKEMEN * 25) * 1.5) +
      ((KNIGHTS * 100) * 1.5) +
      ((WIZARDS * 50) * 1.5) +
      ATTACK +
      DEFENSE +
      (CROWNS * 10) kd_gold
    from KINGDOMS
    order by kd_gold desc;

  cursor trs_cursor is
    select *
    from TRANSACTIONS;
  begin

    select
      WOOD,
      IRON,
      GOLD,
      WOOD_PRICE,
      IRON_PRICE
    into
      r_wood,
      r_iron,
      r_gold,
      r_wood_price,
      r_iron_price
    from war_master.CENTRAL_RESERVE;

    dbms_output.put_line('Reserva Central');
    dbms_output.put_line(rpad('-', 35, '-'));
    dbms_output.put_line('Cantidad de oro:     ' || rpad(r_gold, 10, ' '));
    dbms_output.put_line('Cantidad de madera:  ' || rpad(r_wood, 10, ' '));
    dbms_output.put_line('Cantidad de hierro:  ' || rpad(r_iron, 10, ' '));
    dbms_output.put_line('Precio de la madera: ' || rpad(r_wood_price, 10, ' '));
    dbms_output.put_line('Precio del hierro:   ' || rpad(r_iron_price, 10, ' '));
    dbms_output.put_line(rpad('-', 35, '-'));
    dbms_output.put_line(' ');

    dbms_output.put_line('Ranking de reinos');
    dbms_output.put_line(rpad('-', 50, '-'));
    for kd in kds_cursor
    loop
      dbms_output.put_line('Reino: ' || rpad(kd.NAME, 20, ' ') || ' ' || 'Puntaje: ' || rpad(kd.kd_gold, 12, ' '));
    end loop;
    dbms_output.put_line(rpad('-', 50, '-'));
    dbms_output.put_line(' ');

    dbms_output.put_line('Bitacora');
    dbms_output.put_line(' ');
    dbms_output.put_line(
        rpad('Reino', 12, ' ') || ' ' || rpad('Fecha/Hora', 30, ' ') || ' ' || rpad('Oro', 10, ' ') || ' ' ||
        rpad('Madera', 10, ' ') || ' '
        || rpad('Hierro', 10, ' ') || ' ' || rpad('Coronas', 5, ' ') || ' ' || rpad('Tipo', 5, ' '));
    dbms_output.put_line(rpad('-', 90, '-'));
    for tr in trs_cursor
    loop
      select NAME
      into kd_name
      from KINGDOMS
      where ID_KINGDOM = tr.ID_KINGDOM;
      dbms_output.put_line(
          rpad(kd_name, 12, ' ') || ' ' || rpad(tr.TRANSACTION_DATETIME, 30, ' ') || ' ' || rpad(tr.GOLD, 10, ' ') ||
          ' ' ||
          rpad(tr.WOOD, 10, ' ') || ' '
          || rpad(tr.IRON, 10, ' ') || ' ' || rpad(tr.CROWNS, 5, ' ') || ' ' || rpad(tr.TRANSACTION_TYPE, 5, ' '));
    end loop;
    dbms_output.put_line(rpad('-', 90, '-'));
  end;