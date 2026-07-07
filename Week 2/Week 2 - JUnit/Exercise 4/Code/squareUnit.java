package tests;

import org.junit.Before;
import org.junit.After;
import org.junit.Test;
import static org.junit.Assert.*;


public class squareUnit {

    private UnitTesting obj;

    @Before
    public void setUp() {
        
        obj = new UnitTesting();
        System.out.println("Before Test - Setup");
    }

    @After
    public void tearDown() {
        // Cleanup after each test
        obj = null;
        System.out.println("After Test - Cleanup");
    }

    @Test
    public void testSquareCorrectValue() {
       
        int input = 4;
        int expected = 16;

        
        int actual = obj.square(input);

        
        assertEquals(expected, actual);
    }

    @Test
    public void testSquareAnotherCorrectValue() {
        // Arrange
        int input = 8;
        int expected = 64;

        // Act
        int actual = obj.square(input);

        // Assert
        assertEquals(expected, actual);
    }

    @Test
    public void testSquareIncorrectValue() {
        // Arrange
        int input = 5;
        int wrongExpected = 30;

        // Act
        int actual = obj.square(input);

        // Assert
        assertNotEquals(wrongExpected, actual);
    }
}