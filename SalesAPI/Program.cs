using Prometheus;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenTelemetry()
    .WithTracing(tracing => tracing
        .AddSource("SalesAPI") // Nome da fonte de traces
        .SetResourceBuilder(
            ResourceBuilder.CreateDefault()
                .AddService(serviceName: "sales-api")) // Como aparecerá no Jaeger
        .AddAspNetCoreInstrumentation() // Captura automaticamente requisições HTTP
        .AddOtlpExporter(options =>
        {
            // "jaeger" é o nome do serviço no seu docker-compose
            options.Endpoint = new Uri("http://jaeger:4317"); 
        }));

var app = builder.Build();

// 1. Coleta métricas padrão do ASP.NET (Duração, Erros, Quantidade de Requests)
app.UseHttpMetrics();

// 2. Expõe o endpoint /metrics para o Prometheus ler (Scrape)
app.MapMetrics();

// --- ROTAS PARA TESTAR NA AULA ---

// Rota 1: Sucesso rápido (Base de comparação)
app.MapGet("/", () => "API Operacional!");

// Rota 2: Latência variável (Para mostrar o "Duration" no Grafana)
app.MapGet("/pagamento", async () => {
    var delay = new Random().Next(100, 3000); // Entre 0.1s e 3s
    await Task.Delay(delay);
    return Results.Ok(new { status = "Aprovado", tempo = $"{delay}ms" });
});

// Rota 3: Simulação de Erro (Para mostrar o "Errors" no Grafana)
app.MapGet("/checkout", (ILogger<Program> logger) => {
    if (new Random().Next(1, 5) == 3) {
        logger.LogError("Falha catastrófica no banco de dados durante o checkout!");
        return Results.Problem("Erro interno ao processar venda.");
    }
    return Results.Ok("Venda finalizada!");
});

app.Run();
