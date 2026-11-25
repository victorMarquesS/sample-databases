-- 1. Quais quartos estão disponíveis em determinado período?
-- (Exemplo: período de 12/11/2026 a 13/11/2026)
SELECT * FROM quartos 
WHERE id_quarto NOT IN (
    SELECT id_quarto FROM reservas 
    WHERE status = 'Confirmada' 
    AND (data_checkin <= '2026-11-13' AND data_checkout >= '2026-11-12')
);

-- 2. Quais hóspedes mais realizaram reservas?
SELECT h.nome, COUNT(r.id_reserva) AS total_reservas
FROM hospedes h
JOIN reservas r ON h.id_hospede = r.id_hospede
GROUP BY h.id_hospede, h.nome
ORDER BY total_reservas DESC;

-- 3. Qual foi o faturamento por mês?
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes, SUM(valor) AS faturamento
FROM pagamentos
GROUP BY mes
ORDER BY mes;

-- 4. Quais serviços extras são mais consumidos?
SELECT s.nome, SUM(hs.quantidade) AS total_consumido
FROM servicos s
JOIN hospedagem_servicos hs ON s.id_servico = hs.id_servico
GROUP BY s.id_servico, s.nome
ORDER BY total_consumido DESC;

-- 5. Quais quartos receberam melhores avaliações?
SELECT q.numero, AVG(f.nota) AS media_avaliacoes
FROM quartos q
JOIN reservas r ON q.id_quarto = r.id_quarto
JOIN hospedagens h ON r.id_reserva = h.id_reserva
JOIN feedbacks f ON h.id_hospedagem = f.id_hospedagem
GROUP BY q.id_quarto, q.numero
ORDER BY media_avaliacoes DESC;

-- 6. Quais reservas foram canceladas?
SELECT r.id_reserva, h.nome AS hospede, r.data_checkin, r.data_checkout
FROM reservas r
JOIN hospedes h ON r.id_hospede = h.id_hospede
WHERE r.status = 'Cancelada';

-- 7. Quantas hospedagens cada profissional atendeu?
SELECT f.nome AS profissional, f.cargo, COUNT(fh.id_hospedagem) AS total_atendimentos
FROM funcionarios f
JOIN funcionario_hospedagem fh ON f.id_funcionario = fh.id_funcionario
GROUP BY f.id_funcionario, f.nome, f.cargo
ORDER BY total_atendimentos DESC;