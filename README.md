# Sistema de Gestão de Automóveis (MySQL)

Repositório contendo o script SQL completo (DDL, DML e DQL) para implantação e teste do banco de dados relacional de uma rede de concessionárias de automóveis.

## Estrutura do Banco de Dados

O banco `sistema_automoveis` foi modelado para gerenciar operações comerciais, estoque individualizado de veículos e hierarquia de colaboradores entre múltiplas filiais:

* **`filial`**: Unidades da concessionária (CNPJ, endereço e referência ao gerente responsável).
* **`funcionario`**: Colaboradores (gerentes, vendedores e consultores técnicos), contendo auto-relacionamento de supervisão (`id_supervisor`) e vínculo com a filial (`id_filial`).
* **`cliente`**: Compradores pessoa física (CPF) ou pessoa jurídica (CNPJ), dados de contato e endereço.
* **`veiculo`**: Inventário individualizado pelo número de `chassi` (PK), contendo marca, modelo, ano, cor, preço, filial onde está alocado (`id_filial`) e `status` (`Disponível`, `Vendido` ou `Em Manutenção`).
* **`venda`**: Registro das transações comerciais vinculando cliente, vendedor, filial e o chassi único negociado.

### Particularidade Técnica (Dependência Circular)
Como cada `filial` exige um `id_gerente` (FK para `funcionario`) e cada `funcionario` exige um `id_filial` (FK para `filial`), o script cria inicialmente a coluna `id_gerente` aceitando `NULL`, insere as filiais e seus respectivos gerentes, atualiza os vínculos e, em seguida, aplica as restrições `NOT NULL` e `FOREIGN KEY` via `ALTER TABLE`.

---

## Pré-requisitos

* **MySQL Server 8.0** ou superior instalado e em execução na máquina.
* **MySQL Workbench** (ou outro cliente SQL / acesso via terminal).

---

## Como Executar na Sua Máquina

O arquivo `sistema_automoveis.sql` é autossuficiente: ele recria o banco do zero (`DROP DATABASE IF EXISTS`), constrói as tabelas, insere os dados de teste e executa as consultas.

### Opção 1: Via MySQL Workbench (Interface Gráfica)
1. Abra o **MySQL Workbench** e conecte-se à sua instância local.
2. No menu superior, acesse **File > Open SQL Script...** e selecione o arquivo `sistema_automoveis.sql`.
3. Clique no ícone de **raio** (*Execute the selected portion of the script or everything, if there is no selection*) para rodar o script inteiro.
4. No painel lateral esquerdo (*Schemas*), clique no botão de atualizar (setas circulares) para visualizar o banco `sistema_automoveis`.

### Opção 2: Via Terminal (Linha de Comando)
1. Abra o terminal na pasta onde o arquivo `sistema_automoveis.sql` está localizado.
2. Execute o comando abaixo (substituindo `root` pelo seu usuário do MySQL, se necessário):
   ```bash
   mysql -u root -p < sistema_automoveis.sql
