<div align="center">
	<h1>RESERVAS</h1>
</div>

Descrição: registros principais das reservas do sistema RTMES.

---

## 📖 Índice

- [Visão Geral](#-visão-geral)
- [Campos](#-campos)
- [Constraints / Triggers](#-constraints--triggers)
- [Exemplos (queries/rotinas)](#-exemplos-queriesrotinas)
- [Contribuir](#-contribuir)

---

## 🔎 Visão Geral

Armazena todas as reservas feitas no sistema, incluindo dados do solicitante, arquivos anexados e flags de controle para fluxos de aprovação.

## 🧾 Campos

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
- `mimetype` — VARCHAR2(200) — extensão/tipo do arquivo (ex: application/pdf)
- `filename` — VARCHAR2(200) — nome do arquivo
- `email_enviado` — VARCHAR2(1) — not null — índice para ver se o e-mail de resposta já foi enviado ao solicitante
- `cod_grupo_reserva` — NUMBER — para agrupar reservas e mostrar numa região dinâmica
- `dat_criacao` — TIMESTAMP(6) — not null — data de criação da reserva
- `ramal` — VARCHAR2(10) — not null — ramal do solicitante para contato
- `ind_patrimonio` — VARCHAR2(1) — not null — índice para ver se o e-mail ao patrimônio já foi solicitado

## ⚙️ Constraints / Triggers

- `PK_RESERVAS` — PK em `id_reserva` (exemplo)
- Triggers de auditoria / atualização de `dat_criacao` (adicionar código aqui)

## 🧪 Exemplos (queries/rotinas)

- Exemplo: buscar reservas confirmadas no mês atual

```sql
SELECT * FROM reservas WHERE status = 'confirmado' AND dat_inicio >= TRUNC(SYSDATE, 'MM');
```

---

## 🤝 Contribuir

Edite este arquivo para adicionar constraints, triggers e exemplos. Voltar para: [Visão geral do BD](../README.md)
