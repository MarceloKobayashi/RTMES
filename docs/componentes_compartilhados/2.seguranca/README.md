<div align="center">

<p align="center">
	<h1>2. Segurança</h1>
</p>

</div>

---

## 🎯 Visão Geral

Nessa parte estão presentes as formas que o aplicativo faz a autenticação do usuário. Já que os aplicativos são voltados para usuários internos do Senado Federal, a opção adotada é permitir que o login da intranet autentique automaticamente os usuários no sistema.

## 🔐 Modelo de Autenticação

Para isso, deve-se criar um Esquema de Autenticação (por exemplo `Autenticação Reservas`) e defini-lo como o esquema atual da aplicação. Nas configurações do esquema utilize os seguintes valores:

- **Tipo de Esquema:** Acesso Social
- **Armazenamento de Credenciais:** Credencial_CAS
	- No ambiente de produção a credencial foi criada automaticamente; em desenvolvimento crie uma credencial em: `/App Builder/ Utilitários de Espaço de Trabalho/Credenciais Web`.
		- **Tipo de Autenticação:** Fluxo de Credenciais do Cliente do OAuth2
		- **ID do Cliente / Nome do Usuário:** apex-dda-dsv
		- **Segredo do Cliente / Senha:** Pergunte ao seu supervisor

- **Provedor de Autenticação:** Provedor OpenID Connect
- **URL de descoberta:** `https://adm.senado.gov.br/cas-server/oidc/.well-known/openid-configuration` (produção) e `https://www6gdsv.senado.gov.br/cas-server/oidc/.well-known` (desenvolvimento)
- **Escopo:** oidc
- **Nome do Usuário:** sub
- **Verificar Atributos:** Não

Essas configurações permitem que o APEX delegue a autenticação ao servidor CAS/OpenID Connect do Senado, mapeando o `sub` (sujeito) como identificador do usuário para uso em `:APP_USER`.

---
