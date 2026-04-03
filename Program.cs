using System;
using System.Threading;

int data1 = int.Parse(Environment.GetEnvironmentVariable("data1"));
int data2 = int.Parse(Environment.GetEnvironmentVariable("data2"));

Calculadora calc = new Calculadora();
int resultado = calc.Soma(data1, data2);
Console.WriteLine("Resultado da soma: " + resultado);

Thread.Sleep(200000);
