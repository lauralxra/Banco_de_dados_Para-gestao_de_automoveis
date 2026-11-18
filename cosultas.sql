-- ============================================================================
-- 3. DQL - TODAS AS CONSULTAS E RELATÓRIOS DO PROJETO


-- 1. Consultar veículos disponíveis por modelo, marca e faixa de preço
SELECT chassi, marca, modelo, ano, cor, preco, id_filial
FROM veiculo
WHERE status = 'Disponível'
  AND preco BETWEEN 100000.00 AND 160000.00
ORDER BY preco ASC;

-- 2. Consultar endereço e dados de contato de um cliente
SELECT id_cliente, nome, cpf_cnpj, telefone, rua, numero, complemento, bairro, cidade, cep
FROM cliente
WHERE nome LIKE '%João Pedro%';

-- 3. Consultar histórico de compras / veículos adquiridos por um cliente
SELECT c.nome AS cliente, v.id_venda, v.data_venda, ve.marca, ve.modelo, ve.ano, ve.chassi, v.valor_total, v.forma_pagamento
FROM venda v
INNER JOIN cliente c ON v.id_cliente = c.id_cliente
INNER JOIN veiculo ve ON v.chassi = ve.chassi
ORDER BY c.nome, v.data_venda DESC;

-- 4. Consultar salário, cargo e horas trabalhadas de um funcionário
SELECT f.id_funcionario, f.nome, f.cargo, f.salario, f.horas_trabalhadas, fi.nome_filial
FROM funcionario f
INNER JOIN filial fi ON f.id_filial = fi.id_filial
ORDER BY f.salario DESC;

-- 5. Consultar total de vendas realizadas por um vendedor em determinado período
SELECT f.nome AS vendedor, COUNT(v.id_venda) AS qtd_vendas, SUM(v.valor_total) AS total_vendido
FROM funcionario f
INNER JOIN venda v ON f.id_funcionario = v.id_funcionario
WHERE v.data_venda BETWEEN '2026-08-01' AND '2026-09-30'
GROUP BY f.id_funcionario, f.nome
ORDER BY total_vendido DESC;

-- 6. Consultar estoque atual de veículos por filial
SELECT fi.nome_filial, ve.status, COUNT(ve.chassi) AS quantidade_veiculos
FROM filial fi
LEFT JOIN veiculo ve ON fi.id_filial = ve.id_filial
GROUP BY fi.id_filial, fi.nome_filial, ve.status
ORDER BY fi.nome_filial, ve.status;

-- 7. Consultar filial de origem de uma venda específica
SELECT v.id_venda, v.data_venda, v.valor_total, fi.nome_filial, fi.cnpj_filial, fi.cidade
FROM venda v
INNER JOIN filial fi ON v.id_filial = fi.id_filial
WHERE v.id_venda = 3;

-- 8. Relatório de faturamento total por filial (mensal / anual)
SELECT fi.nome_filial,
       YEAR(v.data_venda) AS ano,
       MONTH(v.data_venda) AS mes,
       COUNT(v.id_venda) AS total_vendas,
       SUM(v.valor_total) AS faturamento_mensal
FROM filial fi
INNER JOIN venda v ON fi.id_filial = v.id_filial
GROUP BY fi.id_filial, fi.nome_filial, YEAR(v.data_venda), MONTH(v.data_venda)
ORDER BY ano DESC, mes DESC, faturamento_mensal DESC;

-- 9. Relatório de comissões e desempenho de vendas por funcionário (ex: comissão de 3%)
SELECT f.id_funcionario,
       f.nome AS vendedor,
       fi.nome_filial,
       COUNT(v.id_venda) AS carros_vendidos,
       COALESCE(SUM(v.valor_total), 0) AS volume_vendas,
       ROUND(COALESCE(SUM(v.valor_total), 0) * 0.03, 2) AS comissao_estimada
FROM funcionario f
INNER JOIN filial fi ON f.id_filial = fi.id_filial
LEFT JOIN venda v ON f.id_funcionario = v.id_funcionario
WHERE f.cargo = 'Vendedor'
GROUP BY f.id_funcionario, f.nome, fi.nome_filial
ORDER BY volume_vendas DESC;

-- 10. Relatório de veículos mais vendidos por marca e modelo
SELECT ve.marca,
       ve.modelo,
       COUNT(v.id_venda) AS unidades_vendidas,
       SUM(v.valor_total) AS receita_gerada
FROM venda v
INNER JOIN veiculo ve ON v.chassi = ve.chassi
GROUP BY ve.marca, ve.modelo
ORDER BY unidades_vendidas DESC, receita_gerada DESC;
