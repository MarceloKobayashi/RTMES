<div align="center">
  <p align="center">
    <h1>206. Confirmar reservas do Grupo</h1>
  </p>
</div>

---

> Página modal que permite a ASQUALOG a confirmar todas as reservas de um grupo de uma vez.

## 🎯 Visão geral

A página `206` contém todas as reservas de um grupo de reservas específicos com um campo de justificativa para que o responsável da ASQUALOG possa confirmar várias reservas de uma vez. 

---

## 1 - Setar Justificativa (Ação Dinâmica)

Antes de carregar os valores dos itens de página, essa ação dinâmica é acionada no carregamento da página. Ela ativa um processo PL/SQL que captura, se houver, a primeira justificativa dentre as reservas desse grupo de reservas e coloca esse valor no item de página 'P206_JUSTIFICATIVA'.

```sql
DECLARE
    l_just  VARCHAR2(1000);
BEGIN
    SELECT MAX(justificativa) INTO l_just
    FROM reservas
    WHERE cod_grupo_reserva = :P206_ID_GRUPO
      AND justificativa IS NOT NULL;

    IF l_just IS NULL THEN
        :P206_JUSTIFICATIVA := '';
    ELSE
        :P206_JUSTIFICATIVA := l_just;
    END IF;
END;
```

---

## 2 — Reservas do Grupo (Relatório Interativo)

Essa região tem como objetivo mostrar ao usuário todas as reservas do grupo com seus respectivos detalhes, para que ele possa analisar todas e confirmar, se for o caso.

---

## 3 - P206_JUSTIFICATIVA (Item de Página)

Esse é o único campo da página que pode ter seu valor alterado. Ele serve para que o usuário avaliador possa colocar uma justificativa em relação à decisão de confirmar todas as reservas daquele grupo. Além disso, esse item será enviado para o processo de submissão de página.

---

## 4 - Buttons Container (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, contém apenas um botão 'Confirmar Reservas'.

- `Confirmar Reservas` - Submete a página, rodando o processo PL/SQL 'Confirmar Reservas' que quando processado, fecha essa página e redireciona o usuário para a página 11, abrindo o grupo de reservas lá.

```sql
-- Confirmar Reservas
BEGIN
    UPDATE reservas
       SET status        = 'Confirmado',
           justificativa = :P206_JUSTIFICATIVA
     WHERE cod_grupo_reserva = :P206_ID_GRUPO;

    COMMIT;
END;
```

---
