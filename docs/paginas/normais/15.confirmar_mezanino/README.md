<div align="center">
  <p align="center">
    <h1>15. Confirmar Mezanino</h1>
  </p>
</div>

---

> Página que mostra as reservas de mezanino que serão solicitadas.

## 🎯 Visão geral

A página `15` contém todas as reservas de mezanino que estão sendo registradas. Após o responsável clicar no botão 'Enviar Solicitações', tais reservas serão confirmadas no sistema.

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

---

## 2 - Reservas Pendentes (Relatório Interativo)

Essa região mostra as reservas de mezanino a serem confirmadas no sistema. Nela existe um relatório interativo, cujo 'link' de cada linha abre a página modal `106` que permite o usuário a deletar tal reserva.

```sql
SELECT r.ID_RESERVA,
       r.DAT_INICIO,
       r.DAT_FIM,
       r.TIP_RESERVAS,
       r.STATUS,
       r.NUM_PARTICIPANTES,
       r.TITULO_RESERVA,
       r.DES_RESERVA,
       r.COD_PESSOA,
       INITCAP(v.nom_pessoa) AS solicitante,
       r.LOC,
       r.OBS,
       dbms_lob.getlength(r.ARQ) AS foto
FROM RESERVAS r
LEFT JOIN dda.vinculo_sf v ON v.num_cpf = LPAD(r.cod_pessoa, 11, '0')
WHERE r.pendente = 'S'
  AND r.tip_reservas = 'Mezanino'
```
<br>

#### Barra de Botões (Sub Região - Região Estática)

Essa região serve apenas para organizar os botões abaixo do relatório interativo. Nela existem dois botões:

- `Cancelar` - Apenas redireciona o usuário para a página `14`, para continuar a solicitação.
- `Create` - Submete a página, rodando o processo PL/SQL 'Alterar o Campo Pendente'. Esse processo é extenso, mas quebrando por partes faz o seguinte:
    + Tira essas reservas da pendências.
    + Cria um corpo de e-mail com as reservas atuais e com a confirmação que a solicitação foi feita, e envia ele para o solicitante e para o setor ASQUALOG.

Depois de rodar esse processo, o usuário é redirecionado para a página `1`.

---
