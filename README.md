# AmostraCientica

## API: MVC
```mermaid

graph LR
a[USER]
b[Controller]
c[Model]
d[DB]
e[VIEW]

a --> |Faz Requisicao| b
b --> |Valida Dados | c
c --> |Consulta/Atualiza DB|d
d --> |Retorna Dados| c
c --> | Envia dados processados| e
e --> |Renderiza Ui| a

subgraph BackEnd[Node.js - Express.js]
    b-- "Lida com a lógica de negócios" -->c
    c --"Manipula dados e ingerage com o Db" --> d
end

subgraph FrontEnd[Vue.js]
    e -- "Manipula dados e interage com o Db" --> a
end

```
### Explicação da Arquitetura:
**Usuário (User):** O fluxo começa quando o usuário faz uma requisição à aplicação, geralmente através de interações na interface de usuário (frontend Vue.js).

**Controller (Controlador):** O controlador, que faz parte do backend no Express.js, é responsável por receber as requisições do usuário. Ele interpreta a requisição (por exemplo, uma requisição de GET, POST, etc.), valida os dados e decide o que fazer. Em termos de POO, ele seria como uma "classe" que gerencia a lógica de requisições.

**Model (Modelo):** O controlador envia os dados recebidos para o Model, que é responsável por acessar ou modificar o banco de dados (MySQL). O modelo contém a lógica de negócios relacionada aos dados e interage diretamente com o banco.

**MySQL (Banco de Dados):** O banco de dados armazena as informações estruturadas da aplicação, como registros de usuários, produtos, etc. O Model se comunica com o MySQL para obter ou salvar dados.

**View (Visão):** Depois que o Model retorna os dados processados ao Controller, o controlador formata esses dados e envia uma resposta para a View (Vue.js). A View é a interface visual que o usuário vê e interage, e ela renderiza as informações recebidas do backend.

**Usuário:** O fluxo termina quando a View renderiza as informações na tela para o usuário, que pode interagir novamente com a aplicação, fechando o ciclo.

```mermaid
flowchart LR
a{{API}}
b[\Controllers\]
c[\Models\]
d[Views]
e[\Classes\]
f[\Routes\]
g[/Public/]
h[\Node_modules\]
i[app.js]
j[package.json]
l[.env]


b1[UsersController.js]
b2[TurmasController.js]
b3[TrabalhosController.js]

c1[UsersModels.js]
c2[TurmaModels.js]
c3[TrabalhosModels.js]

d1[UsersViews.js]
d2[TrumasViews.js]
d3[TrabalhosViews.js]

e1[UsersClasses.js]
e2[TurmasClasses.js]
e3[TrabalhosClasses.js]

f1[UsersRoutes.js]
f2[TrumasRoutes.js]
f3[Trabalhos.js]

a--->|"Controladores, lidam com as requisiçõe HTTP"|b
a--->|"Modelos, lidam com a lógica de dados"|c
a--->|"Vistas, lidam com a renderização de respostas(ou Jason ou APIs)"|d
a--->|"Classes, reutilizavies, encapsulamento, helpers e classes"|e
a--->|"Rotas, define as routas da aplicação"|f
a--->|"Arquivos estáticos(css, imagens...)"|g
a--->|"Dependências da Aplicação"|h
a--->|"Ponto de entrada da aplicação(Express.js)"|i
a--->|"Define as depedêndias da aplicação"|j
a--->|"Variáveis de Ambiente"|l

b-->b1
b-->b2
b-->b3

c-->c1
c-->c2
c-->c3

d-->d1
d-->d2
d-->d3

e-->e1
e-->e2
e-->e3

f-->f1
f-->f2
f-->f3



```