-- Case Stone | Contratos inteligentes ETH
-- Cargo: Analista de Business Intelligence III
-- Candidata: Rosalia Miranda
-- Dataset: bigquery-public-data.crypto_ethereum
--
-- Pergunta 1: Quantos contratos (tokens) são criados por bloco?
-- Obs: "Contratos (tokens)" são tratados como eventos de criação disponíveis na tabela `contracts`.

SELECT
  c.block_number,
  COUNT(DISTINCT c.address) AS contratos_por_bloco
FROM `bigquery-public-data.crypto_ethereum.contracts` AS c
GROUP BY
  c.block_number
ORDER BY
  contratos_por_bloco DESC,
  c.block_number DESC;
