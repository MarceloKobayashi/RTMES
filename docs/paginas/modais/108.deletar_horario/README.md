<div align="center">
  <p align="center">
    <h1>108. Deletar Horário</h1>
  </p>
</div>

---

> Página modal que serve para deletar um horário de mezanino durante o cadastro de uma reserva.

## 🎯 Visão geral

A página `108` contém 3 itens de página ocultos ao usuário e 3 itens de página visíveis que não podem ser alterados e um botão 'Excluir' que submete a página.

---

## 1 - Itens de Página

Os itens 'P108_DAT', 'P108_HOR_INICIO' e 'P108_HOR_FIM' tem seus valores setados através do id do horário que é passado através do relatório dinâmico de datas da página `14`.

- `P108_DAT` - Data dos horários
- `P108_HOR_INICIO` - Hora de início do intervalo
- `P108_HOR_FIM` - Hora de término do intervalo

---

## 2 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem apenas um botão.

- `Excluir` - Submete a página, passando o id da data para rodar o processo PL/SQL 'Deleta horario', que apenas deleta o registro da tabela temporária.

```sql
BEGIN
    DELETE FROM tmp_reservas
    WHERE id_temp = :P108_ID_TEMP;
END;
```
<br>

Depois de rodar, a página `108` fecha e o usuário volta para a página `14`.
---

FALTA IMAGEM!