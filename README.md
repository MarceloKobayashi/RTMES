![Logo do Senado Federal](docs/assets/senado-logo.png)

# RTMES - Reserva de Totens e Mesas - Espaço do Servidor

## Sobre

RTMES é um sistema desenvolvido em Oracle APEX para gerenciar reservas de totens, adesivagem de mesas e uso do mezanino no Senado Federal. O sistema centraliza as solicitações, apresenta disponibilidade em calendário e permite que a ASQUALOG aprove ou recuse pedidos, reduzindo o fluxo manual por e-mail que existia anteriormente.

## Problema que resolve

Anteriormente, reservas eram feitas por e-mail à ASQUALOG, que conferia disponibilidade em planilhas Excel e respondia ao solicitante — um processo lento e suscetível a erros e retrabalho. O RTMES automatiza essa troca, exibindo disponibilidade em calendário e permitindo solicitações e aprovações diretamente na plataforma.

## Objetivos

- Reduzir o tempo e esforço para solicitar e aprovar reservas.
- Centralizar e tornar transparente a disponibilidade de espaços e totens.
- Fornecer controles de aprovação para a ASQUALOG.
- Gerar relatórios e notificações (e-mail) para ações administrativas.

## Funcionalidades principais

- Calendário de eventos e disponibilidade.
- Reserva de totens (porta-banner, porta-cartaz).
- Solicitação de adesivagem de mesas e mezanino.
- Visualização e gestão de todas as reservas.
- Aprovação/recusa de reservas pela ASQUALOG.
- Relatórios de reservas e envio de e-mails para realocação de totens.

## Estrutura da documentação

Toda a documentação detalhada ficará dentro da pasta `docs/`, organizada por módulos:

- `docs/contexto/` — Contexto do sistema e problema resolvido
- `docs/objetivos/` — Objetivos, requisitos e público-alvo
- `docs/arquitetura/` — Estrutura técnica: banco de dados, backend, frontend
- `docs/instalacao/` — Guia de instalação e execução
- `docs/exemplos/` — Exemplos de código, endpoints e integrações
- `docs/revisao/` — Checklist de revisão e entrega

> Observação: coloque o logo do Senado em `docs/assets/senado-logo.png` para que a imagem no topo seja exibida.

## Próximos passos

1. Criar a pasta `docs/` com a estrutura de módulos.
2. Preencher `docs/contexto/` com o histórico e o problema (baseado em `resumos.txt`).
3. Escrever objetivos e requisitos.

## Como contribuir

Abra uma issue descrevendo a alteração proposta ou faça um fork e envie um pull request com as alterações na pasta `docs/`.

---

Arquivo base usado: `resumos.txt` (conteúdo resumido e adaptado).
