using System.Security.Cryptography; // Necessário para o exemplo de Security

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// --- CENÁRIO 1: MAINTAINABILITY (Code Smells / Grau A -> B) ---
// Descomente as linhas abaixo para gerar "Dívida Técnica"
// string tokenInutilizado = "S0M3_S3CR3T_T0K3N"; // Variável declarada e nunca usada
// int x = 10; // Comentário óbvio: atribuindo 10 a x


var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

// Rota Original (Limpa)
app.MapGet("/weatherforecast", () =>
{
    var forecast = Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
})
.WithName("GetWeatherForecast")
.WithOpenApi();


// --- CENÁRIO 2: RELIABILITY (Bugs / Grau A -> C) ---
app.MapGet("/bug-null-reference", (string? nome) =>
{
    // Isso vai gerar um Bug porque 'nome' pode ser nulo e estamos chamando ToUpper()
    return Results.Ok($"Olá, {nome.ToUpper()}"); 
});


// --- CENÁRIO 3: SECURITY & HOTSPOTS (Vulnerabilidades / Grau A -> D/E) ---
app.MapGet("/seguranca-critica", (string senha) =>
{
    // Hotspot: Uso de algoritmo de criptografia fraco/obsoleto (DES)
    var desProvider = DES.Create(); 
    
    // Vulnerabilidade: Log Injection (imprimir dados sensíveis ou não sanitizados no log)
    Console.WriteLine($"Tentativa de login com senha: {senha}"); 
    
    return Results.Ok("Verifique o SonarQube agora!");
});


// --- CENÁRIO 4: DUPLICATION (Duplicidade de Código) ---
// Copiar exatamente a mesma lógica do weatherforecast original gera alerta de duplicação
app.MapGet("/previsao-copiada", () =>
{
    var forecast = Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
});

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}