public class FinancialForecast {
    public static double calculateFutureValueRecursive(double initialAmount, double rate, int years) {
        if (years == 0)
            return initialAmount;
        return calculateFutureValueRecursive(initialAmount, rate, years - 1) * (1 + rate);
    }
    public static double calculateFutureValueIterative(double initialAmount, double rate, int years) {
        double amount = initialAmount;
        for (int i = 0; i < years; i++) {
            amount *= (1 + rate);
        }
        return amount;
    }
    public static void main(String[] args) {
        double initialInvestment = 10000;   
        double annualGrowthRate = 0.08;    
        int forecastYears = 25;            
        long startRecursive = System.nanoTime();
        double futureValueRecursive = calculateFutureValueRecursive(initialInvestment, annualGrowthRate, forecastYears);
        long endRecursive = System.nanoTime();
        long timeRecursive = endRecursive - startRecursive;
        System.out.printf("Recursive - Future value after %d years: ₹%.2f\n", forecastYears, futureValueRecursive);
        System.out.printf("Recursive Time Taken: %.4f ms\n", timeRecursive / 1_000_000.0);
        long startIterative = System.nanoTime();
        double futureValueIterative = calculateFutureValueIterative(initialInvestment, annualGrowthRate, forecastYears);
        long endIterative = System.nanoTime();
        long timeIterative = endIterative - startIterative;
        System.out.printf("Iterative - Future value after %d years: ₹%.2f\n", forecastYears, futureValueIterative);
        System.out.printf("Iterative Time Taken: %.4f ms\n", timeIterative / 1_000_000.0);
    }
}
