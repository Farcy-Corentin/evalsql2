DELIMITER $$

CREATE TRIGGER after_products_update
AFTER UPDATE 
ON products FOR EACH ROW

BEGIN
	-- par default l'alerte est 5
	DECLARE pro_stock_alert INT;
	SET pro_stock_alert = 5;
	-- si la nouvelle valeur de pro_stock est différente a l'ancienne valeur
	-- est que la nouvelle valeur, sois inférieur ou égal a 5
  	IF (NEW.pro_stock != OLD.pro_stock) AND (NEW.pro_stock <= pro_stock_alert) THEN
		INSERT INTO commander_articles (codart, qte, date_du_jour) 
		VALUES (OLD.pro_id, NEW.pro_stock, NOW());
  	END IF;
	-- On veux supprimer la ligne dans commander_article si le pro_stock devient > à 5
	IF(NEW.pro_stock != OLD.pro_stock) AND (NEW.pro_stock > 5)
		DELETE FROM commander_articles WHERE OLD.pro_id = pro_id AND NEW.pro_stock > '5'
	END IF;
END $$
 
DELIMITER ;