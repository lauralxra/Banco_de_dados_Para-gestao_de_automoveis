
-- PROJETO: SISTEMA DE GESTÃO DE AUTOMÓVEIS (UFRPE - BANCO DE DADOS)
-- SGBD: MySQL 8.0+


DROP DATABASE IF EXISTS sistema_automoveis;
CREATE DATABASE sistema_automoveis
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE sistema_automoveis;


-- 1. DDL - CRIAÇÃO DAS TABELAS E RESTRIÇÕES


CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(18) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL,
    rua VARCHAR(100),
    cep VARCHAR(9),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(60),
    cidade VARCHAR(60)
);

CREATE TABLE filial (
    id_filial INT AUTO_INCREMENT PRIMARY KEY,
    nome_filial VARCHAR(100) NOT NULL,
    cnpj_filial VARCHAR(18) NOT NULL UNIQUE,
    id_gerente INT NULL,
    rua VARCHAR(100),
    cep VARCHAR(9),
    numero VARCHAR(10),
    bairro VARCHAR(60),
    cidade VARCHAR(60)
);

CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10, 2),
    data_contratacao DATE NOT NULL,
    data_inicio DATE NOT NULL,
    horas_trabalhadas INT DEFAULT 0,
    id_filial INT NOT NULL,
    id_supervisor INT NULL,
    rua VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(60),
    cidade VARCHAR(60),
    cep VARCHAR(9),
    CONSTRAINT fk_funcionario_filial FOREIGN KEY (id_filial) REFERENCES filial(id_filial),
    CONSTRAINT fk_funcionario_supervisor FOREIGN KEY (id_supervisor) REFERENCES funcionario(id_funcionario)
);

CREATE TABLE veiculo (
    chassi VARCHAR(17) PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano INT,
    cor VARCHAR(30),
    preco DECIMAL(12, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Disponível',
    id_filial INT NOT NULL,
    CONSTRAINT fk_veiculo_filial FOREIGN KEY (id_filial) REFERENCES filial(id_filial)
);

CREATE TABLE venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(12, 2) NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    chassi VARCHAR(17) NOT NULL UNIQUE,
    id_filial INT NOT NULL,
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_venda_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
    CONSTRAINT fk_venda_veiculo FOREIGN KEY (chassi) REFERENCES veiculo(chassi),
    CONSTRAINT fk_venda_filial FOREIGN KEY (id_filial) REFERENCES filial(id_filial)
);


-- 2. DML - INSERÇÃO DOS DADOS (FILIAIS, FUNCIONÁRIOS, CLIENTES, VEÍCULOS, VENDAS)


-- 2.1 Inserir Filiais (inicialmente com id_gerente NULL)
INSERT INTO filial (nome_filial, cnpj_filial, id_gerente, rua, cep, numero, bairro, cidade) VALUES
('Concessionária Recife Matriz', '12.345.678/0001-90', NULL, 'Av. Conde da Boa Vista', '50060-004', '1200', 'Boa Vista', 'Recife'),
('Concessionária Olinda Norte', '12.345.678/0002-71', NULL, 'Av. Getúlio Vargas', '53030-010', '850', 'Bairro Novo', 'Olinda'),
('Concessionária Jaboatão Sul', '12.345.678/0003-52', NULL, 'Av. Bernardo Vieira de Melo', '54410-010', '2100', 'Piedade', 'Jaboatão dos Guararapes');

-- 2.2 Inserir os 3 Gerentes (IDs 1, 2 e 3)
INSERT INTO funcionario (nome, cpf, cargo, salario, data_contratacao, data_inicio, horas_trabalhadas, id_filial, id_supervisor, rua, numero, bairro, cidade, cep) VALUES
('Carlos Eduardo Silva', '111.222.333-44', 'Gerente', 8500.00, '2023-02-01', '2023-02-05', 160, 1, NULL, 'Rua da Aurora', '450', 'Santo Amaro', 'Recife', '50050-000'),
('Fernanda Lima Rocha', '222.333.444-55', 'Gerente', 8200.00, '2023-06-10', '2023-06-15', 160, 2, NULL, 'Rua do Sol', '120', 'Carmo', 'Olinda', '53120-010'),
('Roberto Alves Neto', '333.444.555-66', 'Gerente', 8400.00, '2023-08-01', '2023-08-03', 160, 3, NULL, 'Rua das Calçadas', '340', 'Piedade', 'Jaboatão dos Guararapes', '54400-100');

-- 2.3 Vincular cada Gerente à sua Filial e ativar NOT NULL + FK
UPDATE filial SET id_gerente = 1 WHERE id_filial = 1;
UPDATE filial SET id_gerente = 2 WHERE id_filial = 2;
UPDATE filial SET id_gerente = 3 WHERE id_filial = 3;

ALTER TABLE filial
    MODIFY id_gerente INT NOT NULL,
    ADD CONSTRAINT fk_filial_gerente FOREIGN KEY (id_gerente) REFERENCES funcionario(id_funcionario);

-- 2.4 Inserir Vendedores e Consultor Técnico (IDs 4 a 8)
INSERT INTO funcionario (nome, cpf, cargo, salario, data_contratacao, data_inicio, horas_trabalhadas, id_filial, id_supervisor, rua, numero, bairro, cidade, cep) VALUES
('Mariana Costa', '444.555.666-77', 'Vendedor', 3200.00, '2024-03-10', '2024-03-12', 160, 1, 1, 'Rua do Espinheiro', '310', 'Espinheiro', 'Recife', '52020-020'),
('Lucas Mendes', '555.666.777-88', 'Vendedor', 3100.00, '2024-07-01', '2024-07-03', 152, 1, 1, 'Av. Rosa e Silva', '980', 'Aflitos', 'Recife', '52050-020'),
('Beatriz Santos', '666.777.888-99', 'Vendedor', 3300.00, '2024-01-15', '2024-01-18', 168, 2, 2, 'Av. Carlos de Lima Cavalcanti', '1420', 'Casa Caiada', 'Olinda', '53130-530'),
('Thiago Ferreira', '777.888.999-00', 'Vendedor', 3250.00, '2024-05-20', '2024-05-22', 160, 3, 3, 'Rua Maria Carolina', '215', 'Boa Viagem', 'Recife', '51020-220'),
('Camila Oliveira', '888.999.000-11', 'Consultor Técnico', 4100.00, '2024-02-12', '2024-02-14', 160, 1, 1, 'Rua Benfica', '510', 'Madalena', 'Recife', '50720-001');

-- 2.5 Inserir Clientes (Pessoa Física e Pessoa Jurídica)
INSERT INTO cliente (nome, cpf_cnpj, telefone, rua, cep, numero, complemento, bairro, cidade) VALUES
('João Pedro Almeida', '987.654.321-00', '(81) 98888-1111', 'Av. Boa Viagem', '51011-000', '2500', 'Apto 802', 'Boa Viagem', 'Recife'),
('Logística Nordeste Ltda', '45.678.910/0001-55', '(81) 3222-4455', 'Rodovia BR-101 Sul', '54335-000', '500', 'Galpão B', 'Prazeres', 'Jaboatão dos Guararapes'),
('Ana Carolina Souza', '123.987.456-10', '(81) 99777-2233', 'Rua Zeferino Agra', '53130-110', '74', NULL, 'Casa Caiada', 'Olinda'),
('Construtora Horizonte S.A.', '78.123.456/0001-88', '(81) 3465-9000', 'Av. Conselheiro Aguiar', '51020-020', '1890', 'Sala 1104', 'Boa Viagem', 'Recife'),
('Rafael Gomes da Silva', '321.654.987-22', '(81) 99123-4567', 'Rua das Ninfas', '50070-050', '145', 'Bloco A', 'Soledade', 'Recife'),
('Clínica Vida Saudável Ltda', '33.987.654/0001-12', '(81) 3341-7788', 'Av. Agamenon Magalhães', '52010-040', '2900', 'Térreo', 'Derby', 'Recife'),
('Juliana Martins Pereira', '654.321.789-33', '(81) 98456-7890', 'Av. Caxangá', '50731-000', '3410', 'Casa 04', 'Iputinga', 'Recife'),
('Pedro Henrique Barbosa', '789.456.123-44', '(81) 99654-3210', 'Rua Setúbal', '51030-010', '612', 'Apto 401', 'Boa Viagem', 'Recife');

-- 2.6 Inserir Veículos (15 veículos distribuídos entre as 3 filiais)
INSERT INTO veiculo (chassi, modelo, marca, ano, cor, preco, status, id_filial) VALUES
('9BWZZZ377VT004251', 'Corolla XEi', 'Toyota', 2025, 'Prata', 148900.00, 'Disponível', 1),
('8ADZZZ123AB998877', 'Pulse Audace', 'Fiat', 2026, 'Branco', 115500.00, 'Disponível', 1),
('93HFC2630KZ102938', 'Civic Touring', 'Honda', 2024, 'Preto', 162000.00, 'Vendido', 1),
('9BRBL3HE8P0112233', 'Corolla XEi', 'Toyota', 2025, 'Branco', 151000.00, 'Vendido', 1),
('9BRBL3HE8P0778899', 'Corolla XEi', 'Toyota', 2026, 'Preto', 154000.00, 'Vendido', 1),
('9BWAB45U1PT556677', 'Polo Highline', 'Volkswagen', 2025, 'Azul', 118900.00, 'Em Manutenção', 1),
('9BRBL3HE8P0445566', 'Corolla Altis', 'Toyota', 2026, 'Cinza', 178500.00, 'Vendido', 2),
('9BD358A1MPY778899', 'Pulse Audace', 'Fiat', 2025, 'Vermelho', 112000.00, 'Vendido', 2),
('9BHBG51CAKP334455', 'HB20 Platinum', 'Hyundai', 2026, 'Prata', 104900.00, 'Disponível', 2),
('936CL21B0RG889900', '208 Griffe', 'Peugeot', 2024, 'Cinza', 96000.00, 'Em Manutenção', 2),
('9BHBG51CAKP667788', 'HB20 Comfort', 'Hyundai', 2025, 'Branco', 92500.00, 'Vendido', 3),
('98867512XPK990011', 'Compass Longitude', 'Jeep', 2025, 'Preto', 184000.00, 'Vendido', 3),
('98867512XPK223344', 'Compass Limited', 'Jeep', 2026, 'Cinza', 205000.00, 'Disponível', 3),
('9BD358A1MPY112200', 'Strada Volcano', 'Fiat', 2026, 'Branco', 129900.00, 'Vendido', 3),
('9BG148FK0RC334400', 'Onix Premier', 'Chevrolet', 2026, 'Vermelho', 114200.00, 'Disponível', 3);

-- 2.7 Inserir Vendas (8 vendas concluídas correspondentes aos veículos 'Vendido')
INSERT INTO venda (data_venda, valor_total, forma_pagamento, id_cliente, id_funcionario, chassi, id_filial) VALUES
('2026-07-15', 162000.00, 'Financiamento', 1, 4, '93HFC2630KZ102938', 1),
('2026-08-03', 151000.00, 'Pix', 2, 5, '9BRBL3HE8P0112233', 1),
('2026-08-19', 178500.00, 'À Vista', 3, 6, '9BRBL3HE8P0445566', 2),
('2026-08-27', 112000.00, 'Financiamento', 5, 6, '9BD358A1MPY778899', 2),
('2026-09-02', 92500.00, 'Consórcio', 7, 7, '9BHBG51CAKP667788', 3),
('2026-09-08', 184000.00, 'Pix', 4, 7, '98867512XPK990011', 3),
('2026-09-12', 154000.00, 'Financiamento', 1, 4, '9BRBL3HE8P0778899', 1),
('2026-09-15', 129900.00, 'À Vista', 2, 7, '9BD358A1MPY112200', 3);

