select SZOBA_FK, YEAR(METTOL), COUNT(*)
from foglalas
GROUP BY ROLLUP(SZOBA_FK, YEAR(METTOL))

SELECT 
    f.SZOBA_FK AS 'Szoba ID', 
    f.FOGLALAS_PK AS 'Foglalás ID', 
    DATEDIFF(DAY, f.METTOL, f.MEDDIG) AS 'Eltelt Napok',
    COALESCE(
        DATEDIFF(DAY, lag(f.MEDDIG) OVER (PARTITION BY f.SZOBA_FK ORDER BY f.METTOL), f.METTOL),
        0
    ) AS 'Előző Foglalás Időtartama'
FROM 
    Foglalas f 
JOIN 
    Szoba sz ON f.SZOBA_FK = sz.SZOBA_ID
ORDER BY 
    f.SZOBA_FK, f.METTOL;


SELECT sz.SZALLAS_NEV, COUNT(*)
FROM szallashely sz JOIN Szoba szo ON sz.SZALLAS_ID = SZALLAS_FK
    JOIN Foglalas f ON szo.SZOBA_ID = f.SZOBA_FK
GROUP BY SZALLAS_NEV
HAVING count(*) >
    (select COUNT(*)
FROM szallashely sz JOIN Szoba szo ON sz.SZALLAS_ID = SZALLAS_FK
    JOIN Foglalas f ON szo.SZOBA_ID = f.SZOBA_FK
    where SZALLAS_NEV = 'Fortuna Panzió'
    )