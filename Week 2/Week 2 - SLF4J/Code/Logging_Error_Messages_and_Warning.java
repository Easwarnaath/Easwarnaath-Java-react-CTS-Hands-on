package org.sample;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Logging_Error_Messages_and_Warning {
	private static final Logger logger = LoggerFactory.getLogger(Logging_Error_Messages_and_Warning.class);
    public static void main(String[] args) {
        logger.error("This is an error message");
        logger.warn("This is a warning message");
        logger.info("This is an informational message");
    }
}
