-- Case Stone | Contratos inteligentes ETH
-- Cargo: Analista de Business Intelligence III
-- Candidata: Rosalia Miranda
-- Dataset: bigquery-public-data.crypto_ethereum
--
-- Objetivo: validar suposições do case e checar consistência das respostas de Q1–Q4
-- Obs: caso queira ver as analises, rode as queries por blocos para evitar leituras desnecessárias :)

--------------------------------------------------------------------------------
-- A) Pergunta 01 
--------------------------------------------------------------------------------
-- Verificar se temos block_number nulo
SELECT COUNT(*) AS linhas, COUNTIF(block_number IS NULL) AS nulos
FROM `bigquery-public-data.crypto_ethereum.contracts`;

-- A soma dos contratos por bloco tem que bater com o total de contratos
WITH per_block AS (
  SELECT block_number, COUNT(*) AS contratos_por_bloco
  FROM `bigquery-public-data.crypto_ethereum.contracts`
  GROUP BY block_number
)
SELECT
  (SELECT COUNT(*) FROM `bigquery-public-data.crypto_ethereum.contracts`) AS total_contracts,
  (SELECT SUM(contratos_por_bloco) FROM per_block) AS soma_por_bloco;

--------------------------------------------------------------------------------
-- B) Pergunta 02 
--------------------------------------------------------------------------------
-- Cada bloco aparece uma vez na tabela?
SELECT
  COUNT(*) AS total_linhas,
  COUNT(DISTINCT number) AS total_blocos_distintos
FROM `bigquery-public-data.crypto_ethereum.blocks`;

-- Verificar blocos por dia (deve resultar em zero)
WITH por_dia AS (
  SELECT DATE(timestamp) AS dia, COUNT(*) AS blocos_por_dia
  FROM `bigquery-public-data.crypto_ethereum.blocks`
  GROUP BY dia
)
SELECT *
FROM por_dia
WHERE blocos_por_dia = 0;


--------------------------------------------------------------------------------
-- C) Pergunta 03 
--------------------------------------------------------------------------------
-- Verificar se algum dia tem mais blocos com tokens do que blocos totais (retornar vazio)
WITH total_blocos AS (
  SELECT DATE(timestamp) AS dia, COUNT(*) AS blocos_total
  FROM `bigquery-public-data.crypto_ethereum.blocks`
  GROUP BY dia
),
blocos_com_tokens AS (
  SELECT DATE(b.timestamp) AS dia, COUNT(DISTINCT b.number) AS blocos_com_tokens
  FROM `bigquery-public-data.crypto_ethereum.blocks` b
  JOIN (SELECT DISTINCT block_number FROM `bigquery-public-data.crypto_ethereum.contracts`) c
    ON b.number = c.block_number
  GROUP BY dia
)
SELECT
  t.dia, t.blocos_total, x.blocos_com_tokens
FROM total_blocos t
JOIN blocos_com_tokens x USING (dia)
WHERE x.blocos_com_tokens > t.blocos_total;


--------------------------------------------------------------------------------
-- D) Pergunta 04 
--------------------------------------------------------------------------------
-- Garantir que o bloco retornado realmente está em contracts
-- lembrar de substituir o <BLOCK_NUMBER> pelo número retornado na Q04
SELECT COUNT(*) AS contratos_no_bloco
FROM `bigquery-public-data.crypto_ethereum.contracts`
WHERE block_number = 23990914;

--verificar se o bloco retornado é o máximo
WITH blocos_com_tokens AS (
  SELECT DISTINCT block_number
  FROM `bigquery-public-data.crypto_ethereum.contracts`
),
gas_por_bloco AS (
  SELECT t.block_number, SUM(t.receipt_gas_used) AS gas_total
  FROM `bigquery-public-data.crypto_ethereum.transactions` t
  JOIN blocos_com_tokens bt ON t.block_number = bt.block_number
  GROUP BY t.block_number
)
SELECT *
FROM gas_por_bloco
ORDER BY gas_total DESC
LIMIT 5;
