package tests;

import static org.junit.Assert.*;
import org.junit.Test;


public class squareUnit {

	 @Test
	    public void testSquareCorrect() {
	        UnitTesting obj = new UnitTesting();
	        assertEquals(16, obj.square(4)); 
	        assertEquals(64, obj.square(8));  
	    }

	    @Test
	    public void testSquareIncorrect() {
	        UnitTesting obj = new UnitTesting();
	        assertNotEquals(20, obj.square(4));  
	        assertNotEquals(60, obj.square(8));  
	    }

}
