<div align="center">
  <p align="center">
    <h1>107. Horário Mezanino</h1>
  </p>
</div>

---

> Página modal que serve para adicionar uma data e horário de mezanino durante o cadastro de uma reserva.

## 🎯 Visão geral

A página `107` contém os campos necessários para adicionar uma data e horário para a reserva de mezanino atual na tabela temporária de horários. Além de um botão 'Adicionar Horário' que roda um processo para inserir esse horário.

---

## 1 - Horario Mezanino (Form)

Essa região mostra os itens de página necessários para inserir uma data e horário na tabela temporária de horários.

- `P107_ID_TEMP` - Oculto
- `P107_CPF_SOLICITANTE` - Campo de Texto - CPF do solicitante.
- `P107_DAT` - Seletor de Data - Data que os horários pertencem.
- `P107_HOR_INICIO` - Campo de Texto - Horário de início do intervalo.
- `P107_HOR_FIM` - Campo de Texto - Horário de término do intervalo.
    * Os campos de horário tem ações dinâmicas para liberar tecla e para quando terminarem de digitar no item.
        + `Formatar hora_` - A cada dígito digitado, formata para hh:mm.
        + `Verificar hora_` - Quando sair do item de horário, faz a verificação para ver se a hora é válida.
    <br>

- `P107_ERROR_MESSAGE` - Oculto - Seu valor é definido quando ocorre erro na inserção do horário.

---

## 2 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem dois botões.

- `Fechar` - Fecha a página `107` e volta para a página `14`.
- `Adicionar Horário` - Ativa uma ação dinâmica que roda um processo PL/SQL para validar o horário e inserir ele na tabela temporária, e um código JS que mostra no apex.message a mensagem de resultado do processo.

---

FALTA IMAGEM!