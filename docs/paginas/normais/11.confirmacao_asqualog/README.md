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

Essa região utiliza do item de página oculto 'P11_ID_GRUPO_ATIVO' para colapsar o grupo de reservas.

Etapas:

- Região dinâmica monta os grupos em acordeões colapsáveis, uma área vazia para os dados de um grupo específico serem exibidos e gera 3 botões para os grupos:
  + `Mandar e-mail` - Abre a página 202.
  + `Gerar Texto para a OS` - Abre a página 205.
  + `Confirmar Grupo` - Abre a página 206.
<br>

- Quando um usuário abre um grupo, a função toggleRegion() do JS é executada, expandindo o grupo e mostrando as reservas dele em um relatório interativo. Para isso acontecer, ela chama o processo AJAX LOAD_REPORT_BY_GROUP que recebe o código do grupo e pesquisa todas as reservas daquele grupo, montando essa tabela com dois botões:
  + `Analisar Reserva (Olhinho)` - Abre a página 201.
  + `Download de Arquivo (Upload)` - Abre a página 203.
  O JS recebe essa tabela e coloca dentro da região vazia da região dinâmica.


#### 2.1 - Analisar Reserva / Olhinho (Botão)

Quando um usuário clica no ícone de olho, ele abre a página modal `201` para analisar uma reserva. Caso ele avalie a reserva como confirmada ou cancelada, o usuário é redirecionado para a página `11` passando o valor do código de grupo daquela reserva para o item P11_ID_GRUPO_ATIVO, que colapsa automaticamente o grupo por meio da função JS abrirGrupoAtivo().

---

## 3 - Filtro (Região Estática)

Essa região contém diversos itens de página que o usuário pode colocar um valor para filtrar o calendário e o relatório interativo de reservas confirmadas. Todos os itens tem uma ação dinâmica associada à mudança de valor deles que atualiza as regiões de reservas confirmadas.

- `P11_TITULO` - Campo de Texto - Palavra-chave para pesquisar as reservas.
- `P11_SETOR` - Caixa de Combinação - Setores que possuem ao menos uma reserva cadastrada no sistema.
- `P11_FILTRO` - Lista de Seleção - Tipo de reserva.
- `P11_INICIO` - Seletor de Data - Data de início do intervalo de busca.
- `P11_FIM` - Seletor de Data - Data de término do intervalo de busca.
- `P11_LIXO` - Oculto - Campo para armazenar as entradas manuais dos itens do tipo caixa de combinação.

---

## 4 - Calendário Reservas Confirmadas (Região Estática)

Essa região contém o calendário das reservas confirmadas e uma região de legenda das cores de cada evento do calendário.

#### 4.1 - Calendário (Calendário)

Esse calendário exibe todas as reservas que tem o status 'Confirmado' ou 'Realizado' filtrados pelos itens da região de filtro. O seu único diferencial é a coluna 'css_class' que é utilizada no CSS da página para colorir as reservas de acordo com o tipo dela.

```sql
SELECT ID_RESERVA,
       DAT_INICIO,
       DAT_FIM,
       TIP_RESERVAS,
       STATUS,
       NUM_PARTICIPANTES,
       TITULO_RESERVA,
       DES_RESERVA,
       COD_PESSOA,
       PENDENTE,
       LOC,
       JUSTIFICATIVA,
       OBS,
       dbms_lob.getlength(ARQ) as foto,
       MIMETYPE,
       FILENAME,
       CASE 
            WHEN TITULO_RESERVA IS NOT NULL AND LOC IS NOT NULL THEN 
                tip_reservas || ' - ' || TITULO_RESERVA || ' - ' || LOC
            WHEN TITULO_RESERVA IS NOT NULL AND LOC IS NULL THEN 
                tip_reservas || ' - ' || TITULO_RESERVA
       END AS exibir,
       CASE 
            WHEN tip_reservas = 'Adesivagem' THEN 'adesivagem'
            WHEN tip_reservas = 'Mezanino' THEN 'mezanino'
            WHEN tip_reservas = 'Porta-Banner' THEN 'porta-banner'
            WHEN tip_reservas = 'Porta-Cartaz' THEN 'porta-cartaz'
       END AS css_class
FROM RESERVAS r
JOIN (
    SELECT num_cpf,
           MAX(sgl_orgao_exercicio) KEEP (DENSE_RANK LAST ORDER BY dat_inicio_vinculo) 
             AS sgl_orgao_exercicio
    FROM dda.vinculo_sf
    WHERE ind_vinculo_ativo = 'S'
    GROUP BY num_cpf
) v
   ON v.num_cpf = LPAD(r.cod_pessoa, 11, '0')
WHERE status IN ('Confirmado', 'Realizado')
  AND (:P11_FILTRO IS NULL OR tip_reservas = :P11_FILTRO)
  AND (:P11_INICIO IS NULL OR dat_inicio >= :P11_INICIO)
  AND (:P11_FIM IS NULL OR dat_inicio <= :P11_FIM)
  AND (
        :P11_TITULO IS NULL OR 
        REGEXP_LIKE(UPPER(titulo_reserva), '(^| )' || UPPER(:P11_TITULO))
      )
  AND (
        :P11_SETOR IS NULL OR 
        v.sgl_orgao_exercicio IN (
            SELECT TRIM(COLUMN_VALUE)
            FROM TABLE(apex_string.split(:P11_SETOR, ':'))
        )
      )
```

#### 4.2 - Legenda (Região Estática)

Essa região é composta por um HTML que motra uma bolinha colorida e o nome do tipo de reserva associada a essa cor ao lado.

---

## 5 - Reservas Confirmadas (Relatório Interativo)

Essa região contém as mesmas reservas que na região do calendário, mas em formato de relatório interativo. Cada linha representa um mesmo evento (mesmo título, tipo, datas) com seus vários locais, se houver.

---
