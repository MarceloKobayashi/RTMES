<div align="center">
  <p align="center">
    <h1>5. Cancelar Reservas</h1>
  </p>
</div>

---

> Página que mostra as reservas confirmadas do usuário, para que ele possa cancelar alguma(s).

## 🎯 Visão geral

A página `5` contém todas as reservas confirmadas que o usuário pode cancelar, por motivo próprio.

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

Nessa, em específico, tem dois botões:

- `Voltar` - Que redireciona o usuário para a página `2`.
- `Cancelar Reservas` - Que submete a página, passando as reservas marcadas para o processo PL/SQL que cancelará tais reservas.

---

## 2 - Reservas Confirmadas (Região Estática)

Essa região mostra as reservas confirmadas do usuário que podem ser canceladas. Nela existe um relatório interativo que utiliza de um item de página 'P5_CPF' para recuperar as reservas corretas.

#### RC (Relatório Interativo)

Mostra as reservas confirmadas do usuário com um campo a mais na tabela: 'Deletar?', na query aparece como 'sel'. Esse campo é um checkbox que está associado com a APEX_APPLICATION.G_F01, que será utilizado no processo PL/SQL para marcar as reservas a serem canceladas.

```sql
SELECT r.id_reserva,
       r.dat_inicio AS "Data de Início",
       r.dat_fim AS "Data de Término",
       r.tip_reservas AS "Tipo",
       r.status AS "Status",
       CASE 
         WHEN r.num_participantes IS NULL THEN '---'
         ELSE TO_CHAR(r.num_participantes) 
       END AS "Estimativa de Pessoas",
       r.titulo_reserva AS "Nome do Evento",
       r.des_reserva AS "Descrição",
       r.cod_pessoa AS "CPF",
       CASE 
         WHEN r.loc IS NULL THEN 'N/A' 
         ELSE r.loc 
       END AS "Local",
       r.justificativa AS "Justificativa",
       CASE 
         WHEN r.obs IS NULL THEN 'N/A' 
         ELSE r.obs
       END AS "Observação",
       v.nom_pessoa AS "Solicitante",
       apex_item.checkbox2(p_idx => 1, p_value => r.id_reserva) as sel
FROM reservas r
JOIN dda.vinculo_sf v 
  ON v.num_cpf = LPAD(TO_CHAR(r.cod_pessoa), 11, '0')
WHERE r.status = 'Confirmado'
  AND r.pendente = 'N'
  AND v.ind_vinculo_ativo = 'S'
  AND (
      :P5_CPF IS NULL
      OR LPAD(TO_CHAR(r.cod_pessoa), 11, '0') IN (
        SELECT TRIM(COLUMN_VALUE)
        FROM TABLE(apex_string.split(:P5_CPF, ':'))
      )
  )
ORDER BY v.nom_pessoa, r.dat_inicio, r.tip_reservas, r.id_reserva
```
<br>
Para que o checkbox funcione, nos detalhes da coluna 'sel', deve desativar em 'Segurança' o item 'Caracteres especiais de escape'.
<br>

---

## 3 - Cancelar Reservas e mandar email (Processo PL/SQL)

Quando o usuário clica no botão 'Cancelar Reservas', ele submete a página e ativa esse processo. Esse processo faz o seguinte:

- Verifica foram selecionadas alguma reserva para deletar.
- Faz um loop no APEX_APPLICATION.G_F01 e seta o status como 'Cancelado'.
- Dentro do loop também adiciona os detalhes dessas reservas numa variável que define o corpo do e-mail.
- No fim do loop, finaliza o corpo do e-mail e manda ele para a ASQUALOG.

---