package com.cognizant.orm_learn;

import com.cognizant.orm_learn.model.Country;
import com.cognizant.orm_learn.service.CountryService;
import com.cognizant.orm_learn.service.exception.CountryNotFoundException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

@SpringBootApplication
public class OrmLearnApplication {
    private static final Logger LOGGER = LoggerFactory.getLogger(OrmLearnApplication.class);
    private static CountryService countryService;

    public static void main(String[] args) {
        ApplicationContext context = SpringApplication.run(OrmLearnApplication.class, args);
        countryService = context.getBean(CountryService.class);

        getCountryByCodeTest();
        testAddCountry();
        testUpdateCountry();
        testDeleteCountry();
    }

    private static void getCountryByCodeTest() {
        LOGGER.info("Start getCountryByCodeTest");
        try {
            Country country = countryService.findCountryByCode("IN");
            LOGGER.debug("Country: {}", country);
        } catch (CountryNotFoundException e) {
            LOGGER.error("Exception: {}", e.getMessage());
        }
        LOGGER.info("End getCountryByCodeTest");
    }

    private static void testAddCountry() {
        LOGGER.info("Start testAddCountry");
        Country newCountry = new Country();
        newCountry.setCode("ZZ");
        newCountry.setName("Zootopia");
        countryService.addCountry(newCountry);

        try {
            Country addedCountry = countryService.findCountryByCode("ZZ");
            LOGGER.debug("Added Country: {}", addedCountry);
        } catch (CountryNotFoundException e) {
            LOGGER.error("Country not found after add.");
        }
        LOGGER.info("End testAddCountry");
    }

    private static void testUpdateCountry() {
        LOGGER.info("Start testUpdateCountry");
        try {
            countryService.updateCountry("ZZ", "New Zootopia");
            Country updated = countryService.findCountryByCode("ZZ");
            LOGGER.debug("Updated Country: {}", updated);
        } catch (CountryNotFoundException e) {
            LOGGER.error("Update failed: {}", e.getMessage());
        }
        LOGGER.info("End testUpdateCountry");
    }

    private static void testDeleteCountry() {
        LOGGER.info("Start testDeleteCountry");
        countryService.deleteCountry("ZZ");

        try {
            countryService.findCountryByCode("ZZ");
        } catch (CountryNotFoundException e) {
            LOGGER.info("Country deleted successfully: {}", e.getMessage());
        }
        LOGGER.info("End testDeleteCountry");
    }
}
