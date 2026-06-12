<div align="center">
  <p align="center">
    <h1>13. Histórico Geral</h1>
  </p>
</div>

---

> Página que permite a ASQUALOG ver todas as reservas já feitas no sistema e exportá-las.

## 🎯 Visão geral

A página `13` é a página de repositório de todas as reservas que tiveram sua solicitação confirmada pelo solicitante. Nela, o responsável do setor pode filtrar elas para obter um resultado específico e exportá-lo para uma planilha Excel.

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

Nessa, em específico, tem vários botões que permitem a navegação entre as páginas específicas para a ASQUALOG.

- `E-mail Patrimônio` - Redireciona o usuário para a página `16`.
- `Confirmar Reservas` - Redireciona o usuário para a página `11`.
- `Ver Todas Reservas` - Redireciona o usuário para a página `13`.
- `Gerar Relatório` - Redireciona o usuário para a página `12`.

---

## 2 - Filtro (Conteúdo Estático)

Essa região contém itens de página que o usuário pode inserir valores para filtrar o relatório interativo que mostra as reservas. Todos os itens tem uma ação dinâmica acionada na troca de seus valores, que atualiza a região de relatório interativo.

- `P13_COD_GRUPO` - Caixa de Combinação - Mostra todos os códigos de grupo e permite o usuário a selecionar quantos ele quiser.
<br>

- `P13_NOME_EVENTO` - Campo de Texto - Permite o usuário escrever uma palavra-chave de um evento específico.
<br>

- `P13_TIPO` - Caixa de Combinação - Mostra os tipos de reserva e permite o usuário a selecionar quantos ele 
quiser.
<br>

- `P13_DATA_INICIO` - Seletor de Data - Intervalo de início de data da reserva.
- `P13_DATA_FIM` - Seletor de Data - Intervalo de término de data da reserva.
<br>

- `P13_LOCAL` - Caixa de Combinação - Mostra os locais predefinidos na tabela estática, mas o usuário pode digitar algum manualmente.
<br>

- `P13_ORGAO` - Caixa de Combinação - Mostra os setores que tem alguma reserva no sistema.
<br>

- `P13_STATUS` - Caixa de Combinação - Mostra os status das reservas e deixa o usuário escolher.
<br>

- `P13_LIXO` - Oculto - Armazena as entradas manuais dos itens do tipo caixa de combinação.

Além disso, essa região possui um botão 'Limpar Filtro' que reseta o valor de todos os itens de página.

---

## 3 - Todas as Reservas (Relatório Interativo)

Essa região mostra todas as reservas com seus respectivos detalhes filtradas com os valores dos itens de página. Além disso, ele faz um agrupamento de locais, para que uma reserva de porta- com n locais seja exibido em apenas uma linha e não em n linhas. 

```sql
SELECT
    r.titulo_reserva,
    r.des_reserva,
    max(r.obs) as observacao,
    r.dat_inicio,
    r.dat_fim,
    r.tip_reservas,
    LISTAGG('- ' || LOC, '<br>')
            WITHIN GROUP (ORDER BY LOC) AS LOCAIS,
    max(r.num_participantes) as num_participantes,
    max(v.nom_pessoa) as nom_pessoa,
    max(o.sgl_orgao) AS orgao_formatado,
    r.status,
    max(r.cod_pessoa) AS cpf,
    max(r.justificativa) as justificativa,
    max(r.obs_asqualog) as obs_asqualog
FROM reservas r
JOIN dda.vinculo_sf v ON v.num_cpf = LPAD(TO_CHAR(r.cod_pessoa), 11, '0')
JOIN dda.orgao o ON o.sgl_orgao = v.sgl_orgao_exercicio
WHERE r.pendente = 'N'
AND v.ind_vinculo_ativo = 'S'
AND (:P13_COD_GRUPO IS NULL OR r.cod_grupo_reserva IN (
        SELECT TO_NUMBER(column_value)
        FROM TABLE(apex_string.split(:P13_COD_GRUPO, ':'))
    ))
AND (
  :P13_NOME_EVENTO IS NULL OR 
  REGEXP_LIKE(UPPER(r.titulo_reserva), '(^| )' || UPPER(:P13_NOME_EVENTO))
)

AND (:P13_DATA_INICIO IS NULL OR r.dat_inicio >= TO_DATE(:P13_DATA_INICIO, 'DD/MM/YYYY'))
AND (:P13_DATA_FIM IS NULL OR r.dat_inicio <= TO_DATE(:P13_DATA_FIM, 'DD/MM/YYYY'))
AND (:P13_TIPO IS NULL OR r.tip_reservas IN (
        SELECT column_value
        FROM TABLE(apex_string.split(:P13_TIPO, ':'))
    ))
AND (:P13_LOCAL IS NULL OR r.loc IN (
        SELECT column_value
        FROM TABLE(apex_string.split(:P13_LOCAL, ':'))
    ))
AND (:P13_ORGAO IS NULL OR o.sgl_orgao IN (
        SELECT column_value
        FROM TABLE(apex_string.split(:P13_ORGAO, ':'))
    ))
AND (:P13_STATUS IS NULL OR r.status IN (
        SELECT column_value
        FROM TABLE(apex_string.split(:P13_STATUS, ':'))
    ))
GROUP BY
    r.titulo_reserva,
    r.des_reserva,
    r.tip_reservas,
    r.status,
    r.dat_inicio,
    r.dat_fim
ORDER BY r.dat_inicio asc, r.tip_reservas
```
<br>

Além disso, existe um botão que redireciona o usuário para a aba de exportar o relatório interativo filtrado para Excel. O botão 'Baixar Reservas', quando clicado, ativa a ação dinâmica que roda um código JS que faz o seguinte:

- Faz uma automatização dos cliques no relatório interativo para abrir a aba de download.
- Se o tipo selecionado for PDF, ele mostra uma mensagem alerta de que vai demorar um pouco.

---