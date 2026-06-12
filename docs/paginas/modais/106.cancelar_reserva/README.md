<div align="center">
  <p align="center">
    <h1>106. Cancelar Reserva</h1>
  </p>
</div>

---

> Página modal que serve para deletar uma reserva de mezanino antes dela ser confirmada.

## 🎯 Visão geral

A página `106` contém os detalhes de uma reserva de mezanino e um botão 'Cancelar Reserva' que deleta ela antes de ela ser confirmada.

---

## 1 - Reserva (Form)

Aqui serão exibidos, em forma de item de página, os detalhes da reserva de mezanino a ser deletada.

- `P106_TIP_RESERVAS` - Tipo da reserva, no caso 'Mezanino'.
- `P106_TITULO_RESERVA` - Título do evento da reserva.
- `P106_DES_RESERVA` - Descrição do evento da reserva.
- `P106_NUM_PARTICIPANTES` - Estimativa de participantes do evento.
- `P106_OBSERVACAO` - Observação em relação à reserva.

Além disso, tem uma sub-região que mostra as datas e horários de tal reserva.

---

## 2 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem apenas um botão.

- `Cancelar` - Submete a página, passando o id da reserva para rodar o processo PL/SQL 'Deletar reserva', que deleta o registro da reserva e de suas datas do banco de dados.

```sql
BEGIN
    IF :P106_TIP_RESERVAS = 'Mezanino' THEN
        DELETE FROM horarios_mezanino
        WHERE id_reserva = :P106_ID_RESERVA;
    END IF;

    DELETE FROM reservas
    WHERE id_reserva = :P106_ID_RESERVA;
END;
```
<br>

Depois de rodar, a página `106` fecha e o usuário volta para a página `15`.
---

FALTA IMAGEM!