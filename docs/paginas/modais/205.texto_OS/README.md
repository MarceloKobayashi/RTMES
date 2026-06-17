<div align="center">
  <p align="center">
    <h1>205. Gerar texto para a OS</h1>
  </p>
</div>

---

> Página modal que permite a ASQUALOG a obter o texto para abertura da OS via e-mail.

## 🎯 Visão geral

A página `205` contém todas as reservas de um grupo de reservas específicos com um botão que envia, utilizando um padrão estabelecido, um texto pronto para abertura da OS.

---

## 1 — ROS (Relatório Interativo)

Essa região tem como objetivo mostrar ao usuário todas as reservas do grupo que estão com status 'Confirmado' com seus respectivos detalhes.

Dentro desse relatório tem um botão 'Gerar Texto' que submete a página, rodando o processo PL/SQL 'Enviar Email com OS' que faz o seguinte:

- Monta o corpo do email com todas as informações das reservas dos grupos, com seus locais.
- Coloca no final, o nome do usuário da ASQUALOG que pediu esse texto.
<br>

- Depois de rodar o processo, redireciona o usuário de volta para a página 11 e mostra uma mensagem de sucesso do envio do email.

---
