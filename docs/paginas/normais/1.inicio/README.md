<div align="center">
  <p align="center">
    <h1>1. Início/Home</h1>
  </p>
</div>

---

> Página inicial com botões para redirecionar os usuários.

## 🎯 Visão geral

A página `1` contém os ícones que redirecionam o usuário para outras páginas da aplicação, como se fosse a Central de Serviços do SF.

---

## Deletar Reservas não Feitas (Ação Dinâmica)

Antes de qualquer coisa, quando um usuário acessa essa página, essa ação dinâmica é ativada e roda um PL/SQL que deleta as reservas que não foram confirmadas pelo solicitante, ou seja, um usuário começou a fazer a reserva e não finalizou o pedido.
```SQL
BEGIN
  DELETE FROM HORARIOS_MEZANINO
  WHERE ID_RESERVA IN (
      SELECT ID_RESERVA
      FROM RESERVAS
      WHERE DAT_CRIACAO < TRUNC(SYSDATE)
        AND PENDENTE = 'S'
  );

  DELETE FROM TMP_RESERVAS
  WHERE DAT_CRIACAO < TRUNC(SYSDATE);

  DELETE FROM ATENDIMENTO_RESERVAS
  WHERE FK_ATENDIMENTO_RESERVAS_RESERVAS IN (
      SELECT ID_RESERVA
      FROM RESERVAS
      WHERE PENDENTE = 'S'
        AND DAT_CRIACAO < TRUNC(SYSDATE)
  );

  DELETE FROM RESERVAS
  WHERE DAT_CRIACAO < TRUNC(SYSDATE)
    AND PENDENTE = 'S';

  COMMIT;
END;
```
### Observação

Além de rodar isso no carregamento da página, o JS utiliza do item de página P1_ASQUALOG para verificar o setor do usuário e exibe apenas os ícones permitidos.

---

## 1 — Barra de Pesquisas (Região Estática)

Essa região tem como objetivo permitir que o usuário possa filtrar os botões com base no que ele quer ao digitar algo nela.

Ela é composta por um HTML/CSS/JS composto por um input.
```HTML
<input type="text" class="search-input" placeholder="Digite sua busca...">
    <button type="button" class="search-button" disabled>
      <i class="fa fa-search"></i>
    </button>
```

Quando um usuário digita algo nela, um JS definido na região 'Função e Declaração de Variáveis Global' roda para filtrar as regiões. Primeiro ele roda a função `debounce` para dar uma pausa a cada letra digitada antes de filtrar, depois aciona a função `filtrarCards` para ativar os filtros e mostrar os ícones corretos.

---

## 2 - Itens de Página

- `P1_ASQUALOG` - Esse item armazena o setor do usuário atual, para que o JS possa exibir apenas os ícones permitidos.

---

## 3 — Todos os Serviços (Região Estática)

Essa região compreende os botões propriamente ditos, formados por meio de HTML e estilizados com o CSS estabelecido 'Em Linha' da página. Os botões são compostos por uma âncora direcionada a uma página, um ícone central e uma legenda.

Aqui está um exemplo de um botão que leva a página 11, com o ícone de check e legenda 'Análise Asqualog'.
```HTML
<a href="f?p=&APP_ID.:11:&SESSION." class="botao-wrapper asqualog">
        <div class="botao-icone">
            <span class="t-Icon fa fa-check-square-o"></span>
        </div>
        <div class="t-Button-label">Análise Asqualog</div>
    </a>
```
---
