<div align="center">
  <p align="center">
    <h1>11. Confirmação Asqualog</h1>
  </p>
</div>

---

> Página que permite a ASQUALOG a analisar e avaliar solicitações de reservas.

## 🎯 Visão geral

A página `11` é a página central para o setor responsável pelas reservas, a ASQUALOG, pois mostra as reservas solicitadas que devem ser avaliadas e duas regiões para mostrar as reservas confirmadas e que devem ser feitas, com a possibilidade de filtrá-las.

---

## Alterar status por Tempo (Ação Dinâmica)

Antes de qualquer coisa, quando um usuário acessa essa página, essa ação dinâmica é ativada e roda 2 processos PL/SQL:

- Se uma reserva foi confirmada e já passou, seta seu valor como 'Realizado'.
- Se uma reserva não foi avaliada e já passou, seta seu valor como 'Cancelado'.

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

Nessa, em específico, tem vários botões que permitem a navegação entre as páginas específicas para a ASQUALOG.

- `E-mail Patrimônio` - Redireciona o usuário para a página `16`.
- `Confirmar Reservas` - Redireciona o usuário para a página `11`.
- `Ver Todas Reservas` - Redireciona o usuário para a página `13`.
- `Gerar Relatório` - Redireciona o usuário para a página `12`.

---

## 2 - Grupos de Reservas para Avaliar (Conteúdo Dinâmico)

Essa região exibe um HTML gerado dentro de um PL/SQL que retorna um CLOB (Character Long Object). O HTML gerado mostra todos os grupos de reservas (reservas feitas ao mesmo tempo) como regiões de accordion fechados que quando abertos mostram uma espécie de relatório interativo, também gerado no PL/SQL, com as reservas e botões para gerar texto para abertura de OS baseado nessas reservas, confirmar todas as reservas desse grupo e mandar e-mail ao solicitante em relação a análise dessas reservas. Além disso, o 'link' de cada linha do relatório abre a página modal 201 para que o responsável do setor possa avaliar a reserva.

---
