using NUnit.Framework;

[TestFixture]  // Indica que esta classe contém testes
public class CalculadoraTest {
    private Calculadora calc;

    [SetUp]  // Executado antes de cada teste
    public void Setup() {
        calc = new Calculadora();
    }

    [Test]  // Define um teste
    public void TestSoma() {
        int resultado = calc.Soma(2, 3);
        Assert.AreEqual(5, resultado);
    }

    [Test] 
    public void TestSubtrai() {
        int resultado = calc.Subtrai(10, 4);
        Assert.AreEqual(7, resultado);
    }

    [Test]
    public void TestSomaFalha() {
        int resultado = calc.Soma(2, 2);
        Assert.AreNotEqual(5, resultado); // Teste deve passar, pois 2+2 != 5
    }
}