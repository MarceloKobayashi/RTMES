<div align="center">

<p align="center">
	<h1>Componentes Compartilhados</h1>
</p>

> Documentação dos recursos reutilizáveis de uma aplicação em **Oracle APEX** e de como eles sustentam telas, regras e navegação de forma padronizada.

[![Oracle APEX](https://img.shields.io/badge/Oracle%20APEX-Application-orange?logo=oracle&logoColor=white)](https://apex.oracle.com/)
[![Oracle Database](https://img.shields.io/badge/Oracle-Database-red?logo=oracle&logoColor=white)](https://www.oracle.com/database/)

</div>

---

## 🎯 Visão Geral

Em Oracle APEX, componentes compartilhados são objetos reutilizáveis definidos no nível da aplicação para evitar repetição e garantir consistência entre páginas. Eles concentram regras, aparência, navegação e comportamentos que precisam ser usados em mais de uma tela.

## 🧩 O que são componentes compartilhados

Os componentes compartilhados representam a camada de padronização da aplicação. Em vez de configurar a mesma lógica em várias páginas, o APEX permite centralizar esses elementos em um único lugar e reaproveitá-los sempre que necessário.

Isso reduz manutenção, diminui divergências entre telas e facilita a evolução da aplicação, porque uma alteração feita no componente compartilhado pode refletir em vários pontos do sistema.

## ⚙️ Como funcionam no Oracle APEX

No APEX, os componentes compartilhados ficam disponíveis para toda a aplicação e são consumidos pelas páginas conforme a necessidade. O ciclo de uso geralmente é este:

1. O componente é criado na aplicação, como uma lista, um template, um breadcrumb, uma árvore de navegação, uma LOV ou uma autorização.
2. A página ou região referencia esse componente em vez de recriar a configuração do zero.
3. Na execução, o APEX resolve o componente e aplica o comportamento definido nele.
4. Se o componente for alterado, todas as páginas que o utilizam passam a refletir a nova versão.

Esse modelo funciona bem para padronizar interfaces e regras de acesso, porque o componente compartilhado passa a ser a fonte única de verdade para aquilo que precisa ser consistente.

## 🧱 Principais elementos

- Itens e Processos do Aplicativo.
- Autorizações e autenticações.
- Plug-ins
- Breadcrumbs para orientação do usuário.
- Arquivos utilizados pelo aplicativo.s

---