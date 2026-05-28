<div align="center">
	<h1>RESERVAS_IMG</h1>
</div>

Descrição: tabela estática que armazena imagens de exemplo para porta-banner e porta-cartaz (apenas uma linha).

---

## 📖 Índice

- [Visão Geral](#-visão-geral)
- [Campos](#-campos)
- [Constraints / Triggers](#-constraints--triggers)
- [Contribuir](#-contribuir)

---

## 🔎 Visão Geral

Armazena imagens de referência exibidas no frontend para ilustrar tipos de totens e cartazes. Mantida como tabela estática de leitura/escrita manual.

## 🧾 Campos

- `id_img` — NUMBER — not null — identificador de registro
- `img_ban` — BLOB — not null — imagem do porta-banner
- `mimetype_ban` — VARCHAR2(200) — not null — extensão/tipo da imagem do porta-banner
- `filename_ban` — VARCHAR2(200) — not null — nome do arquivo da imagem do porta-banner
- `img_car` — BLOB — not null — imagem do porta-cartaz
- `mimetype_car` — VARCHAR2(200) — not null — extensão/tipo da imagem do porta-cartaz
- `filename_car` — VARCHAR2(200) — not null — nome do arquivo da imagem do porta-cartaz

## ⚙️ Constraints

- `RESERVAS_IMG_PK` - Define a coluna de identificador como primary key.
```sql
CONSTRAINT "RESERVAS_IMG_PK" PRIMARY KEY ("ID_IMG") USING INDEX ENABLE
```

## ⚙️ Triggers

Não há triggers relacionados a essa tabela.

---

Voltar para: [Visão geral do BD](../README.md)
