<div align="center">
  <p align="center">
    <h1>104. Seletor de Datas</h1>
  </p>
</div>

---

> Página modal que serve apenas para o usuário salvar as datas nos campos da página `3`


## 🎯 Visão geral

A página `104` contém apenas dois itens de página que já vem preenchidos com os valores das datas cujo usuário selecionou na página `3`. Apesar disso, nessa página as datas podem ser alteradas pelo usuário também. Além dos itens, tem um botão que 'transfere' os valores para os campos da página `3`.

---

## 1 - Itens de Página

Os itens 'P104_DAT_INICIO' e 'P104_DAT_FIM' tem seus valores setados através dos valores selecionados no calendário da página `3`. Da seguinte forma, em 'Atributos' -> 'Criar Link' -> 'Definir Itens', coloquei &APEX$NEW_START_DATE. e &APEX$NEW_END_DATE. para os itens dessa página.

- `P104_DAT_INICIO` - Seletor de Data
- `P104_DAT_FIM` - Seletor de Data

---

## 2 - Botões (Região Estática)

Região no footer da página modal destinada para botões. Nessa, em específico, tem dois botões.

- `Fechar` - Ativa a ação dinâmica 'Close Dialog' que apenas cancela a página modal `104` e volta para a `3`.
- `Salvar` - Ativa a ação dinâmcia 'Enviar Data' que roda um JS que captura os valores dos itens de página, faz algumas validações e seta os valores na página `3`, fechando o modal.

    + Validações:
        * Data de início não pode ser posterior à data de fim.
        * Data de início não pode ser no passado.
        * Data de início deve ter pelo menos dois dias úteis de antecedência.
        <br>
    + ```js
        // Obter datas dos campos
        var dataInicio = new Date($v("P104_DAT_INICIO"));
        var dataFim = new Date($v("P104_DAT_FIM"));
        var hoje = new Date();
        hoje.setHours(0,0,0,0); // Zera horas para comparar apenas datas

        // Função para adicionar dias úteis
        function adicionarDiasUteis(data, diasUteis) {
            var resultado = new Date(data);
            while (diasUteis > 0) {
                resultado.setDate(resultado.getDate() + 1);
                var diaSemana = resultado.getDay();
                if (diaSemana !== 0 && diaSemana !== 6) {
                    diasUteis--;
                }
            }
            return resultado;
        }

        var minInicio = adicionarDiasUteis(hoje, 2);

        // Validação
        if (dataInicio > dataFim) {
            apex.message.alert("A data de início não pode ser posterior à data de fim.");
        } else if (dataInicio < hoje) {
            apex.message.alert("A data de início não pode ser no passado.");
        } else if (dataInicio < minInicio) {
            apex.message.alert("A data de início deve ser com pelo menos 2 dias úteis de antecedência.");
        } else {
            // Datas válidas – aplicar no formulário pai
            parent.$s("P3_DAT_INICIO", $v("P104_DAT_INICIO"));
            parent.$s("P3_DAT_FIM", $v("P104_DAT_FIM"));
            parent.apex.navigation.dialog.close(true, {});
        }
    ```
---