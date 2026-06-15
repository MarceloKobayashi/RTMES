<div align="center">
  <p align="center">
    <h1>12. Relatório</h1>
  </p>
</div>

---

> Página que permite a ASQUALOG a visualizar gráficos e KPIs sobre as reservas.

## 🎯 Visão geral

A página `12` é a página que mostra todas as métricas pensadas pela equipe, juntamente de 5 gráficos que ajudam a visualizar o estado das reservas. Além disso, o usuário pode filtrar as métricas e gráficos para melhor visualização.

---

## 1 — Breadcrumb (Breadcrumb)

Essa região mostra uma estrutura hierárquica da navegação até a página atual.

Nessa, em específico, tem vários botões que permitem a navegação entre as páginas específicas para a ASQUALOG.

- `E-mail Patrimônio` - Redireciona o usuário para a página `16`.
- `Confirmar Reservas` - Redireciona o usuário para a página `11`.
- `Ver Todas Reservas` - Redireciona o usuário para a página `13`.
- `Gerar Relatório` - Redireciona o usuário para a página `12`.

---

## 2 - KPI (Conteúdo Estático)

Essa região contém 6 sub-regiões do tipo Cartões que exibem alguns indicadores chave de performance (KPIs). O valor exibido nos cartões é calculado por meio de um PL/SQL que utiliza os valores dos itens de página da região 'Filtro' para filtrar as queries.

- `Reservas Totais` - Mostra a quantidade total de reservas no banco de dados.
<br>

- `Média de Reservas por Dia` - Média calculada pelo total de reservas e o número de dias com registro.
<br>

- `Reservas a Analisar` - Reservas que a ASQUALOG precisa analisar.
<br>

- `Reservas Confirmadas` - Total de reservas confirmadas no sistema.
<br>

- `Reservas Canceladas` - Total de reservas canceladas.
<br>

- `Taxa de Confirmação das Reservas` - Total de reservas confirmadas e realizadas dividido pelo total de reservas canceladas.

---

## 3 - Filtro (Conteúdo Estático)

Essa região contém itens de página que o usuário pode inserir valores para filtrar o relatório interativo que mostra as reservas. Todos os itens tem uma ação dinâmica acionada na troca de seus valores, que atualiza a região de relatório interativo.

- `P12_FILTRO_SETOR` - Caixa de Combinação - Permite o usuário escolher os setores que tem alguma reserva no sistema..
<br>

- `P12_FILTRO_TIPO` - Grupo de Caixa de Seleção - Mostra os tipos de reserva e permite o usuário a selecionar quantos ele 
quiser.
<br>

- `P16_FILTRO_MES` - Caixa de Combinação - Mostra os meses e o ano que o usuário pode escolher como filtro.
<br>

- `P12_LIXO` - Oculto - Armazena as entradas manuais dos itens do tipo caixa de combinação.

---

## 4 - Quantidade de Reservas por Mês (Gráfico)

Essa região é uma região do tipo gráfico de linha com área. Ela mostra todos os meses do ano atual e quantas reservas existem em cada um, permitindo filtrar por tipo e pelo setor.

---

## 5 - Reservas Confirmadas por Tipo (Gráfico)

Essa região é uma região do tipo gráfico de rosca. Ela mostra a quantidade de reservas confirmadas que existem em cada tipo, podendo ser filtrada pelo tipo, data e setor.

---

## 6 - Reservas Confirmadas por Setor/Órgão (Gráfico)

Essa região é uma região do tipo gráfico de rosca. Ela mostra a quantidade de reservas confirmadas que existem em cada setor que possui ao menos uma reserva cadastrada no sistema, podendo ser filtrada pelo tipo e data.

---

## 5 - Média de Duração das Reservas (Gráfico)

Essa região é uma região do tipo gráfico de barras horizontais. Ela mostra a duração média de dias de cada tipo de reserva.

---

## 6 - Reservas nesse mês por Dia (Gráfico)

Essa região é uma região do tipo gráfico de barras verticais empilhadas. Ela mostra todos os dias da semana e a quantidade de reservas feitas em cada dia separadas por tipo. Esse gráfico foi feito para calcular em quais dias da semana os usuários mais cadastram reservas no sistema.

---