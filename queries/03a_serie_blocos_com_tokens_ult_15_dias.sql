-- Case Stone | Contratos inteligentes ETH
-- Cargo: Analista de Business Intelligence III
-- Candidata: Rosalia Miranda
-- Dataset: bigquery-public-data.crypto_ethereum
--
-- Pergunta 3: Variação (últimos 15 dias) da quantidade de blocos com tokens
-- Obs 1: bloco com token = bloco que possui pelo menos um evento de criação registrado na tabela `contracts`.
-- Obs 2: retorna a série diária (últimos 15 dias) de blocos com tokens
-- Obs 3: a métrica-resumo de variação (CV) está calculada em uma query complementar (Q03b).
-- Obs 4: usei INTERVAL 14 DAY para retornar 15 dias (incluindo dt_max)


-- lista blocos com pelo menos 1 contrato
WITH blocos_com_tokens AS (
  SELECT DISTINCT
    block_number
  FROM `bigquery-public-data.crypto_ethereum.contracts`
),
-- coloca os blocos com token em série diária
blocos_tokens_por_dia AS (
  SELECT
    DATE(b.timestamp) AS dt_bloco,
    COUNT(*) AS blocos_com_tokens
  FROM `bigquery-public-data.crypto_ethereum.blocks` AS b
  JOIN blocos_com_tokens c
    ON c.block_number = b.number
  GROUP BY 1
),
-- verifica qual a data mais recente
janela AS (
  SELECT
    MAX(dt_bloco) AS dt_max
  FROM blocos_tokens_por_dia
)
--cria a tabela final
SELECT
  s.dt_bloco,
  s.blocos_com_tokens
FROM blocos_tokens_por_dia s
CROSS JOIN janela j
WHERE s.dt_bloco >= DATE_SUB(j.dt_max, INTERVAL 14 DAY)
ORDER BY
  s.dt_bloco;
