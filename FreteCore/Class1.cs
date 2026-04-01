namespace FreteCore;

public class CalculadoraFrete
{
    public decimal Calcular(decimal valorPedido)
    {

        if (valorPedido > 100){
            return 0;
        }

        return 15.00m; 
    }



}