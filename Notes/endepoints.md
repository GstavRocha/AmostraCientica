# Queriers e rotinas para os Endepoints:

Para o fluxo de páginas que você descreveu, os seguintes endpoints seriam necessários para lidar com o processo de login, gerenciamento de usuários (visitante, aluno, professor) e trilha dos trabalhos. Vou listar os endpoints com base nas funcionalidades descritas:

---

### 1. **Login**
- **POST /login**
  - Endpoint para autenticação.
  - Requisição:
    - `nome`: string
    - `tipo_usuario`: enum (visitante, aluno, professor)
  - Resposta:
    - Retorna token de autenticação, ou redireciona para a página correta com base no tipo de usuário.

- **POST /visitante**
  - Endpoint para cadastro de visitantes.
  - Requisição:
    - `nome_completo`: string
    - `aluno_convidou`: string
    - `serie_aluno`: string
    - `turma`: string

- **POST /professor**
  - Endpoint para cadastro de professores.
  - Requisição:
    - `nome_completo`: string
    - `email_institucional`: string

- **POST /aluno**
  - Endpoint para cadastro de alunos.
  - Requisição:
    - `nome_completo`: string
    - `data_aniversario`: date
    - `turma`: string
    - `turno`: string
    - `professor_orientador`: boolean (verificar se o professor e a turma são válidos, chamando uma procedure SQL)

---

### 2. **Trilha dos Trabalhos**
- **GET /trabalhos**
  - Endpoint para exibir os trabalhos por grau e turma, filtrando conforme o grau escolar (ex: 6° ANO, 7° ANO).
  - Resposta:
    - Lista de trabalhos ordenada por turno, grau e turma.

- **GET /trabalhos/{id_trabalho}**
  - Endpoint para obter os detalhes de um trabalho específico.
  - Requisição:
    - `id_trabalho`: int
  - Resposta:
    - Detalhes do trabalho, incluindo autor, descrição e grau.

---

### 3. **Ler QR Code**
- **POST /trabalhos/{id_trabalho}/like**
  - Endpoint para registrar um like em um trabalho específico ao ler o QR Code.
  - Requisição:
    - `id_trabalho`: int
  - Resposta:
    - Confirmação de que o like foi registrado.

- **POST /trabalhos/{id_trabalho}/comentario**
  - Endpoint para enviar um comentário opcional em um trabalho.
  - Requisição:
    - `id_trabalho`: int
    - `comentario`: string (opcional)
  - Resposta:
    - Confirmação de que o comentário foi enviado.

---

### 4. **Apresentação de QR Code**
- **GET /apresentacao/gerar-qr**
  - Endpoint para gerar um QR Code que representa o trabalho que está sendo apresentado.
  - Requisição:
    - `id_trabalho`: int
  - Resposta:
    - QR Code associado ao trabalho.

---

### 5. **Professor - Avaliação de Trabalhos**
- **POST /trabalhos/{id_trabalho}/avaliacao**
  - Endpoint para que o professor atribua uma nota ao trabalho.
  - Requisição:
    - `id_trabalho`: int
    - `nota`: int (0-10)
  - Resposta:
    - Confirmação de que a nota foi registrada.

---

### 6. **Dashboard**
- **GET /dashboard**
  - Endpoint para exibir os trabalhos com mais likes.
  - Resposta:
    - Lista dos trabalhos com o maior número de likes, ordenados em ordem decrescente.

---
