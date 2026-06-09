<div align="center">
  <p align="center">
    <h1>101. Detalhes Reservas Confirmdas</h1>
  </p>
</div>

---

> Página modal que mostra os detalhes de uma reserva cadastrada pelo solicitante que está em análise ou confirmada.

## 🎯 Visão geral

A página `101` contém as principais informações a respeito de uma reserva e as etapas do atendimento em relação a ela, como horário, descrição e responsável.

---

## Exibir os campos corretos (Ação Dinâmica)

Antes de qualquer coisa, quando um usuário acessa essa página, essa ação dinâmica é ativada e roda dois JS, um para exibir os campos corretos em relação ao tipo da reserva (se for mezanino, mostra os horários) e outro para exibir as regiões corretas quanto ao valor de 'P101_MODO'.

---

## 1 — Atendimento e Detalhes (Botões)

Esses dois botões ficam localizados no topo da página modal e servem para alternar a visualização da reserva entre detalhes e atendimento.

Ao clicar em um deles, uma ação dinâmica é ativada, setando o valor de 'P101_MODO' para 'Atendimento' ou 'Detalhes'.

---

## 2 - Reserva (Form)

Essa região compreende os detalhes da reserva específica. Ela utiliza uma query simples que apenas pega os valores da tabela reservas.

- `P101_MODO` - Não é um campo na tabela reservas, mas é um item de página oculto criado apenas para alternar entre as visualizações. Quando seu valor é alterado, uma ação dinâmica é acionada e roda um JS que exibe as regiões corretas.
- `P101_ID_RESERVA` - Item de página oculto que armazena o ID da reserva atual.
- `P101_TITULO_RESERVA` - Exibe o título da reserva.
- `P101_DES_RESERVA` - Exibe a descrição da reserva.
- `P101_DAT_INICIO` - Data de início do evento da reserva.
- `P101_DAT_FIM` - Data de término do evento da reserva.
- `P101_TIP_RESERVAS` - Tipo da reserva.
- `P101_LOC` - Local da reserva, se aplicável.
- `P101_STATUS` - Status da reserva.
- `P101_NUM_PARTICIPANTES` - Número estimado de participantes para o evento da reserva, se aplicável.
- `P101_COD_PESSOA` - CPF do solicitante da reserva.

#### Datas Mezanino (Região Estática)

Essa região faz a separação visual dos itens e do relatório interativo de horários do evento da reserva, caso ele for do tipo 'Mezanino'.

- `Datas Mezanino` - Relatório Interativo - Mostra os horários da reserva.
```SQL
select ID_HORARIO,
       ID_RESERVA,
       HOR_INICIO,
       HOR_FIM,
       DAT
  from HORARIOS_MEZANINO
  where :P101_TIP_RESERVAS = 'Mezanino'
    and id_reserva = :P101_ID_RESERVA
  order by dat, hor_inicio
```
---

## 3 — Atendimento (Relatório Interativo)

Essa região tem como objetivo mostrar ao usuário os registros de atendimento dessa reserva, como 'Registro da Solicitação', 'Reserva confirmada para realização'. Além disso, também mostra a data e hora que foi feita tal etapa e quem realizou tal etapa do atendimento.

```sql
select PK_ATENDIMENTO_RESERVAS,
       -- Ícone para o estado da reserva na etapa específica
       CASE
        WHEN CONFIRMADO = 'S' THEN '<span class="fa fa-check-circle" style="color:green;"></span>'
        WHEN CONFIRMADO = 'N' THEN '<span class="fa fa-check-circle" style="color:red;"></span>'
        ELSE ''
       END AS icone_confirmação,
       TO_CHAR(DAT_CRIACAO_ATENDIMENTO, 'DD/MM/YYYY HH24:MI:SS') as data_hora,
       DES_ATENDIMENTO,
       'por ' || NOM_ATENDIMENTO as responsavel,
       FK_ATENDIMENTO_RESERVAS_RESERVAS,
       CONFIRMADO
  from ATENDIMENTO_RESERVAS
  where fk_atendimento_reservas_reservas = :P101_ID_RESERVA
  order by dat_criacao_atendimento DESC;
```
---