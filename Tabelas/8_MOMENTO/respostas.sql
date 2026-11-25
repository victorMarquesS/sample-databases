-- ==========================================
-- NÍVEL 1: CONHECENDO A EMPRESA
-- ==========================================
-- 1.1 Inserindo você (ID 300, Depto 6 - TI, Cargo 9 - Dev Web)
INSERT INTO funcionarios (funcionario_id, primeiro_nome, sobrenome, email, data_contratacao, cargo_id, salario, departamento_id, status_funcionario_id)
VALUES (300, 'Seu', 'Nome', 'seu.nome@momento.org', CURDATE(), 9, 6000.00, 6, 1);

-- 1.2 Total de funcionários
SELECT COUNT(*) AS total_funcionarios FROM funcionarios;

-- 1.3 Funcionários no Departamento de Tecnologia (ID 6)
SELECT COUNT(*) AS total_ti FROM funcionarios WHERE departamento_id = 6;

-- 1.4 Departamentos e quantos são
SELECT departamento_nome FROM departamentos;
SELECT COUNT(*) AS qtd_departamentos FROM departamentos;

-- 1.5 Escritórios e países
SELECT e.escritorio_nome, p.pais_nome 
FROM escritorios e
JOIN paises p ON e.pais_id = p.pais_id;

-- ==========================================
-- NÍVEL 2: ANÁLISE FINANCEIRA BÁSICA
-- ==========================================
-- 2.1 e 2.2 Vendas: Funcionários e Custo Total (Depto Vendas = 8)
SELECT COUNT(*) AS qtd_funcionarios, SUM(salario) AS custo_total 
FROM funcionarios WHERE departamento_id = 8;

-- 2.3 Média salarial excluindo CEO (4), CFO (7) e CMO (10)
SELECT AVG(salario) AS media_salarial 
FROM funcionarios 
WHERE cargo_id NOT IN (4, 7, 10);

-- 2.4 Média salarial de Tecnologia (ID 6)
SELECT AVG(salario) AS media_ti FROM funcionarios WHERE departamento_id = 6;

-- 2.5 Departamento com maior média salarial
SELECT d.departamento_nome, AVG(f.salario) AS media
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_nome
ORDER BY media DESC LIMIT 1;

-- 2.6 Departamento com menor número de funcionários
SELECT d.departamento_nome, COUNT(f.funcionario_id) AS qtd
FROM funcionarios f
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_nome
ORDER BY qtd ASC LIMIT 1;

-- ==========================================
-- NÍVEL 3: RECURSOS HUMANOS
-- ==========================================
-- 3.1 e 3.2 Dependentes (Cônjuges e Filhos)
SELECT COUNT(DISTINCT funcionario_id) AS com_conjuge FROM dependentes WHERE relacionamento = 'Cônjuge';
SELECT COUNT(DISTINCT funcionario_id) AS com_filhos FROM dependentes WHERE relacionamento = 'Filha(o)';

-- 3.3 e 3.4 Contratados há mais e menos tempo
SELECT primeiro_nome, sobrenome, data_contratacao FROM funcionarios ORDER BY data_contratacao ASC LIMIT 1;
SELECT primeiro_nome, sobrenome, data_contratacao FROM funcionarios ORDER BY data_contratacao DESC LIMIT 1;

-- 3.5 Top 5 com mais tempo de casa
SELECT primeiro_nome, sobrenome, data_contratacao FROM funcionarios ORDER BY data_contratacao ASC LIMIT 5;

-- 3.6 Contratados na década de 90
SELECT COUNT(*) AS qtd_anos_90 FROM funcionarios WHERE data_contratacao BETWEEN '1990-01-01' AND '1999-12-31';

-- 3.7 Evolução salarial por ano
SELECT YEAR(data_contratacao) AS ano, AVG(salario) AS media_salarial 
FROM funcionarios GROUP BY ano ORDER BY ano ASC;

-- ==========================================
-- NÍVEL 4: OPERAÇÕES E ESCRITÓRIOS
-- ==========================================
-- 4.1 Custo total de suprimentos por escritório
SELECT e.escritorio_nome, SUM(s.quantidade_estoque * s.custo_unitario) AS custo_total
FROM suprimentos s
JOIN escritorios e ON s.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_nome ORDER BY custo_total DESC;

-- 4.2 Escritório com maior variedade de suprimentos
SELECT e.escritorio_nome, COUNT(DISTINCT s.suprimento_nome) AS variedade
FROM suprimentos s
JOIN escritorios e ON s.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_nome ORDER BY variedade DESC LIMIT 1;

-- 4.3 e 4.4 Suprimento mais caro e Inventário total
SELECT suprimento_nome, custo_unitario FROM suprimentos ORDER BY custo_unitario DESC LIMIT 1;
SELECT SUM(quantidade_estoque * custo_unitario) AS valor_total_inventario FROM suprimentos;

-- ==========================================
-- NÍVEL 5: PRODUTOS E VENDAS
-- ==========================================
-- 5.1 Produtos únicos vendidos
SELECT DISTINCT p.produto_nome FROM produtos p JOIN itens_venda iv ON p.produto_id = iv.produto_id;

-- 5.2 e 5.3 Produto mais e menos vendido
SELECT p.produto_nome, SUM(iv.quantidade) AS qtd FROM produtos p JOIN itens_venda iv ON p.produto_id = iv.produto_id GROUP BY p.produto_nome ORDER BY qtd DESC LIMIT 1;
SELECT p.produto_nome, SUM(iv.quantidade) AS qtd FROM produtos p JOIN itens_venda iv ON p.produto_id = iv.produto_id GROUP BY p.produto_nome ORDER BY qtd ASC LIMIT 1;

-- 5.4 Produto que gerou mais receita
SELECT p.produto_nome, SUM(iv.quantidade * iv.preco_unitario) AS receita FROM produtos p JOIN itens_venda iv ON p.produto_id = iv.produto_id GROUP BY p.produto_nome ORDER BY receita DESC LIMIT 1;

-- 5.5 Produto mais caro e 5.6 Faturamento total
SELECT produto_nome, preco_catalogo FROM produtos ORDER BY preco_catalogo DESC LIMIT 1;
SELECT SUM(quantidade * preco_unitario) AS faturamento_total FROM itens_venda;

-- 5.7 Vendas em Junho/2023
SELECT COUNT(*) FROM vendas WHERE YEAR(data_venda) = 2023 AND MONTH(data_venda) = 6;

-- 5.8 e 5.9 Vendedor com mais vendas e mais receita
SELECT f.primeiro_nome, COUNT(v.venda_id) AS qtd_vendas FROM funcionarios f JOIN vendas v ON f.funcionario_id = v.funcionario_id GROUP BY f.primeiro_nome ORDER BY qtd_vendas DESC LIMIT 1;
SELECT f.primeiro_nome, SUM(iv.quantidade * iv.preco_unitario) AS receita FROM funcionarios f JOIN vendas v ON f.funcionario_id = v.funcionario_id JOIN itens_venda iv ON v.venda_id = iv.venda_id GROUP BY f.primeiro_nome ORDER BY receita DESC LIMIT 1;

-- ==========================================
-- NÍVEL 6: OPERAÇÕES DE ATUALIZAÇÃO
-- ==========================================
-- 6.1 Novo departamento no Wayne Offices (ID 1400)
INSERT INTO departamentos (departamento_id, departamento_nome, educacional, escritorio_id) VALUES (31, 'Inovações', 0, 1400);

-- 6.2 Transferir 2 funcionários de TI (6) para Inovações (31)
UPDATE funcionarios SET departamento_id = 31 WHERE departamento_id = 6 LIMIT 2;

-- 6.3 Aumento de 10% para quem ficou em TI
UPDATE funcionarios SET salario = salario * 1.10 WHERE departamento_id = 6;

-- 6.4 Promoção de Bruce Ernst (Cargo 26 - Senior Web Developer)
UPDATE funcionarios SET cargo_id = 26, salario = 5000.00 WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';

-- 6.5 Novo suprimento (ID 106) em Wayne Offices
INSERT INTO suprimentos (suprimento_id, referencia_compra, suprimento_nome, quantidade_estoque, custo_unitario, moeda, data_compra, escritorio_id) VALUES (106, 'PO-1400-08', 'Headsets', 15, 150.00, 'USD', CURDATE(), 1400);

-- 6.6 Aposentadoria (Update de status)
SELECT COUNT(*) FROM funcionarios WHERE data_contratacao < '1990-01-01';
UPDATE funcionarios SET status_funcionario_id = 3 WHERE data_contratacao < '1990-01-01';

-- ==========================================
-- NÍVEL 7: DA SALA DE AULA AO IMPACTO CORPORATIVO
-- ==========================================
-- 7.1 Cursos ativos, carga, nível e turmas abertas
SELECT c.curso_nome, c.carga_horaria, n.nome AS nivel, COUNT(t.turma_id) AS turmas
FROM cursos c JOIN niveis_curso n ON c.nivel_curso_id = n.nivel_curso_id
LEFT JOIN turmas t ON c.curso_id = t.curso_id
WHERE c.ativo = TRUE GROUP BY c.curso_id;

-- 7.2 Turmas com professores e matrículas
SELECT c.curso_nome, t.codigo, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS professor, t.capacidade, COUNT(m.matricula_id) AS matriculas
FROM turmas t JOIN cursos c ON t.curso_id = c.curso_id
JOIN funcionarios f ON t.professor_funcionario_id = f.funcionario_id
LEFT JOIN matriculas m ON t.turma_id = m.turma_id
GROUP BY t.turma_id;

-- 7.3 Bolsas concedidas
SELECT a.nome AS aluno, c.curso_nome, b.percentual_desconto 
FROM bolsas b JOIN alunos a ON b.aluno_id = a.aluno_id
JOIN cursos c ON b.curso_id = c.curso_id;

-- 7.4 Matrículas, concluintes, certificados e média por turma
SELECT c.curso_nome, t.codigo, 
  COUNT(m.matricula_id) AS matriculas,
  SUM(CASE WHEN m.status_matricula_id = 3 THEN 1 ELSE 0 END) AS concluintes,
  SUM(CASE WHEN m.certificado_emitido = TRUE THEN 1 ELSE 0 END) AS certificados,
  AVG(m.nota_final) AS media
FROM turmas t JOIN cursos c ON t.curso_id = c.curso_id
LEFT JOIN matriculas m ON t.turma_id = m.turma_id
GROUP BY t.turma_id;

-- 7.5 Trajetória de Ariel Nunes
SELECT 
    a.nome AS aluno, c.curso_nome, t.codigo AS turma, m.data_matricula, m.status_matricula_id,
    b.percentual_desconto AS bolsa, tv.nome AS tipo_vinculo, d.departamento_nome, f.primeiro_nome AS contratado_como
FROM alunos a
LEFT JOIN matriculas m ON a.aluno_id = m.aluno_id
LEFT JOIN turmas t ON m.turma_id = t.turma_id
LEFT JOIN cursos c ON t.curso_id = c.curso_id
LEFT JOIN bolsas b ON a.aluno_id = b.aluno_id AND c.curso_id = b.curso_id
LEFT JOIN vinculos_talentos v ON a.aluno_id = v.aluno_id
LEFT JOIN tipos_vinculo tv ON v.tipo_vinculo_id = tv.tipo_vinculo_id
LEFT JOIN departamentos d ON v.departamento_id = d.departamento_id
LEFT JOIN funcionarios f ON v.funcionario_id = f.funcionario_id
WHERE a.nome = 'Ariel Nunes';

-- 7.6 Vínculos de talentos
SELECT a.nome AS aluno, tv.nome AS tipo, d.departamento_nome, sv.nome AS status, f.primeiro_nome AS funcionario
FROM vinculos_talentos v JOIN alunos a ON v.aluno_id = a.aluno_id
JOIN tipos_vinculo tv ON v.tipo_vinculo_id = tv.tipo_vinculo_id
JOIN departamentos d ON v.departamento_id = d.departamento_id
JOIN status_vinculo sv ON v.status_vinculo_id = sv.status_vinculo_id
LEFT JOIN funcionarios f ON v.funcionario_id = f.funcionario_id;

-- 7.7 Departamentos que recebem talentos
SELECT DISTINCT d.departamento_nome FROM vinculos_talentos v JOIN departamentos d ON v.departamento_id = d.departamento_id;

-- 7.8 Query única com totais da escola
SELECT 
    (SELECT COUNT(*) FROM alunos) AS total_alunos,
    (SELECT COUNT(*) FROM matriculas WHERE status_matricula_id = 1) AS matriculas_ativas,
    (SELECT COUNT(*) FROM matriculas WHERE status_matricula_id = 3) AS concluintes,
    (SELECT COUNT(*) FROM bolsas) AS bolsas_concedidas,
    (SELECT COUNT(*) FROM vinculos_talentos WHERE tipo_vinculo_id = 1) AS estagios,
    (SELECT COUNT(*) FROM vinculos_talentos WHERE tipo_vinculo_id = 2) AS contratacoes,
    (SELECT GROUP_CONCAT(DISTINCT departamento_nome SEPARATOR ', ') FROM departamentos WHERE departamento_id IN (SELECT departamento_id FROM vinculos_talentos)) AS departamentos_receptores;

-- 7.11 (Texto): A tabela vinculos_talentos faz a ponte entre alunos formados e as oportunidades de trabalho na empresa, registrando se o vínculo é estágio ou contratação.

-- ==========================================
-- NÍVEL 8: DUAS FRENTES, DUAS OPERAÇÕES
-- ==========================================
-- 8.1 Custo da frente educacional vs comercial
SELECT 
    CASE WHEN d.educacional = 1 THEN 'Frente Educacional' ELSE 'Frente Comercial' END AS frente,
    COUNT(DISTINCT f.funcionario_id) AS qtd_funcionarios,
    SUM(DISTINCT f.salario) AS custo_salarios,
    SUM(DISTINCT s.quantidade_estoque * s.custo_unitario) AS custo_suprimentos
FROM departamentos d
LEFT JOIN funcionarios f ON d.departamento_id = f.departamento_id
LEFT JOIN escritorios e ON d.escritorio_id = e.escritorio_id
LEFT JOIN suprimentos s ON e.escritorio_id = s.escritorio_id
GROUP BY d.educacional;

-- 8.2 Escritórios com equipes comerciais e escola
SELECT e.escritorio_nome, 
       SUM(CASE WHEN d.educacional = 1 THEN 1 ELSE 0 END) AS equipe_escola,
       SUM(CASE WHEN d.educacional = 0 THEN 1 ELSE 0 END) AS equipe_comercial
FROM escritorios e
JOIN departamentos d ON e.escritorio_id = d.escritorio_id
JOIN funcionarios f ON d.departamento_id = f.departamento_id
GROUP BY e.escritorio_nome;

-- 8.4 Cargos compartilhados pelas duas frentes
SELECT c.cargo_nome, 
       SUM(CASE WHEN d.educacional = 1 THEN 1 ELSE 0 END) AS na_escola,
       SUM(CASE WHEN d.educacional = 0 THEN 1 ELSE 0 END) AS no_comercial
FROM funcionarios f
JOIN cargos c ON f.cargo_id = c.cargo_id
JOIN departamentos d ON f.departamento_id = d.departamento_id
GROUP BY c.cargo_nome
HAVING na_escola > 0 AND no_comercial > 0;

-- ==========================================
-- NÍVEL 9: ANÁLISE AVANÇADA COM AGREGAÇÕES
-- ==========================================
-- 9.1 Relatório de departamentos
SELECT d.departamento_nome, COUNT(f.funcionario_id) AS qtd_funcionarios, SUM(f.salario) AS total_salarios, AVG(f.salario) AS media_salarial
FROM departamentos d LEFT JOIN funcionarios f ON d.departamento_id = f.departamento_id
GROUP BY d.departamento_id;

-- 9.2 Os 3 cargos mais comuns
SELECT c.cargo_nome, COUNT(f.funcionario_id) AS qtd_funcionarios
FROM funcionarios f JOIN cargos c ON f.cargo_id = c.cargo_id
GROUP BY c.cargo_nome ORDER BY qtd_funcionarios DESC LIMIT 3;

-- 9.3 Funcionários que ganham acima da média do próprio depto
SELECT f.primeiro_nome, f.salario, f.departamento_id 
FROM funcionarios f
WHERE f.salario > (SELECT AVG(salario) FROM funcionarios f2 WHERE f2.departamento_id = f.departamento_id);

-- 9.4 Crescimento da empresa por ano
SELECT YEAR(data_contratacao) AS ano, COUNT(*) AS contratacoes FROM funcionarios GROUP BY ano ORDER BY ano;

-- 9.5 Ranking de vendedores
SELECT CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor, COUNT(v.venda_id) AS qtd_vendas, SUM(iv.quantidade * iv.preco_unitario) AS receita_total
FROM funcionarios f JOIN vendas v ON f.funcionario_id = v.funcionario_id
JOIN itens_venda iv ON v.venda_id = iv.venda_id
GROUP BY f.funcionario_id ORDER BY receita_total DESC;

-- 9.6 Produtos vendidos por apenas um vendedor
SELECT p.produto_nome FROM produtos p 
JOIN itens_venda iv ON p.produto_id = iv.produto_id
JOIN vendas v ON iv.venda_id = v.venda_id
GROUP BY p.produto_id HAVING COUNT(DISTINCT v.funcionario_id) = 1;

-- ==========================================
-- NÍVEL 10: AUDITORIA DE VENDAS
-- ==========================================
-- 10.1 Vendas sem vendedor
SELECT * FROM vendas WHERE funcionario_id IS NULL;

-- 10.2 Vendedores inexistentes no cadastro
SELECT v.* FROM vendas v 
LEFT JOIN funcionarios f ON v.funcionario_id = f.funcionario_id 
WHERE f.funcionario_id IS NULL;

-- 10.3 Produtos com variação de preço > 10%
SELECT produto_id, MAX(preco_unitario) AS max_p, MIN(preco_unitario) AS min_p, 
       (MAX(preco_unitario) - MIN(preco_unitario)) / MAX(preco_unitario) AS variancia
FROM itens_venda GROUP BY produto_id HAVING variancia > 0.10;

-- 10.4 Dashboard Completo (CORRIGIDO)
SELECT 
    (SELECT COUNT(*) FROM funcionarios) AS total_funcionarios,
    (SELECT SUM(salario) FROM funcionarios) AS custo_salarios,
    (SELECT COUNT(*) FROM departamentos) AS num_departamentos,
    (SELECT COUNT(*) FROM escritorios) AS num_escritorios,
    (SELECT SUM(quantidade * preco_unitario) FROM itens_venda) AS receita_vendas,
    (SELECT p.produto_nome 
     FROM produtos p 
     JOIN itens_venda iv ON p.produto_id = iv.produto_id 
     GROUP BY p.produto_id 
     ORDER BY SUM(iv.quantidade) DESC 
     LIMIT 1) AS produto_mais_vendido;

-- ==========================================
-- NÍVEL 11: ETL DO CSV
-- ==========================================
-- NOTA: A importação do CSV foi feita via "Table Data Import Wizard" do MySQL Workbench para a tabela stg_vendas_csv.
-- Exemplo de consulta para validação após a importação:
SELECT * FROM stg_vendas_csv LIMIT 5;

-- Registrando rejeições de SKU (exemplo de tratamento de erro do ETL):
INSERT INTO etl_rejeicoes (rejeicao_id, source_row_id, campo, valor_original, motivo, acao_etl_id)
SELECT 
    ROW_NUMBER() OVER (ORDER BY source_row_id) + 100 AS rejeicao_id,
    source_row_id, 'sku_raw', sku_raw, 'SKU não encontrado no catálogo', 1
FROM stg_vendas_csv
WHERE sku_raw NOT IN (SELECT sku FROM produtos);

-- ==========================================
-- NÍVEL 12: ALTERAÇÕES SEGURAS (TRANSAÇÕES)
-- ==========================================
-- 12.1 Novo departamento em escritório existente
START TRANSACTION;
INSERT INTO departamentos (departamento_id, departamento_nome, educacional, escritorio_id) 
VALUES (99, 'Inovação Segura', 0, 1400);
SELECT * FROM departamentos WHERE departamento_id = 99;
COMMIT;

-- 12.2 Cadastrar "Senior Web Developer" e promover Bruce Ernst
START TRANSACTION;
INSERT INTO cargos (cargo_id, cargo_nome, min_salario, max_salario) 
VALUES (99, 'Senior Web Developer', 7000, 16000);
UPDATE funcionarios SET cargo_id = 99, salario = 5000.00 WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';
SELECT primeiro_nome, cargo_id, salario FROM funcionarios WHERE primeiro_nome = 'Bruce' AND sobrenome = 'Ernst';
COMMIT;

-- 12.3 Transferir duas pessoas de TI para o novo departamento
START TRANSACTION;
UPDATE funcionarios SET departamento_id = 99 WHERE departamento_id = 6 LIMIT 2;
SELECT funcionario_id, primeiro_nome, departamento_id FROM funcionarios WHERE departamento_id = 99;
COMMIT;

-- 12.4 Adicionar compra de headsets
START TRANSACTION;
INSERT INTO suprimentos (suprimento_id, referencia_compra, suprimento_nome, quantidade_estoque, custo_unitario, moeda, data_compra, escritorio_id) 
VALUES (99, 'PO-TESTE-99', 'Headsets', 15, 150.00, 'USD', CURDATE(), 1400);
SELECT * FROM suprimentos WHERE referencia_compra = 'PO-TESTE-99';
COMMIT;

-- 12.5 Simular aposentadoria (mantendo histórico)
START TRANSACTION;
UPDATE funcionarios SET status_funcionario_id = 3 WHERE data_contratacao < '1990-01-01';
SELECT primeiro_nome, status_funcionario_id FROM funcionarios WHERE data_contratacao < '1990-01-01';
COMMIT;