# Componentes Compartilhados

## Visão Geral

Os componentes compartilhados do RTMES concentram regras, navegação, identidade visual, seleção de valores e integrações reutilizáveis no nível da aplicação Oracle APEX. A intenção é evitar duplicação entre páginas, garantir comportamento consistente e centralizar o que precisa ser consumido por múltiplas telas ou fluxos.

Na prática, a aplicação usa um conjunto reduzido de categorias, mas com forte acoplamento entre elas: a autenticação identifica o usuário, o item global exibe esse usuário na interface, o cabeçalho e o rodapé da página global são reaproveitados em toda a aplicação, os breadcrumbs orientam o fluxo entre páginas, as LOVs padronizam escolhas, os arquivos estáticos sustentam o layout e os recursos de interface, o plugin AOP viabiliza geração de documentos e a automação por e-mail mantém o processo operacional da ASQUALOG.

Os artefatos analisados não mostraram componentes dedicados para listas de navegação, authorization schemes, application computations, build options, text messages, REST sources ou web source modules. Por isso, a documentação abaixo cobre apenas as categorias efetivamente identificadas.

## Autenticação

### Objetivo

Delegar o login para a infraestrutura institucional e manter a sessão do APEX alinhada ao usuário autenticado da intranet.

### Componentes existentes

- Esquema de autenticação baseado em CAS/OpenID Connect.
- Descoberta automática do provedor por URL de `well-known`.
- Mapeamento do identificador do usuário via atributo `sub`.

### Como são utilizados

A aplicação usa o provedor institucional para autenticar o usuário antes do acesso às páginas de negócio. Após a autenticação, o identificador do usuário passa a estar disponível para consultas e para composição de dados globais, como nome exibido no cabeçalho.

### Onde são utilizados

- Em toda a aplicação, porque a sessão é criada a partir dessa autenticação.
- Na lógica global que busca o nome do usuário autenticado.
- Nos filtros e consultas de páginas que precisam identificar o solicitante ou o responsável logado.

### Dependências

- Servidor CAS/OpenID Connect do Senado Federal.
- `:APP_USER` como referência de login no APEX.
- Tabelas corporativas de vínculo e usuários usadas pelas consultas de identificação.

### Observações

- O modelo é institucional e não local.
- A autenticação é uma dependência estrutural de quase todos os componentes reaproveitados, porque eles assumem que o usuário já está identificado.

## Lógica de Aplicação

### Objetivo

Preparar dados globais em tempo de execução e disponibilizar informações padronizadas para toda a interface.

### Componentes existentes

- Item de aplicação `NOME_USUARIO`.
- Processo de aplicação `Carregar_nome_usuario`.

### Como são utilizados

O processo executa uma consulta em tempo de execução, monta o nome do usuário autenticado em formato padronizado e grava o valor no item global `NOME_USUARIO`. Esse valor é consumido pelo cabeçalho e por outros pontos da aplicação que precisam exibir o usuário sem repetir a consulta em cada página.

### Onde são utilizados

- Na página global, onde o nome aparece no menu do usuário.
- Em qualquer página que consuma o item global no render ou em regiões dinâmicas.
- Indiretamente em fluxos que precisam mostrar a identidade do solicitante ou do operador.

### Dependências

- `:APP_USER`.
- Consultas nas estruturas corporativas de vínculo e login.
- Autenticação institucional previamente concluída.

### Observações

- O processo também trata ausência de dados com mensagens de fallback.
- A lógica é centralizada e evita duplicação de consulta nas páginas.

## Navegação e Breadcrumbs

### Objetivo

Orientar o usuário dentro do fluxo da aplicação e permitir acesso rápido aos pontos principais da operação.

### Componentes existentes

- Breadcrumbs nas páginas operacionais e modais.
- Botões contextuais anexados ao breadcrumb em áreas específicas.

### Como são utilizados

Os breadcrumbs representam a trilha hierárquica até a página atual e, em alguns pontos, incluem ações rápidas para alternar entre áreas relacionadas. A solução substitui uma navegação lateral ou menu compartilhado por um caminho mais direto, alinhado ao fluxo das reservas.

### Onde são utilizados

- Páginas normais do fluxo principal, como as telas de reservas, confirmações, relatórios e visão de mezanino.
- Modais usados na análise, confirmação, envio de e-mail e visualização de detalhes.

### Dependências

- Estrutura de páginas da aplicação.
- Relações entre páginas pai e filha.
- Botões e links definidos em cada breadcrumb.

### Observações

- O projeto não adotou uma lista de navegação compartilhada como componente central.
- O breadcrumb cumpre parte da função que, em outras aplicações, ficaria em um menu global.

## Arquivos Estáticos, CSS e JavaScript

### Objetivo

Fornecer recursos visuais e comportamentais reaproveitáveis sem duplicar código em várias páginas.

### Componentes existentes

- Documento modelo para geração de saída via APEX Office Print.
- Recursos de imagem usados na interface e no cabeçalho.
- Scripts JavaScript para comportamento de botões, cabeçalho e apoio a upload.
- Estilos CSS para calendários, cards e estados visuais.

### Como são utilizados

Os arquivos estáticos sustentam a apresentação e a interação da aplicação. O template de documento serve como base para geração de textos e saídas documentais. O JavaScript implementa ações de interface que seriam repetitivas ou difíceis de manter apenas com configuração declarativa. O CSS diferencia visualmente reservas, estados e tipos de evento em calendários e blocos dinâmicos.

### Onde são utilizados

- Página global, para composição visual do header e do menu do usuário.
- Páginas de início e formulários, onde há botões e elementos visuais personalizados.
- Páginas de calendário, onde classes CSS definem cores por status e tipo.
- Fluxos de upload, onde o JavaScript auxilia o tratamento do arquivo.
- Página modal de geração de texto para OS, que usa o template de documento como referência.

### Dependências

- Estrutura da página global.
- Componentes de calendário da aplicação.
- Upload de arquivos e regiões dinâmicas.
- Plugin de geração documental usado no fluxo da OS.

### Observações

- O repositório de documentação confirma como artefato físico o template de documento usado na geração automática.
- Os demais recursos são descritos como parte da solução e do comportamento da interface, mesmo quando o artefato original não está armazenado nesta pasta de documentação.

## Plugins e Geração de Documentos

### Objetivo

Expandir a capacidade nativa do APEX para gerar documentos a partir de dados da aplicação.

### Componentes existentes

- Integração com APEX Office Print.
- Template de documento usado como base de saída.

### Como são utilizados

O plugin é empregado para transformar dados de reservas em conteúdo documental. O fluxo previsto era gerar automaticamente o texto da OS a partir das reservas selecionadas; a documentação também registra que o uso foi avaliado como alternativa ao envio por e-mail, mas o fluxo operacional final privilegiou o e-mail como caminho principal em parte do processo.

### Onde são utilizados

- Página modal de geração de texto para OS.
- Fluxos de apoio à ASQUALOG que consolidam reservas em uma saída documentada.

### Dependências

- Plugin AOP habilitado na aplicação.
- Template de documento compatível com o mecanismo de placeholders.
- Dados das reservas e do usuário que solicita a geração.

### Observações

- A solução evita reprocessamento manual de conteúdo textual.
- O template funciona como contrato entre o dado armazenado e a saída documental.

## Workflows e Automações

### Objetivo

Executar rotinas assíncronas e periódicas que mantêm o processo de reservas atualizado sem intervenção manual constante.

### Componentes existentes

- Rotina agendada diária para envio de e-mail.
- Envio via `APEX_MAIL`.
- Atualização lógica baseada em flags de reserva, como pendência e acionamento de patrimônio.

### Como são utilizados

A automação percorre reservas confirmadas de totens com pendência de comunicação ao patrimônio e monta um e-mail consolidado para a equipe responsável. O processo trabalha com janela temporal de dois meses, gera o corpo HTML, envia o alerta e grava a fila de e-mail por meio da infraestrutura do APEX.

### Onde são utilizados

- Processo em segundo plano, não atrelado a uma página específica.
- Fluxo operacional da ASQUALOG para controle de patrimônio.
- Indiretamente, sobre os dados produzidos pelas páginas de reserva e confirmação.

### Dependências

- Tabela `RESERVAS`.
- Campos de controle como `pendente`, `status`, `ind_patrimonio` e `tip_reservas`.
- Serviço de e-mail do APEX.

### Observações

- A automação evita acompanhamento manual de eventos já confirmados.
- O processo é estritamente operacional e não substitui a análise feita nas páginas da ASQUALOG.

## Como os Componentes Compartilhados Interagem com as Páginas

A aplicação foi organizada para que a experiência de navegação, identidade visual e lógica comum seja resolvida uma única vez e reaproveitada em todas as páginas. A página global entrega a estrutura base da interface; o esquema de autenticação garante a identidade do usuário; o item `NOME_USUARIO` alimenta o cabeçalho; os breadcrumbs conectam os pontos principais do fluxo; as LOVs padronizam escolhas em formulários e filtros; os arquivos estáticos e o JavaScript sustentam a interação; o plugin AOP cobre a geração documental; e a automação de e-mail mantém a comunicação operacional com o patrimônio.

Na prática, isso significa que as páginas de entrada, reserva, confirmação, relatório e modais especializados não precisam reinventar sua base de apresentação nem suas regras de seleção. Cada página consome os componentes compartilhados conforme sua necessidade, mas a responsabilidade de padronização permanece concentrada nos recursos comuns da aplicação.