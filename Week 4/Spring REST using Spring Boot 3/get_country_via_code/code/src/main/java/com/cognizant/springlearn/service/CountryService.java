package com.cognizant.springlearn.service;

import com.cognizant.springlearn.model.Country;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CountryService {

    ApplicationContext context = new ClassPathXmlApplicationContext("country.xml");

    @SuppressWarnings("unchecked")
    public Country getCountry(String code) {
        List<Country> countries = (List<Country>) context.getBean("countryList");

        return countries.stream()
                .filter(country -> country.getCode().equalsIgnoreCase(code))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Country not found for code: " + code));
    }
}
