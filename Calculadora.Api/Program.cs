using System;
using System.Threading;

Calculadora calc = new Calculadora();
int resultado = calc.Soma(5, 3);
Console.WriteLine("Resultado da soma: " + resultado);

Thread.Sleep(200000);

