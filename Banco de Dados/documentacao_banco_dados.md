# Documentação do Banco de Dados - IDEA SERVICE

## Visão Geral

Este documento descreve a estrutura do banco de dados desenvolvido para o site da IDEA SERVICE, uma empresa de serviços de elétrica e automação. O banco de dados foi projetado para suportar todas as funcionalidades do site, incluindo gestão de usuários, serviços, orçamentos, agendamentos e depoimentos.

## Estrutura do Banco de Dados

### Diagrama de Entidade-Relacionamento (Conceitual)

```
USUÁRIOS ----1----< ENDEREÇOS
    |
    |----1----< ORÇAMENTOS ----1----< ITENS_ORÇAMENTO
    |               |                      |
    |               |                      |----N----1 SERVIÇOS ----N----< PACOTES_SERVIÇOS >----N---- PACOTES
    |               |
    |               |----1----< AGENDAMENTOS ----1----< ATENDIMENTOS
    |                               |                       |
    |                               |                       |
    |----N----< TÉCNICOS_AGENDAMENTO                       |
    |                                                       |
    |----1----< DEPOIMENTOS >----1--------------------------
    |
    |----1----< LOGS_SISTEMA
```

## Descrição das Tabelas

### 1. Gestão de Usuários

#### `niveis_acesso`
- **Propósito**: Define os diferentes níveis de permissão no sistema.
- **Campos principais**: id_nivel, nome, descricao
- **Relacionamentos**: Um nível de acesso pode ser atribuído a vários usuários.

#### `usuarios`
- **Propósito**: Armazena informações de todos os usuários do sistema (clientes, técnicos, administradores).
- **Campos principais**: id_usuario, nome_completo, cpf, telefone, email, senha, id_nivel
- **Relacionamentos**: Um usuário pode ter vários endereços, orçamentos, depoimentos e pode ser designado para vários agendamentos como técnico.

#### `enderecos`
- **Propósito**: Armazena os endereços dos usuários.
- **Campos principais**: id_endereco, id_usuario, tipo, cep, logradouro, numero, complemento, bairro, cidade, estado
- **Relacionamentos**: Um endereço pertence a um único usuário, mas um usuário pode ter vários endereços.

### 2. Gestão de Serviços

#### `categorias_servicos`
- **Propósito**: Classifica os serviços em categorias.
- **Campos principais**: id_categoria, nome, descricao, icone
- **Relacionamentos**: Uma categoria pode conter vários serviços.

#### `servicos`
- **Propósito**: Armazena informações sobre os serviços oferecidos.
- **Campos principais**: id_servico, id_categoria, nome, descricao, preco_base, tempo_estimado
- **Relacionamentos**: Um serviço pertence a uma categoria e pode fazer parte de vários pacotes e orçamentos.

#### `pacotes`
- **Propósito**: Define pacotes de serviços com preços especiais.
- **Campos principais**: id_pacote, nome, descricao, preco
- **Relacionamentos**: Um pacote pode conter vários serviços.

#### `pacotes_servicos`
- **Propósito**: Tabela de relacionamento entre pacotes e serviços.
- **Campos principais**: id_pacote, id_servico, quantidade, desconto
- **Relacionamentos**: Relaciona pacotes com serviços em uma relação N:N.

### 3. Gestão de Orçamentos

#### `status_orcamentos`
- **Propósito**: Define os possíveis status de um orçamento.
- **Campos principais**: id_status, nome, descricao, cor
- **Relacionamentos**: Um status pode ser atribuído a vários orçamentos.

#### `orcamentos`
- **Propósito**: Armazena as solicitações de orçamento.
- **Campos principais**: id_orcamento, id_usuario, id_endereco, id_status, data_solicitacao, data_validade, valor_total
- **Relacionamentos**: Um orçamento pertence a um usuário, está associado a um endereço e pode conter vários itens.

#### `itens_orcamento`
- **Propósito**: Detalha os itens incluídos em um orçamento.
- **Campos principais**: id_item, id_orcamento, id_servico, id_pacote, descricao, quantidade, valor_unitario
- **Relacionamentos**: Um item pertence a um orçamento e está associado a um serviço ou pacote.

### 4. Gestão de Agendamentos

#### `status_agendamentos`
- **Propósito**: Define os possíveis status de um agendamento.
- **Campos principais**: id_status, nome, descricao, cor
- **Relacionamentos**: Um status pode ser atribuído a vários agendamentos.

#### `agendamentos`
- **Propósito**: Registra as visitas e instalações agendadas.
- **Campos principais**: id_agendamento, id_orcamento, id_status, data_agendamento, hora_inicio, hora_fim
- **Relacionamentos**: Um agendamento está associado a um orçamento e pode ter vários técnicos designados.

#### `tecnicos_agendamento`
- **Propósito**: Relaciona técnicos com agendamentos.
- **Campos principais**: id_agendamento, id_usuario
- **Relacionamentos**: Relaciona agendamentos com técnicos em uma relação N:N.

### 5. Gestão de Atendimentos

#### `status_atendimentos`
- **Propósito**: Define os possíveis status de um atendimento.
- **Campos principais**: id_status, nome, descricao, cor
- **Relacionamentos**: Um status pode ser atribuído a vários atendimentos.

#### `atendimentos`
- **Propósito**: Registra os serviços em execução ou concluídos.
- **Campos principais**: id_atendimento, id_agendamento, id_status, data_inicio, data_fim, relatorio_tecnico
- **Relacionamentos**: Um atendimento está associado a um agendamento e pode receber depoimentos.

### 6. Gestão de Depoimentos

#### `depoimentos`
- **Propósito**: Armazena avaliações e comentários dos clientes.
- **Campos principais**: id_depoimento, id_usuario, id_atendimento, titulo, texto, avaliacao
- **Relacionamentos**: Um depoimento é feito por um usuário e está associado a um atendimento específico.

### 7. Gestão de Conteúdo

#### `conteudo_site`
- **Propósito**: Armazena conteúdos estáticos do site como FAQs, termos e políticas.
- **Campos principais**: id_conteudo, tipo, titulo, conteudo
- **Relacionamentos**: Não possui relacionamentos diretos com outras tabelas.

#### `contatos`
- **Propósito**: Registra mensagens enviadas pelo formulário de contato.
- **Campos principais**: id_contato, nome, email, telefone, assunto, mensagem
- **Relacionamentos**: Não possui relacionamentos diretos com outras tabelas.

### 8. Auditoria

#### `logs_sistema`
- **Propósito**: Registra ações realizadas no sistema para auditoria.
- **Campos principais**: id_log, id_usuario, acao, tabela, id_registro, dados_antigos, dados_novos
- **Relacionamentos**: Um log pode estar associado a um usuário.

## Fluxos Principais

### Fluxo de Solicitação de Orçamento

1. Um usuário (cliente) se cadastra no sistema (`usuarios`)
2. O cliente cadastra seu endereço (`enderecos`)
3. O cliente solicita um orçamento (`orcamentos`) com status "Pendente"
4. O orçamento inclui serviços ou pacotes específicos (`itens_orcamento`)
5. Após análise, o orçamento tem seu status alterado para "Aprovado" ou "Recusado"

### Fluxo de Agendamento e Atendimento

1. Após aprovação do orçamento, é criado um agendamento (`agendamentos`)
2. Técnicos são designados para o agendamento (`tecnicos_agendamento`)
3. No dia agendado, é registrado o início do atendimento (`atendimentos`)
4. Ao concluir o serviço, o atendimento é finalizado com relatório técnico
5. O cliente pode deixar um depoimento sobre o serviço (`depoimentos`)

## Considerações de Segurança

- Senhas armazenadas com hash seguro (bcrypt)
- Controle de acesso baseado em níveis de permissão
- Registro de logs para auditoria de ações críticas
- Tokens de recuperação de senha com expiração

## Dados Iniciais

O script inclui dados iniciais para:
- Níveis de acesso (Cliente, Técnico, Administrador, Super Admin)
- Status de orçamentos, agendamentos e atendimentos
- Categorias de serviços (Monitoramento, Alarmes, Instalações Elétricas, Automação)
- Serviços em cada categoria
- Pacotes de serviços
- Conteúdo do site (FAQs, termos, políticas)
- Um usuário administrador para testes

## Implementação

Para implementar este banco de dados:

1. Execute o script SQL em um servidor MySQL/MariaDB
2. Verifique se todas as tabelas foram criadas corretamente
3. Confirme se os dados iniciais foram inseridos
4. Teste as relações entre as tabelas com consultas simples

## Extensibilidade

O banco de dados foi projetado para ser facilmente extensível:
- Novas categorias e serviços podem ser adicionados sem alterar a estrutura
- Novos status podem ser criados para diferentes fluxos de trabalho
- O sistema de logs permite rastrear todas as alterações
