# Case Stone — Contratos Inteligentes da cripto Ethereum

**Cargo:** Analista de Business Intelligence III  
**Candidata:** Rosalia Miranda  

---

## Objetivo

Este projeto tem como objetivo analisar a criação de contratos inteligentes (tokens) na blockchain da cripto Ethereum utilizando dados públicos do BigQuery. A ideia é responder perguntas relacionadas ao negócio, com consultas em SQL, validações de dados e criação de métricas para consumo analítico diário.

---

## Estrutura do projeto

O repositório está organizado da seguinte forma:

- **queries/**
  Contém todas as queries SQL desenvolvidas para responder às perguntas do case + validações:
  - `01_tokens_por_bloco.sql`
  - `02_blocos_por_dia.sql`
  - `03a_serie_blocos_com_tokens_ult_15_dias.sql`
  - `03b_cv_blocos_com_tokens_ult_15_dias.sql`
  - `04_bloco_com_maior_gas_e_tokens.sql`
  - `00_analise_exploratoria.sql`

- **docs/**
  Documentação de apoio ao projeto:
  - `conceitos.md`: premissas e definições conceituais sobre a cripto.

- **README.md**
  Documento principal com a explicação do desenvolvimento projeto.

---

## Contexto conceitual
Os conceitos estão mais detalhados em [conceitos.md](docs/conceitos.md).

* **Blockchain:** estrutura de dados composta por blocos encadeados cronologicamente.
* **Bloco:** conjunto de transações validadas em um determinado momento.
* **Contrato inteligente:** código executado na blockchain; neste case, representa eventos de criação de tokens.
* **Gas:** unidade que mede o custo computacional das transações executadas na rede.

---

## Tecnologias utilizadas

* **BigQuery**
  * Execução das queries 
  * Criação das métricas em tabelas
  * Atualização via queries agendadas

* **Google Sheets**
  * Consumo das tabelas criadas via conector do BigQuery
  * Uso para leitura tabular

* **Looker Studio**
  * Visualização simples das métricas finais

---

## Acesso aos dados (BigQuery)

Os dados utilizados neste case são públicos e estão disponíveis no BigQuery, no dataset `bigquery-public-data.crypto_ethereum`.

### Como criar uma conta no BigQuery

1. Acesse: https://cloud.google.com/
2. Crie uma conta gratuita na Google Cloud Platform (GCP)
3. Durante o cadastro, o Google disponibiliza uma cota mensal gratuita de uso do BigQuery
4. No Console da GCP, acesse o serviço BigQuery

### Acessando o dataset público

1. No painel lateral do BigQuery, localize o projeto `bigquery-public-data`
2. Abra o dataset `crypto_ethereum`
3. As principais tabelas utilizadas neste projeto são:
   - `blocks`
   - `transactions`
   - `contracts`
   - `tokens`

As queries deste repositório podem ser executadas diretamente no BigQuery, sem necessidade de upload de dados adicionais.

---

## Perguntas do case

### Q01 — Quantos contratos (tokens) são criados por bloco?
- Métrica construída a partir da contagem de registros da tabela `contracts`, agregados por `block_number`.
- Query utilizada: 
[01_tokens_por_bloco.sql](queries/01_tokens_por_bloco.sql)

---

### Q02 — Quantos blocos são criados por dia?
- Agregação diária da tabela `blocks`, utilizando o timestamp do bloco.
- Query utilizada: 
[02_blocos_por_dia.sql](queries/02_blocos_por_dia.sql)

---

### Q03 — Variação na quantidade de blocos com tokens (últimos 15 dias)
 
**Q03a — Série temporal**
- Série diária de blocos que possuem ao menos um evento de criação de contrato.
- Fiz uma janela dinâmica baseada na data máxima disponível nos dados.
- Query utilizada: 
[03a_serie_blocos_com_tokens_ult_15_dias.sql](queries/03a_serie_blocos_com_tokens_ult_15_dias.sql)

**Q03b — Métrica-resumo**
- Com base na query anterior, foi realizado o cálculo de média, desvio padrão e coeficiente de variação (CV).
- Query utilizada:  
  [03b_cv_blocos_com_tokens_ult_15_dias.sql](queries/03b_cv_blocos_com_tokens_ult_15_dias.sql)

---

### Q04 — Bloco com maior consumo de gas entre blocos com tokens

- Soma de `receipt_gas_used` por bloco, considerando apenas blocos com eventos de criação de contratos.
- Identificação do bloco com maior consumo total de gas.
- Listagem dos contratos criados nesse bloco, com nome e símbolo do token quando disponíveis.

- Em redes como a Ethereum, nem todos os contratos seguem padrões como ERC-20, em que as funções `name()` e `symbol()` são definidas como opcionais. Como resultado, nem todos os tokens possuem `token_name` e `token_symbol` preenchidos no dataset público do BigQuery.  
- (Baseado em: https://eips.ethereum.org/EIPS/eip-20 e https://ethereum.org/en/developers/docs/standards/tokens/erc-20/)

- Query utilizada:  
  [04_bloco_com_maior_gas_e_tokens.sql](queries/04_bloco_com_maior_gas_e_tokens.sql)


### Q05 — Como você faria para automatizar a criação das tabelas e sua atualização diária com as Queries que você montou para responder as perguntas?
Após o desenvolvimento das consultas SQL no BigQuery, os resultados foram validados para garantir consistência e coerência com as perguntas do case. 

Com as consultas validadas, foi realizado a automatização da atualização dos resultados por meio da funcionalidade Programação do próprio BigQuery. Nesse processo, as queries foram configuradas para criar os resultados em tabelas e atualizar de forma recorrente sem a necessidade de execução manual. 

- Consumo e visualização dos dados

Caso tenha a necessidade de criar uma visualização para as métricas criadas, sem gerar custos elevados de processamento, os dados criados no BigQuery podem ser conectados ao Google Sheets e, a partir daí, consumir por ferramentas de visualização como o usado neste case, Looker Studio.

Dependendo do volume de dados e da frequência de atualização, a conexão direta entre BigQuery e ferramentas de visualização pode gerar custos adicionais, uma vez que cada interação pode disparar novas consultas.  
Nesse contexto, o uso de tabelas criadas e sua exposição via Google Sheets se apresenta como uma alternativa mais segura e econômica, especialmente para análises exploratórias e dashboards simples.

- Observação sobre agendamento

Durante os testes realizados, foi observado que o agendamento no BigQuery está diretamente vinculado à query no momento em que ela é programada.  
Caso a consulta seja alterada posteriormente, recomendo criar um novo agendamento, garantindo que a versão atualizada da query seja a que alimenta a tabela automatizada.

Essa prática ajuda a evitar inconsistências entre a lógica esperada e os dados efetivamente atualizados ao longo do tempo.

As métricas criadas ao longo deste case podem ser visualizadas em:  
[Looker Studio](https://lookerstudio.google.com/reporting/29c5c916-ed20-437f-94cd-afb96b2988dc)

---

## Validações e qualidade dos dados
Foram realizadas validações para garantir a confiabilidade das métricas.
É possível fazer a verificação de validações na pasta [00_analise_exploratoria.sql](queries/00_analise_exploratoria.sql)

---
