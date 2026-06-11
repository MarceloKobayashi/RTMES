<div align="center">
  <p align="center">
    <h1>109. Visualizar Mezanino</h1>
  </p>
</div>

---
> Página modal que serve para mostrar os detalhes de uma reserva de mezanino já registrada.

## 🎯 Visão geral

A página `109` mostra os detalhes de uma reserva do tipo mezanino. Caso a reserva do horário selecionado não foi confirmada, essa página mostra uma região 'Temporário' com uma mensagem.

---

## 1 - Exibição do temporário (Ação Dinâmica)

Antes de mostrar o conteúdo, faz uma verificação para saber se o horário vem da tabela temporária ou se vem da tabela definitiva. Caso venha da temporária (não tem um id de reserva associado), ele mostra a região 'Temporário'.

---

## 2 - Visualizar Mezanino (Form)

Essa região mostra os detalhes da reserva de mezanino para aquele horário específico.

- `P109_ID_RESERVA` - ID da reserva passada da página `14`, se houver.
- `P109_TITULO_RESERVA` - Título do evento da reserva.
- `P109_DES_RESERVA` - Descrição do evento da reserva.
- `P109_HORA_INICIO` - Hora de início desse horário.
- `P109_HORA_FIM` - Hora de término desse horário.
- `P109_NUM_PARTICIPANTES` - Estimativa do número de participantes desse evento.
- `P109_OBSERVACAO` - Observação da reserva.
- `P109_NOME` - Nome do solicitante.
- `P109_RAMAL` - Ramal do solicitante.
- `P109_SETOR` - Setor do solicitante.

---

## 3 - Temporário (Região Estática)

Região oculta que é exibida somente se o horário não tiver uma reserva associada a ele. Essa região é composta por um HTML que mostra apenas uma frase de que o horário está reservado, mas ainda não tem uma reserva associada.

---

## 4 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem apenas um botão.

- `Fechar` - Fecha a página `109` e volta para a página `14`.

---

FALTA IMAGEM!