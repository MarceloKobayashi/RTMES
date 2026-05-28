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

## ⚙️ Constraints

- `SYS_C0060497` - Define a coluna de identificador como primary key. Não fiz uma constraint própria para isso!
```sql
PRIMARY KEY ("ID_HORARIO")
```

- `ID_RESERVA` - Define a coluna de identificador da reserva como foreign key.
```sql
CONSTRAINT "ID_RESERVA" FOREIGN KEY ("ID_RESERVA") REFERENCES "RESERVAS" ("ID_RESERVA") ENABLE
```

## ⚙️ Triggers

- `TRG_HORARIOS_MEZANINO_B_I` - Gera automaticamente um valor para o identificador a partir de uma sequência "SEQ_HORARIOS_MEZANINO".
```sql
CREATE or REPLACE TRIGGER "TRG_HORARIOS_MEZANINO_B_I"
BEFORE INSERT ON horarios_mezanino
FOR EACH ROW
BEGIN
	SELECT SEQ_HORARIOS_MEZANINO.NEXTVAL 
	INTO :NEW.ID_HORARIO 
	FROM DUAL;
END;
```

## 🧪 Exemplos

```sql
SELECT * FROM horarios_mezanino WHERE id_reserva = :id_reserva ORDER BY dat, hor_inicio;
```

---

Voltar para: [Visão geral do BD](../README.md)
