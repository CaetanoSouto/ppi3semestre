# Requisitos de Banco de Dados - IDEA SERVICE

## Análise de Requisitos

Com base no site da IDEA SERVICE, identificamos as seguintes necessidades de dados:

### 1. Gestão de Usuários
- Armazenar dados de cadastro de clientes (nome, CPF, telefone, email, senha)
- Gerenciar níveis de acesso (clientes, administradores, técnicos)
- Controlar autenticação e sessões

### 2. Gestão de Serviços
- Catálogo de serviços oferecidos (monitoramento, alarmes, instalações elétricas, automação)
- Detalhes de cada serviço (descrição, preço base, tempo estimado)
- Pacotes de serviços (básico, avançado, premium)

### 3. Gestão de Orçamentos
- Solicitações de orçamentos pelos clientes
- Detalhes do orçamento (serviços incluídos, valores, prazos)
- Status do orçamento (pendente, aprovado, recusado)

### 4. Agendamentos
- Visitas técnicas agendadas
- Instalações programadas
- Manutenções preventivas

### 5. Gestão de Projetos/Atendimentos
- Acompanhamento de serviços em andamento
- Histórico de serviços realizados
- Relatórios técnicos

### 6. Depoimentos de Clientes
- Avaliações e comentários de clientes
- Classificação por estrelas
- Aprovação de depoimentos antes da publicação

### 7. Conteúdo do Site
- Informações de contato
- FAQs
- Termos e condições

## Entidades Principais Identificadas

1. **Usuários** - Clientes e funcionários da empresa
2. **Serviços** - Tipos de serviços oferecidos
3. **Pacotes** - Combinações de serviços com preços específicos
4. **Orçamentos** - Solicitações de orçamento pelos clientes
5. **Agendamentos** - Visitas e instalações programadas
6. **Atendimentos** - Serviços em execução ou concluídos
7. **Depoimentos** - Avaliações de clientes
8. **Conteúdo** - Informações estáticas do site

## Relacionamentos Principais

- Um usuário pode solicitar múltiplos orçamentos
- Um orçamento pode incluir vários serviços
- Um agendamento está relacionado a um orçamento aprovado
- Um atendimento está relacionado a um agendamento
- Um usuário pode deixar múltiplos depoimentos
- Um depoimento está relacionado a um atendimento específico
- Um serviço pode fazer parte de vários pacotes
