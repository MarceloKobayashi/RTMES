
<div align="center">
  <h1>Banco de Dados — RTMES</h1>
</div>

Este documento descreve as tabelas que compõem o banco de dados utilizado pelo RTMES.

---

## 📖 Índice

- [Visão Geral](#-visão-geral)
- [Tabelas](#-tabelas)
- [Notas e Recomendações](#-notas-e-recomendações)
- [Diagrama físico](#-diagrama-físico)

---

## 🔎 Visão geral

O banco de dados consiste em 5 tabelas (duas com valores estáticos). As tabelas armazenam informações sobre reservas, horários do mezanino, histórico de atendimento e imagens/locais de referência.

## 🧾 Tabelas

### RESERVAS — registros principais de reserva

- `id_reserva` — NUMBER — not null — identificador de cada reserva
- `dat_inicio` — TIMESTAMP(6) — not null — data de começo do evento da reserva
- `dat_fim` — TIMESTAMP(6) — not null — data de término do evento da reserva
- `tip_reservas` — VARCHAR2(20) — not null — tipo da reserva (porta-banner, porta-cartaz, adesivagem, mezanino)
- `status` — VARCHAR2(20) — not null — estado da reserva (Em andamento, confirmado, cancelado, realizado)
- `num_participantes` — NUMBER — estimativa de participantes (mezanino)
- `titulo_reserva` — VARCHAR2(400) — not null — nome do evento/campanha
- `des_reserva` — VARCHAR2(4000) — not null — descrição do evento
- `cod_pessoa` — NUMBER — not null — CPF do solicitante
- `pendente` — VARCHAR2(1) — not null — índice para ver se o solicitante confirmou a solicitação dessa reserva
- `loc` — VARCHAR2(4000) — local do evento (válido apenas para os totens)
- `justificativa` — VARCHAR2(4000) — resposta da ASQUALOG quanto à reserva
- `obs` — VARCHAR2(4000) — observação dada pelo solicitante quanto à reserva
- `arq` — BLOB — arquivo com identidade visual, adesivo ou PDF sobre o evento
- `mimetype` — VARCHAR2(200) — extensão/ tipo do arquivo (ex: application/pdf)
- `filename` — VARCHAR2(200) — nome do arquivo
- `email_enviado` — VARCHAR2(1) — not null — índice para ver se o e-mail de resposta já foi enviado ao solicitante
- `cod_grupo_reserva` — NUMBER — para agrupar reservas e mostrar numa região dinâmica
- `dat_criacao` — TIMESTAMP(6) — not null — data de criação da reserva
- `ramal` — VARCHAR2(10) — not null — ramal do solicitante para contato
- `ind_patrimonio` — VARCHAR2(1) — not null — índice para ver se o e-mail ao patrimônio já foi solicitado

### HORARIOS_MEZANINO — horários por dia/hora (N:1 → RESERVAS)

- `id_horario` — NUMBER — not null — identificador do horário
- `id_reserva` — NUMBER — not null — chave estrangeira para a tabela `RESERVAS`
- `dat` — DATE — not null — data do dia da reserva do mezanino
- `hor_inicio` — VARCHAR2(200) — not null — hora de início desse dia
- `hor_fim` — VARCHAR2(200) — not null — hora de término desse dia

### ATENDIMENTO_RESERVAS — histórico/auditoria (N:1 → RESERVAS)

- `pk_atendimento_reservas` — NUMBER — not null — identificador do registro
- `dat_criacao_atendimento` — TIMESTAMP(6) — not null — data e hora do registro
- `des_atendimento` — VARCHAR2(200) — not null — descrição breve do atendimento (ex: reserva aprovada)
- `fk_atendimento_reservas_reservas` — NUMBER — not null — chave estrangeira para a tabela `RESERVAS`
- `confirmado` — CHAR(1) — not null — índice para saber se esse registro confirmou a reserva

### RESERVAS_IMG — imagens de referência (tabela estática, 1 linha)

- `id_img` — NUMBER — not null — identificador de registro
- `img_ban` — BLOB — not null — imagem do porta-banner
- `mimetype_ban` — VARCHAR2(200) — not null — extensão/tipo da imagem do porta-banner
- `filename_ban` — VARCHAR2(200) — not null — nome do arquivo da imagem do porta-banner
- `img_car` — BLOB — not null — imagem do porta-cartaz
- `mimetype_car` — VARCHAR2(200) — not null — extensão/tipo da imagem do porta-cartaz
- `filename_car` — VARCHAR2(200) — not null — nome do arquivo da imagem do porta-cartaz
- Observação: possui apenas uma linha; não se relaciona com outras tabelas.

### RESERVAS_LOCAIS — locais comuns (tabela estática, ~8 registros)

- `id_local` — NUMBER — not null — identificador do local
- `des_local` — VARCHAR2(200) — nome do local
- Observação: possui aproximadamente 8 registros; não se relaciona com outras tabelas.

---

## 📝 Notas e recomendações

- FKs: `HORARIOS_MEZANINO.id_reserva` e `ATENDIMENTO_RESERVAS.fk_atendimento_reservas_reservas` → `RESERVAS.id_reserva`.
- Índices sugeridos: `RESERVAS(dat_inicio, dat_fim)`, `RESERVAS(cod_pessoa)`, `HORARIOS_MEZANINO(dat)`.
- Atenção com campos BLOB e `VARCHAR2(4000)` para exportação e backups.

---

## 🗺️ Diagrama físico

<p align="center">
  <img src="BD_Físico.png" alt="Diagrama físico do banco de dados" width="720" />
</p>

*Arquivo: `docs/banco_de_dados/BD_Físico.png`.*

