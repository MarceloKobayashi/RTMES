<div align="center">
  <p align="center">
    <h1>103. Detalhes Reservas Pendentes</h1>
  </p>
</div>

---

> Página modal que mostra os detalhes de uma reserva que está sendo cadastrada no momento.

## 🎯 Visão geral

A página `103` contém os detalhes básicos de uma reserva que está pendente de confirmação por parte do solicitante. Nela, o usuário consegue deletar uma reserva que não queira mais.

---

## 1 - Carregar local/numero (Ação Dinâmica)

Antes de carregar os valores dos itens de página, essa ação dinâmica é acionada no carregamento da página. Ela ativa um JS que captura o tipo de reserva e exibe apenas os campos relevantes para tal (como se for Porta-, exibe P103_LOC).

---

## 2 — Detalhes da Reserva (Form)

Essa região tem como objetivo mostrar ao usuário os detalhes dessa reserva, não permitindo ele fazer alterações desses valores, sendo todos apenas leitura. Caso o tipo da reserva for 'Mezanino', uma sub-região de relatório interativo será exibida para mostrar os horários dessa reserva.

- `P103_STATUS` - Oculto - Status da Reserva (Por padrão 'Em Andamento').
- `P103_ID_RESERVA` - Oculto - Identificador da Reserva.
- `P103_TITULO_RESERVA` - Área de Texto - Título do evento da reserva.
- `P103_DES_RESERVA` - Área de Texto - Descrição do evento da reserva.
- `P103_TIP_RESERVAS` - Lista de Seleção - Tipo da reserva.
- `P103_DAT_INICIO` - Seletor de Data - Data de início do evento.
- `P103_DAT_FIM` - Seletor de Data - Data de término do evento.
- `P103_LOC` - Área de Texto - Local da reserva.
- `P103_NUM_PARTICIPANTES` - Campo de Texto - Estimativa do número de participantes do evento.
- `P103_OBSERVACAO` - Área de Texto - Observação da reserva.

#### 3.1 - Datas Mezanino (Relatório Interativo)

Caso a reserva for do tipo 'Mezanino', recupera da tabela horarios_mezanino os horários dessa reserva.

```sql
select ID_HORARIO,
       ID_RESERVA,
       HOR_INICIO,
       HOR_FIM,
       DAT
  from HORARIOS_MEZANINO
  where id_reserva = :P103_ID_RESERVA
```
---

## 3 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem apenas um botão 'Cancelar Reserva'. Quando o usuário clica nesse botão, a página é submetida e roda o processo PL/SQL 'Cancelar Reserva'.

- `Cancelar Reserva` - Deleta as ocorrências do atendimento e a própria reserva do banco de dados. Além disso, se o tipo for 'Mezanino', deleta os horários relacionados a essa reserva. 

```sql
-- Deletar reserva da lista de reservas a ser solicitada
BEGIN
    IF :P103_TIP_RESERVAS = 'Mezanino' THEN
        DELETE FROM horarios_mezanino
        WHERE id_reserva = :P103_ID_RESERVA;
    END IF;

    DELETE FROM atendimento_reservas
    WHERE fk_atendimento_reservas_reservas IN (
        SELECT id_reserva
        FROM reservas
        WHERE id_reserva = :P103_ID_RESERVA
    );

    DELETE FROM reservas
    WHERE id_reserva = :P103_ID_RESERVA;
END;
```

Depois disso, a página `103` é fechada e retorna para a página `3` a fim de prosseguir a solicitação de reserva.

---