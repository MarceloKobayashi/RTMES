
<div align="center">

<p align="center">
    <h1>RTMES — Workflows e Automações</h1>
</p>

</div>

---

## 🎯 Visão Geral

Este diretório descreve automações e workflows utilizados pelo RTMES. O principal workflow aqui é uma rotina agendada (diária, 06:00) que envia alertas por e-mail ao setor SEQUALOG sobre eventos de totens (porta-banner e porta-cartaz) confirmados e pendentes de comunicação ao patrimônio para os próximos dois meses.

---

## ✅ Automação: `Enviar Email` (resumo)

- Agendamento: diariamente às 06:00
- Objetivo: notificar o setor de patrimônio sobre reservas confirmadas de totens que ainda não foram encaminhadas ao patrimônio

### Script (PL/SQL)

```sql
-- Envia e-mail com alertas de reservas de totens pendentes de envio para patrimônio
DECLARE
    v_email_destino      VARCHAR2(200) := 'sequalog-equipe@senado.gov.br';
    v_email_remetente    VARCHAR2(200) := 'noreply@senado.gov.br';
    v_assunto            VARCHAR2(300) := 'AVISO: Reservas Confirmadas Pendentes de Patrimônio';
    v_mensagem           CLOB;
    v_qtd_grupos         NUMBER := 0;
    v_mes_atual          NUMBER := EXTRACT(MONTH FROM SYSDATE);
    v_ano_atual          NUMBER := EXTRACT(YEAR FROM SYSDATE);
    v_mes_proximo        NUMBER;
    v_ano_proximo        NUMBER;
    v_mes_atual_nome     VARCHAR2(20);
    v_mes_proximo_nome   VARCHAR2(20);

BEGIN
    IF v_mes_atual = 12 THEN
        v_mes_proximo := 1;
        v_ano_proximo := v_ano_atual + 1;
    ELSE
        v_mes_proximo := v_mes_atual + 1;
        v_ano_proximo := v_ano_atual;
    END IF;
    
    SELECT TO_CHAR(TO_DATE(v_mes_atual || '/01/' || v_ano_atual, 'MM/DD/YYYY'), 'Month')
    INTO v_mes_atual_nome
    FROM dual;
    
    SELECT TO_CHAR(TO_DATE(v_mes_proximo || '/01/' || v_ano_proximo, 'MM/DD/YYYY'), 'Month')
    INTO v_mes_proximo_nome
    FROM dual;
    
    SELECT COUNT(*) INTO v_qtd_grupos
    FROM (
        SELECT 
            r.titulo_reserva,
            r.des_reserva,
            r.dat_inicio,
            r.dat_fim,
            r.tip_reservas
        FROM reservas r
        WHERE r.pendente = 'N'
        AND r.status = 'Confirmado'
        AND r.ind_patrimonio = 'N'
        AND r.tip_reservas IN ('Porta-Cartaz', 'Porta-Banner')
        AND (
            (EXTRACT(MONTH FROM r.dat_inicio) = v_mes_atual AND EXTRACT(YEAR FROM r.dat_inicio) = v_ano_atual)
            OR
            (EXTRACT(MONTH FROM r.dat_inicio) = v_mes_proximo AND EXTRACT(YEAR FROM r.dat_inicio) = v_ano_proximo)
        )
        GROUP BY 
            r.titulo_reserva,
            r.des_reserva,
            r.dat_inicio,
            r.dat_fim,
            r.tip_reservas
    );
    
    IF v_qtd_grupos > 0 THEN
        
        v_mensagem := '<html>
                        <head>
                            <meta charset="UTF-8">
                        </head>
                        <body style="font-family: Arial, Helvetica, sans-serif; font-size:14px; color:#333;">
                            <p>Prezados,</p>
                            <p>
                                <b>AVISO:</b> Existem <b style="color:#d9534f;">' || v_qtd_grupos || ' evento(s)</b> confirmado(s) 
                                com <b>pendência de envio para patrimônio</b> nos meses de 
                                <b>' || TRIM(v_mes_atual_nome) || '</b> e <b>' || TRIM(v_mes_proximo_nome) || '</b>.
                            </p>
                            <p>
                                Solicitamos a priorização no envio destas informações para o setor de patrimônio.
                            </p>
                            <p>
                                Para mais detalhes, acesse o sistema ASQUALOG.
                            </p>
                            <br><br>
                            <p>
                                Atenciosamente,<br>
                                <b>RTMES - Reservas de Totens e Mesas - Espaço do Servidor</b><br>
                                Assessoria de Qualidade de Atendimento e Logística<br>
                                Diretoria-Geral<br>
                                + 55 (61) 3303-4536
                            </p>
                        </body>
                    </html>';
        
        APEX_MAIL.SEND (
            p_to        => v_email_destino,
            p_from      => v_email_remetente,
            p_subj      => v_assunto,
            p_body      => NULL,
            p_body_html => v_mensagem
        );
        
        APEX_MAIL.PUSH_QUEUE;
       
        COMMIT;
    END IF;
END;
```

---
