<div align="center">

<p align="center">
  <h1>0. Página Global</h1>
</p>

</div>

---

## 🎯 Visão Geral

A página `0` contém regiões e recursos compartilhados pela aplicação: header, footer e scripts/estilos globais que são incluídos em todas as páginas.

## 🧩 Objetivo

Centralizar a personalização visual e comportamental do header e footer (logo, título, menu do usuário e link de logout), além de estilos globais necessários para manter identidade visual do Senado.

## ⚙️ Componentes principais

- Header fixo com logo e título da aplicação.
- Menu do usuário (nome + dropdown com link de logout) utilizando o item de aplicação NOME_USUARIO e 'URL' para o logout.
- Faixa institucional (banda verde/amarela abaixo do header).
- Footer com identificação do setor (ASQUALOG).

## JavaScript do Header

- Aqui eu vou mostrar somente o JS, pois a parte do CSS não tem muito mistério.

```js
document.addEventListener('DOMContentLoaded', function() {
    const header = document.querySelector('.t-Header');

    if (header) {
        header.addEventListener('click', function(e) {

            // Redirecionar o usuário para a página inicial correta
            if (e.offsetX < header.offsetWidth / 2) {
                var setor = $v('P0_ASQUALOG');
                var setoresPermitidos = ['ASQUALOG', 'SEQUALOG', 'SEGEPAVI'];

                var pagina = setoresPermitidos.includes(setor) ? 2 : 1;

                window.location.href = "f?p=&APP_ID.:" + pagina + ":&SESSION.::NO::";
            }
        });

        const titleText = document.createElement('div');
        titleText.className = 'header-title';
        titleText.textContent = 'Ordem de Serviço';

        // Colocar o item de aplicação e a 'URL' para o logout no botão.
        const userMenu = document.createElement('div');
        userMenu.className = 'user-menu';

        userMenu.innerHTML = `
            <div class="user-name">
                &NOME_USUARIO.
                <i class="fa-solid fa-chevron-down" style="font-size: 12px;"></i>
            </div>
            <div class="user-dropdown">
                <a href="&LOGOUT_URL.">
                    <i class="fa-solid fa-sign-out" style="margin-right: 6px;"></i>Sair
                </a>
            </div>
        `;

        header.appendChild(titleText);
        header.appendChild(userMenu);

        // Mudar o estilo da seta
        userMenu.querySelector('.user-name').addEventListener('click', function(e) {
            e.stopPropagation();
            const dropdown = userMenu.querySelector('.user-dropdown');
            const icon = userMenu.querySelector('.user-name i');

            const isOpen = dropdown.style.display === 'block';
            dropdown.style.display = isOpen ? 'none' : 'block';
            icon.className = isOpen ? 'fa-solid fa-chevron-down' : 'fa-solid fa-chevron-up';
        });

        document.addEventListener('click', function() {
            const dropdown = userMenu.querySelector('.user-dropdown');
            const icon = userMenu.querySelector('.user-name i');

            if (dropdown.style.display === 'block') {
                dropdown.style.display = 'none';
                icon.className = 'fa-solid fa-chevron-down';
            }
        });
    }
});
```
---

Ver também: [paginas/README.md](../README.md)
