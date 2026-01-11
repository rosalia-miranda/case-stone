-- Case Stone | Contratos inteligentes ETH
-- Cargo: Analista de Business Intelligence III
-- Candidata: Rosalia Miranda
-- Dataset: bigquery-public-data.crypto_ethereum
--
-- Pergunta 4: Qual bloco (que criou tokens) utilizou mais gas no total e quais tokens foram criados?
-- Obs 1: blocos com tokens = blocos que possuem ao menos um contrato registrado em `contracts`
-- Obs 2: o gas do bloco é calculado como o total de `receipt_gas_used` das transações incluídas no bloco
-- Obs 3: nome e símbolo do token são obtidos via tabela `tokens` quando disponíveis

--blocos que tiveram criação de contrato
WITH blocos_com_tokens AS (
  SELECT DISTINCT
    block_number
  FROM `bigquery-public-data.crypto_ethereum.contracts`
),
--gas total por bloco
gas_por_bloco AS (
  SELECT
    t.block_number,
    SUM(t.receipt_gas_used) AS gas_total
  FROM `bigquery-public-data.crypto_ethereum.transactions` t
  JOIN blocos_com_tokens bt
    ON t.block_number = bt.block_number
  GROUP BY t.block_number
),
-- pega o bloco com maior consumo de gás
bloco_top AS (
  SELECT
    block_number,
    gas_total
  FROM gas_por_bloco
  ORDER BY gas_total DESC, block_number DESC
  LIMIT 1
)
-- tabela final com lista de contratos criados no bloco top + nome/símbolo quando disponíveis.
SELECT
  bt.block_number,
  bt.gas_total,
  c.address AS contract_address,
  tok.name AS token_name,
  tok.symbol AS token_symbol
FROM bloco_top bt
JOIN `bigquery-public-data.crypto_ethereum.contracts` c
  ON c.block_number = bt.block_number
LEFT JOIN `bigquery-public-data.crypto_ethereum.tokens` tok
  ON tok.address = c.address
ORDER BY
  contract_address;
