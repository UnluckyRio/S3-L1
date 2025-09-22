-- =====================================================
-- DATABASE RELAZIONALE - STRUTTURA E QUERY
-- =====================================================

-- Creazione del database
CREATE DATABASE IF NOT EXISTS esercizio_s3_l1;
USE esercizio_s3_l1;

-- =====================================================
-- CREAZIONE TABELLE
-- =====================================================

-- Tabella clienti
CREATE TABLE clienti (
    numero_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    anno_di_nascita INT NOT NULL,
    regione_residenza VARCHAR(50) NOT NULL
);

-- Tabella prodotti
CREATE TABLE prodotti (
    id_prodotto INT PRIMARY KEY AUTO_INCREMENT,
    descrizione VARCHAR(255) NOT NULL,
    in_produzione BOOLEAN NOT NULL DEFAULT FALSE,
    in_commercio BOOLEAN NOT NULL DEFAULT FALSE,
    data_attivazione DATE,
    data_disattivazione DATE
);

-- Tabella fornitori
CREATE TABLE fornitori (
    numero_fornitore INT PRIMARY KEY AUTO_INCREMENT,
    denominazione VARCHAR(100) NOT NULL,
    regione_residenza VARCHAR(50) NOT NULL
);

-- Tabella fatture
CREATE TABLE fatture (
    numero_fattura INT PRIMARY KEY AUTO_INCREMENT,
    tipologia CHAR(1) NOT NULL,
    importo DECIMAL(10,2) NOT NULL,
    iva DECIMAL(5,2) NOT NULL,
    numero_cliente_cliente INT NOT NULL,
    data_fattura DATE NOT NULL,
    numero_fornitore INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clienti(numero_cliente),
    FOREIGN KEY (numero_fornitore) REFERENCES fornitori(numero_fornitore)
);

-- =====================================================
-- INSERIMENTO DATI DI ESEMPIO
-- =====================================================

-- Inserimento clienti
INSERT INTO clienti (nome, cognome, anno_di_nascita, regione_residenza) VALUES
('Mario', 'Rossi', 1982, 'Lombardia'),
('Luigi', 'Verdi', 1975, 'Veneto'),
('Mario', 'Bianchi', 1980, 'Lazio'),
('Anna', 'Neri', 1982, 'Toscana'),
('Giuseppe', 'Gialli', 1990, 'Sicilia'),
('Mario', 'Ferrari', 1985, 'Emilia-Romagna'),
('Francesca', 'Blu', 1980, 'Piemonte'),
('Roberto', 'Viola', 1978, 'Campania');

-- Inserimento fornitori
INSERT INTO fornitori (denominazione, regione_residenza) VALUES
('Fornitore Alpha S.r.l.', 'Lombardia'),
('Beta Supplies', 'Veneto'),
('Gamma Corporation', 'Lazio'),
('Delta Industries', 'Toscana'),
('Epsilon Trading', 'Sicilia');

-- Inserimento prodotti
INSERT INTO prodotti (descrizione, in_produzione, in_commercio, data_attivazione, data_disattivazione) VALUES
('Prodotto A', TRUE, TRUE, '2017-03-15', NULL),
('Prodotto B', FALSE, TRUE, '2016-08-20', '2020-12-31'),
('Prodotto C', TRUE, FALSE, '2017-11-10', NULL),
('Prodotto D', TRUE, TRUE, '2018-01-05', NULL),
('Prodotto E', FALSE, FALSE, '2017-07-22', '2019-06-30'),
('Prodotto F', TRUE, TRUE, '2017-12-01', NULL);

-- Inserimento fatture
INSERT INTO fatture (tipologia, importo, iva, numero_cliente, data_fattura, numero_fornitore) VALUES
('A', 1500.00, 22.00, 1, '2023-01-15', 1),
('B', 750.50, 20.00, 2, '2023-02-20', 2),
('A', 2200.00, 22.00, 3, '2023-03-10', 1),
('A', 450.75, 20.00, 1, '2023-04-05', 3),
('B', 1800.00, 22.00, 4, '2023-05-12', 2),
('A', 320.00, 20.00, 5, '2023-06-18', 4),
('A', 950.25, 20.00, 2, '2023-07-22', 1),
('B', 1200.00, 22.00, 6, '2023-08-30', 5),
('A', 680.50, 20.00, 7, '2023-09-14', 3),
('A', 1750.00, 20.00, 8, '2023-10-25', 2),
('B', 890.00, 20.00, 3, '2022-11-15', 1),
('A', 1100.00, 22.00, 1, '2022-12-20', 4),
('A', 520.75, 20.00, 4, '2022-08-10', 2),
('B', 1350.00, 20.00, 5, '2022-09-25', 3),
('A', 780.00, 20.00, 6, '2021-05-18', 1),
('A', 2100.00, 22.00, 7, '2021-07-30', 5),
('B', 65.00, 20.00, 8, '2021-10-12', 2);

-- =====================================================
-- QUERY RICHIESTE
-- =====================================================

-- 1. Selezionare tutti i clienti con nome 'Mario'
SELECT * FROM clienti WHERE nome = 'Mario';

-- 2. Estrazione di nome e cognome dei clienti nati nel 1982
SELECT nome, cognome FROM clienti WHERE anno_di_nascita = 1982;

-- 3. Contare le fatture con IVA al 20%
SELECT COUNT(*) AS numero_fatture_iva_20 FROM fatture WHERE iva = 20.00;

-- 4. Selezionare i prodotti attivati nel 2017 che sono in produzione o in commercio
SELECT * FROM prodotti 
WHERE EXTRACT(YEAR FROM data_attivazione) = 2017 
AND (in_produzione = TRUE OR in_commercio = TRUE);

-- 5. Estrazione delle fatture con importo < 1000€ e relativi dati dei clienti associati
SELECT f.*, c.nome, c.cognome, c.anno_di_nascita, c.regione_residenza
FROM fatture f
JOIN clienti c ON f.numero_cliente_cliente = c.numero_cliente
WHERE f.importo < 1000.00;

-- 6. Elenco fatture (numero, importo, iva, data) con denominazione del fornitore
SELECT f.numero_fattura, f.importo, f.iva, f.data_fattura, fo.denominazione
FROM fatture f
JOIN fornitori fo ON f.numero_fornitore = fo.numero_fornitore;

-- 7. Conteggio fatture con IVA 20% raggruppate per anno
SELECT EXTRACT(YEAR FROM data_fattura) AS anno, COUNT(*) AS numero_fatture
FROM fatture 
WHERE iva = 20.00
GROUP BY EXTRACT(YEAR FROM data_fattura)
ORDER BY anno;

-- 8. Numero di fatture e somma importi raggruppati per anno di fatturazione
SELECT 
    EXTRACT(YEAR FROM data_fattura) AS anno,
    COUNT(*) AS numero_fatture,
    SUM(importo) AS somma_importi
FROM fatture
GROUP BY EXTRACT(YEAR FROM data_fattura)
ORDER BY anno;

-- 9. Estrazione degli anni con più di 2 fatture di tipo 'A'
SELECT EXTRACT(YEAR FROM data_fattura) AS anno, COUNT(*) AS numero_fatture_tipo_A
FROM fatture
WHERE tipologia = 'A'
GROUP BY EXTRACT(YEAR FROM data_fattura)
HAVING COUNT(*) > 2
ORDER BY anno;

-- 10. Totale importi fatture raggruppati per regione di residenza dei clienti
SELECT c.regione_residenza, SUM(f.importo) AS totale_importi
FROM fatture f
JOIN clienti c ON f.numero_cliente = c.numero_cliente
GROUP BY c.regione_residenza
ORDER BY totale_importi DESC;

-- 11. Conteggio clienti nati nel 1980 con almeno una fattura > 50€
SELECT COUNT(DISTINCT c.numero_cliente) AS clienti_1980_con_fatture_over_50
FROM clienti c
JOIN fatture f ON c.numero_cliente = f.numero_cliente_cliente
WHERE c.anno_di_nascita = 1980 AND f.importo > 50.00;