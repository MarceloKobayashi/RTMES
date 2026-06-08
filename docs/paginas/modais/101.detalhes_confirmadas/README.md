<div align="center">
  <p align="center">
    <h1>101. Detalhes Reservas Confirmdas</h1>
  </p>
</div>

---

> Página modal que mostra os detalhes de uma reserva.

## 🎯 Visão geral

A página `2` contém todas as reservas que o usuário fez separadas por 'em Análise', 'Confirmadas' e 'Canceladas/Realizadas'. Permitindo que o usuário possa consultar o histórico de suas reservas, além de filtrar elas e deletá-las.

---

## Atualizar estado das reservas (Ação Dinâmica)

Antes de qualquer coisa, quando um usuário acessa essa página, essa ação dinâmica é ativada e roda dois PL/SQL para setar reservas no passado que não foram aprovadas para 'Cancelado' e reservas no passado que foram confirmadas para 'Realizado', além de um JS para mudar a exibição das reservas entre usuário e setor. 

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

Nessa, em específico, tem um botão 'Fazer_Reserva' que direciona o usuário para a página 3.

---

## 2 - Filtro (Região Estática)

Essa região compreende os itens de página cujo valores serão utilizados nas queries dos relatórios interativos para filtrar eles. Além dos itens, possui um botão de 'Remover_Filtros' que reseta os valores dos itens.

- `P2_EXIBIR` - Grupo de Rádio - Alternar entre reservas do setor e do usuário apenas.
- `P2_TITULO` - Campo de Texto - Palavra-chave para buscar reservas.
- `P2_INICIO` - Seletor de Data - Data de início do intervalo de busca.
- `P2_FIM` - Seletor de Data - Data de fim do intervalo de busca.
- `P2_SOLICITANTE` - Caixa de Combinação - Solicitantes do setor.
- `P2_FILTRO` - Lista de Seleção - Tipo da reserva.
- `P2_LIXO` - Oculto - Guarda os valores manuais dos itens de caixa de combinação.

#### Ação Dinâmica

Todos esses itens, exceto o 'P2_LIXO', ativam uma ação dinâmica quando tem seu valor alterado, para atualizar os relatórios interativos.

#### Botão 'Remover_Filtros'

Esse botão serve para resetar os valores dos itens do filtro e exibir as reservas de forma 'bruta'. Quando o usuário clica nesse botão, uma ação dinâmica é acionada executando um JS, que seta os valores para vazio, e atualizando os relatórios.

---

## 3 — Reservas em Análise (Região Estática)

Essa região tem como objetivo mostrar ao usuário reservas que ele solicitou para a ASQUALOG, mas que ainda não obteve resposta. Para isso, ela apresenta um relatório interativo que mostra tais reservas, com um botão a esquerda de cada linha para ver os detalhes da reserva e do atendimento dela.

#### Reservas em andamento (Relatório Interativo)

Mostra as reservas que ainda não foram analisadas pelo setor responsável.
