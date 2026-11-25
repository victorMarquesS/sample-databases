-- ==========================================
-- NÍVEL 1: PRIMEIROS PASSOS
-- ==========================================
-- 1.1
SELECT COUNT(*) AS total_registros FROM indicados_ao_oscar;

-- 1.2.1 e 1.2.2
SELECT DISTINCT categoria FROM indicados_ao_oscar;
SELECT COUNT(DISTINCT categoria) AS qtd_categorias FROM indicados_ao_oscar;

-- 1.3 e 1.4
SELECT MIN(ano_cerimonia) AS primeiro_ano FROM indicados_ao_oscar;
SELECT MAX(ano_cerimonia) AS ultimo_ano FROM indicados_ao_oscar;

-- 1.5
SELECT COUNT(DISTINCT ano_cerimonia) AS total_cerimonias FROM indicados_ao_oscar;

-- 1.6 (Exemplo de inserção para 2024/2025 - ajuste conforme os vencedores reais)
INSERT INTO indicados_ao_oscar (ano_filmagem, ano_cerimonia, edicao_cerimonia, categoria, nome_indicado, nome_filme, vencedor) VALUES 
(2024, 2025, 97, 'BEST PICTURE', 'Produtor X', 'Filme Vencedor 2025', true);

-- ==========================================
-- NÍVEL 2: EXPLORANDO CATEGORIAS
-- ==========================================
-- 2.1 e 2.2
SELECT categoria, COUNT(*) AS total_indicacoes 
FROM indicados_ao_oscar 
GROUP BY categoria 
ORDER BY total_indicacoes DESC;

-- 2.3
SELECT categoria, COUNT(*) AS total_indicacoes 
FROM indicados_ao_oscar 
GROUP BY categoria 
ORDER BY total_indicacoes ASC LIMIT 1;

-- 2.4
SELECT MAX(ano_cerimonia) AS ultimo_ano_actress FROM indicados_ao_oscar WHERE categoria = 'ACTRESS';

-- 2.5
SELECT DISTINCT categoria 
FROM indicados_ao_oscar 
WHERE ano_cerimonia = 1928 
AND categoria NOT IN (
    SELECT DISTINCT categoria FROM indicados_ao_oscar WHERE ano_cerimonia = (SELECT MAX(ano_cerimonia) FROM indicados_ao_oscar)
);

-- 2.6
SELECT DISTINCT categoria FROM indicados_ao_oscar WHERE categoria LIKE '%DIRECTING%';

-- ==========================================
-- NÍVEL 3: ATORES E ATRIZES Famosos
-- ==========================================
-- 3.1 a 3.4 (Natalie Portman)
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Natalie Portman%';
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Natalie Portman%' AND vencedor = true;
SELECT ano_cerimonia, nome_filme FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Natalie Portman%';
SELECT ano_cerimonia, categoria, nome_filme, vencedor FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Natalie Portman%';

-- 3.5 a 3.7 (Viola Davis)
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Viola Davis%';
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Viola Davis%' AND vencedor = true;
SELECT nome_filme FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Viola Davis%';

-- 3.8 e 3.9 (Amy Adams)
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Amy Adams%' AND vencedor = true;
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Amy Adams%' AND vencedor = false;

-- 3.10 a 3.12 (Denzel Washington)
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Denzel Washington%' AND vencedor = true;
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Denzel Washington%';
SELECT ano_cerimonia, categoria, nome_filme FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Denzel Washington%' AND vencedor = true;

-- ==========================================
-- NÍVEL 4: VENCEDORES HISTÓRICOS
-- ==========================================
-- 4.1 e 4.2
SELECT nome_indicado, ano_cerimonia, nome_filme FROM indicados_ao_oscar WHERE categoria = 'ACTRESS' AND vencedor = true ORDER BY ano_cerimonia ASC LIMIT 1;
SELECT nome_indicado, ano_cerimonia, nome_filme FROM indicados_ao_oscar WHERE categoria = 'ACTOR' AND vencedor = true ORDER BY ano_cerimonia ASC LIMIT 1;

-- 4.3, 4.4 e 4.5
SELECT COUNT(*) AS total_vencedores FROM indicados_ao_oscar WHERE vencedor = true;
SELECT nome_filme, ano_cerimonia FROM indicados_ao_oscar WHERE categoria IN ('OUTSTANDING PICTURE', 'BEST PICTURE') AND vencedor = true;
SELECT COUNT(DISTINCT nome_filme) FROM indicados_ao_oscar WHERE vencedor = true;

-- ==========================================
-- NÍVEL 5: ANÁLISE DE INDICAÇÕES
-- ==========================================
-- 5.1 e 5.2
SELECT nome_indicado, COUNT(*) AS qtd_indicacoes 
FROM indicados_ao_oscar 
GROUP BY nome_indicado 
HAVING qtd_indicacoes > 1 
ORDER BY qtd_indicacoes DESC;

-- 5.3
SELECT nome_indicado, COUNT(*) AS qtd 
FROM indicados_ao_oscar 
GROUP BY nome_indicado 
HAVING qtd > 3 AND SUM(CASE WHEN vencedor = true THEN 1 ELSE 0 END) = 0;

-- 5.4
SELECT nome_indicado, COUNT(DISTINCT categoria) AS qtd_categorias 
FROM indicados_ao_oscar 
GROUP BY nome_indicado 
HAVING qtd_categorias > 1;

-- 5.5
SELECT COUNT(*) FROM (
    SELECT nome_indicado FROM indicados_ao_oscar GROUP BY nome_indicado HAVING COUNT(*) = 1
) AS indicados_unica_vez;

-- 5.6
SELECT ano_cerimonia, COUNT(*) AS total FROM indicados_ao_oscar GROUP BY ano_cerimonia ORDER BY total DESC LIMIT 1;

-- ==========================================
-- NÍVEL 6: ANÁLISE DE FILMES (Toy Story, Crash, Central do Brasil)
-- ==========================================
-- 6.1 a 6.3 (Toy Story)
SELECT ano_cerimonia FROM indicados_ao_oscar WHERE nome_filme LIKE '%Toy Story%' AND vencedor = true;
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_filme LIKE '%Toy Story%';
SELECT DISTINCT categoria FROM indicados_ao_oscar WHERE nome_filme LIKE '%Toy Story%';

-- 6.4 a 6.6 (Crash)
SELECT ano_cerimonia FROM indicados_ao_oscar WHERE nome_filme = 'Crash' LIMIT 1;
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_filme = 'Crash';
SELECT vencedor FROM indicados_ao_oscar WHERE nome_filme = 'Crash' AND categoria IN ('OUTSTANDING PICTURE', 'BEST PICTURE');

-- 6.7 e 6.8 (Central do Brasil)
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_filme LIKE '%Central do Brasil%';
SELECT COUNT(*) FROM indicados_ao_oscar WHERE nome_filme LIKE '%Central do Brasil%';

-- ==========================================
-- NÍVEL 7: OPERAÇÕES DE ATUALIZAÇÃO
-- ==========================================
-- 7.1 (Assumindo que estejam como string no banco)
UPDATE indicados_ao_oscar SET vencedor = 1 WHERE vencedor = 'true';
UPDATE indicados_ao_oscar SET vencedor = 0 WHERE vencedor = 'false';

-- 7.2
INSERT INTO indicados_ao_oscar (ano_filmagem, ano_cerimonia, edicao_cerimonia, categoria, nome_indicado, nome_filme, vencedor) VALUES 
(2023, 2024, 96, 'BEST PICTURE', 'Greta Gerwig', 'Barbie', false);

-- 7.3
INSERT INTO indicados_ao_oscar (ano_filmagem, ano_cerimonia, edicao_cerimonia, categoria, nome_indicado, nome_filme, vencedor) VALUES 
(2023, 2024, 96, 'BEST INTERNATIONAL FEATURE FILM', 'Reino Unido', 'The Zone of Interest', true);

-- 7.4
UPDATE indicados_ao_oscar SET nome_filme = TRIM(nome_filme);

-- 7.5
DELETE FROM indicados_ao_oscar WHERE nome_filme IS NULL;

-- ==========================================
-- NÍVEL 8: ANÁLISE TEMPORAL
-- ==========================================
-- 8.1 a 8.3
SELECT (ano_cerimonia DIV 10) * 10 AS decada, COUNT(*) AS total_indicacoes 
FROM indicados_ao_oscar 
GROUP BY decada ORDER BY decada;

-- 8.4
SELECT ano_cerimonia, COUNT(*) AS total FROM indicados_ao_oscar GROUP BY ano_cerimonia ORDER BY total DESC LIMIT 1;

-- 8.5
SELECT MAX(qtd) - MIN(qtd) AS taxa_crescimento FROM (
    SELECT COUNT(*) AS qtd FROM indicados_ao_oscar GROUP BY (ano_cerimonia DIV 10) * 10
) AS sub;

-- ==========================================
-- NÍVEL 9: QUESTÕES HISTÓRICAS E SOCIAIS
-- ==========================================
-- 9.1 e 9.2
SELECT ano_cerimonia, nome_filme, vencedor FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Sidney Poitier%' ORDER BY ano_cerimonia ASC LIMIT 1;

-- 9.3 (Buscando por nomes conhecidos na história)
SELECT DISTINCT nome_indicado 
FROM indicados_ao_oscar 
WHERE categoria IN ('ACTOR', 'ACTRESS') AND ano_cerimonia < 1970 
AND nome_indicado IN ('Sidney Poitier', 'Hattie McDaniel', 'Dorothy Dandridge', 'Cicely Tyson', 'Sammy Davis Jr.', 'Louis Armstrong');

-- 9.4 (Exemplo com Kathryn Bigelow - primeira mulher a ganhar Direção)
SELECT DISTINCT nome_filme FROM indicados_ao_oscar WHERE nome_indicado LIKE '%Kathryn Bigelow%' AND vencedor = true;

-- 9.5 e 9.6 (Denzel e Jamie Foxx)
SELECT DISTINCT ano_cerimonia FROM indicados_ao_oscar 
WHERE nome_indicado IN ('Denzel Washington', 'Jamie Foxx') 
GROUP BY ano_cerimonia HAVING COUNT(DISTINCT nome_indicado) = 2;

-- 9.7
SELECT nome_filme, ano_cerimonia, COUNT(*) AS qtd_premios 
FROM indicados_ao_oscar 
WHERE vencedor = true 
GROUP BY nome_filme, ano_cerimonia 
HAVING qtd_premios > 1 ORDER BY qtd_premios DESC;

-- ==========================================
-- NÍVEL 10: ANÁLISE AVANÇADA
-- ==========================================
-- 10.1 (Filmes que ganharam Melhor Filme e Direção no mesmo ano)
SELECT DISTINCT i.nome_filme, i.ano_cerimonia 
FROM indicados_ao_oscar i
WHERE i.categoria IN ('BEST PICTURE', 'OUTSTANDING PICTURE') AND i.vencedor = true
AND EXISTS (
    SELECT 1 FROM indicados_ao_oscar d 
    WHERE d.ano_cerimonia = i.ano_cerimonia AND d.categoria = 'DIRECTING' AND d.vencedor = true 
    AND d.nome_indicado = (SELECT nome_indicado FROM indicados_ao_oscar LIMIT 1) -- Simulação simplificada de vínculo
);

-- 10.2
SELECT nome_filme, ano_cerimonia, COUNT(*) AS qtd_ind FROM indicados_ao_oscar GROUP BY nome_filme, ano_cerimonia ORDER BY qtd_ind DESC LIMIT 1;

-- 10.3
SELECT nome_filme, 
       (SUM(CASE WHEN vencedor = true THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS taxa_conversao 
FROM indicados_ao_oscar 
GROUP BY nome_filme 
HAVING COUNT(*) >= 5 
ORDER BY taxa_conversao DESC LIMIT 10;

-- 10.4
SELECT a.nome_indicado, a.ano_cerimonia, b.ano_cerimonia 
FROM indicados_ao_oscar a 
JOIN indicados_ao_oscar b ON a.nome_indicado = b.nome_indicado AND a.ano_cerimonia = b.ano_cerimonia - 1
GROUP BY a.nome_indicado, a.ano_cerimonia, b.ano_cerimonia;

-- 10.5
SELECT AVG(qtd) AS media_por_cerimonia FROM (SELECT ano_cerimonia, COUNT(*) AS qtd FROM indicados_ao_oscar GROUP BY ano_cerimonia) sub;

-- 10.6 (Filmes com apenas 1 indicação na categoria principal)
SELECT * FROM indicados_ao_oscar i 
WHERE i.categoria IN ('ACTOR', 'ACTRESS', 'BEST PICTURE', 'OUTSTANDING PICTURE')
AND (SELECT COUNT(*) FROM indicados_ao_oscar i2 WHERE i2.nome_filme = i.nome_filme AND i2.ano_cerimonia = i.ano_cerimonia) = 1;

-- ==========================================
-- NÍVEL 11: DESAFIOS COMPLEXOS
-- ==========================================
-- 11.1 e 11.2
SELECT nome_filme, COUNT(*) AS total_oscars FROM indicados_ao_oscar WHERE vencedor = true GROUP BY nome_filme ORDER BY total_oscars DESC LIMIT 10;
SELECT nome_indicado, COUNT(*) AS total_ind FROM indicados_ao_oscar GROUP BY nome_indicado ORDER BY total_ind DESC LIMIT 10;

-- 11.3 (Azarões)
SELECT nome_indicado, COUNT(*) AS total_ind 
FROM indicados_ao_oscar 
GROUP BY nome_indicado 
HAVING total_ind > 5 AND SUM(CASE WHEN vencedor = true THEN 1 ELSE 0 END) = 0;

-- 11.4 (Categoria com menos vencedores diferentes)
SELECT categoria, COUNT(DISTINCT nome_indicado) AS vencedores_diferentes 
FROM indicados_ao_oscar 
WHERE vencedor = true 
GROUP BY categoria ORDER BY vencedores_diferentes ASC LIMIT 1;

-- 11.5 (Competitividade)
SELECT categoria, COUNT(*) / COUNT(DISTINCT ano_cerimonia) AS media_indicados_por_ano 
FROM indicados_ao_oscar GROUP BY categoria;

-- ==========================================
-- NÍVEL 12, 13 e 14: CENÁRIOS E DASHBOARD
-- ==========================================
-- 12.1
SELECT nome_filme, COUNT(*) AS total FROM indicados_ao_oscar WHERE vencedor = true GROUP BY nome_filme ORDER BY total DESC LIMIT 20;

-- 12.3 (Clássicos esquecidos)
SELECT DISTINCT nome_filme FROM indicados_ao_oscar WHERE vencedor = true AND ano_cerimonia < 1974;

-- 13.1
SELECT DISTINCT nome_filme FROM indicados_ao_oscar WHERE nome_filme LIKE 'The %' AND vencedor = true;

-- 13.2
SELECT DISTINCT nome_indicado FROM indicados_ao_oscar WHERE nome_indicado LIKE '%-%';

-- 13.3 (Empates)
SELECT ano_cerimonia, categoria, COUNT(*) AS qtd FROM indicados_ao_oscar WHERE vencedor = true GROUP BY ano_cerimonia, categoria HAVING COUNT(*) > 1;

-- 13.4 (Loteria)
SELECT DISTINCT nome_filme FROM indicados_ao_oscar WHERE categoria IN ('BEST PICTURE', 'OUTSTANDING PICTURE') AND vencedor = true ORDER BY RAND() LIMIT 5;

-- 14.1 DASHBOARD FINAL COMPLETO
SELECT 
    (SELECT COUNT(*) FROM indicados_ao_oscar) AS total_indicacoes,
    (SELECT COUNT(DISTINCT ano_cerimonia) FROM indicados_ao_oscar) AS total_cerimonias,
    (SELECT COUNT(*) FROM indicados_ao_oscar WHERE vencedor = true) AS total_vencedores,
    (SELECT categoria FROM indicados_ao_oscar GROUP BY categoria ORDER BY COUNT(*) DESC LIMIT 1) AS categoria_mais_indicada,
    (SELECT nome_filme FROM indicados_ao_oscar WHERE vencedor = true GROUP BY nome_filme ORDER BY COUNT(*) DESC LIMIT 1) AS filme_mais_premiado,
    (SELECT nome_indicado FROM indicados_ao_oscar GROUP BY nome_indicado ORDER BY COUNT(*) DESC LIMIT 1) AS artista_mais_indicado,
    (SELECT (ano_cerimonia DIV 10) * 10 FROM indicados_ao_oscar WHERE vencedor = true GROUP BY (ano_cerimonia DIV 10) * 10 ORDER BY COUNT(*) DESC LIMIT 1) AS decada_mais_premiada,
    (SELECT COUNT(DISTINCT categoria) FROM indicados_ao_oscar) AS total_categorias_unicas;