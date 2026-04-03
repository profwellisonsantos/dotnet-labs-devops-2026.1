using System;
using System.Threading;

// string ConnectionString = "Server=myserver;Database=mydb;User Id=admin;Password=12345;";

int data1 = int.Parse(Environment.GetEnvironmentVariable("data1"));
int data2 = int.Parse(Environment.GetEnvironmentVariable("data2"));

Calculadora calc = new Calculadora();
int resultado = calc.Soma(data1, data2);
Console.WriteLine("Resultado da soma: " + resultado);

Thread.Sleep(200000);
