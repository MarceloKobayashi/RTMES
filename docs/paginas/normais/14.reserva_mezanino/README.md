<div align="center">
  <p align="center">
    <h1>14. Reserva do Mezanino</h1>
  </p>
</div>

---

> Página exclusiva para a ASQUALOG que permite o registro de reservas do mezanino.

## 🎯 Visão geral

A página `14` é um caso a parte nesse sistema pelo motivo do fluxo de reserva do mezanino ser diferente. Antes de qualquer coisa, o solicitante deve solicitar a reserva de espaço à Primeira Secretaria para que ela aprove e assine, gerando um documento. Quando o documento for aprovado, a ASQUALOG será alertada e algum membro do setor fará o upload dele nesta página. Assim que o documento for inserido na página, os campos serão preenchidos automaticamente com os valores dentro do documento.

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

---

## 2 - Reservar o Mezanino (Form)

Essa região compreende os campos necessários para cadastrar uma reserva do tipo mezanino, além de um calendário mostrando todas as reservas do mesmo tipo.

- `P14_ID_RESERVA` - Oculto
- `P14_PENDENTE` - Oculto
- `P14_STATUS` - Oculto
- `P14_ARQ` - Upload de Arquivo - Formulário da Primeira Secretaria, quando um arquivo é colocado nesse item de página uma ação dinâmica é ativada, rodando a função JS setupFileListener(), definida em 'Função e Declaração de Variável Global'.
<br>

Todos os itens abaixo são preenchidos de acordo com o que está presente no formulário da Primeira Secretaria.

- `P14_TIP_RESERVAS` - Campo de Texto - Tipo da reserva
- `P14_NOME_SOLICITANTE` - Campo de Texto - Nome do solicitante
- `P14_CPF_SOLICITANTE` - Campo de Texto - CPF do solicitante
    + Esse campo é preenchido por meio de uma ação dinâmica disparada quando o nome do solicitante é preenchido, rodando um PL/SQL que captura o CPF.
    + Depois disso, com o CPF do solicitante, a região de datas é atualizada para mostrar as datas pendentes associadas ao usuário.
    <br>

- `P14_RAMAL` - Campo de Texto - Ramal do solicitante
- `P14_TITULO_RESERVA` - Campo de Texto - Título do evento da reserva
- `P14_DES_RESERVA` - Área de Texto - Descrição do evento da reserva.
- `P14_NUM_PARTICIPANTES` - Campo de Número - Estimativa do número de participantes do evento.
- `P14_JUSTIFICATIVA` - Campo de Texto - Justificativa do aceite da reserva, por padrão 'Aprovado pela Primeira Secretaria'
- `P14_OBS` - Área de Texto - Observação em relação a reserva.

### 2.1 - Datas Selecionadas (Sub-Região - Região Estática)

#### 2.1.1 - Datas Selecionadas (Relatório Interativo)

Essa região mostra as datas e horários que estão presentes no formulário e que são inseridas automaticamente na tabela temporária tmp_reservas usando o CPF do solicitante. 

Caso o responsável do setor queira adicionar mais datas, ele pode clicar no botão 'Adicionar Data' presente na região, que leva ele para a página `107`.

Assim como, se o sistema tiver cadastrado uma data ou horário errado, ele pode clicar no link na linha da data, que leva o usuário para a página `108`.

#### 2.1.2 - Região do Calendário

Esse calendário mostra os eventos do tipo mezanino com o horário e nome de cada evento. Esse calendário mostra as reservas da tabela temporária e da definitiva. Cada evento é colorido como:

- Verde - Reserva confirmada.
- Laranja - Reserva pendente da confirmação (temporária).
- Cinza - Reserva sendo cadastrada no momento.
- Azul - Reserva confirmada do usuário atual.
```sql
SELECT 'Temp' AS origem,
       CPF_SOLICITANTE,
       NULL AS id_reserva,
       HOR_INICIO,
       HOR_FIM,
       DAT,
       TO_TIMESTAMP(TO_CHAR(DAT, 'YYYY-MM-DD') || ' ' || HOR_INICIO, 'YYYY-MM-DD HH24:MI') AS start_date,
       HOR_INICIO || ' - ' || HOR_FIM AS descricao,
       CASE
         WHEN LPAD(CPF_SOLICITANTE, 11, '0') = :P14_CPF_SOLICITANTE
              THEN 'horario_usuario_atual'
         ELSE 'horario_analise'
       END AS class_name
FROM TMP_RESERVAS

UNION ALL

SELECT 'Mezanino' AS origem,
       r.COD_PESSOA AS FK_ID_PESSOA_RESERVA,
       m.id_reserva,
       m.hor_inicio,
       m.hor_fim,
       m.dat,
       TO_TIMESTAMP(TO_CHAR(m.dat, 'YYYY-MM-DD') || ' ' || m.hor_inicio, 'YYYY-MM-DD HH24:MI') AS start_date,
       m.hor_inicio || ' - ' || m.hor_fim AS descricao,
       CASE
         WHEN LPAD(r.COD_PESSOA, 11, '0') = :P14_CPF_SOLICITANTE THEN 'horario_usuario'
         WHEN r.status = 'Em Andamento' THEN 'horario_analise'
         ELSE 'horario_confirmado'
       END AS class_name
FROM horarios_mezanino m
JOIN reservas r ON r.id_reserva = m.id_reserva;
```
<br>

A cor dos eventos é feita pela coluna class_name na query e é colocada em 'Atributos' do calendário no campo 'Classe CSS'.
```css
.fc-event.horario_confirmado {
    background-color: #28a745 !important;
    border-color: #28a745 !important;
    color: white !important;
}

.fc-event.horario_analise {
    background-color: orange !important;
    border-color: orange !important;
    color: white !important;
}

.fc-event.horario_usuario {
    background-color: #007bff !important;
    border-color: #0056b3 !important;
}

.fc-event.horario_usuario_atual {
    background-color: #9E9E9E !important;
    border-color: #9e9e9e80 !important;
}
```
<br>

- Legenda - Conteúdo Estático - Composto por um HTML que mostra a cor de cada evento e seu significado.

#### 2.1.3 - Funções do calendário

Esse calendário tem várias funções, entre elas:

- `Abrir uma página para salvar uma data e hora` - Permite selecionar uma data diretamente no calendário ao clicar nela e transferir o valor para a página `107` para adicionar uma data e hora. 
    + Isso é feito em 'Atributos' do calendário, na parte de 'Criar Link'.
    + Quando for criada a data e a página `107` for fechada, uma ação dinâmica roda para atualizar as regiões de data.
    <br>
- `Ver detalhes de outra reserva` - Ao clicar em um evento do calendário, a página `109` é aberta exibindo os detalhes da reserva e do solicitante, permitindo contato para possíveis negociações de disponibilidade.
    + Isso é feito em 'Atributos' do calendário, na parte de 'Link Exibir/Editar'.

---

### 2.2 - Botões

No final dessa região, existem dois botões:

- `Cancelar` - Redireciona o usuário para a página home.
- `Adicionar aos Pendentes` - Submete a página, passando todos os valores dos campos para um processo PL/SQL 'Inserir no BD' e rodando ele.
    + No processo, as datas passam por diversas verificações, dentre elas:
        * Reservas com datas no passado;
        * Menos de dois dias de antecedência;
        * Hora de início menor que a hora de término;
        * Reservas no horário de almoço (12:00 - 14:00);
        * Conflito com reserva existente, precisa ter no mínimo 1h de intervalo.
    <br>
    + Depois insere o registro na tabela de reservas e depois transfere os horários da tabela temporária e insere eles na tabela definitiva horarios_mezanino.
    + Por fim, ele registra as etapas do atendimento das reservas, sendo elas a de registro e a de confirmação.

---

## 3 - Reservas de Mezanino (Região Estática)

Essa região tem como objetivo mostrar ao responsável do setor, as reservas de mezanino que ele está cadastrando, tudo em um relatório interativo. Cada linha tem um botão de link que abre a página `103` mostrando seus detalhes e um botão para deletar a reserva. Além de um botão para prosseguir para a página de confirmação `15`.

- Link para alvo personalizado passando o id da reserva.

```sql
SELECT r.ID_RESERVA,
       r.DAT_INICIO,
       r.DAT_FIM,
       r.TIP_RESERVAS,
       CASE 
         WHEN r.num_participantes IS NULL THEN '---' 
         ELSE TO_CHAR(r.num_participantes) 
       END AS num_participantes,
       r.TITULO_RESERVA,
       r.DES_RESERVA,
       (
         SELECT DISTINCT INITCAP(v.nom_pessoa)
           FROM dda.vinculo_sf v
          WHERE v.num_cpf = LPAD(r.cod_pessoa, 11, '0')
          FETCH FIRST 1 ROWS ONLY
       ) AS nome_pessoa,
       r.PENDENTE,
       CASE 
         WHEN r.obs IS NULL THEN 'N/A' 
         ELSE r.obs 
       END AS observacao,
       dbms_lob.getlength(r.ARQ) AS foto,
       r.filename,
       r.mimetype
  FROM RESERVAS r
 WHERE r.PENDENTE = 'S' 
    AND r.tip_reservas = 'Mezanino'
 ORDER BY r.dat_inicio, r.tip_RESERVAS, r.id_reserva;
```
---

## 4 - Bloco para o JS funcionar (Região Estática)

Esse bloco é um bloco oculto e serve apenas para importar algumas bibliotecas para leitura de PDF. Não tem nenhuma relevância visual.

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/1.10.100/pdf.min.js" ></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.6.347/pdf.worker.entry.min.js" ></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/1.10.100/pdf.worker.min.js" ></script>
```

## 5. JavaScript da Página (Parte Mais Importante)

Esta etapa é responsável por realizar a leitura do PDF enviado pelo usuário e transferir automaticamente as informações extraídas para os itens de página do Oracle APEX.

#### Fluxo Geral

1. O usuário realiza o upload do **Formulário da Primeira Secretaria** no item de página **P14_ARQ**.
2. O upload dispara a função **`setupFileListener()`**.
3. A função chama o processo **`NOME_DO_PROCESSO`**, que verifica a quantidade de arquivos temporários existentes com o nome armazenado em **P14_ARQ**.
4. Caso exista apenas um documento, a função **`ExtractText()`** é executada.

#### Conversão do PDF

A função **`ExtractText()`**:
* Converte o arquivo PDF para **Base64**;
* Chama a função **`convertDataURIToBinary()`**, responsável por converter o conteúdo Base64 em um array de bytes;
* Em seguida, chama a função **`pdfAsArray()`**, passando os bytes do arquivo como parâmetro.

#### Processamento dos Dados

A função **`pdfAsArray()`** é o núcleo de toda a solução. Suas responsabilidades incluem:
* Recuperar todas as páginas do PDF;
* Extrair e consolidar os textos encontrados;
* Realizar tratamentos e limpezas dos dados extraídos;
* Identificar as informações relevantes;
* Preencher automaticamente os itens de página correspondentes.

> **Observação:** Atualmente, a localização dos valores é baseada em posições fixas dentro do documento. Portanto, caso o layout do formulário seja alterado, será necessário revisar a lógica de extração.

#### Tratamento das Datas e Horários

Durante o processamento, o sistema identifica os blocos contendo:
* Data;
* Horário de início;
* Horário de término.

Essas informações são organizadas em um dicionário (estrutura de dados temporária). Para cada registro encontrado:

1. É realizada uma chamada ao processo **`INSERE_TEMP_RESERVAS`**;
2. O processo insere automaticamente os dados na tabela temporária de reservas;
3. Os registros ficam disponíveis para utilização nas etapas seguintes do fluxo.

---

FALTA FOTO!