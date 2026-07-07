package tests;

import org.junit.Test;
import static org.junit.Assert.*;

public class PrimeCheckTest {

    @Test
    public void TestIsPrime() {
        PrimeCheckMain checker = new PrimeCheckMain();
        assertTrue(checker.isPrime(3));
        assertTrue(checker.isPrime(7));
        assertFalse(checker.isPrime(24));
        assertFalse(checker.isPrime(-7));
    }
}
