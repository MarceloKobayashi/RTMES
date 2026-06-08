<div align="center">
  <p align="center">
    <h1>2. Minhas Reservas</h1>
  </p>
</div>

---

> Página que mostra todas as reservas referentes ao usuário.

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

```SQL
SELECT r.id_reserva,
       r.dat_inicio,
       r.dat_fim,
       r.tip_reservas,
       r.status,
       CASE 
         WHEN r.num_participantes IS NULL THEN '---' 
         ELSE TO_CHAR(r.num_participantes) 
       END AS num_participantes,
       r.titulo_reserva,
       r.des_reserva,
       r.cod_pessoa,
       r.pendente,
       CASE 
         WHEN r.loc IS NULL THEN 'N/A' 
         ELSE r.loc 
       END AS loc,
       r.justificativa,
       CASE 
         WHEN r.obs IS NULL THEN 'N/A' 
         ELSE r.obs 
       END AS obs,
       v.nom_pessoa,
       dbms_lob.getlength(r.arq) AS arq,
       r.mimetype,
       r.filename
FROM reservas r
JOIN dda.vinculo_sf v 
  ON v.num_cpf = LPAD(TO_CHAR(r.cod_pessoa), 11, '0')
WHERE r.status NOT IN ('Cancelado', 'Realizado', 'Confirmado')
  AND r.pendente = 'N'
  AND v.ind_vinculo_ativo = 'S'
  AND (
      (:P2_EXIBIR = 'usuario' AND LPAD(TO_CHAR(r.cod_pessoa), 11, '0') = 
        (
            SELECT num_cpf_pessoa
            FROM dda.usuario_rede
            WHERE :APP_USER = txt_login_ad
                AND nom_situacao_login_ad = 'ATIVO'
        )
      )
      OR
      (:P2_EXIBIR = 'setor' AND v.sgl_orgao_exercicio IN (
          SELECT o.sgl_orgao
          FROM dda.orgao o 
          WHERE o.sgl_orgao_hierarquia LIKE '%' || (
              SELECT sgl_orgao_exercicio 
              FROM dda.vinculo_sf 
              WHERE ind_vinculo_ativo = 'S' 
                AND num_cpf =
                    (
                        SELECT num_cpf_pessoa
                        FROM dda.usuario_rede
                        WHERE :APP_USER = txt_login_ad
                            AND nom_situacao_login_ad = 'ATIVO'
                    )
                AND ROWNUM = 1
          ) || '%'
      ))
  )
  AND (:P2_FILTRO IS NULL OR r.tip_reservas = :P2_FILTRO)
  AND (:P2_INICIO IS NULL OR r.dat_inicio >= :P2_INICIO)
  AND (:P2_FIM IS NULL OR r.dat_inicio <= :P2_FIM)
  AND (
      :P2_TITULO IS NULL OR 
      REGEXP_LIKE(UPPER(r.titulo_reserva), '(^| )' || UPPER(:P2_TITULO))
  )
  AND (
      :P2_SOLICITANTE IS NULL
      OR LPAD(TO_CHAR(r.cod_pessoa), 11, '0') IN (
        SELECT TRIM(COLUMN_VALUE)
        FROM TABLE(apex_string.split(:P2_SOLICITANTE, ':'))
      )
  )
  AND (
      :P2_SETOR IS NULL
      OR LPAD(TO_CHAR(r.cod_pessoa), 11, '0') IN (
            SELECT v.num_cpf
            FROM dda.vinculo_sf v
            WHERE v.ind_vinculo_ativo = 'S'
                AND v.sgl_orgao_exercicio IN (
                    SELECT TRIM(COLUMN_VALUE)
                    FROM TABLE(apex_string.split(:P2_SETOR, ':'))
                )  
      )
  )
ORDER BY v.nom_pessoa, r.dat_inicio, r.tip_reservas, r.id_reserva;
```

Além de que o link é setado para a página modal 101 de detalhes das confirmadas passando o id da reserva.

---

## 4 — Reservas Confirmadas (Região Estática)

Essa região tem como objetivo mostrar ao usuário reservas que foram confirmadas pela ASQUALOG. Para isso, ela apresenta um relatório interativo que mostra tais reservas, com um botão a esquerda de cada linha para ver os detalhes da reserva e do atendimento dela. Além de um botão 'Cancelar Reservas' que leva o usuário para a página 5.

#### Reservas Confirmadas (Relatório Interativo)

Mostra as reservas que foram confirmadas pelo setor responsável.

```SQL
SELECT r.id_reserva,
       r.dat_inicio,
       r.dat_fim,
       r.tip_reservas,
       r.status,
       CASE 
         WHEN r.num_participantes IS NULL THEN '---' 
         ELSE TO_CHAR(r.num_participantes) 
       END AS num_participantes,
       r.titulo_reserva,
       r.des_reserva,
       r.cod_pessoa,
       r.pendente,
       CASE 
         WHEN r.loc IS NULL THEN 'N/A' 
         ELSE r.loc 
       END AS loc,
       r.justificativa,
       CASE 
         WHEN r.obs IS NULL THEN 'N/A' 
         ELSE r.obs
       END AS obs,
       v.nom_pessoa,
       dbms_lob.getlength(r.arq) AS arq,
       r.mimetype,
       r.filename
FROM reservas r
JOIN dda.vinculo_sf v 
  ON v.num_cpf = LPAD(TO_CHAR(r.cod_pessoa), 11, '0')
WHERE r.status NOT IN ('Cancelado', 'Realizado', 'Em Andamento')
  AND r.pendente = 'N'
  AND v.ind_vinculo_ativo = 'S'
  AND (
      (:P2_EXIBIR = 'usuario' AND LPAD(TO_CHAR(r.cod_pessoa), 11, '0') = 
        (
            SELECT num_cpf_pessoa
            FROM dda.usuario_rede
            WHERE :APP_USER = txt_login_ad
                AND nom_situacao_login_ad = 'ATIVO'
        )
      )
      OR
      (:P2_EXIBIR = 'setor' AND v.sgl_orgao_exercicio IN (
          SELECT o.sgl_orgao
          FROM dda.orgao o 
          WHERE o.sgl_orgao_hierarquia LIKE '%' || (
              SELECT sgl_orgao_exercicio
              FROM dda.vinculo_sf
              WHERE ind_vinculo_ativo = 'S'
                AND num_cpf = 
                    (
                        SELECT num_cpf_pessoa
                        FROM dda.usuario_rede
                        WHERE :APP_USER = txt_login_ad
                            AND nom_situacao_login_ad = 'ATIVO'
                    )
                AND ROWNUM = 1
          ) || '%'
      ))
  )
  AND (:P2_FILTRO IS NULL OR r.tip_reservas = :P2_FILTRO)
  AND (:P2_INICIO IS NULL OR r.dat_inicio >= :P2_INICIO)
  AND (:P2_FIM IS NULL OR r.dat_inicio <= :P2_FIM)
  AND (
      :P2_TITULO IS NULL OR 
      REGEXP_LIKE(UPPER(r.titulo_reserva), '(^| )' || UPPER(:P2_TITULO))
  )
  AND (
      :P2_SOLICITANTE IS NULL
      OR LPAD(TO_CHAR(r.cod_pessoa), 11, '0') IN (
        SELECT TRIM(COLUMN_VALUE)
        FROM TABLE(apex_string.split(:P2_SOLICITANTE, ':'))
      )
  )
  AND (
      :P2_SETOR IS NULL
      OR LPAD(TO_CHAR(r.cod_pessoa), 11, '0') IN (
            SELECT v.num_cpf
            FROM dda.vinculo_sf v
            WHERE v.ind_vinculo_ativo = 'S'
                AND v.sgl_orgao_exercicio IN (
                    SELECT TRIM(COLUMN_VALUE)
                    FROM TABLE(apex_string.split(:P2_SETOR, ':'))
                )  
      )
  )
ORDER BY v.nom_pessoa, r.dat_inicio, r.tip_reservas, r.id_reserva
```

O link também é setado para a página modal 101 de detalhes das confirmadas passando o id da reserva.

---

## 5 — Reservas Canceladas/Realizadas (Região Estática)

Essa região tem como objetivo mostrar ao usuário reservas que foram recusadas pela ASQUALOG ou que tem a data de término mais antiga que hoje. Para isso, ela apresenta um relatório interativo que mostra tais reservas, com um botão a esquerda de cada linha para ver os detalhes da reserva e do atendimento dela.

#### Reservas Realizadas/Canceladas (Relatório Interativo)

Mostra as reservas que foram canceladas pelo setor responsável ou que já passaram.

```SQL
SELECT r.id_reserva,
       r.dat_inicio,
       r.dat_fim,
       r.tip_reservas,
       r.status,
       CASE 
         WHEN r.num_participantes IS NULL THEN '---' 
         ELSE TO_CHAR(r.num_participantes) 
       END AS num_participantes,
       r.titulo_reserva,
       r.des_reserva,
       r.cod_pessoa,
       r.pendente,
       CASE 
         WHEN r.loc IS NULL THEN 'N/A' 
         ELSE r.loc 
       END AS loc,
       r.justificativa,
       CASE 
         WHEN r.obs IS NULL THEN 'N/A' 
         ELSE r.obs 
       END AS obs,
       v.nom_pessoa,
       dbms_lob.getlength(r.arq) AS arq,
       r.mimetype,
       r.filename
FROM reservas r
JOIN dda.vinculo_sf v 
  ON v.num_cpf = LPAD(TO_CHAR(r.cod_pessoa), 11, '0')
WHERE r.status IN ('Cancelado', 'Realizado')
  AND r.dat_inicio >= ADD_MONTHS(TRUNC(SYSDATE), -1)
  AND v.ind_vinculo_ativo = 'S'
  AND (
      (:P2_EXIBIR = 'usuario' AND LPAD(TO_CHAR(r.cod_pessoa), 11, '0') = 
        (
            SELECT num_cpf_pessoa
            FROM dda.usuario_rede
            WHERE :APP_USER = txt_login_ad
                AND nom_situacao_login_ad = 'ATIVO'
        )
      )
      OR
      (:P2_EXIBIR = 'setor' AND v.sgl_orgao_exercicio IN (
          SELECT o.sgl_orgao
          FROM dda.orgao o 
          WHERE o.sgl_orgao_hierarquia LIKE '%' || (
              SELECT sgl_orgao_exercicio 
              FROM dda.vinculo_sf 
              WHERE ind_vinculo_ativo = 'S'
                AND num_cpf = 
                    (
                        SELECT num_cpf_pessoa
                        FROM dda.usuario_rede
                        WHERE :APP_USER = txt_login_ad
                            AND nom_situacao_login_ad = 'ATIVO'
                    )
                AND ROWNUM = 1
          ) || '%'
      ))
  )
  AND (:P2_FILTRO IS NULL OR r.tip_reservas = :P2_FILTRO)
  AND (:P2_INICIO IS NULL OR r.dat_inicio >= :P2_INICIO)
  AND (:P2_FIM IS NULL OR r.dat_inicio <= :P2_FIM)
  AND (
      :P2_TITULO IS NULL OR 
      REGEXP_LIKE(UPPER(r.titulo_reserva), '(^| )' || UPPER(:P2_TITULO))
  )
  AND (
      :P2_SOLICITANTE IS NULL
      OR LPAD(TO_CHAR(r.cod_pessoa), 11, '0') IN (
        SELECT TRIM(COLUMN_VALUE)
        FROM TABLE(apex_string.split(:P2_SOLICITANTE, ':'))
      )
  )
  AND (
      :P2_SETOR IS NULL
      OR LPAD(TO_CHAR(r.cod_pessoa), 11, '0') IN (
            SELECT v.num_cpf
            FROM dda.vinculo_sf v
            WHERE v.ind_vinculo_ativo = 'S'
                AND v.sgl_orgao_exercicio IN (
                    SELECT TRIM(COLUMN_VALUE)
                    FROM TABLE(apex_string.split(:P2_SETOR, ':'))
                )  
      )
  )
ORDER BY v.nom_pessoa, r.dat_inicio ASC, r.tip_reservas ASC, r.id_reserva ASC;
```

Além de que o link é setado para a página modal 102 de detalhes das canceladas passando o id da reserva.


