<div align="center">
  <p align="center">
    <h1>105. Detalhes Reservas Outros</h1>
  </p>
</div>

---

> Página modal que mostra os detalhes de uma reserva de outro solicitante.

## 🎯 Visão geral

A página `105` contém os detalhes básicos de uma reserva de outro usuário. Ela serve para permitir a negociação de datas entre os usuários fora do sistema, já que mostra o nome, setor e ramal do solicitante da reserva.

---

## 1 - Carregar local/numero (Ação Dinâmica)

Antes de carregar os valores dos itens de página, essa ação dinâmica é acionada no carregamento da página. Ela ativa um JS que captura o tipo de reserva e exibe apenas os campos relevantes para tal (como se for Porta-, exibe P105_LOC).

---

## 2 — Detalhes Reserva dos Outros (Form)

Essa região tem como objetivo mostrar ao usuário os detalhes da reserva de outro usuário, não permitindo ele fazer alteração dos valores, sendo todos apenas leitura. Caso o tipo da reserva for 'Mezanino', uma sub-região de relatório interativo será exibida para mostrar os horários dessa reserva.

- `P105_ID_RESERVA` - Oculto - Identificador da Reserva.
- `P105_TITULO_RESERVA` - Área de Texto - Título do evento da reserva.
- `P105_DES_RESERVA` - Área de Texto - Descrição do evento da reserva.
- `P105_TIP_RESERVAS` - Lista de Seleção - Tipo da reserva.
- `P105_DAT_INICIO` - Seletor de Data - Data de início do evento.
- `P105_DAT_FIM` - Seletor de Data - Data de término do evento.
- `P105_LOC` - Área de Texto - Local da reserva.
- `P105_NUM_PARTICIPANTES` - Campo de Texto - Estimativa do número de participantes do evento.
- `P105_STATUS` - Campo de Texto - Status da Reserva.
- `P105_PENDENTE` - Oculto - Se o solicitante confirmou ou não o pedido da reserva.
- `P105_COD_PESSOA` - Oculto - CPF do solicitante.
<br>

#### 3.1 - Solicitante (Região Estática)

Contém os itens de páginas que identificam o solicitante dessa reserva, com seu nome, setor e ramal.

- `P105_NOME` - Campo de Texto - Nome completo do solicitante.
- `P105_RAMAL` - Campo de Texto - Ramal do solicitante.
- `P105_SETOR` - Campo de Texto - Setor do solicitante.
<br>

#### 3.2 - Datas Mezanino (Relatório Interativo)

Caso a reserva for do tipo 'Mezanino', recupera da tabela horarios_mezanino os horários dessa reserva.

```sql
select ID_HORARIO,
       ID_RESERVA,
       HOR_INICIO,
       HOR_FIM,
       DAT
  from HORARIOS_MEZANINO
  where id_reserva = `P105_ID_RESERVA
```
---

## 4 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem apenas um botão 'Fechar'.

- `Fechar` - Ativa uma ação dinâmica que cancela a caixa de diálogo, ou seja, fecha a página modal `105`.

---