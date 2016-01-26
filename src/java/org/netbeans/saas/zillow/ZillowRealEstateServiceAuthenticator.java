/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.netbeans.saas.zillow;

import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.netbeans.saas.RestConnection;

/**
 *
 *
 * @author Sorra
 */
public class ZillowRealEstateServiceAuthenticator {
    
    private static String apiKey;
    
    private static final String PROP_FILE = ZillowRealEstateServiceAuthenticator.class.getSimpleName().toLowerCase() + ".properties";
    
    static {
        try {
            Properties props = new Properties();
            props.load(ZillowRealEstateServiceAuthenticator.class.getResourceAsStream(PROP_FILE));
            apiKey = props.getProperty("api_key");
        } catch (IOException ex) {
            Logger.getLogger(ZillowRealEstateServiceAuthenticator.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public static String getApiKey() throws IOException {
        if (apiKey == null || apiKey.length() == 0) {
            throw new IOException("Please specify your api key in the " + PROP_FILE + " file.");
        }
        
        return apiKey;
    }
    
    public static String getGetRegionChartResource(String unitType, String city, String state, String zIP, String width, String height,
            
        String chartduration) throws IOException {
        
        String result = null;
        String apiKey = "X1-ZWz1f07f0r3ax7_8w9nb";
        String[][] queryParams = new String[][]{{"zws-id", "" + apiKey + ""}, {"unit-type", unitType}, {"city", city}, {"state", state}, {"ZIP", zIP}, {"width", width}, {"height", height}, {"Chartduration", chartduration}};
        RestConnection conn = new RestConnection("http://www.zillow.com/webservice/GetRegionChart.htm", queryParams);
        
        result = conn.toString();
        return result;
}
}
