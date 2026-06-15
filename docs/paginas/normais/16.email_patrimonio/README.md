<div align="center">
  <p align="center">
    <h1>16. Email Patrimônio</h1>
  </p>
</div>

---

> Página que permite a ASQUALOG a informar o Patrimônio sobre os locais que os porta- devem estar.

## 🎯 Visão geral

A página `16` é a página que mostra todas as reservas do tipo 'Porta-Banner' e 'Porta-Cartaz' desse com evento nesse e no próximo mês, informando se já foi avisado para o patrimônio. Além disso, o usuário pode selecionar aquelas que não foram avisadas e mandar um e-mail ao patrimônio informando sobre elas.

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

- `P16_NOME_EVENTO` - Campo de Texto - Permite o usuário escrever uma palavra-chave de um evento específico.
<br>

- `P16_TIPO` - Caixa de Combinação - Mostra os tipos de reserva e permite o usuário a selecionar quantos ele 
quiser.
<br>

- `P16_DATA_INICIO` - Seletor de Data - Intervalo de início de data da reserva.
- `P16_DATA_FIM` - Seletor de Data - Intervalo de término de data da reserva.
<br>

- `P16_LOCAL` - Caixa de Combinação - Mostra os locais predefinidos na tabela estática, mas o usuário pode digitar algum manualmente.
<br>

- `P16_LIXO` - Oculto - Armazena as entradas manuais dos itens do tipo caixa de combinação.

Além disso, essa região possui um botão 'Limpar Filtro' que reseta o valor de todos os itens de página.

---

## 3 - Todas as Reservas (Relatório Interativo)

Essa região mostra todas as reservas com seus respectivos detalhes filtradas com os valores dos itens de página. Além disso, ele faz um agrupamento de locais, para que uma reserva de porta- com n locais seja exibido em apenas uma linha e não em n linhas. Com um campo adicional de checkbox para selecionar as reservas que serão enviadas com foco no email.

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
    max(r.obs_asqualog) as obs_asqualog,
    max(r.ind_patrimonio) as ind_patrimonio,
    apex_item.checkbox2(p_idx => 1, p_value => MAX(r.id_reserva)) as sel
FROM reservas r
JOIN dda.vinculo_sf v ON v.num_cpf = LPAD(TO_CHAR(r.cod_pessoa), 11, '0')
JOIN dda.orgao o ON o.sgl_orgao = v.sgl_orgao_exercicio
WHERE r.pendente = 'N'
AND v.ind_vinculo_ativo = 'S'
AND TRUNC(r.dat_inicio) >= TO_DATE('01/03/' || EXTRACT(YEAR FROM SYSDATE), 'DD/MM/YYYY')
--AND TRUNC(r.dat_inicio) >= TRUNC(SYSDATE)
AND r.status = 'Confirmado'
AND r.tip_reservas IN ('Porta-Banner', 'Porta-Cartaz')
AND (
  :P16_NOME_EVENTO IS NULL OR 
  REGEXP_LIKE(UPPER(r.titulo_reserva), '(^| )' || UPPER(:P16_NOME_EVENTO))
)

AND (:P16_DATA_INICIO IS NULL OR r.dat_inicio >= TO_DATE(:P16_DATA_INICIO, 'DD/MM/YYYY'))
AND (:P16_DATA_FIM IS NULL OR r.dat_inicio <= TO_DATE(:P16_DATA_FIM, 'DD/MM/YYYY'))
AND (:P16_TIPO IS NULL OR r.tip_reservas IN (
        SELECT column_value
        FROM TABLE(apex_string.split(:P16_TIPO, ':'))
    ))
AND (:P16_LOCAL IS NULL OR r.loc IN (
        SELECT column_value
        FROM TABLE(apex_string.split(:P16_LOCAL, ':'))
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

Além disso, existe um botão que submete a página e roda o processo 'Email para Patrimônio', que seta as reservas selecionadas como 'S' em 'ind_patrimonio' e envia um email ao patrimônio avisando sobre essas reservas.

- Monta o corpo do email com duas tabelas, uma com as reservas selecionadas antes de mandar o email e outra com todas as reservas desse mês e do próximo que já foram enviados ao patrimônio, para reforçar o conhecimento delas.

---