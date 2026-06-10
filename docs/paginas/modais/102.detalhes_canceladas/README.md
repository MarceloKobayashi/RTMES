<div align="center">
  <p align="center">
    <h1>102. Detalhes Reservas Canceladas/Realizadas</h1>
  </p>
</div>

---

> Página modal que mostra o histórico de atendimento de uma reserva que foi cancelada pela ASQUALOG ou que o evento está no passado.

## 🎯 Visão geral

A página `102` contém o histórico completo do atendimento de uma reserva, com data e hora, descrição e nome do responsável por cada etapa do atendimento.

---

## 1 — Atendimento (Relatório Interativo)

Essa região tem como objetivo mostrar ao usuário os registros de atendimento dessa reserva, como 'Registro da Solicitação', 'Reserva confirmada para realização'. Além disso, também mostra a data e hora que foi feita tal etapa e quem realizou tal etapa do atendimento.

```sql
select PK_ATENDIMENTO_RESERVAS,
       -- Ícone para o estado da reserva na etapa específica
       CASE
        WHEN CONFIRMADO = 'S' THEN '<span class="fa fa-check-circle" style="color:green;"></span>'
        WHEN CONFIRMADO = 'N' THEN '<span class="fa fa-check-circle" style="color:red;"></span>'
        ELSE ''
       END AS icone_confirmação,
       TO_CHAR(DAT_CRIACAO_ATENDIMENTO, 'DD/MM/YYYY HH24:MI:SS') as data_hora,
       DES_ATENDIMENTO,
       'por ' || NOM_ATENDIMENTO as responsavel,
       FK_ATENDIMENTO_RESERVAS_RESERVAS,
       CONFIRMADO
  from ATENDIMENTO_RESERVAS
  where fk_atendimento_reservas_reservas = :P102_ID_RESERVA
  order by dat_criacao_atendimento DESC;
```
---