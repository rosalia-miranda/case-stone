-- Case Stone | Contratos inteligentes ETH
-- Cargo: Analista de Business Intelligence III
-- Candidata: Rosalia Miranda
-- Dataset: bigquery-public-data.crypto_ethereum

-- Pergunta 2: Quantos blocos são criados em um dia?
-- Obs: Cada registro na tabela `blocks` representa um bloco criado


SELECT
  DATE(b.timestamp) AS dt_bloco,
  COUNT(*) AS blocos_por_dia
FROM `bigquery-public-data.crypto_ethereum.blocks` AS b
GROUP BY
  dt_bloco
ORDER BY
  dt_bloco DESC;
