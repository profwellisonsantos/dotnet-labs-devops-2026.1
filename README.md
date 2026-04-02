Aula 05: Qualidade de Software com .NET
==========================================

### TDD, Testes Unitários (xUnit), Cobertura e Testes de Mutação

Este módulo faz parte do laboratório de DevOps 2026.1 e foca em garantir que o código não apenas funcione, mas seja resiliente, testável e de fácil manutenção.

🎯 Objetivos da Aula
--------------------

*   Compreender e aplicar o fluxo **TDD (Test-Driven Development)**.
    
*   Implementar testes unitários utilizando o framework **xUnit**.
    
*   Analisar a eficácia dos testes através da **Cobertura de Código (Code Coverage)**.
    
*   Validar a qualidade dos testes com **Testes de Mutação (Stryker.NET)**.
    

🛠️ Tecnologias Utilizadas
--------------------------

*   **.NET 8/9 SDK**
    
*   **xUnit:** Framework de testes unitários.
        
*   **Coverlet:** Coletor de cobertura de código cross-platform.
    
*   **Stryker.NET:** Ferramenta para testes de mutação.
    

📑 Conteúdo Programático
------------------------

### 1\. TDD (Test-Driven Development)

Praticamos o ciclo **Red-Green-Refactor**:

1.  🔴 **Red:** Escrevemos um teste que falha para uma funcionalidade que ainda não existe.
    
2.  🟢 **Green:** Escrevemos o código mínimo necessário para o teste passar.
    
3.  🔵 **Refactor:** Melhoramos o código mantendo o teste passando.
    

### 2\. Testes Unitários com xUnit

Diferenciamos os dois tipos principais de testes no xUnit:

*   \[Fact\]: Testes que são sempre verdadeiros, testando uma condição invariável.
    
*   \[Theory\]: Testes que aceitam parâmetros (\[InlineData\]), permitindo testar múltiplos cenários com o mesmo método.
    

### 3\. Cobertura de Código

Não basta ter testes, precisamos saber o que eles cobrem. Utilizamos o **Coverlet** para gerar relatórios de cobertura.

> **Desafio:** Atingir 80% de cobertura não garante ausência de bugs! É aqui que entra o próximo tópico.

### 4\. Testes de Mutação (Stryker)

O Stryker introduz <i>bugs</i> propositais (mutantes) no seu código. Se os seus testes continuarem passando mesmo com o código alterado, o mutante **sobreviveu**, indicando que seu teste é fraco. Se o teste falhar, o mutante foi **morto**.

🚀 Como Executar os Testes
--------------------------

### Executar Testes Unitários

`   dotnet test   `

### Gerar Relatório de Cobertura

1. `dotnet add package coverlet.collector`
2. `dotnet test --collect:"XPlat Code Coverage"`
3. `dotnet tool install -g dotnet-reportgenerator-globaltool`
4. `reportgenerator -reports:"FreteCore.Tests/TestResults/*/coverage.cobertura.xml" -targetdir:"coveragereport" -reporttypes:Html`

### Executar Testes de Mutação (Stryker)

Certifique-se de ter o Stryker instalado:

`dotnet tool install -g dotnet-stryker`

Para rodar no projeto de testes:

`dotnet stryker`

📊 Discussões em Aula
---------------------

*   **Pirâmide de Testes:** Por que focar tanto em testes unitários?
    
*   **Mocking:** Quando isolar dependências externas?
    
*   **Cobertura vs. Qualidade:** Por que 100% de cobertura pode ser uma métrica vaidosa se os asserts forem ruins.
    

🔗 Links Úteis
--------------

*   [Documentação xUnit](https://xunit.net/)
    
*   [Stryker.NET Docs](https://stryker-mutator.io/docs/stryker-net/introduction/)
    
*   [FluentAssertions](https://fluentassertions.com/)
