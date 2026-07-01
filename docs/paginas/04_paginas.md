# Páginas

## Página 0 - Página Global

### Objetivo

Fornecer a estrutura visual e comportamental comum da aplicação, com header, footer, identidade institucional e menu do usuário.

### Fluxo de utilização

A página é carregada em todas as demais como base de layout. Ao renderizar, monta o cabeçalho, exibe o nome do usuário autenticado, disponibiliza o logout e redireciona o usuário para a página inicial adequada ao setor quando o header é acionado.

### Funcionalidades

- Header fixo com logo, título e menu do usuário.
- Footer institucional com identificação do setor.
- Faixa visual institucional abaixo do header.
- Redirecionamento inteligente para a página inicial por setor.

### Itens

- `P0_ASQUALOG`
- `NOME_USUARIO`
- `LOGOUT_URL`

### Regiões

- Header global.
- Footer global.
- Elementos visuais institucionais.

### Botões

- Menu do usuário com ação de logout.
- Área clicável do header para navegação inicial.

### Processos

Não há processo transacional próprio. A página consome a lógica global de carregamento do nome do usuário.

### Validações

- Redirecionamento de início condicionado ao setor do usuário.
- Dropdown do usuário alterna abertura e fechamento pelo clique.

### Dynamic Actions

- Comportamento do header no carregamento.
- Alternância do menu do usuário.

### Consultas SQL importantes

Não há consultas próprias nesta página; ela consome o item global preenchido por processo de aplicação.

### Integração com banco de dados

Integração indireta via item global derivado de consultas corporativas para identificação do usuário autenticado.

### Componentes compartilhados utilizados

- Autenticação.
- Lógica de aplicação.
- Arquivos estáticos de identidade visual.

### Observações

É a camada estrutural da aplicação, não uma tela de negócio.

## Página 1 - Início

### Objetivo

Servir como ponto de entrada da aplicação e oferecer acesso rápido às áreas operacionais conforme o setor do usuário.

### Fluxo de utilização

Ao abrir a página, o sistema executa uma limpeza de rascunhos e registros temporários de reservas pendentes. Em seguida, exibe os cartões de navegação filtrados por setor e a área de busca para localizar funcionalidades.

### Funcionalidades

- Exibição de cartões de acesso rápido.
- Campo de busca para localizar páginas ou funcionalidades.
- Limpeza automática de registros incompletos ao entrar.

### Itens

- `P1_ASQUALOG`

### Regiões

- Barra de pesquisa.
- Cartões de navegação.

### Botões

- Links dos cartões de navegação para as páginas principais.

### Processos

- Remoção de reservas pendentes incompletas e dados temporários associados.

### Validações

- Exibição dos cartões depende do setor do usuário.

### Dynamic Actions

- Limpeza executada no carregamento.
- Filtragem dos cartões pela busca.

### Consultas SQL importantes

- Exclusões em `RESERVAS`, `HORARIOS_MEZANINO`, `ATENDIMENTO_RESERVAS` e tabelas temporárias para remover rascunhos.

### Integração com banco de dados

- `RESERVAS`
- `HORARIOS_MEZANINO`
- `ATENDIMENTO_RESERVAS`
- `TMP_RESERVAS`

### Componentes compartilhados utilizados

- Página global.
- Lógica de aplicação.
- Identidade visual compartilhada.

### Observações

É a única página com rotina de saneamento de dados temporários na entrada.

## Página 2 - Minhas Reservas

### Objetivo

Permitir ao usuário acompanhar suas próprias reservas, com visão por situação e ações sobre registros ainda controláveis.

### Fluxo de utilização

A página carrega a visão consolidada das reservas do usuário, ajusta status históricos quando necessário e apresenta três blocos principais: em análise, confirmadas e canceladas/realizadas. O usuário pode filtrar os dados, abrir detalhes em modais e acessar o fluxo de nova reserva.

### Funcionalidades

- Consulta da carteira pessoal de reservas.
- Separação por status de negócio.
- Filtros por título, datas, solicitante, tipo e exibição.
- Acesso aos detalhes e cancelamento de reservas ainda elegíveis.

### Itens

- `P2_EXIBIR`
- `P2_TITULO`
- `P2_INICIO`
- `P2_FIM`
- `P2_SOLICITANTE`
- `P2_FILTRO`
- `P2_LIXO`

### Regiões

- Breadcrumb.
- Filtro.
- Reservas em análise.
- Reservas confirmadas.
- Reservas canceladas e realizadas.

### Botões

- `Fazer_Reserva`
- `Remover_Filtros`

### Processos

- Atualização de reservas vencidas ou pendentes conforme status de negócio.

### Validações

- Filtros de texto e seleção combinada são reconciliados pelo item auxiliar.
- A tela separa visualmente o que pode ou não ser tratado pelo próprio usuário.

### Dynamic Actions

- Recarregamento das regiões ao alterar filtros.
- Alternância da exibição entre reservas pessoais e reservas do setor.

### Consultas SQL importantes

- Consultas sobre `RESERVAS` com `dda.vinculo_sf`, `dda.usuario_rede` e `dda.orgao`.
- Uso de `apex_string.split`, `REGEXP_LIKE` e agregações por status.

### Integração com banco de dados

- `RESERVAS`
- `ATENDIMENTO_RESERVAS`
- `dda.vinculo_sf`
- `dda.usuario_rede`
- `dda.orgao`

### Componentes compartilhados utilizados

- Página global.
- Breadcrumb.
- Modais 101, 102 e 103.

### Observações

É a área pessoal de acompanhamento e, por isso, combina leitura histórica com ações pontuais de manutenção.

## Página 3 - Fazer Reserva

### Objetivo

Concentrar a criação de reservas do usuário, com validação visual de disponibilidade e apoio direto à seleção de locais e datas.

### Fluxo de utilização

O usuário escolhe o tipo de reserva, visualiza os detalhes de ajuda, seleciona o período e verifica a disponibilidade em calendário. Depois preenche título, descrição, local, participantes, anexo e contato, e envia a solicitação como pendente.

### Funcionalidades

- Cadastro de reserva por formulário.
- Calendário de disponibilidade por tipo.
- Filtro dinâmico de locais disponíveis.
- Exibição de imagens de apoio por tipo de reserva.
- Acesso a detalhes de outros eventos para negociação.

### Itens

- `P3_ID_RESERVA`
- `P3_PENDENTE`
- `P3_STATUS`
- `P3_TIP_RESERVAS`
- `P3_TITULO_RESERVA`
- `P3_DES_RESERVA`
- `P3_DAT_INICIO`
- `P3_DAT_FIM`
- `P3_LOC`
- `P3_NUM_PARTICIPANTES`
- `P3_COD_PESSOA`
- `P3_OBS`
- `P3_ARQ`
- `P3_RAMAL`
- `P3_NOME`
- `P3_SETOR`

### Regiões

- Breadcrumb.
- Formulário de reserva.
- Identificação do solicitante.
- Reservas pendentes.
- Calendário de disponibilidade.
- Região de imagens do tipo.
- Região de locais.

### Botões

- `Cancel`
- `Create`
- `Todos_os_Locais`
- `Apagar_Locais`

### Processos

- Criação da reserva em estado pendente.

### Validações

- Local obrigatório para tipos porta-banner e porta-cartaz.
- Datas coerentes e com antecedência mínima.
- Locais filtrados por disponibilidade no intervalo escolhido.
- Bloqueio de conflitos com reservas já existentes.

### Dynamic Actions

- Ajuste de campos conforme o tipo de reserva.
- Atualização do texto de ajuda.
- Troca do calendário conforme o tipo.
- Recarregamento da LOV de locais.
- Abertura dos modais 104 e 105 a partir do calendário.

### Consultas SQL importantes

- LOV de locais baseada em `NOT EXISTS` sobre `RESERVAS`.
- Calendário com classificação visual por status e proprietário.
- Consulta de identificação do solicitante via estruturas corporativas.

### Integração com banco de dados

- `RESERVAS`
- `RESERVAS_IMG`
- `RESERVAS_LOCAIS`

### Componentes compartilhados utilizados

- Página global.
- LOVs.
- Arquivos estáticos.
- JavaScript compartilhado.
- Modais 104 e 105.

### Observações

É a principal página transacional do usuário e a que concentra maior densidade de regras de disponibilidade.

## Página 4 - Confirmar Solicitação

### Objetivo

Concluir a submissão das reservas pendentes do usuário e encaminhá-las para a análise institucional.

### Fluxo de utilização

A página consolida as reservas ainda pendentes em um resumo único. O usuário revisa os dados, confirma a submissão e então o sistema registra o grupo, cria os atendimentos iniciais e envia a comunicação correspondente.

### Funcionalidades

- Consolidação de reservas pendentes em grupo.
- Encaminhamento da solicitação para análise.
- Envio de mensagem de confirmação.

### Itens

- Itens herdados do contexto da página anterior.

### Regiões

- Breadcrumb.
- Resumo das reservas pendentes.
- Barra de ações.

### Botões

- `Cancelar`
- `Create`

### Processos

- Geração do grupo de reservas.
- Criação de registros de atendimento.
- Remoção do estado pendente.
- Envio de e-mail de confirmação.

### Validações

- Apenas reservas pendentes e pertencentes ao usuário são consideradas.

### Dynamic Actions

- Atualização do resumo após mudanças no conteúdo consolidado.

### Consultas SQL importantes

- Agrupamento com `LISTAGG` de locais e dados de reserva.
- Filtragem por vínculo do usuário em `dda.vinculo_sf`.

### Integração com banco de dados

- `RESERVAS`
- `ATENDIMENTO_RESERVAS`

### Componentes compartilhados utilizados

- Página global.
- Breadcrumb.
- Padrão de e-mail da aplicação.

### Observações

Funciona como fechamento do fluxo do usuário, não como tela de entrada de dados.

## Página 5 - Cancelar Reservas

### Objetivo

Permitir que o usuário cancele reservas já confirmadas sob seu controle.

### Fluxo de utilização

A página lista as reservas confirmadas elegíveis, o usuário seleciona uma ou mais linhas e executa o cancelamento. O sistema atualiza os registros e gera a comunicação correspondente.

### Funcionalidades

- Cancelamento em lote.
- Seleção por checkbox.
- Visão filtrada por CPF do solicitante.

### Itens

- `P5_CPF`
- Coluna auxiliar `sel`

### Regiões

- Breadcrumb.
- Relatório de reservas confirmadas.

### Botões

- `Voltar`
- `Cancelar Reservas`

### Processos

- Atualização do status para cancelado.
- Geração do e-mail de cancelamento.

### Validações

- Apenas reservas confirmadas e ativas entram na lista.

### Dynamic Actions

- Submissão orientada pela seleção das linhas.

### Consultas SQL importantes

- Uso de `apex_item.checkbox2`.
- Consulta com `dda.vinculo_sf` para restringir o universo do usuário.

### Integração com banco de dados

- `RESERVAS`
- `ATENDIMENTO_RESERVAS`
- `dda.vinculo_sf`

### Componentes compartilhados utilizados

- Página global.
- Breadcrumb.
- Padrão de checkbox de relatório.

### Observações

É a única página de cancelamento em massa no fluxo do solicitante.

## Página 11 - Confirmação Asqualog

### Objetivo

Servir como central operacional da ASQUALOG para análise, confirmação, cancelamento e comunicação sobre reservas.

### Fluxo de utilização

Ao entrar, a página atualiza automaticamente o estado de reservas vencidas e organiza as solicitações em grupos. O usuário analisa grupos, abre detalhes em modais, emite e-mails, gera texto de OS e confirma em lote quando necessário.

### Funcionalidades

- Agrupamento de reservas por solicitação.
- Análise individual ou em lote.
- Confirmação, cancelamento e comunicação.
- Calendário e relatório das reservas já confirmadas.

### Itens

- `P11_ID_GRUPO_ATIVO`
- `P11_TITULO`
- `P11_SETOR`
- `P11_FILTRO`
- `P11_INICIO`
- `P11_FIM`
- `P11_LIXO`

### Regiões

- Breadcrumb.
- Grupos de reservas para avaliar.
- Filtro.
- Calendário de reservas confirmadas.
- Relatório de reservas confirmadas.

### Botões

- `E-mail Patrimônio`
- `Confirmar Reservas`
- `Ver Todas Reservas`
- `Gerar Relatório`

### Processos

- Atualização automática de status por tempo.
- Carregamento dinâmico dos grupos de reservas.
- Ações de confirmação, cancelamento e envio de mensagens por grupo.

### Validações

- Apenas grupos ativos podem ser expandidos.
- Filtros devem ser compatíveis com o relatório e o calendário.

### Dynamic Actions

- Abertura e recolhimento de grupos.
- Carregamento AJAX do conteúdo do grupo.
- Restauração do grupo ativo após retorno de modal.

### Consultas SQL importantes

- Query de calendário com classificação CSS por tipo e status.
- Query de grupo montada dinamicamente para o relatório interativo.

### Integração com banco de dados

- `RESERVAS`
- `ATENDIMENTO_RESERVAS`
- `HORARIOS_MEZANINO`
- `RESERVAS_IMG`
- `dda.vinculo_sf`
- `dda.orgao`

### Componentes compartilhados utilizados

- Página global.
- Breadcrumb.
- Modais 201, 202, 203, 205 e 206.
- Padrões de calendário e relatório.

### Observações

É a página com maior concentração de tarefas de ASQUALOG e a principal consumidora de fluxos em modal.

## Página 12 - Relatório

### Objetivo

Exibir indicadores e gráficos para análise gerencial das reservas.

### Fluxo de utilização

O usuário ajusta filtros por setor, tipo e mês para recalcular KPIs e visualizações. A página responde com cartões de indicadores e gráficos consolidados.

### Funcionalidades

- KPIs de volume, confirmação e cancelamento.
- Gráficos por mês, tipo, setor, duração e dia da semana.

### Itens

- `P12_FILTRO_SETOR`
- `P12_FILTRO_TIPO`
- `P16_FILTRO_MES`
- `P12_LIXO`

### Regiões

- Breadcrumb.
- KPI.
- Filtro.
- Quantidade de reservas por mês.
- Reservas confirmadas por tipo.
- Reservas confirmadas por setor.
- Média de duração das reservas.
- Reservas por dia da semana.

### Botões

- Breadcrumbs de navegação interna.

### Processos

- Cálculo dos indicadores via PL/SQL.

### Validações

- Os gráficos devem responder aos mesmos filtros para manter coerência analítica.

### Dynamic Actions

- Recalcular visualizações a partir dos filtros.

### Consultas SQL importantes

- Agregações sobre `RESERVAS` por mês, tipo, setor e status.

### Integração com banco de dados

- `RESERVAS`
- `dda.vinculo_sf`
- `dda.orgao`

### Componentes compartilhados utilizados

- Página global.
- Breadcrumb.

### Observações

É uma página exclusivamente analítica e não executa mutações de dados.

## Página 13 - Histórico Geral

### Objetivo

Concentrar a visão histórica completa das reservas para consulta e exportação.

### Fluxo de utilização

O usuário filtra o conjunto de reservas históricas, revisa os resultados em relatório e pode exportar o conteúdo para análise externa.

### Funcionalidades

- Pesquisa histórica por vários critérios.
- Exportação da listagem.

### Itens

- `P13_COD_GRUPO`
- `P13_NOME_EVENTO`
- `P13_TIPO`
- `P13_DATA_INICIO`
- `P13_DATA_FIM`
- `P13_LOCAL`
- `P13_ORGAO`
- `P13_STATUS`
- `P13_LIXO`

### Regiões

- Breadcrumb.
- Filtro.
- Relatório de histórico.

### Botões

- `Limpar Filtro`
- `Baixar Reservas`

### Processos

- Atualização do relatório conforme os filtros.
- Exportação dos dados filtrados.

### Validações

- Valores digitados manualmente em caixas de combinação são armazenados no item auxiliar.

### Dynamic Actions

- Recarregamento do relatório ao alterar filtros.
- Ação de download associada ao relatório.

### Consultas SQL importantes

- Agrupamento com `LISTAGG` de locais.
- Conversão de datas com `TO_DATE`.
- Uso de `apex_string.split` e `REGEXP_LIKE` para filtros flexíveis.

### Integração com banco de dados

- `RESERVAS`
- `dda.vinculo_sf`
- `dda.orgao`

### Componentes compartilhados utilizados

- Página global.
- Breadcrumb.
- Padrão de exportação de relatório.

### Observações

É a visão mais abrangente do histórico e complementa a análise analítica da página 12.

## Página 14 - Reserva do Mezanino

### Objetivo

Permitir o cadastro de reservas de mezanino com apoio documental, captura de horários e validações específicas do fluxo.

### Fluxo de utilização

O usuário anexa o documento-base, o sistema lê o conteúdo, extrai os dados principais e ajuda no preenchimento. Em seguida, o usuário agenda os horários, revisa os dados e envia a solicitação para a fila de pendências.

### Funcionalidades

- Leitura de PDF anexado.
- Preenchimento assistido dos campos do formulário.
- Gestão de horários temporários.
- Calendário específico para o mezanino.

### Itens

- `P14_ID_RESERVA`
- `P14_PENDENTE`
- `P14_STATUS`
- `P14_ARQ`
- `P14_TIP_RESERVAS`
- `P14_NOME_SOLICITANTE`
- `P14_CPF_SOLICITANTE`
- `P14_RAMAL`
- `P14_TITULO_RESERVA`
- `P14_DES_RESERVA`
- `P14_NUM_PARTICIPANTES`
- `P14_JUSTIFICATIVA`
- `P14_OBS`

### Regiões

- Breadcrumb.
- Formulário de mezanino.
- Datas selecionadas.
- Apoio JavaScript e PDF.
- Reservas pendentes de mezanino.

### Botões

- `Cancelar`
- `Adicionar aos Pendentes`

### Processos

- Inserção da reserva como pendente.
- Consolidação dos horários em estrutura temporária.

### Validações

- Horários e datas respeitam regras de intervalo e conflito.
- O fluxo de mezanino trata janelas de almoço e mínimos de antecedência.

### Dynamic Actions

- Listener de upload do arquivo.
- Busca automática de dados do CPF.
- Atualização do calendário de seleção.
- Abertura dos modais 107, 108 e 109.

### Consultas SQL importantes

- Calendário unindo `TMP_RESERVAS` e `HORARIOS_MEZANINO`.
- Uso de `dbms_lob.getlength` para controle de anexo.

### Integração com banco de dados

- `RESERVAS`
- `HORARIOS_MEZANINO`
- `TMP_RESERVAS`

### Componentes compartilhados utilizados

- Página global.
- Arquivos estáticos.
- JavaScript de apoio.
- Modais 107, 108 e 109.

### Observações

É o único fluxo que depende de documento de entrada e de consolidação de horários temporários antes da confirmação final.

## Página 15 - Confirmar Mezanino

### Objetivo

Finalizar as reservas de mezanino que já foram preparadas e enviá-las para o fluxo institucional.

### Fluxo de utilização

A página lista as reservas de mezanino pendentes, permite revisar os detalhes e conclui a confirmação com envio de comunicação.

### Funcionalidades

- Revisão de pendências de mezanino.
- Confirmação final da reserva.
- Notificação por e-mail.

### Itens

- Itens de relatório e contexto do grupo de mezanino.

### Regiões

- Breadcrumb.
- Relatório de pendências.
- Barra de ações.

### Botões

- `Cancelar`
- `Create`

### Processos

- Atualização de status para confirmado.
- Envio de e-mail para os destinatários do fluxo.

### Validações

- Apenas registros pendentes de mezanino entram no resumo.

### Dynamic Actions

- Abertura do modal 106 a partir do relatório.

### Consultas SQL importantes

- Lista de reservas de mezanino com filtro de estado pendente.

### Integração com banco de dados

- `RESERVAS`

### Componentes compartilhados utilizados

- Página global.
- Breadcrumb.
- Padrão de confirmação aplicado ao mezanino.

### Observações

É o fechamento exclusivo do fluxo de mezanino e não compartilha a mesma lógica de grupo da página 11.

## Página 16 - Email Patrimônio

### Objetivo

Controlar o envio de notificações para o setor de patrimônio sobre reservas confirmadas de totens que ainda não foram comunicadas.

### Fluxo de utilização

O usuário filtra as reservas elegíveis, revisa o conjunto e aciona o envio da comunicação. O sistema marca os itens como informados e envia o e-mail consolidado.

### Funcionalidades

- Lista de reservas confirmadas pendentes de envio ao patrimônio.
- Filtro por período, tipo e local.
- Marcação de envio concluído.

### Itens

- `P16_NOME_EVENTO`
- `P16_TIPO`
- `P16_DATA_INICIO`
- `P16_DATA_FIM`
- `P16_LOCAL`
- `P16_LIXO`

### Regiões

- Breadcrumb.
- Filtro.
- Relatório de reservas para patrimônio.

### Botões

- `Limpar Filtro`
- Botão de envio de e-mail.

### Processos

- Atualização de `IND_PATRIMONIO`.
- Envio de e-mail consolidado.

### Validações

- Apenas reservas confirmadas de porta-banner e porta-cartaz aparecem.
- A janela de análise considera o mês atual e o seguinte.

### Dynamic Actions

- Recarregamento do relatório ao alterar filtros.

### Consultas SQL importantes

- Agrupamento com `LISTAGG`.
- Filtro temporal por mês corrente e próximo mês.
- Seleção por `apex_item.checkbox2`.

### Integração com banco de dados

- `RESERVAS`
- `dda.vinculo_sf`
- `dda.orgao`

### Componentes compartilhados utilizados

- Página global.
- Breadcrumb.
- Padrão de comunicação por e-mail.

### Observações

É um fluxo lateral de comunicação operacional, separado da confirmação principal da ASQUALOG.

## Página 101 - Detalhes de Reservas Confirmadas

### Objetivo

Exibir detalhes completos de uma reserva já confirmada, com acesso ao histórico de atendimento.

### Fluxo de utilização

A página é aberta a partir de relatórios ou da análise da ASQUALOG. O usuário alterna entre a visualização dos dados da reserva e a linha do tempo de atendimento.

### Funcionalidades

- Visualização de detalhes da reserva.
- Visualização do histórico de atendimento.
- Exibição de horários do mezanino quando aplicável.

### Itens

- `P101_MODO`
- `P101_ID_RESERVA`
- `P101_TITULO_RESERVA`
- `P101_DES_RESERVA`
- `P101_DAT_INICIO`
- `P101_DAT_FIM`
- `P101_TIP_RESERVAS`
- `P101_LOC`
- `P101_STATUS`
- `P101_NUM_PARTICIPANTES`
- `P101_COD_PESSOA`

### Regiões

- Formulário de reserva.
- Datas do mezanino.
- Relatório de atendimento.

### Botões

- `Atendimento`
- `Detalhes`

### Processos

Não há mutação direta de dados.

### Validações

- A região de datas é exibida apenas para mezanino.

### Dynamic Actions

- `P101_MODO` alterna a região visível.

### Consultas SQL importantes

- Histórico em `ATENDIMENTO_RESERVAS` ordenado do mais recente para o mais antigo.

### Integração com banco de dados

- `RESERVAS`
- `ATENDIMENTO_RESERVAS`

### Componentes compartilhados utilizados

- Padrão de detalhe/histórico reaproveitado em outras modais.

### Observações

É uma modal de consulta e não de decisão.

## Página 102 - Detalhes de Reservas Canceladas e Realizadas

### Objetivo

Exibir a trilha de atendimento de reservas já encerradas.

### Fluxo de utilização

A modal é aberta a partir de listas históricas e mostra apenas a evolução do atendimento vinculado à reserva.

### Funcionalidades

- Consulta do histórico de atendimento.

### Itens

- Contexto da reserva selecionada.

### Regiões

- Relatório de atendimento.

### Botões

- Não há botões de ação direta documentados.

### Processos

Não há.

### Validações

Não há regras operacionais adicionais além do contexto da reserva.

### Dynamic Actions

Não documentadas.

### Consultas SQL importantes

- Mesmo padrão de leitura de `ATENDIMENTO_RESERVAS` usado na modal 101.

### Integração com banco de dados

- `ATENDIMENTO_RESERVAS`

### Componentes compartilhados utilizados

- Padrão de auditoria/histórico.

### Observações

Difere da modal 101 por não alternar entre detalhe e histórico; ela é apenas leitura histórica.

## Página 103 - Detalhes de Reservas Pendentes

### Objetivo

Permitir ao usuário revisar uma reserva ainda não confirmada e excluí-la se necessário.

### Fluxo de utilização

A modal mostra os dados da reserva pendente, incluindo o bloco de mezanino quando aplicável, e oferece a ação de cancelamento do rascunho.

### Funcionalidades

- Consulta de reserva pendente.
- Exibição condicional de horários do mezanino.
- Exclusão da reserva em rascunho.

### Itens

- `P103_STATUS`
- `P103_ID_RESERVA`
- `P103_TITULO_RESERVA`
- `P103_DES_RESERVA`
- `P103_TIP_RESERVAS`
- `P103_DAT_INICIO`
- `P103_DAT_FIM`
- `P103_LOC`
- `P103_NUM_PARTICIPANTES`
- `P103_OBSERVACAO`

### Regiões

- Formulário de reserva.
- Datas do mezanino.
- Rodapé de ações.

### Botões

- `Cancelar Reserva`

### Processos

- Exclusão em cascata lógica da reserva e dos horários associados.

### Validações

- Visibilidade dos campos varia conforme o tipo de reserva.

### Dynamic Actions

- Ajuste de campos conforme o tipo.

### Consultas SQL importantes

- Remoção direta por identificador da reserva.

### Integração com banco de dados

- `RESERVAS`
- `HORARIOS_MEZANINO`
- `ATENDIMENTO_RESERVAS`

### Componentes compartilhados utilizados

- Padrão de detalhamento das modais.

### Observações

É a modal de manutenção do rascunho do usuário.

## Página 104 - Seletor de Datas

### Objetivo

Ajudar a selecionar um intervalo de datas válido para a reserva.

### Fluxo de utilização

A modal recebe o intervalo escolhido no calendário, permite ajustes e devolve as datas para a página de reserva.

### Funcionalidades

- Seleção e confirmação de intervalo.
- Validação de antecedência e coerência do período.

### Itens

- `P104_DAT_INICIO`
- `P104_DAT_FIM`

### Regiões

- Campos de data.
- Rodapé de ações.

### Botões

- `Fechar`
- `Salvar`

### Processos

Não há processos de banco.

### Validações

- A data inicial não pode ser posterior à final.
- O intervalo não pode estar no passado.
- O início deve respeitar a antecedência mínima definida pela regra de negócio.

### Dynamic Actions

- Retorno das datas para a página chamadora.

### Consultas SQL importantes

Não se aplica.

### Integração com banco de dados

Não se aplica diretamente.

### Componentes compartilhados utilizados

- Fluxo de calendário da página 3.

### Observações

É uma modal de apoio puro, sem persistência própria.

## Página 105 - Detalhes de Reservas de Outros

### Objetivo

Exibir a reserva de outro solicitante para apoio à negociação de disponibilidade.

### Fluxo de utilização

A modal abre em modo somente leitura, mostra o solicitante, o setor e os dados da reserva, e permite retorno sem edição.

### Funcionalidades

- Consulta de reserva de terceiro.
- Exibição da identidade do solicitante.
- Exibição do contexto do setor.

### Itens

- `P105_ID_RESERVA`
- `P105_TITULO_RESERVA`
- `P105_DES_RESERVA`
- `P105_TIP_RESERVAS`
- `P105_DAT_INICIO`
- `P105_DAT_FIM`
- `P105_LOC`
- `P105_NUM_PARTICIPANTES`
- `P105_STATUS`
- `P105_PENDENTE`
- `P105_COD_PESSOA`
- `P105_NOME`
- `P105_RAMAL`
- `P105_SETOR`

### Regiões

- Formulário de detalhe.
- Bloco do solicitante.
- Datas do mezanino.
- Rodapé.

### Botões

- `Fechar`

### Processos

Não há.

### Validações

- Campos exibidos variam conforme o tipo de reserva.

### Dynamic Actions

- Exibição condicional de local, número de participantes e horários do mezanino.

### Consultas SQL importantes

- Consulta do responsável e do setor via vínculos corporativos.

### Integração com banco de dados

- `RESERVAS`
- `HORARIOS_MEZANINO`
- `dda.vinculo_sf`
- `dda.orgao`

### Componentes compartilhados utilizados

- Padrão de detalhe entre modais de reserva.

### Observações

Difere das modais do próprio usuário por expor dados do terceiro para negociação.

## Página 106 - Cancelar Reserva

### Objetivo

Excluir uma reserva de mezanino ainda não confirmada.

### Fluxo de utilização

A modal exibe a reserva e executa a exclusão quando o usuário confirma o cancelamento.

### Funcionalidades

- Consulta da reserva de mezanino.
- Exclusão do agendamento e de seus horários.

### Itens

- `P106_TIP_RESERVAS`
- `P106_TITULO_RESERVA`
- `P106_DES_RESERVA`
- `P106_NUM_PARTICIPANTES`
- `P106_OBSERVACAO`

### Regiões

- Formulário de reserva.
- Rodapé.

### Botões

- `Cancelar`

### Processos

- Exclusão da reserva e dos horários vinculados.

### Validações

- Fluxo aplicado apenas ao cenário de mezanino pendente.

### Dynamic Actions

Não documentadas.

### Consultas SQL importantes

- Remoção direta por identificador.

### Integração com banco de dados

- `RESERVAS`
- `HORARIOS_MEZANINO`

### Componentes compartilhados utilizados

- Padrão de exclusão da etapa de mezanino.

### Observações

É uma versão mais simples da lógica de cancelamento do mezanino.

## Página 107 - Horário Mezanino

### Objetivo

Inserir um intervalo temporário de horário para compor a reserva de mezanino.

### Fluxo de utilização

O usuário informa data, início e fim do horário e grava o intervalo em área temporária para posterior consolidação.

### Funcionalidades

- Cadastro de intervalo temporário.
- Validação de formato de horário.

### Itens

- `P107_ID_TEMP`
- `P107_CPF_SOLICITANTE`
- `P107_DAT`
- `P107_HOR_INICIO`
- `P107_HOR_FIM`
- `P107_ERROR_MESSAGE`

### Regiões

- Formulário.
- Rodapé.

### Botões

- `Fechar`
- `Adicionar Horário`

### Processos

- Inserção do horário em tabela temporária.

### Validações

- Formatação e consistência do horário na digitação.

### Dynamic Actions

- Máscara e checagem de horário em tempo real.

### Consultas SQL importantes

- Inserção em `TMP_RESERVAS`.

### Integração com banco de dados

- `TMP_RESERVAS`

### Componentes compartilhados utilizados

- Fluxo temporário da página 14.

### Observações

É a única página modal voltada a uma tabela temporária de agenda.

## Página 108 - Deletar Horário

### Objetivo

Remover um intervalo temporário previamente adicionado ao mezanino.

### Fluxo de utilização

A modal exibe o horário selecionado e confirma sua exclusão da área temporária.

### Funcionalidades

- Exclusão de intervalo temporário.

### Itens

- `P108_DAT`
- `P108_HOR_INICIO`
- `P108_HOR_FIM`
- `P108_ID_TEMP`

### Regiões

- Rodapé.

### Botões

- `Excluir`

### Processos

- Exclusão da linha temporária.

### Validações

Nenhuma além do contexto da linha selecionada.

### Dynamic Actions

Não documentadas.

### Consultas SQL importantes

- Remoção por identificador temporário.

### Integração com banco de dados

- `TMP_RESERVAS`

### Componentes compartilhados utilizados

- Manutenção da agenda temporária do mezanino.

### Observações

É o inverso funcional da página 107.

## Página 109 - Visualizar Mezanino

### Objetivo

Exibir um horário de mezanino, seja ele temporário ou já consolidado.

### Fluxo de utilização

A modal avalia a origem do registro e mostra o detalhe completo ou um aviso de estado temporário.

### Funcionalidades

- Consulta de slot de mezanino.
- Tratamento visual de registro temporário.

### Itens

- `P109_ID_RESERVA`
- `P109_TITULO_RESERVA`
- `P109_DES_RESERVA`
- `P109_HORA_INICIO`
- `P109_HORA_FIM`
- `P109_NUM_PARTICIPANTES`
- `P109_OBSERVACAO`
- `P109_NOME`
- `P109_RAMAL`
- `P109_SETOR`

### Regiões

- Formulário de detalhe.
- Aviso de temporário.
- Rodapé.

### Botões

- `Fechar`

### Processos

Não há.

### Validações

- A exibição depende da origem do slot.

### Dynamic Actions

- Escolha da região conforme o estado do item.

### Consultas SQL importantes

Não documentadas no material consolidado.

### Integração com banco de dados

- `RESERVAS`
- Contexto temporário do mezanino.

### Componentes compartilhados utilizados

- Fluxo de detalhe do mezanino.

### Observações

É a modal que melhor diferencia o estado provisório do estado confirmado.

## Página 201 - Confirmar ou Cancelar Reserva

### Objetivo

Permitir que a ASQUALOG tome decisão individual sobre uma reserva específica.

### Fluxo de utilização

A modal abre o registro, permite informar justificativa e executa a decisão de confirmar ou cancelar, retornando depois ao grupo correspondente na página 11.

### Funcionalidades

- Aprovação individual.
- Reprovação individual.
- Registro de justificativa.
- Geração de auditoria da decisão.

### Itens

- `P201_ID_RESERVA`
- `P201_TITULO_RESERVA`
- `P201_DES_RESERVA`
- `P201_TIP_RESERVAS`
- `P201_DAT_INICIO`
- `P201_DAT_FIM`
- `P201_LOC`
- `P201_NUM_PARTICIPANTES`
- `P201_OBSERVACAO`
- `P201_NOM_PESSOA`
- `P201_JUSTIFICATIVA`

### Regiões

- Formulário de reserva.
- Datas do mezanino.
- Rodapé.

### Botões

- `Recusar`
- `Confirmar`

### Processos

- Callback de confirmação ou cancelamento.
- Geração de retorno para a página 11.

### Validações

- Exibição do bloco de horários apenas para mezanino.

### Dynamic Actions

- Alternância de campos conforme o tipo de reserva.

### Consultas SQL importantes

- Atualização de status da reserva.
- Inserção de atendimento em `ATENDIMENTO_RESERVAS`.

### Integração com banco de dados

- `RESERVAS`
- `ATENDIMENTO_RESERVAS`

### Componentes compartilhados utilizados

- Página 11 como contexto de retorno.
- Padrão de detalhe de modais.

### Observações

É a unidade mínima de decisão da ASQUALOG.

## Página 202 - Enviar Email Reserva

### Objetivo

Revisar um grupo de reservas antes de enviar a resposta consolidada por e-mail.

### Fluxo de utilização

A modal mostra o grupo em análise, confirma a ação de envio e retorna para a página 11 após o processamento.

### Funcionalidades

- Revisão em nível de grupo.
- Envio da resposta consolidada.

### Itens

- Contexto do grupo.

### Regiões

- Grupo de reservas.

### Botões

- `Confirmar e Enviar E-mail`

### Processos

- Montagem do corpo do e-mail.
- Atualização do indicador de e-mail enviado.
- Envio para o solicitante e SEQUALOG.

### Validações

- O grupo revisado deve estar completo para envio.

### Dynamic Actions

Não documentadas.

### Consultas SQL importantes

- Consolidação das reservas do grupo para compor a mensagem.

### Integração com banco de dados

- `RESERVAS`

### Componentes compartilhados utilizados

- Fluxo de grupo da página 11.

### Observações

É uma etapa de comunicação, não de decisão.

## Página 203 - Imagem da Reserva

### Objetivo

Disponibilizar o download do arquivo associado à reserva.

### Fluxo de utilização

A modal é aberta a partir da análise da ASQUALOG e apresenta somente o componente de download do anexo.

### Funcionalidades

- Download do arquivo da reserva.

### Itens

- Contexto do anexo da reserva.

### Regiões

- Download.

### Botões

- Não há botões de ação além do próprio download.

### Processos

Não há.

### Validações

Não há.

### Dynamic Actions

Não há.

### Consultas SQL importantes

- Leitura do BLOB e metadados do anexo da reserva.

### Integração com banco de dados

- `RESERVAS`

### Componentes compartilhados utilizados

- Página 11 como origem do link.

### Observações

É a modal mais simples do conjunto.

## Página 204 - Detalhes/Cancelar Reservas Confirmadas

### Objetivo

Permitir que a ASQUALOG inspecione uma reserva confirmada, registre observações internas e, se necessário, cancele o item.

### Fluxo de utilização

A modal abre o detalhe da reserva, permite adicionar observação interna, exibe horários do mezanino quando aplicável e oferece a ação de cancelamento.

### Funcionalidades

- Visualização completa da reserva.
- Registro de observação da ASQUALOG.
- Cancelamento com justificativa.

### Itens

- `P204_JUSTIFICATIVA`
- `P204_OBS_ASQUALOG`
- `P204_ID_RESERVA`
- `P204_TITULO_RESERVA`
- `P204_DES_RESERVA`
- `P204_TIP_RESERVAS`
- `P204_DAT_INICIO`
- `P204_DAT_FIM`
- `P204_LOC`
- `P204_NUM_PARTICIPANTES`
- `P204_STATUS`
- `P204_NOME`
- `P204_RAMAL`
- `P204_SETOR`

### Regiões

- Formulário de reserva.
- Datas do mezanino.
- Rodapé.

### Botões

- `Fechar`
- `Adicionar Observação`
- `Cancelar Reserva`

### Processos

- Atualização da observação interna.
- Cancelamento com envio de e-mail.

### Validações

- Exibição condicionada pelo tipo de reserva.

### Dynamic Actions

- Exibição de campos conforme o tipo.

### Consultas SQL importantes

- Atualização direta de `RESERVAS` e remoção/encerramento do fluxo associado.

### Integração com banco de dados

- `RESERVAS`
- `HORARIOS_MEZANINO`

### Componentes compartilhados utilizados

- Padrão de detalhe das modais de análise.

### Observações

É a modal de revisão confirmada com capacidade de cancelamento posterior.

## Página 205 - Gerar texto para a OS

### Objetivo

Gerar o texto consolidado usado na abertura de uma ordem de serviço.

### Fluxo de utilização

A ASQUALOG revisa o grupo confirmado, aciona a geração do texto e recebe o conteúdo padronizado para uso operacional.

### Funcionalidades

- Geração de texto para OS.
- Consolidação de informações do grupo.

### Itens

- Contexto do grupo.

### Regiões

- Relatório do grupo confirmado.

### Botões

- `Gerar Texto`

### Processos

- Montagem do corpo textual com dados das reservas e locais.

### Validações

- Apenas reservas confirmadas do grupo entram na composição.

### Dynamic Actions

Não documentadas.

### Consultas SQL importantes

- Consolidação dos locais e dados das reservas do grupo.

### Integração com banco de dados

- `RESERVAS`

### Componentes compartilhados utilizados

- Página 11 como origem do fluxo.
- Plugin de geração documental.
- Template de documento.

### Observações

É uma modal de produção de conteúdo, não de decisão.

## Página 206 - Confirmar Reservas do Grupo

### Objetivo

Confirmar em lote todas as reservas pertencentes ao mesmo grupo.

### Fluxo de utilização

A modal apresenta o grupo, permite registrar ou reaproveitar justificativa e aplica a confirmação em todas as reservas relacionadas.

### Funcionalidades

- Aprovação em lote.
- Justificativa única para o grupo.

### Itens

- `P206_ID_GRUPO`
- `P206_JUSTIFICATIVA`

### Regiões

- Grupo de reservas.
- Campo de justificativa.

### Botões

- `Confirmar Reservas`

### Processos

- Atualização de todas as reservas do grupo para confirmado.

### Validações

- A ação considera apenas o grupo selecionado.

### Dynamic Actions

- Preenchimento inicial da justificativa quando disponível.

### Consultas SQL importantes

- Atualização em lote sobre `RESERVAS`.

### Integração com banco de dados

- `RESERVAS`

### Componentes compartilhados utilizados

- Página 11 como origem do grupo.

### Observações

É a alternativa em massa à decisão individual da página 201.

## Fluxo Completo da Navegação

O fluxo começa na página 0, que estrutura a aplicação inteira, e normalmente entra pela página 1 como ponto de acesso às áreas funcionais. Do lado do usuário final, a jornada principal segue para a página 3 para criação da reserva, passa pela página 4 para confirmação da solicitação e retorna ao acompanhamento em 2. As páginas 5, 103 e 106 suportam cancelamentos e exclusões pontuais ao longo desse caminho.

O fluxo de mezanino é separado e mais especializado: a página 14 recebe o documento de entrada, organiza horários temporários nas modais 107, 108 e 109 e conclui no fechamento pela página 15. Do lado da ASQUALOG, a operação se concentra na página 11, que distribui o trabalho para as modais 201, 202, 203, 205 e 206, além de navegar para 12, 13 e 16 pelos atalhos do breadcrumb. A página 12 oferece análise gerencial, a 13 consolida histórico e exportação, e a 16 fecha o ciclo operacional de comunicação com patrimônio.

Em termos práticos, o percurso da aplicação é: entrada e acesso rápido em 1, criação em 3, confirmação em 4, acompanhamento em 2, tratamento operacional em 11, análise em 12 e 13, comunicação com patrimônio em 16 e, no caso do mezanino, preparação em 14 e fechamento em 15. Os modais funcionam como pontos de decisão ou detalhe que interrompem esse fluxo principal sem quebrar a navegação de retorno ao contexto de origem.