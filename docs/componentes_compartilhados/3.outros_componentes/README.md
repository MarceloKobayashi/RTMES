
<div align="center">

<p align="center">
	<h1>RTMES — Outros Componentes</h1>
</p>

</div>

---

## 🎯 Visão Geral

Este diretório reúne componentes e integrações auxiliares utilizados pelo RTMES. O principal item aqui é a integração com o APEX Office Print (AOP), que permite gerar documentos (.docx / .pdf) a partir de templates preenchidos com dados do banco.

## 🧭 Contexto

A intenção inicial foi usar o AOP para gerar automaticamente textos para abertura de Ordens de Serviço (OS) relacionadas a reservas — implementação prevista originalmente na página 205 do aplicativo. Durante o desenvolvimento optou-se por enviar o texto por e-mail em vez de gerar o arquivo automaticamente, devido a custo/limitações e simplicidade de fluxo.

## ❗ Observações e limitações

- O AOP oferece funcionalidades poderosas, mas a conta gratuita tem limite mensal de gerações de arquivos; planeje uso em produção.
- Gerar e armazenar muitos documentos pode ser custoso; avaliar alternativas (envio por e-mail ou geração sob demanda).

## ✅ Instalação e uso (resumo)

1. Instalar o plugin AOP no Oracle APEX conforme a documentação oficial ou guias da comunidade.
2. Criar templates (.docx) com placeholders compatíveis com AOP e armazená-los no repositório do APEX ou em FTP/Storage suportado.
3. Configurar credenciais/API key do AOP no ambiente (variáveis de ambiente ou credenciais do APEX).
4. Implementar rotinas que alimentam o template com dados do banco e disparam a geração/entrega (download ou e-mail).

> Nota: para instruções passo a passo, veja o guia referenciado em "Links úteis".

## 🔗 Links úteis

- Guia de referência que foi utilizado: https://medium.com/@cristina.varas98/creating-reports-and-documents-with-apex-office-print-in-oracle-apex-8c1d1dcae452

---
