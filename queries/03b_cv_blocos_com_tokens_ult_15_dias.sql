-- Case Stone | Contratos inteligentes ETH
-- Cargo: Analista de Business Intelligence III
-- Candidata: Rosalia Miranda
-- Dataset: bigquery-public-data.crypto_ethereum
--
-- Pergunta 3b: Métrica-resumo da variação (últimos 15 dias) de blocos com tokens
-- Obs 1: bloco com token = bloco que possui ao menos um evento de criação registrado na tabela `contracts`.
-- Obs 2: variação medida via coeficiente de variação = desvio padrão / média.

-- lista blocos com pelo menos 1 contrato
WITH blocos_com_contratos AS (
  SELECT DISTINCT
    block_number
  FROM `bigquery-public-data.crypto_ethereum.contracts`
),
-- coloca os blocos com token em série diária
blocos_tokens_por_dia AS (
  SELECT
    DATE(b.timestamp) AS dia,
    COUNT(DISTINCT b.number) AS blocos_com_tokens
  FROM `bigquery-public-data.crypto_ethereum.blocks` b
  JOIN blocos_com_contratos c
    ON b.number = c.block_number
  GROUP BY dia
),
-- verifica qual a data mais recente
janela AS (
  SELECT
    MAX(dia) AS dia_max
  FROM blocos_tokens_por_dia
),
-- ultimos 15 dias disponiveis
ultimos_15_dias AS (
  SELECT
    dia,
    blocos_com_tokens
  FROM blocos_tokens_por_dia
  CROSS JOIN janela
  WHERE dia >= DATE_SUB(dia_max, INTERVAL 15 DAY)
)
-- tabela final contendo a parte estatística
SELECT
  AVG(blocos_com_tokens) AS media,
  STDDEV(blocos_com_tokens) AS desvio_padrao,
  SAFE_DIVIDE(STDDEV(blocos_com_tokens), AVG(blocos_com_tokens)) AS coeficiente_variacao
FROM ultimos_15_dias;
