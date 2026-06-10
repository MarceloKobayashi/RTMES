<div align="center">
  <p align="center">
    <h1>3. Fazer Reserva</h1>
  </p>
</div>

---

> Página que permite ao usuário fazer uma reserva e visualizar as reservas de outros solicitantes.

## 🎯 Visão geral

A página `3` é a principal do RTMES, pois resolve o problema de retrabalho na verificação de disponibilidade de datas e locais. Ao selecionar um tipo de reserva, o usuário visualiza no calendário apenas os eventos relacionados, facilitando a identificação de horários disponíveis. Além disso, a página exibe detalhes da reserva e permite a solicitação de múltiplos eventos simultaneamente, concentrando as principais funcionalidades do sistema.

---

## Carregar Página com o Tipo (Ação Dinâmica)

Antes de qualquer coisa, quando um usuário acessa essa página, essa ação dinâmica é ativada e roda 3 JS:
- `Carregar os campos corretos` - Exibir os campos corretos de acordo com o tipo de reserva selecionado (Adesivagem não tem local, por exemplo).
- `Carregar o texto de ajuda` - Chama a função `atualizarTextoAjuda` definida na Função e Declaração de Variável Global da página. Essa função apenas define o que será escrito no texto de ajuda do item de tipo de reserva, com os detalhes de cada tipo.
- `Carregar a região de data` - Exibir os calendários corretos, pois se for o tipo mezanino, outro calendário será exibido. Atualmente a reserva do mezanino está sendo feita apenas pela ASQUALOG, mas no início poderia ser feita por todos.

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

Nessa, em específico, tem um botão 'Reservar_Tudo' que direciona o usuário para a página 4.

---

## 2 - Reservar um Evento (Form)

Essa região compreende os detalhes do tipo de reserva, todos os campos a serem preenchidos pelo solicitante para fazer a reserva e o calendário com todos os eventos já cadastrados no sistema, com data de início e término, para que o usuário saiba a disponibilidade das datas.

- `P3_ID_RESERVA` - Oculto
- `P3_PENDENTE` - Oculto - Tem como padrão 'S'.
- `P3_STATUS` - Oculto - Tem como padrão 'Em Andamento'.
- `P3_TIP_RESERVAS` - Lista de Seleção - Permite o usuário a escolher entre 3 tipos de reserva (Porta- e Adesivagem).
    + Abaixo desse item é exibido o texto de ajuda, que é alterado pela função já citada `atualizarTextoAjuda`.
    + Quando esse item tem seu valor alterado, as mesmas funções JS que são ativadas no carregamento da página são acionadas.
    + Abaixo do texto ajuda tem uma região Imagens do tipo relatório interativo. Essa região mostra as imagens da tabela estática `reservas_img` apenas.
    <br>

- `P3_TITULO_RESERVA` - Campo de Texto - Título do evento da reserva.
- `P3_DES_RESERVA` - Área de Texto - Descrição do evento da reserva.
- `P3_DAT_INICIO` - Seletor de Data - Seleciona a data de início da reserva.
- `P3_DAT_FIM` - Seletor de Data - Seleciona a data de término da reserva.
    + Quando esse valor ou do tipo de reservas é alterado, uma ação dinâmica é ativada para atualizar o 'P3_LOC'. Essa ação serve para que o 'P3_LOC' exiba apenas os locais disponíveis para aquele intervalo de data e tipo.
    <br>
- `P3_LOC` - LOV Popup - Dentre os valores da tabela estática reservas_locais, mostra apenas os que tem disponibilidade no intervalo de data e tipo. Permite o usuário escolher mais de um valor e digitar locais novos.
    ```sql
    SELECT rl.des_local  AS display_value,
        rl.des_local  AS return_value
    FROM reservas_locais rl
    WHERE :P3_TIP_RESERVAS IS NOT NULL
    AND (
            :P3_DAT_INICIO IS NULL
            OR :P3_DAT_FIM IS NULL
            OR NOT EXISTS (
                SELECT 1
                FROM reservas r
                WHERE r.tip_reservas = :P3_TIP_RESERVAS
                    AND r.status <> 'Cancelado'
                    AND TRIM(UPPER(r.loc)) = TRIM(UPPER(rl.des_local))
                    AND r.dat_inicio <= :P3_DAT_FIM
                    AND r.dat_fim    >= :P3_DAT_INICIO
            )
        )
    -- remove os já escolhidos
    AND (
            :P3_LOC IS NULL
            OR INSTR(':' || :P3_LOC || ':', ':' || rl.des_local || ':') = 0
        )
    ORDER BY rl.des_local;
    ```
    + Abaixo de P3_LOC, tem uma região estática 'Locais' que possui dois botões:
        * `Todos_os_Locais` - Roda um PL/SQL que seleciona todos os locais da tabela que estão disponíveis.
        * `Apagar_Locais` - Roda um PL/SQL que seta P3_LOC como nulo.

- `P3_NUM_PARTICIPANTES` - Campo de Número - Número estimado de participantes, apenas no mezanino.
- `P3_COD_PESSOA` - Oculto - CPF do solicitante.
- `P3_OBS` - Área de Texto - Observação sobre a solicitação.
- `P3_ARQ` - Upload de Arquivo - Arquivo de identidade visual ou adesivo. 
- `P3_RAMAL` - Campo de Texto - Ramal do solicitante.

Além desses itens e 'sub-regiões', ao final desse formulário existem dois botões:

- `Cancel` - Volta para a página 3 zerando todos os campos.
- `Create` - Submete a página e roda o processo PL/SQL 'Adicionar aos Pendentes'. Esse processo salva as reservas na tabela reservas como pendentes.

### 2.1 - Calendário

#### 2.1.1 - Regiões do Calendário

Abaixo dos itens de página de data, a página exibe um calendário que tem como eventos, as reservas feitas por todos que tem o tip_reservas igual ao P3_TIP_RESERVAS. Existem dois calendários, com suas respectivas legendas, mas já que o mezanino não está sendo feito nessa página, não vou explicar.

Basicamente a região é composta por duas regiões, o calendário e a legenda dele.

- `Datas` - Calendário - Mostra um calendário com todas as reservas como eventos nele. Cada evento mostra o local (caso seja Porta-) ou o titulo do evento (caso seja adesivagem). Cada evento também é colorido de acordo com seu status e proprietário.
    + Azul - Reserva do usuário.
    + Verde - Reserva confirmada de outro usuário.
    + Amarelo - Reserva pendente de outro usuário.
    <br>
    
    ```sql
        SELECT ID_RESERVA,
            DAT_INICIO,
            DAT_FIM,
            TIP_RESERVAS,
            STATUS,
            NUM_PARTICIPANTES,
            TITULO_RESERVA,
            DES_RESERVA,
            COD_PESSOA,
            PENDENTE,
            LOC,
            CASE
                WHEN TIP_RESERVAS LIKE 'Porta-C%' THEN LOC
                WHEN TIP_RESERVAS LIKE 'Porta-B%' THEN LOC
                WHEN TIP_RESERVAS IN ('Adesivagem', 'Mezanino') THEN TITULO_RESERVA
                ELSE DES_RESERVA
            END AS descricao_real,
            CASE
                WHEN STATUS = 'Em Andamento' THEN 'pendentes'
                WHEN PENDENTE = 'N' AND LPAD(COD_PESSOA, 11, '0') = 
                        (
                            SELECT num_cpf_pessoa
                            FROM dda.usuario_rede
                            WHERE :APP_USER = txt_login_ad
                                AND nom_situacao_login_ad = 'ATIVO'
                        )
                    THEN 'reservas-usuario'
                WHEN PENDENTE = 'N' AND LPAD(COD_PESSOA, 11, '0') <>
                        (
                            SELECT num_cpf_pessoa
                            FROM dda.usuario_rede
                            WHERE :APP_USER = txt_login_ad
                                AND nom_situacao_login_ad = 'ATIVO'
                        )
                    THEN 'reservas-outro'
            END AS colorir_pendente
        FROM RESERVAS
        WHERE ( :P3_TIP_RESERVAS IS NULL OR UPPER(TIP_RESERVAS) = UPPER(:P3_TIP_RESERVAS) )
          AND STATUS NOT IN ('Cancelado')
    ```
    
    <br>
    A cor dos eventos é feita pela coluna colorir_pendente na query e é colocada em 'Atributos' do calendário no campo 'Classe CSS'.

    ```css
        .fc-event.pendentes {
            background-color: orange;
            border-color: orange;
            color: black;
        }

        .fc-event.reservas-outro {
            background-color: #13af13;
            border: #00cc00;
            color: black;
        }

        .fc-event.reservas-usuario {
            background-color: #007bff !important;
            border-color: #0056b3 !important;
        }
    ```
- Legenda - Conteúdo Estático - Composto por um HTML que mostra a cor de cada evento e seu significado.

#### 2.1.2 - Funções do calendário

Esse calendário tem várias funções, entre elas:

- `Salvar o intervalo de datas nos itens de página` - Permite selecionar um período diretamente no calendário. Ao arrastar o mouse entre duas datas, a página `104` é aberta e, após a confirmação, as datas selecionadas são preenchidas nos campos da página `3`.
    + Isso é feito em 'Atributos' do calendário, na parte de 'Criar Link'.
    <br>
- `Ver detalhes de outro solicitante` - Ao clicar em um evento do calendário, a página `105` é aberta exibindo os detalhes da reserva e do solicitante, permitindo contato para possíveis negociações de disponibilidade.
    + Isso é feito em 'Atributos' do calendário, na parte de 'Link Exibir/Editar'.

---

## 3 - Solicitante (Região Estática)

Essa região apenas exibe ao usuário e assegura ele que o sistema identifica ele corretamente. Nela são exibidos dois itens de página que não podem ser alterados, um mostra o nome completo do usuário e outro mostra o setor dele.
 
- `P3_NOME` - Exibe o nome completo do usuário utilizando o APP_USER.
```sql
SELECT nom_pessoa
FROM dda.vinculo_sf
WHERE num_cpf = 
    (
        SELECT num_cpf_pessoa
        FROM dda.usuario_rede
        WHERE :APP_USER = txt_login_ad
            AND nom_situacao_login_ad = 'ATIVO'
    )
  AND ind_vinculo_ativo = 'S'
``` 
- `P3_SETOR` - Exibe a sigla do setor e o nome completo dele.
```sql
SELECT o.sgl_orgao || ' - ' || o.nom_orgao || ' (' || o.sgl_orgao_hierarquia || ')'
FROM dda.orgao o
JOIN dda.vinculo_sf v ON v.sgl_orgao_exercicio = o.sgl_orgao
WHERE v.num_cpf = 
    (
        SELECT num_cpf_pessoa
        FROM dda.usuario_rede
        WHERE :APP_USER = txt_login_ad
            AND nom_situacao_login_ad = 'ATIVO'
    )
  AND v.ind_vinculo_ativo = 'S'
```
---

## 4 - Reservas Pendentes (Região Estática)

Essa região tem como objetivo mostrar ao usuário as reservas que ele está solicitando em um relatório interativo com um botão a cada reserva, que abre a página `103` mostrando seus detalhes e um botão para deletar tal reserva. Além de um botão para prosseguir para a página de confirmação `4`.

- Link para alvo personalizado passando o id da reserva.

```sql
select ID_RESERVA,
       DAT_INICIO,
       DAT_FIM,
       TIP_RESERVAS,
       CASE 
         WHEN num_participantes IS NULL THEN '---' 
         ELSE TO_CHAR(num_participantes)
       END AS num_participantes,
       TITULO_RESERVA,
       DES_RESERVA,
       COD_PESSOA,
       loc,
       CASE 
         WHEN obs IS NULL THEN 'N/A' 
         ELSE obs
       END AS observacao
  from RESERVAS
  where PENDENTE = 'S'
    and tip_reservas <> 'Mezanino'
    and LPAD(COD_PESSOA, 11, '0') = 
        (
            SELECT num_cpf_pessoa
            FROM dda.usuario_rede
            WHERE :APP_USER = txt_login_ad
                AND nom_situacao_login_ad = 'ATIVO'
        )
  order by dat_inicio, tip_RESERVAS, id_reserva
```

---
