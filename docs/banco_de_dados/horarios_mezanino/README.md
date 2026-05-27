<div align="center">
	<h1>HORARIOS_MEZANINO</h1>
</div>

Descrição: horários detalhados para reservas do tipo mezanino, cada linha representa um intervalo de hora em um dia específico.

---

## 📖 Índice

- [Visão Geral](#-visão-geral)
- [Campos](#-campos)
- [Constraints / Triggers](#-constraints--triggers)
- [Exemplos](#-exemplos)
- [Contribuir](#-contribuir)

---

## 🔎 Visão Geral

Usada para armazenar intervalos horários vinculados a reservas do tipo mezanino. Permite múltiplos períodos em datas diferentes para uma única `id_reserva`.

## 🧾 Campos

- `id_horario` — NUMBER — not null — identificador do horário
- `id_reserva` — NUMBER — not null — chave estrangeira para a tabela `RESERVAS`
- `dat` — DATE — not null — data do dia da reserva do mezanino
- `hor_inicio` — VARCHAR2(200) — not null — hora de início desse dia
- `hor_fim` — VARCHAR2(200) — not null — hora de término desse dia

## ⚙️ Constraints / Triggers

- FK: `HORARIOS_MEZANINO.id_reserva` → `RESERVAS.id_reserva`
- Índices recomendados por `dat` e `id_reserva` para desempenho de consultas

## 🧪 Exemplos

```sql
SELECT * FROM horarios_mezanino WHERE id_reserva = :id_reserva ORDER BY dat, hor_inicio;
```

---

Voltar para: [Visão geral do BD](../README.md)
