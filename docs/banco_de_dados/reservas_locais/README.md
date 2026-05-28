<div align="center">
	<h1>RESERVAS_LOCAIS</h1>
</div>

Descrição: tabela estática com os locais mais comuns para colocar porta-banner e porta-cartaz.

---

## 📖 Índice

- [Visão Geral](#-visão-geral)
- [Campos](#-campos)
- [Constraints / Triggers](#-constraints--triggers)
- [Contribuir](#-contribuir)

---

## 🔎 Visão Geral

Armazena os locais pré-definidos utilizados nas solicitações de totens e cartazes. Mantida como referência estática.

## 🧾 Campos

- `id_local` — NUMBER — not null — identificador do local
- `des_local` — VARCHAR2(200) — nome do local

## ⚙️ Constraints

- `SYS_C0060515` - Define a coluna de identificador como primary key. Não fiz uma constraint própria para isso!
```sql
PRIMARY KEY ("ID_LOCAL") USING INDEX ENABLE
```

## ⚙️ Triggers

Não há triggers relacionados a essa tabela.

---

Voltar para: [Visão geral do BD](../README.md)
