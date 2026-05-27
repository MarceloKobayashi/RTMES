<div align="center">
	<h1>ATENDIMENTO_RESERVAS</h1>
</div>

Descrição: tabela de auditoria / histórico das reservas para acompanhar o progresso e etapas de cada solicitação.

---

## 📖 Índice

- [Visão Geral](#-visão-geral)
- [Campos](#-campos)
- [Constraints / Triggers](#-constraints--triggers)
- [Exemplos](#-exemplos)
- [Contribuir](#-contribuir)

---

## 🔎 Visão Geral

Registros automáticos que documentam cada mudança de estado ou ação tomada sobre uma `reserva`, servindo como histórico visível ao solicitante e equipe ASQUALOG.

## 🧾 Campos

- `pk_atendimento_reservas` — NUMBER — not null — identificador do registro
- `dat_criacao_atendimento` — TIMESTAMP(6) — not null — data e hora do registro
- `des_atendimento` — VARCHAR2(200) — not null — descrição breve do atendimento (ex: reserva aprovada)
- `fk_atendimento_reservas_reservas` — NUMBER — not null — chave estrangeira para a tabela `RESERVAS`
- `confirmado` — CHAR(1) — not null — índice para saber se esse registro confirmou a reserva

## ⚙️ Constraints / Triggers

- FK para `RESERVAS` em `fk_atendimento_reservas_reservas`
- Índices por `dat_criacao_atendimento` para relatórios e buscas

## 🧪 Exemplos

```sql
SELECT * FROM atendimento_reservas WHERE fk_atendimento_reservas_reservas = :id_reserva ORDER BY dat_criacao_atendimento;
```

---

Voltar para: [Visão geral do BD](../README.md)
