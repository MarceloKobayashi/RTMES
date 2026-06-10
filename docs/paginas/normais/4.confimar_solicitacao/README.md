<div align="center">
  <p align="center">
    <h1>4. Confirmar Solicitação</h1>
  </p>
</div>

---

> Página que mostra as reservas do usuário que serão solicitadas.

## 🎯 Visão geral

A página `4` contém todas as reservas que o usuário deseja solicitar separadas por evento e tipo. Após o usuário clicar no botão 'Enviar Solicitações', tais reservas serão enviadas para a ASQUALOG fazer suas análises.

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

---

## 2 - Reservas Pendentes (Relatório Interativo)

Essa região mostra as reservas a serem solicitadas pelo usuário, com um diferencial que é o agrupamento das reservas caso o evento, tipo, datas e status forem os mesmos, a fim de que os locais sejam exibidos em uma célula apenas.

```sql
SELECT r.DAT_INICIO,
       r.DAT_FIM,
       r.TIP_RESERVAS,
       r.STATUS,
       LPAD(max(r.cod_pessoa), 11, '0') AS cpf,
       r.TITULO_RESERVA,
       r.DES_RESERVA,
       max(r.num_participantes),
       LISTAGG('- ' || LOC, '<br>')
            WITHIN GROUP (ORDER BY LOC) AS LOCAIS,
       max(r.OBS)
FROM RESERVAS r
WHERE r.pendente = 'S'
  AND r.tip_reservas <> 'Mezanino'
  AND LPAD(r.COD_PESSOA, 11, '0') = 
      (
        SELECT num_cpf_pessoa
        FROM dda.usuario_rede
        WHERE :APP_USER = txt_login_ad
            AND nom_situacao_login_ad = 'ATIVO'
      )
  AND EXISTS (
      SELECT 1
      FROM dda.vinculo_sf v
      WHERE v.num_cpf = LPAD(r.COD_PESSOA, 11, '0')
        AND v.ind_vinculo_Ativo = 'S'
  )
  GROUP BY
    titulo_reserva,
    des_reserva,
    tip_reservas,
    dat_inicio,
    dat_fim,
    status
```
<br>

#### Barra de Botões (Sub Região - Região Estática)

Essa região serve apenas para organizar os botões abaixo do relatório interativo. Nela existem dois botões:

- `Cancelar` - Apenas redireciona o usuário para a página `3`, para continuar a solicitação.
- `Create` - Submete a página, rodando o processo PL/SQL 'Alterar o Campo Pendente'. Esse processo é extenso, mas quebrando por partes faz o seguinte:
    + Seta um grupo de reservas para essas reservas.
    + Insere o registro da solicitação no atendimento.
    + Tira essas reservas da pendências.
    + Cria um corpo de e-mail com as reservas atuais e com a confirmação que a solicitação foi feita, e envia ele para o solicitante e para o setor ASQUALOG.

Depois de rodar esse processo, o usuário é redirecionado para a página `2` de suas reservas.

---
