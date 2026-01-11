# Definições importantes 

O documento descreve as principais definições conceituais e decisões analíticas adotadas ao longo do case de análise de dados sobre contratos inteligentes na rede de criptos Ethereum, com a base disponível no BigQuery.

---

## 1. Definição de Contratos Inteligentes e Tokens

Neste projeto, o termo **contratos (tokens)** refere-se a **eventos de criação de tokens executados por contratos inteligentes na blockchain Ethereum**.

- A criação de tokens é inferida a partir de eventos de deploy de contratos disponíveis no dataset público `crypto_ethereum`.
- Considera-se que cada evento de criação corresponde a uma execução bem-sucedida de um contrato inteligente.

Essa definição segue o escopo do desafio, no qual os conceitos de contrato e token são tratados de forma equivalente para fins analíticos.

---

## 2. Conceitos de Blockchain

### Bloco
Um **bloco** é um conjunto de transações validadas adicionadas à blockchain Ethereum.

- Cada bloco possui um número único e um timestamp.
- Um bloco pode conter zero ou mais transações.
- Um bloco pode conter um ou mais eventos de criação de contratos (tokens).

### Transação
Uma **transação** representa uma ação executada na blockchain, podendo envolver:
- Transferência de Ether
- Interação com contratos inteligentes
- Criação de contratos inteligentes (tokens)

### Token (Contrato Inteligente)
Neste case, um **token** corresponde a um contrato inteligente criado na rede Ethereum.

- Cada token é identificado de forma única por seu **endereço de contrato**.
- Os atributos `name` (nome) e `symbol` (símbolo) **não são obrigatórios** na implementação de contratos inteligentes.
- Como consequência, nem todos os tokens possuem nome ou símbolo definidos no dataset `crypto_ethereum`.

Quando o nome do token não está disponível, o **endereço do contrato** é utilizado como identificador principal, sendo o nome tratado apenas como informação adicional.
---

## 3. Gas e Taxas

- **Gas** representa o custo computacional necessário para executar transações ou criar contratos inteligentes na rede Ethereum.
- Transações mais complexas tendem a consumir maior quantidade de gas.

Para este case:
- O consumo de gas é analisado de forma agregada **no nível do bloco**, quando aplicável.
- O bloco com maior consumo total de gas é interpretado como o bloco mais custoso computacionalmente entre aqueles que geraram tokens.

---

## 4. Granularidade Temporal

- Todas as análises temporais utilizam o **timestamp do bloco**.
- As agregações diárias são realizadas com base na data em UTC disponibilizado na base de dados.

---

## 5. Criação de Tokens por Bloco

- A quantidade de tokens criados por bloco é calculada a partir da contagem de endereços distintos de contratos associados a cada bloco.
- Blocos sem eventos de criação de tokens são excluídos das análises específicas de tokens, mas podem ser considerados em métricas gerais de blocos.

---

## 6. Criação de Blocos por Dia

- O número de blocos criados por dia é calculado por meio da contagem de blocos distintos.
- Essa métrica representa a atividade geral da rede Ethereum, independentemente da criação de tokens.

---

## 7. Métrica de Variação (Coeficiente de Variação – CV)

Para analisar a variação na quantidade de blocos que contêm criação de tokens ao longo dos últimos 15 dias, foi utilizado o **Coeficiente de Variação (CV)**.

O Coeficiente de Variação é definido como a razão entre o desvio padrão e a média dos valores observados, sendo uma métrica que permite avaliar a volatilidade relativa dos dados.

A escolha do CV se justifica porque:
- Permite comparar a variabilidade de uma métrica independentemente da sua escala;
- Facilita a interpretação da instabilidade relativa da criação de tokens ao longo do tempo;
- É mais informativo do que a variância absoluta em análises temporais de volume.

Neste contexto, o CV é utilizado para medir o quão estável ou volátil foi a quantidade diária de blocos contendo criação de tokens no período analisado.

---

## 8. Fonte de Dados e Limitações

- Os dados utilizados são provenientes do dataset público do BigQuery:
  - Projeto: `bigquery-public-data`
  - Dataset: `crypto_ethereum`
- A análise depende da qualidade e completude dos dados públicos disponibilizados.
- Não foi realizado enriquecimento com fontes externas.

---
