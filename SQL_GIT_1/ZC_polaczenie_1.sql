declare
a integer := 5;
b integer := 15;
begin
if a = b then
SYS.DBMS_OUTPUT.PUT_LINE('rowne');
else
SYS.DBMS_OUTPUT.PUT_LINE('nie rowne');
end if;
end;
---------------------------------------------
-- Petla loop
---------------------------------------------

declare
  a integer :=0;
begin 
  LOOP
  a:=a+1;
  DBMS_OUTPUT.PUT_LINE(a);
/*
  if a = 11 then EXIT ; 
  end if;
*/
  EXIT when a = 3 ;
END LOOP;
end;
---------------------------------------------
-- Tworzymy procedure
---------------------------------------------

CREATE OR REPLACE PROCEDURE ZC_proc_1
IS
BEGIN
SYS.DBMS_OUTPUT.PUT_LINE('procedura uruchomiona');
END;

CREATE OR REPLACE PROCEDURE ZC_proc_1 (x in NUMBER, y in NUMBER, z out NUMBER)
IS
BEGIN
z:=x*y;
END;

DECLARE
  a integer;
  b integer;
  y integer;
BEGIN
  a:= 3;
  b:= 5;
  ZC_PROC_1(a,b,y);
  SYS.DBMS_OUTPUT.PUT_LINE(y);
END;
---------------------------------------
-- Kursory nie jawy --- moze byæ tylko jeden wiersz ------------
select * from ZC_SAMOCHODY;

declare 
  x ZC_SAMOCHODY.LICZBA_MODELI%type; -- dynamiczna deklaracja typu danych
begin
  select ZC_SAMOCHODY.LICZBA_MODELI into x 
  from ZC_SAMOCHODY 
  where rownum =1;
  DBMS_OUTPUT.put_line(x);
end;  

---------------------------------------
-- Kursory nie jawy -
-- wiele wierszy    -
select a.* from ZC_SAMOCHODY a;

declare 
begin
  FOR wsk IN ( select MARKA, WERSJA, SILNIK, LICZBA_MODELI from ZC_SAMOCHODY ) LOOP
--  DBMS_OUTPUT.put_line(wsk.MARKA ||' '|| wsk.WERSJA ||' '|| wsk.SILNIK ||' '|| wsk.LICZBA_MODELI);
  DBMS_OUTPUT.put_line();
  END LOOP;
end;

-- Kursory jawy --------------------------------
-- wiele wierszy  ------------------------------


CREATE OR REPLACE PROCEDURE ZC_PROC_KUR (ogr in NUMBER) AS

  m ZC_SAMOCHODY.MARKA%TYPE;
  w ZC_SAMOCHODY.WERSJA%TYPE;
  s ZC_SAMOCHODY.SILNIK%TYPE;
  l ZC_SAMOCHODY.LICZBA_MODELI%TYPE;
  
  CURSOR kur is 
    select MARKA, WERSJA, SILNIK, LICZBA_MODELI from ZC_SAMOCHODY where rownum < ogr;

BEGIN
  OPEN kur;
    LOOP FETCH kur into m,w,s,l;
      EXIT WHEN kur%NOTFOUND;
      DBMS_OUTPUT.put_line(m ||' '|| w ||' '|| s ||' '|| l );
    END LOOP;  
  CLOSE kur;
END;

exec ZC_PROC_KUR(3);
--------------------------------------------------
-- instrukcje masowe -----------------------------

DECLARE
  TYPE m_model  is table of varchar2(20);
  TYPE l_modeli is table of number; 
    
  m m_model; 
  y l_modeli;
BEGIN
  SELECT MARKA, LICZBA_MODELI BULK COLLECT INTO m, y FROM ZC_SAMOCHODY;
  FOR i in 1..m.count loop
  DBMS_OUTPUT.PUT_LINE(m(i));
  end loop;
END;

--------------------------------------------------
-- limitowanie danych-----------------------------

declare 
  TYPE m_model  is table of VARCHAR2(20);
  TYPE l_modeli is table of number; 
    
  m m_model; 
  y l_modeli;

  cursor kursor_my is 
    SELECT MARKA, LICZBA_MODELI BULK COLLECT INTO m, y FROM ZC_SAMOCHODY;
    
begin
  OPEN kursor_my;
    LOOP FETCH kursor_my BULK COLLECT INTO m, y limit 2;
      exit when y.count = 0;
      for i in 1..y.count loop
        DBMS_OUTPUT.PUT_LINE (y(i));
      END LOOP;
    DBMS_OUTPUT.PUT_LINE ('koniec jednego pakietu');  
    END LOOP;
  CLOSE kursor_my;
END;
--------------------------------------------------
-- kolekcja danych -------------------------------

DECLARE 
  TYPE ZC_kolekcja is varray(4) of integer;
  ZC_kol ZC_kolekcja := ZC_kolekcja(111,222,33,4);
BEGIN
--  FOR i in 1..ZC_kol.count loop
    FOR i in ZC_kol.first..ZC_kol.last loop

    DBMS_OUTPUT.PUT_LINE('element kolekcji' || ZC_kol(3));
    DBMS_OUTPUT.PUT_LINE('metoda NEXT = '|| ZC_kol.next(i));
    DBMS_OUTPUT.PUT_LINE('metoda PRIOR = ' || ZC_kol.prior(i));
    DBMS_OUTPUT.PUT_LINE('metoda LIMIT = ' || ZC_kol.limit);
  end loop;
END;
  



