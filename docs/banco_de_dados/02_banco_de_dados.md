# Banco de Dados

## Visão Geral

O banco de dados do RTMES adota uma modelagem centrada em reservas, com uma tabela transacional principal e tabelas dependentes para detalhamento de horários, auditoria operacional e apoio visual ou cadastral. A estrutura foi desenhada para atender diferentes modalidades de reserva no mesmo domínio funcional, mantendo o controle de integridade próximo ao dado e favorecendo consultas por histórico, disponibilidade e suporte ao atendimento.

O fluxo geral segue a criação da reserva em `RESERVAS`, seguida pela associação de registros complementares quando necessário. Para reservas de mezanino, os intervalos por dia são normalizados em `HORARIOS_MEZANINO`. Para acompanhamento do ciclo de vida da solicitação, `ATENDIMENTO_RESERVAS` registra as etapas e eventos de atendimento vinculados à reserva original. As tabelas `RESERVAS_IMG` e `RESERVAS_LOCAIS` funcionam como repositórios auxiliares estáticos para conteúdo visual e locais frequentemente utilizados.

A estratégia de relacionamentos privilegia dependência de um registro pai para múltiplos registros filhos, sem excesso de normalização em pontos que precisam ser consumidos diretamente pela aplicação Oracle APEX. As restrições de unicidade e validade são garantidas por chaves primárias, chaves estrangeiras, `CHECK constraints` e, no caso da tabela principal, por trigger de validação de regras de negócio. Quando o comportamento é estático, a persistência é simplificada em tabelas pequenas, com manutenção manual ou controlada pela aplicação.

Os padrões predominantes são:

- Uso de chaves substitutas numéricas como identificadores técnicos.
- Combinação de `IDENTITY` e sequência para geração automática de chaves, conforme o objeto.
- Armazenamento de metadados de arquivos junto ao respectivo `BLOB`.
- Histórico operacional separado da entidade principal para rastreabilidade.
- Regras de negócio críticas aplicadas no banco apenas quando a consistência depende da concorrência ou da disponibilidade global do domínio.
- Estrutura sem procedures, functions ou packages identificadas nos objetos analisados deste escopo.

## RESERVAS

### Objetivo

Armazenar a solicitação principal de reserva e centralizar os dados do evento, do solicitante, do período reservado, do tipo de reserva e dos controles de fluxo utilizados pela aplicação.

### Relacionamentos

É a tabela pai do modelo. Um registro em `RESERVAS` pode possuir múltiplos registros em `HORARIOS_MEZANINO` e múltiplos eventos em `ATENDIMENTO_RESERVAS`.

### Colunas principais

| Coluna | Tipo | Obrigatória | Finalidade |
| --- | --- | --- | --- |
| ID_RESERVA | NUMBER | Sim | Identificador técnico da reserva. |
| DAT_INICIO | TIMESTAMP(6) | Sim | Início do período solicitado. |
| DAT_FIM | TIMESTAMP(6) | Sim | Fim do período solicitado. |
| TIP_RESERVAS | VARCHAR2(20 CHAR) | Sim | Classificação funcional da reserva. |
| STATUS | VARCHAR2(20 CHAR) | Sim | Estado corrente da solicitação. |
| NUM_PARTICIPANTES | NUMBER | Não | Quantidade estimada de participantes, aplicada sobretudo ao mezanino. |
| TITULO_RESERVA | VARCHAR2(400 CHAR) | Sim | Título ou identificação resumida do evento. |
| DES_RESERVA | VARCHAR2(4000 CHAR) | Sim | Descrição detalhada da solicitação. |
| COD_PESSOA | NUMBER | Sim | Identificador do solicitante. |
| PENDENTE | VARCHAR2(1 CHAR) | Sim | Controle de confirmação pelo solicitante. |
| LOC | VARCHAR2(4000) | Não | Local físico vinculado à reserva. |
| JUSTIFICATIVA | VARCHAR2(4000) | Não | Resposta ou parecer da equipe responsável. |
| OBS | VARCHAR2(4000) | Não | Observação adicional do solicitante. |
| OBS_ASQUALOG | VARCHAR2(4000) | Não | Observação interna da equipe ASQUALOG. |
| ARQ | BLOB | Não | Anexo principal da solicitação. |
| MIMETYPE | VARCHAR2(200) | Não | Tipo MIME do anexo. |
| FILENAME | VARCHAR2(200) | Não | Nome original do arquivo anexado. |
| EMAIL_ENVIADO | VARCHAR2(1) | Sim | Controle de envio de resposta por e-mail. |
| COD_GRUPO_RESERVA | NUMBER | Não | Agrupamento lógico de reservas relacionadas. |
| DAT_CRIACAO | TIMESTAMP(6) | Sim | Data de criação do registro. |
| RAMAL | VARCHAR2(10) | Sim | Ramal para contato com o solicitante. |
| IND_PATRIMONIO | VARCHAR2(1) | Sim | Controle de acionamento do patrimônio. |

### Chave Primária

- `AAA_RESERVAS_PK` sobre `ID_RESERVA`.

### Chaves Estrangeiras

- Não há chave estrangeira declarada nesta tabela.

### Constraints

- `AAA_RESERVAS_PK`: garante a unicidade técnica da reserva.
- `AAA_RESERVAS_STATUS`: restringe o valor de `STATUS` aos estados previstos no DDL.
- `AAA_RESERVAS_TIPO`: restringe o valor de `TIP_RESERVAS` aos tipos permitidos.

### Índices

- Índice implícito da chave primária `AAA_RESERVAS_PK`.
- Não há índices auxiliares declarados no escopo analisado.

### Triggers

`TRG_RESERVAS_B_I` executa antes da inserção para atribuir o identificador via `SEQ_RESERVAS` e aplicar regras de disponibilidade e coerência do domínio. A trigger impede conflito de reservas por período, limita a quantidade de `Porta-Banner` e `Porta-Cartaz` em janela sobreposta, bloqueia sobreposição de `Adesivagem`, valida datas no passado, garante que a data inicial não seja posterior à final, exige antecedência mínima para abertura e obriga local para tipos de reserva que dependem de espaço físico. Trata-se do ponto mais concentrado de regra de negócio do modelo.

### Procedures relacionadas

Nenhuma identificada no escopo analisado.

### Functions relacionadas

Nenhuma identificada no escopo analisado.

### Packages relacionadas

Nenhum package identificado no escopo analisado.

### Observações

- A tabela concentra o ciclo de vida da reserva e parte do controle operacional da aplicação.
- O `STATUS` e os tipos de reserva são validados por `CHECK constraint`, reduzindo inconsistências de cadastro.
- A trigger usa sequência própria para geração da chave e reforça regras que dependem do conjunto já persistido.
- O objeto contém metadados de arquivo no mesmo registro do anexo, padrão útil para consumo direto em APEX.

## HORARIOS_MEZANINO

### Objetivo

Detalhar os intervalos de horário associados às reservas do tipo mezanino, permitindo múltiplos registros por reserva e por data.

### Relacionamentos

É uma tabela filha de `RESERVAS`. Cada reserva de mezanino pode possuir vários intervalos, normalmente um por dia ou por faixa horária cadastrada.

### Colunas principais

| Coluna | Tipo | Obrigatória | Finalidade |
| --- | --- | --- | --- |
| ID_HORARIO | NUMBER | Sim | Identificador técnico do intervalo. |
| ID_RESERVA | NUMBER | Sim | Referência à reserva principal. |
| DAT | DATE | Sim | Data do intervalo. |
| HOR_INICIO | VARCHAR2(200) | Sim | Horário inicial da faixa. |
| HOR_FIM | VARCHAR2(200) | Sim | Horário final da faixa. |

### Chave Primária

- Chave primária sobre `ID_HORARIO`.

### Chaves Estrangeiras

- `ID_RESERVA` referencia `RESERVAS(ID_RESERVA)`.

### Constraints

- Chave primária sobre `ID_HORARIO`.
- Chave estrangeira `ID_RESERVA` para garantir vínculo com a reserva pai.

### Índices

- Índice implícito da chave primária.
- Não há outros índices declarados.

### Triggers

`TRG_HORARIOS_MEZANINO_B_I` preenche automaticamente `ID_HORARIO` com a sequência `SEQ_HORARIOS_MEZANINO` antes da inserção. A trigger atua apenas na geração do identificador, sem impor regras adicionais de negócio.

### Procedures relacionadas

Nenhuma identificada no escopo analisado.

### Functions relacionadas

Nenhuma identificada no escopo analisado.

### Packages relacionadas

Nenhum package identificado no escopo analisado.

### Observações

- A modelagem permite representar um conjunto de horários distribuídos por datas diferentes para a mesma reserva.
- Horário é armazenado como texto, o que sugere controle de formatação na camada de aplicação.

## ATENDIMENTO_RESERVAS

### Objetivo

Registrar o histórico de atendimento, acompanhamento e evolução de cada reserva, servindo como trilha de auditoria operacional.

### Relacionamentos

É uma tabela filha de `RESERVAS`. Uma reserva pode gerar múltiplos registros de atendimento ao longo de seu ciclo de vida.

### Colunas principais

| Coluna | Tipo | Obrigatória | Finalidade |
| --- | --- | --- | --- |
| PK_ATENDIMENTO_RESERVAS | NUMBER | Sim | Identificador técnico do atendimento. |
| DAT_CRIACAO_ATENDIMENTO | TIMESTAMP(6) | Sim | Momento em que o evento de atendimento foi registrado. |
| DES_ATENDIMENTO | VARCHAR2(200 CHAR) | Sim | Descrição resumida da ação realizada. |
| NOM_ATENDIMENTO | VARCHAR2(200 CHAR) | Sim | Nome ou identificação textual do atendimento. |
| FK_ATENDIMENTO_RESERVAS_RESERVAS | NUMBER | Sim | Referência à reserva principal. |
| CONFIRMADO | CHAR(1) | Sim | Controle lógico de confirmação da etapa. |

### Chave Primária

- `ATENDIMENTO_RESERVAS_PK` sobre `PK_ATENDIMENTO_RESERVAS`.

### Chaves Estrangeiras

- `ATENDIMENTO_RESERVAS_CON` referencia `RESERVAS(ID_RESERVA)`.

### Constraints

- `ATENDIMENTO_RESERVAS_PK`: garante unicidade do evento de atendimento.
- `ATENDIMENTO_RESERVAS_CON`: assegura integridade referencial com a reserva associada.

### Índices

- Índice implícito da chave primária.
- Não há índices adicionais declarados.

### Triggers

Não há triggers relacionados a esta tabela.

### Procedures relacionadas

Nenhuma identificada no escopo analisado.

### Functions relacionadas

Nenhuma identificada no escopo analisado.

### Packages relacionadas

Nenhum package identificado no escopo analisado.

### Observações

- A tabela foi comentada no DDL como repositório das etapas que cada reserva passou.
- O desenho favorece auditoria e exibição de linha do tempo sem sobrecarregar a tabela principal.

## RESERVAS_IMG

### Objetivo

Armazenar imagens de referência para porta-banner e porta-cartaz, com finalidade de apoio visual à interface e às solicitações.

### Relacionamentos

Não possui relacionamento por chave estrangeira. Seu uso é de suporte, com consumo direto pela aplicação.

### Colunas principais

| Coluna | Tipo | Obrigatória | Finalidade |
| --- | --- | --- | --- |
| ID_IMG | NUMBER | Sim | Identificador técnico do registro estático. |
| IMG_BAN | BLOB | Sim | Imagem de referência do porta-banner. |
| MIMETYPE_BAN | VARCHAR2(200 CHAR) | Sim | Tipo MIME da imagem do porta-banner. |
| FILENAME_BAN | VARCHAR2(200 CHAR) | Sim | Nome do arquivo do porta-banner. |
| IMG_CAR | BLOB | Sim | Imagem de referência do porta-cartaz. |
| MIMETYPE_CAR | VARCHAR2(200) | Sim | Tipo MIME da imagem do porta-cartaz. |
| FILENAME_CAR | VARCHAR2(200) | Sim | Nome do arquivo do porta-cartaz. |

### Chave Primária

- `RESERVAS_IMG_PK` sobre `ID_IMG`.

### Chaves Estrangeiras

- Não há chave estrangeira declarada nesta tabela.

### Constraints

- `RESERVAS_IMG_PK`: garante o identificador único do registro estático.

### Índices

- Índice implícito da chave primária.
- Não há índices auxiliares declarados.

### Triggers

Não há triggers relacionados a esta tabela.

### Procedures relacionadas

Nenhuma identificada no escopo analisado.

### Functions relacionadas

Nenhuma identificada no escopo analisado.

### Packages relacionadas

Nenhum package identificado no escopo analisado.

### Observações

- O objeto foi modelado como tabela estática de suporte, com persistência de um conjunto reduzido de imagens e respectivos metadados.
- O padrão de `BLOB` mais `MIME type` e nome de arquivo permite consumo direto em APEX sem transformação adicional.

## RESERVAS_LOCAIS

### Objetivo

Concentrar os locais mais comuns usados nas reservas de porta-banner e porta-cartaz, funcionando como base cadastral de apoio.

### Relacionamentos

Não possui chaves estrangeiras. É uma tabela de referência para escolha de locais pela aplicação.

### Colunas principais

| Coluna | Tipo | Obrigatória | Finalidade |
| --- | --- | --- | --- |
| ID_LOCAL | NUMBER | Sim | Identificador técnico do local. |
| DES_LOCAL | VARCHAR2(200) | Não | Nome descritivo do local. |

### Chave Primária

- Chave primária sobre `ID_LOCAL`.

### Chaves Estrangeiras

- Não há chave estrangeira declarada nesta tabela.

### Constraints

- Chave primária sobre `ID_LOCAL`.

### Índices

- Índice implícito da chave primária.
- Não há índices adicionais declarados.

### Triggers

Não há triggers relacionados a esta tabela.

### Procedures relacionadas

Nenhuma identificada no escopo analisado.

### Functions relacionadas

Nenhuma identificada no escopo analisado.

### Packages relacionadas

Nenhum package identificado no escopo analisado.

### Observações

- A tabela é de referência e pode ser administrada como cadastro simples de apoio à operação.
- O conteúdo tende a ser pequeno e estável, por isso não exige estruturas adicionais de persistência.

## Resumo geral da arquitetura

A arquitetura de banco de dados do RTMES é orientada a uma entidade transacional central, `RESERVAS`, da qual derivam registros especializados para histórico e detalhamento operacional. O modelo reduz redundância no que é funcionalmente repetível, mas preserva autonomia de leitura para a aplicação consumir o conjunto com baixo acoplamento. As regras de integridade mais sensíveis foram posicionadas no banco quando dependem de concorrência ou de consistência global da agenda, enquanto cadastros de apoio e conteúdo visual permanecem em tabelas estáticas simples.

Do ponto de vista físico, a solução combina chaves substitutas numéricas, chaves estrangeiras em cascata lógica de pai para filho, `BLOBs` acompanhados de metadados e `CHECK constraints` para valores controlados. O resultado é um banco relativamente enxuto, adequado para Oracle APEX, com forte foco em disponibilidade de consulta, rastreabilidade do atendimento e controle das restrições de negócio mais críticas.