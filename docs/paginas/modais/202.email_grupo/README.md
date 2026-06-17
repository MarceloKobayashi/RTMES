<div align="center">
  <p align="center">
    <h1>202. Enviar Email Reserva</h1>
  </p>
</div>

---

> Página modal que permite a ASQUALOG revisar o grupo de reservas antes de confirmar sua decisão.

## 🎯 Visão geral

A página `202` contém todas as reservas de um grupo de reservas, menos aquelas que foram canceladas pelo próprio solicitante, para que o responsável da ASQUALOG possa confirmar as decisões feitas em relação à elas.

---

## 1 — Grupo (Relatório Interativo)

Essa região tem como objetivo mostrar ao usuário as reservas do grupo, com exceção àquelas canceladas pelo próprio solicitante, e seus detalhes, para que ele possa confirmar e revisar suas decisões acerca delas.

---

## 2 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, contém apenas um botão 'Confirmar e Enviar E-mail'.

- `Confirmar e Enviar E-mail` - Submete a página, rodando o processo PL/SQL 'Confirmar escolhas e enviar email' que quando processado, fecha essa página e redireciona o usuário para a página 11.
    + Verifica se todas as reservas do grupo foram analisadas.
    + Monta o corpo do e-mail com a resposta da ASQUALOG sobre as reservas do solicitante. Ela será separada por eventos e se foi cancelada ou confirmada.
    <br>

    + Atualiza um índice (coluna 'email_enviado') de todas as reservas para 'S'.
    + Envia o e-mail para o solicitante e para a equipe SEQUALOG.

---
