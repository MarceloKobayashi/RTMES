<div align="center">
  <p align="center">
    <h1>204. Detalhes/Cancelar Reservas Confirmadas</h1>
  </p>
</div>

---
> Página modal que permite a ASQUALOG ver os detalhes de uma reserva confirmada e adicionar uma observação ou cancelar ela.

## 🎯 Visão geral

A página `204` contém os detalhes de uma reserva já confirmada pela ASQUALOG e dois itens de página que podem ser preenchidos.

- `P204_JUSTIFICATIVA` - Campo para o usuário colocar uma justificativa sobre o cancelamento da reserva.
- `P204_OBS_ASQUALOG` - Campo para o usuário colocar uma observação interna sobre a reserva.

Assim, a página possui duas outras funcionalidades: a de cancelar essa reserva ou a de adicionar uma observação destinada para a ASQUALOG.

---

## 1 - Carregar local/numero (Ação Dinâmica)

Antes de carregar os valores dos itens de página, essa ação dinâmica é acionada no carregamento da página. Ela ativa um JS que captura o tipo de reserva e exibe apenas os campos relevantes para tal (se for Porta-, exibe P204_LOC).

---

## 2 — Detalhes Reservas dos Outros (Form)

Essa região tem como objetivo mostrar ao usuário os detalhes da reserva de outro usuário, não permitindo ele fazer alteração dos valores, exceto nos de justificativa e de observação interna. Caso o tipo da reserva for 'Mezanino', uma sub-região de relatório interativo será exibida para mostrar os horários dessa reserva.

- `P204_ID_RESERVA` - Oculto - Identificador da Reserva.
- `P204_TITULO_RESERVA` - Área de Texto - Título do evento da reserva.
- `P204_DES_RESERVA` - Área de Texto - Descrição do evento da reserva.
- `P204_TIP_RESERVAS` - Lista de Seleção - Tipo da reserva.
- `P204_DAT_INICIO` - Seletor de Data - Data de início do evento.
- `P204_DAT_FIM` - Seletor de Data - Data de término do evento.
- `P204_LOC` - Área de Texto - Local da reserva.
- `P204_NUM_PARTICIPANTES` - Campo de Texto - Estimativa do número de participantes do evento.
- `P204_STATUS` - Campo de Texto - Mostra o status da reserva 'Confirmado'.
- `P204_NOME` - Área de Texto - Nome do solicitante.
- `P204_RAMAL` - Área de Texto - Ramal do solicitante.
- `P204_SETOR` - Área de Texto - Setor do solicitante.
- `P204_JUSTIFICATIVA` - Área de Texto - Campo para o usuário da ASQUALOG colocar a justificativa da sua decisão sobre a reserva.
- `P204_OBS_ASQUALOG` - Área de Texto - Campo para o usuário da ASQUALOG colocar a observação interna daquela reserva.
<br>

#### 2.1 - Datas Mezanino (Relatório Interativo)

Essa região mostra as datas e horários de uma reserva, caso ela for do tipo 'Mezanino'.

---

## 3 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem três botões 'Fechar', 'Adicionar Observação' e 'Cancelar Reserva'.

- `Fechar` - Fecha a página `204` e redireciona o usuário de volta para a página `11`.

- `Adicionar Observação` - Submete a página e roda um processo PL/SQL simples que apenas altera a reserva para adicionar a observação interna na tabela.

- `Cancelar Reserva` - Submete a página e roda um processo PL/SQL que cancela a reserva e envia um e-mail ao solicitante informando sobre o ocorrido e colocando a justificativa sobre tal decisão.

---
