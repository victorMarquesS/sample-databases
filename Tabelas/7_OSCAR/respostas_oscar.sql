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

