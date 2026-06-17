<div align="center">
  <p align="center">
    <h1>201. Confirmar ou Cancelar Reserva</h1>
  </p>
</div>

---

> Página modal que permite a ASQUALOG a confirmar ou cancelar uma reserva.

## 🎯 Visão geral

A página `201` contém os detalhes de uma reserva com um campo extra para justificativa da decisão da ASQUALOG. Nessa página, o setor deve avaliar uma reserva para ver se essa é aplicável ou não, setando o status como 'Confirmado' ou 'Cancelado'.

---

## 1 - Exibir local/número (Ação Dinâmica)

Antes de carregar os valores dos itens de página, essa ação dinâmica é acionada no carregamento da página. Ela ativa um JS que captura o tipo de reserva e exibe apenas os campos relevantes para tal (se for Porta-, exibe P201_LOC). Além disso, executa um PL/SQL que insere um registro de atendimento nessa reserva ('Um usuário da ASQUALOG está analisando sua reserva.').

---

## 2 — Detalhes da Reserva (Form)

Essa região tem como objetivo mostrar ao usuário os detalhes da reserva de outro usuário, não permitindo ele fazer alteração dos valores, sendo todos apenas leitura. Caso o tipo da reserva for 'Mezanino', uma sub-região de relatório interativo será exibida para mostrar os horários dessa reserva.

- `P201_ID_RESERVA` - Oculto - Identificador da Reserva.
- `P201_TITULO_RESERVA` - Área de Texto - Título do evento da reserva.
- `P201_DES_RESERVA` - Área de Texto - Descrição do evento da reserva.
- `P201_TIP_RESERVAS` - Lista de Seleção - Tipo da reserva.
- `P201_DAT_INICIO` - Seletor de Data - Data de início do evento.
- `P201_DAT_FIM` - Seletor de Data - Data de término do evento.
- `P201_LOC` - Área de Texto - Local da reserva.
- `P201_NUM_PARTICIPANTES` - Campo de Texto - Estimativa do número de participantes do evento.
- `P201_OBSERVACAO` - Área te Texto - Observação da reserva.
- `P201_NOM_PESSOA` - Área de Texto - Nome do solicitante.
- `P201_JUSTIFICATIVA` - Área de Texto - Campo para o usuário da ASQUALOG colocar a justificativa da sua decisão sobre a reserva.
<br>

#### 2.1 - Datas Mezanino (Relatório Interativo)

Essa região mostra as datas e horários de uma reserva, caso ela for do tipo 'Mezanino'.

---

## 3 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem dois botões 'Recusar' e 'Confirmar'.

- `Recusar` - Ativa uma ação dinâmica que roda um JS passando 'Cancelar', o id da reserva, grupo da reserva e justificativa para um processo AJAX 'CONFIRMAR_OU_CANCELAR_RESERVA'.

- `Confirmar` - Ativa uma ação dinâmica que roda um JS passando 'Confirmar', o id da reserva, grupo da reserva e justificativa para um processo AJAX 'CONFIRMAR_OU_CANCELAR_RESERVA'.

#### 3.1 Ação Dinâmica dos Botões

As duas ações dinâmicas chamam o processo 'CONFIRMAR_OU_CANCELAR_RESERVA', mas passam um parâmetro para que ele execute a ação correta. Depois disso, ele chama outro processo AJAX 'GERAR_URL_11', que gera a url para voltar para a página 11 passando o código do grupo para o item responsável por colapsar automaticamente o grupo correto.

---

## 4 - CONFIRMAR_OU_CANCELAR_RESERVA (Processo AJAX Callback)

Esse processo PL/SQL serve para alterar o status de uma reserva para 'Cancelado' ou 'Confirmado', setar a justificativa do setor e inserir um registro de atendimento em relação a tal.

---
