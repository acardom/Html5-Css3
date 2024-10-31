--Ejercicio 5

--CONSULTAS MULTITABLA (COMPOSICI�N INTERNA)
-- 1
SELECT DISTINCT c.nombre_cliente AS "CLIENTE", e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "REPRESENTANTE VENTAS"
    FROM cliente c, empleado e
    WHERE c.codigo_empleado_rep_ventas=e.codigo_empleado;
    
--2
SELECT DISTINCT c.nombre_cliente AS "CLIENTE", e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "REPRESENTANTE VENTAS"
    FROM cliente c, empleado e, pago p
    WHERE c.codigo_cliente=p.codigo_cliente
        AND c.codigo_empleado_rep_ventas=e.codigo_empleado;

--3
SELECT DISTINCT c.nombre_cliente AS "CLIENTE", e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "REPRESENTANTE VENTAS"
    FROM cliente c, empleado e
    WHERE c.codigo_cliente NOT IN (SELECT cl.codigo_cliente FROM cliente cl, pago p WHERE cl.codigo_cliente=p.codigo_cliente)
        AND c.codigo_empleado_rep_ventas=e.codigo_empleado;
        
--4
SELECT DISTINCT c.nombre_cliente AS "CLIENTE", e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "REPRESENTANTE VENTAS", o.ciudad AS "CIUDAD OFICINA"
    FROM cliente c, empleado e, pago p, oficina o
    WHERE c.codigo_cliente=p.codigo_cliente
        AND c.codigo_empleado_rep_ventas=e.codigo_empleado
        AND e.codigo_oficina=o.codigo_oficina;
        
--5 
SELECT DISTINCT c.nombre_cliente AS "CLIENTE", e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "REPRESENTANTE VENTAS", o.ciudad AS "CIUDAD OFICINA"
    FROM cliente c, empleado e, oficina o
    WHERE c.codigo_cliente NOT IN (SELECT cl.codigo_cliente FROM cliente cl, pago p WHERE cl.codigo_cliente=p.codigo_cliente)
        AND c.codigo_empleado_rep_ventas=e.codigo_empleado
        AND e.codigo_oficina=o.codigo_oficina;
        
--6
SELECT DISTINCT o.linea_direccion1 || ', ' || o.linea_direccion2 || '. ' || o.codigo_postal || ' - ' || o.ciudad || ' (' || o.pais || ')' AS "DIRECCI�N OFICINA"
    FROM oficina o, empleado e, cliente c
    WHERE (UPPER(c.linea_direccion1) LIKE '%FUENLABRADA%' OR UPPER(c.linea_direccion2) LIKE '%FUENLABRADA%' OR UPPER(c.ciudad) LIKE '%FUENLABRADA%' OR UPPER(c.region) LIKE '%FUENLABRADA%')
        AND c.codigo_empleado_rep_ventas=e.codigo_empleado
        AND e.codigo_oficina=o.codigo_oficina;

--7
SELECT DISTINCT c.nombre_cliente AS "CLIENTE", e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "REPRESENTANTE VENTAS", o.ciudad AS "CIUDAD OFICINA"
    FROM cliente c, empleado e, oficina o
    WHERE c.codigo_empleado_rep_ventas=e.codigo_empleado
        AND e.codigo_oficina=o.codigo_oficina;
        
--8
SELECT e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "EMPLEADO", j.nombre || ' ' || j.apellido1 || ' ' || j.apellido2 AS "JEFE"
    FROM empleado e, empleado j
    WHERE e.codigo_jefe=j.codigo_empleado;
    
--9
SELECT DISTINCT c.nombre_cliente AS "CLIENTE"
    FROM cliente c, pedido p
    WHERE p.fecha_esperada<p.fecha_entrega
        AND p.codigo_cliente=c.codigo_cliente;
        
--10
SELECT DISTINCT c.nombre_cliente AS "CLIENTE", g.gama AS "GAMA"
    FROM cliente c, pedido p, detalle_pedido dp, producto pr, gama_producto g
    WHERE c.codigo_cliente=p.codigo_cliente
        AND p.codigo_pedido=dp.codigo_pedido
        AND dp.codigo_producto=pr.codigo_producto
        AND pr.gama=g.gama
    ORDER BY "CLIENTE";
    
--CONSULTAS MULTITABLA (COMPOSICI�N EXTERNA)
--1
SELECT DISTINCT c.nombre_cliente AS "CLIENTE"
    FROM cliente c, pago p
    WHERE c.codigo_cliente=p.codigo_cliente(+)
        AND p.codigo_cliente IS NULL;
    
SELECT DISTINCT c.nombre_cliente AS "CLIENTE"
    FROM cliente c
    LEFT JOIN pago p ON c.codigo_cliente=p.codigo_cliente
    WHERE p.codigo_cliente IS NULL;    
	
--Mismo ejercicio realizado con subconsultas
SELECT DISTINCT c.nombre_cliente AS "CLIENTE"
    FROM cliente c
    WHERE c.codigo_cliente NOT IN (SELECT p.codigo_cliente FROM pago p);
        
--2
SELECT DISTINCT c.nombre_cliente AS "CLIENTE"
    FROM cliente c, pedido p
    WHERE c.codigo_cliente=p.codigo_cliente(+)
        AND p.codigo_cliente IS NULL;
        
--3
SELECT DISTINCT c.nombre_cliente AS "CLIENTE"
    FROM cliente c, pedido pe, pago pa
    WHERE c.codigo_cliente=pe.codigo_cliente(+)
        AND c.codigo_cliente=pa.codigo_cliente(+)
        AND pe.codigo_cliente IS NULL
        AND pa.codigo_cliente IS NULL;
        
--4
SELECT e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "EMPLEADO"
    FROM empleado e, oficina o
    WHERE e.codigo_oficina=o.codigo_oficina(+)
        AND o.codigo_oficina IS NULL;

--5 
SELECT e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "EMPLEADO"
    FROM empleado e, cliente c
    WHERE e.codigo_empleado=c.codigo_empleado_rep_ventas(+)
        AND c.codigo_empleado_rep_ventas IS NULL;
        
--6
SELECT e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "EMPLEADO"
    FROM empleado e, cliente c, oficina o
    WHERE e.codigo_empleado=c.codigo_empleado_rep_ventas(+)
        AND e.codigo_oficina=o.codigo_oficina(+)
        AND c.codigo_empleado_rep_ventas IS NULL
        AND o.codigo_oficina IS NULL;
        
--7 
SELECT DISTINCT p.codigo_producto AS "C�DIGO PRODUCTO", p.nombre AS "PRODUCTO"
    FROM producto p, detalle_pedido dt
    WHERE p.codigo_producto=dt.codigo_producto(+)
        AND dt.codigo_producto IS NULL;
        
--8 
SELECT DISTINCT o.codigo_oficina AS "OFICINA", o.ciudad AS "CIUDAD", o.pais AS "PAIS"
    FROM oficina o, 
        (SELECT DISTINCT e.codigo_empleado, e.codigo_oficina
            FROM empleado e, cliente c, pedido p, detalle_pedido dp, producto pr
            WHERE pr.gama='Frutales' AND pr.codigo_producto=dp.codigo_producto AND dp.codigo_pedido=p.codigo_pedido
                AND p.codigo_cliente=c.codigo_cliente
                AND e.codigo_empleado=c.codigo_empleado_rep_ventas) ef
    WHERE o.codigo_oficina=ef.codigo_oficina(+)
        AND ef.codigo_oficina IS NULL;       

--9
SELECT DISTINCT c.codigo_cliente AS "C�DIGO CLIENTE", c.nombre_cliente AS "NOMBRE CLIENTE"
    FROM cliente c, pedido pe, pago pa
    WHERE c.codigo_cliente=pe.codigo_cliente
        AND c.codigo_cliente=pa.codigo_cliente(+)
        AND pa.codigo_cliente IS NULL;

--10
SELECT DISTINCT e.codigo_empleado AS "C�DIGO EMPLEADO", e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "EMPLEADO", j.nombre || ' ' || j.apellido1 || ' ' || j.apellido2 AS "JEFE"
    FROM empleado e, cliente c, empleado j
    WHERE e.codigo_empleado=c.codigo_empleado_rep_ventas(+)
        AND e.codigo_jefe=j.codigo_empleado
        AND c.codigo_empleado_rep_ventas IS NULL;
        
--CONSULTAS RESUMEN
--1
SELECT COUNT(*) AS "N�MERO EMPLEADOS" FROM empleado;

--2
SELECT c.pais AS "PA�S", COUNT(*) AS "N�MERO CLIENTES"
    FROM cliente c
    GROUP BY c.pais;
    
--3
SELECT TO_CHAR(AVG(pa.total),'999G999D99L') AS "PAGO MEDIO 2009"
    FROM pago pa
    WHERE TO_CHAR(fecha_pago,'YYYY')='2009';
    
--4
SELECT estado AS "ESTADO", COUNT(*) AS "N� PEDIDOS" FROM pedido GROUP BY estado ORDER BY "N� PEDIDOS" DESC;

--5
SELECT MAX(precio_venta) AS "PRECIO M�S CARO", MIN(precio_venta) AS "PRECIO M�S BARATO" FROM producto;

--6
SELECT COUNT(*) AS "N� CLIENTES" FROM cliente;
    
--7
SELECT COUNT(*) AS "N� CLIENTES DE MADRID" FROM cliente WHERE UPPER(ciudad)='MADRID';

--8
SELECT ciudad AS "CIUDAD", COUNT(*) AS "N� CLIENTES" FROM cliente WHERE UPPER(ciudad) LIKE 'M%' GROUP BY ciudad;

--9
SELECT e.codigo_empleado AS "EMPLEADO", COUNT(c.codigo_cliente) AS "CLIENTES REPRESENTADOS"
    FROM empleado e, cliente c
    WHERE e.codigo_empleado=c.codigo_empleado_rep_ventas
    GROUP BY e.codigo_empleado;
    
--10
SELECT COUNT(*) AS "CLIENTES SIN REPRESENTANTE" FROM cliente WHERE codigo_empleado_rep_ventas IS NULL;

--11
SELECT c.codigo_cliente AS "C�DIGO CLIENTE", c.nombre_cliente AS "NOMBRE CLIENTE", MIN(p.fecha_pago) AS "PRIMER PAGO", MAX(p.fecha_pago) AS "�LTIMO PAGO"
    FROM cliente c, pago p WHERE c.codigo_cliente=p.codigo_cliente GROUP BY c.codigo_cliente, c.nombre_cliente;
    
--12
SELECT dt.codigo_pedido AS "C�DIGO PEDIDO", COUNT(DISTINCT dt.codigo_producto) AS "N� PRODUCTOS"
    FROM detalle_pedido dt GROUP BY dt.codigo_pedido;
    
--13
SELECT dt.codigo_pedido AS "C�DIGO PEDIDO", SUM(dt.cantidad) AS "N� PRODUCTOS"
    FROM detalle_pedido dt GROUP BY dt.codigo_pedido;

--14
SELECT p.* FROM (
    SELECT dt.codigo_producto AS "C�DIGO PRODUCTO", SUM(dt.cantidad) AS "N� PRODUCTOS"
    FROM detalle_pedido dt GROUP BY dt.codigo_producto ORDER BY "N� PRODUCTOS" DESC) p
    WHERE ROWNUM<=20;
    
--15
SELECT TO_CHAR(SUM(dp.cantidad*dp.precio_unidad),'999G999D99L') AS "BASE IMPONIBLE", TO_CHAR(SUM(dp.cantidad*dp.precio_unidad*0.21),'999G999D99L') AS "IVA", TO_CHAR(SUM((dp.cantidad*dp.precio_unidad)+(dp.cantidad*dp.precio_unidad*0.21)),'999G999D99L') AS "TOTAL"
    FROM detalle_pedido dp;

--16
SELECT dp.codigo_producto AS "C�DIGO PRODUCTO", TO_CHAR(SUM(dp.cantidad*dp.precio_unidad),'999G999D99L') AS "BASE IMPONIBLE", TO_CHAR(SUM(dp.cantidad*dp.precio_unidad*0.21),'999G999D99L') AS "IVA", TO_CHAR(SUM((dp.cantidad*dp.precio_unidad)+(dp.cantidad*dp.precio_unidad*0.21)),'999G999D99L') AS "TOTAL"
    FROM detalle_pedido dp GROUP BY dp.codigo_producto;

--17
SELECT dp.codigo_producto AS "C�DIGO PRODUCTO", TO_CHAR(SUM(dp.cantidad*dp.precio_unidad),'999G999D99L') AS "BASE IMPONIBLE", TO_CHAR(SUM(dp.cantidad*dp.precio_unidad*0.21),'999G999D99L') AS "IVA", TO_CHAR(SUM((dp.cantidad*dp.precio_unidad)+(dp.cantidad*dp.precio_unidad*0.21)),'999G999D99L') AS "TOTAL"
    FROM detalle_pedido dp GROUP BY dp.codigo_producto HAVING dp.codigo_producto LIKE 'OR%';
    
--18
SELECT dp.codigo_producto AS "C�DIGO PRODUCTO", SUM(dp.cantidad) AS "CANTIDAD VENDIDA", TO_CHAR(SUM(dp.cantidad*dp.precio_unidad),'999G999D99L') AS "BASE IMPONIBLE", TO_CHAR(SUM((dp.cantidad*dp.precio_unidad)+(dp.cantidad*dp.precio_unidad*0.21)),'999G999D99L') AS "TOTAL"
    FROM detalle_pedido dp GROUP BY dp.codigo_producto HAVING SUM(dp.cantidad*dp.precio_unidad)>3000;
    
--SUBCONSULTAS
--1
SELECT c.nombre_cliente AS "CLIENTE CON CREDITO M�XIMO" FROM cliente c
    WHERE c.limite_credito=(SELECT MAX(limite_credito) FROM cliente);

--2
SELECT e.nombre || ' ' || e.apellido1 AS "EMPLEADO", e.puesto AS "CARGO"
    FROM empleado e
    WHERE e.codigo_empleado NOT IN (SELECT DISTINCT codigo_empleado_rep_ventas FROM cliente);

--3
SELECT p.nombre AS "PRODUCTO" FROM producto p
    WHERE p.precio_venta=(SELECT MAX(precio_venta) FROM producto);

--4
SELECT lp.* 
    FROM (SELECT p.nombre AS "PRODUCTO" 
        FROM producto p, detalle_pedido dp 
        WHERE p.codigo_producto=dp.codigo_producto 
        GROUP BY dp.codigo_producto,p.nombre 
        ORDER BY SUM(dp.cantidad) DESC) lp
    WHERE ROWNUM=1;

--5
SELECT c.nombre_cliente AS "CLIENTE"
    FROM cliente c
    WHERE c.limite_credito>(SELECT SUM(p.total) FROM pago p WHERE p.codigo_cliente=c.codigo_cliente);

--6
SELECT p.nombre AS "PRODUCTO"
    FROM producto p
    WHERE p.cantidad_en_stock=(SELECT MAX(cantidad_en_stock) FROM producto)
        OR p.cantidad_en_stock=(SELECT MIN(cantidad_en_stock) FROM producto);

--7
SELECT e.nombre || ' ' || e.apellido1 || ' ' || e.apellido2 AS "EMPLEADO", e.email "EMAIL" 
    FROM empleado e
    WHERE e.codigo_jefe=(SELECT j.codigo_empleado FROM empleado j WHERE UPPER(j.nombre) LIKE '%ALBERTO%' AND UPPER(j.apellido1) LIKE '%SORIA%');
    

--CONSULTAS VARIADAS
--1
SELECT c.nombre_cliente AS "CLIENTE", NVL(SUM(p.codigo_pedido),0) AS "N� PEDIDOS"
    FROM cliente c, pedido p
    WHERE c.codigo_cliente=p.codigo_cliente(+)
    GROUP BY c.nombre_cliente;

--2
SELECT c.nombre_cliente AS "CLIENTE", TO_CHAR(NVL(SUM(p.total),0),'999G990D99L') AS "TOTAL PAGADO"
    FROM cliente c, pago p
    WHERE c.codigo_cliente=p.codigo_cliente(+)
    GROUP BY c.nombre_cliente;

--3
SELECT DISTINCT c.nombre_cliente AS "CLIENTE" FROM cliente c, pedido p
    WHERE TO_CHAR(p.fecha_pedido,'YYYY')='2008'
        AND c.codigo_cliente=p.codigo_cliente
    ORDER BY c.nombre_cliente;

--4
SELECT c.nombre_cliente AS "CLIENTE", e.nombre || ' ' || e.apellido1 AS "REPRESENTANTE VENTAS", o.telefono AS "TEL�FONO OFICINA"
    FROM empleado e, cliente c, oficina o, pago p
    WHERE c.codigo_empleado_rep_ventas=e.codigo_empleado AND e.codigo_oficina=o.codigo_oficina
        AND c.codigo_cliente=p.codigo_cliente(+) AND p.codigo_cliente IS NULL;

--5
SELECT c.nombre_cliente AS "CLIENTE", e.nombre || ' ' || e.apellido1 AS "REPRESENTANTE VENTAS", o.ciudad AS "CIUDAD OFICINA"
    FROM empleado e, cliente c, oficina o
    WHERE c.codigo_empleado_rep_ventas=e.codigo_empleado AND e.codigo_oficina=o.codigo_oficina;

--6
SELECT e.nombre || ' ' || e.apellido1 AS "EMPLEADO", e.puesto AS "PUESTO", o.telefono AS "TEL�FONO OFICINA"
    FROM empleado e, cliente c, oficina o
    WHERE e.codigo_oficina=o.codigo_oficina
        AND e.codigo_empleado=c.codigo_empleado_rep_ventas(+) AND c.codigo_empleado_rep_ventas IS NULL;

--7
SELECT o.ciudad AS "CIUDAD", COUNT(e.codigo_empleado) AS "N� EMPLEADOS"
    FROM oficina o, empleado e
    WHERE o.codigo_oficina=e.codigo_oficina
    GROUP BY o.ciudad;

    
