-- 1. CRIAÇÃO DO BANCO E TABELAS

CREATE DATABASE hotel_nebula;
USE hotel_nebula;

CREATE TABLE hospedes (
    id_hospede INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20),
    data_nascimento DATE
);

CREATE TABLE quartos (
    id_quarto INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) UNIQUE NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    capacidade INT DEFAULT 2,
    preco_diaria DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Disponível'
);

CREATE TABLE funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    turno VARCHAR(20)
);

CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_hospede INT NOT NULL,
    id_quarto INT NOT NULL,
    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Confirmada',
    FOREIGN KEY (id_hospede) REFERENCES hospedes(id_hospede),
    FOREIGN KEY (id_quarto) REFERENCES quartos(id_quarto)
);

CREATE TABLE hospedagens (
    id_hospedagem INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT UNIQUE NOT NULL,
    checkin_real DATETIME,
    checkout_real DATETIME,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

CREATE TABLE pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_hospedagem INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    metodo VARCHAR(30) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagens(id_hospedagem)
);

CREATE TABLE servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE feedbacks (
    id_feedback INT AUTO_INCREMENT PRIMARY KEY,
    id_hospedagem INT UNIQUE NOT NULL,
    nota INT CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagens(id_hospedagem)
);

CREATE TABLE hospedagem_servicos (
    id_hospedagem INT NOT NULL,
    id_servico INT NOT NULL,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (id_hospedagem, id_servico),
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagens(id_hospedagem),
    FOREIGN KEY (id_servico) REFERENCES servicos(id_servico)
);

CREATE TABLE funcionario_hospedagem (
    id_funcionario INT NOT NULL,
    id_hospedagem INT NOT NULL,
    PRIMARY KEY (id_funcionario, id_hospedagem),
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario),
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagens(id_hospedagem)
);

-- 2. INSERÇÃO DE DADOS PARA TESTE

INSERT INTO hospedes (nome, email, cpf, telefone) VALUES
('Ana Silva', 'ana@email.com', '111.111.111-11', '11999999999'),
('Bruno Costa', 'bruno@email.com', '222.222.222-22', '11888888888'),
('Carla Dias', 'carla@email.com', '333.333.333-33', '11777777777');

INSERT INTO quartos (numero, tipo, capacidade, preco_diaria) VALUES
('101', 'Standard', 2, 150.00),
('102', 'Luxo', 2, 350.00),
('201', 'Suíte Master', 4, 600.00);

INSERT INTO funcionarios (nome, cargo, turno) VALUES
('Carlos Recepcionista', 'Recepcionista', 'Manhã'),
('Mariana Camareira', 'Camareira', 'Tarde');

INSERT INTO reservas (id_hospede, id_quarto, data_checkin, data_checkout, status) VALUES
(1, 1, '2026-11-10', '2026-11-15', 'Confirmada'),
(2, 2, '2026-11-12', '2026-11-14', 'Confirmada'),
(3, 3, '2026-11-20', '2026-11-25', 'Cancelada');

INSERT INTO hospedagens (id_reserva, checkin_real, checkout_real) VALUES
(1, '2026-11-10 14:00:00', '2026-11-15 11:00:00'),
(2, '2026-11-12 15:30:00', NULL);

INSERT INTO pagamentos (id_hospedagem, valor, metodo) VALUES
(1, 750.00, 'Cartão de Crédito'),
(2, 700.00, 'Pix');

INSERT INTO servicos (nome, preco) VALUES
('Frigobar', 50.00),
('Lavanderia', 30.00),
('Spa', 200.00);

INSERT INTO feedbacks (id_hospedagem, nota, comentario) VALUES
(1, 5, 'Quarto maravilhoso e limpo!'),
(2, 4, 'Bom atendimento, mas o chuveiro é frio.');

INSERT INTO hospedagem_servicos (id_hospedagem, id_servico, quantidade) VALUES
(1, 1, 3), -- Ana consumiu 3 frigobares
(1, 2, 1), -- Ana usou lavanderia 1 vez
(2, 1, 1); -- Bruno consumiu 1 frigobar

INSERT INTO funcionario_hospedagem (id_funcionario, id_hospedagem) VALUES
(1, 1), (2, 1), (1, 2);