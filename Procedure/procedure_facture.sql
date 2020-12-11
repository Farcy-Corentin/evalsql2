DELIMITER $$
DROP PROCEDURE IF EXISTS Facture $$
CREATE PROCEDURE Facture(IN p_ord_id INT) 
BEGIN
-- Affichage client 
SELECT c.cus_id as client, CONCAT(c.cus_lastname as 'nom'," ", c.cus_firstname as 'prénom'), c.cus_address as 'adresse', c.cus_zipcode as 'code postal', c.cus_city as 'ville', c.cus_mail as 'email', c.cus_phone as 'téléphone'
FROM orders o
    JOIN customers c on c.cus_id = o.ord_cus_id
where o.ord_id=p_ord_id);
-- Affichage facture
SELECT o.ord_id as 'numéro de facture', o.ord_order_date as 'date de commande', o.ord_payment_date as 'date de payement', o.ord_ship_date "date d'envoi", o.ord_status as 'statut de la commande',
sum(ode.ode_unit_price*ode.ode_quantity) as 'total commande HT', sum(0.2*ode.ode_unit_price*ode.ode_quantity) as 'TVA', sum(ode.ode_unit_price*ode.ode_quantity*(1-ode.ode_discount/100)*1.2) as 'Total commande TTC'
FROM orders o
    JOIN orders_details ode on o.ord_id = ode.ode_ord_id
where o.ord_id=p_ord_id;
-- Affichage PTTC
SELECT SUM(ode_unit_price-ode_unit_price*ode_discount/100-(ode_unit_price-ode_unit_price*ode_discount/100)*1.20) AS 'TVA', SUM(ode_unit_price/100*ode_discount) AS 'Remise', SUM(ode_unit_price*ode_quantity - ode_unit_price/100*ode_discount)*1.2 AS 'PTTC' FROM orders_details WHERE ode_ord_id = p_ord_id GROUP BY ode_ord_id
END $$
DELIMITER ;
CALL Facture(53);