using Xunit;
using FreteCore;

namespace FreteCore.Tests;

public class CalculadoraFreteTests
{
    [Fact] // Indica um teste unitário simples
    public void Calcular_DeveRetornarValorFixo_QuandoPedidoForComum()
    {
        // Arrange (Preparar)
        var calculadora = new CalculadoraFrete();
        decimal valorPedido = 50.00m;
        decimal freteEsperado = 15.00m;

        // Act (Executar)
        var resultado = calculadora.Calcular(valorPedido);

        // Assert (Verificar)
        Assert.Equal(freteEsperado, resultado);
    }

    [Fact]
     public void Calcular_DeveRetonarZero_QuandoPedidoForAcimaDeCemReais(){

        var calculadora = new CalculadoraFrete();
        decimal valorPedido = 150.00m;
        decimal freteEsperado = 0.00m;

        var resultado = calculadora.Calcular(valorPedido);

        Assert.Equal(freteEsperado, resultado);
     }

    [Theory]
    [InlineData(50, 15)]
    [InlineData(150, 0)]
    [InlineData(100, 0)]
    public void Calcular_DeveRetornarValorEsperado_DeAcordoComValorDoPedido(decimal valorPedido, decimal freteEsperado)
    {
        // Arrange (Preparar)
        var calculadora = new CalculadoraFrete();

        // Act (Executar)
        var resultado = calculadora.Calcular(valorPedido);

        // Assert (Verificar)
        Assert.Equal(freteEsperado, resultado);
    }

}