<%-- 
    Document   : property
    Created on : Nov 18, 2015, 5:21:04 PM
    Author     : Sorra
--%>

<%@page import="java.util.*"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.XML"%>
<%@page import="java.io.*"%>
<%@page import="org.netbeans.saas.*, org.netbeans.saas.zillow.*" %>
<%@page import="org.netbeans.saas.google.*" %>
<%@page import="org.netbeans.saas.*, org.netbeans.saas.google.*" %>
<%@page import="org.netbeans.saas.*, org.netbeans.saas.google.*" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>CST3619 - Search Results</title>

        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>

        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCgxY6DqJ4TxnRfKjlZR8SfLSQRtOSTxEU&signed_in=true&callback=initMap"
        async defer></script>
        
        <script>
        function loadMap() {
          var map = new google.maps.Map(document.getElementById('map_container'), {
            zoom: 8,
            center: {lat: 40.6954929, lng: -73.9875681} //300 Jay st - 40.6954929, -73.9875681
          });
          var geocoder = new google.maps.Geocoder();

          document.getElementById('search').addEventListener('click', function() {
            geocodeAddress(geocoder, map);
          });
        }

        function geocodeAddress(geocoder, resultsMap) 
        {
          var address = document.getElementById('address').value;
          
          geocoder.geocode({'address': address}, function(results, status) {
              
            if (status === google.maps.GeocoderStatus.OK) {
              resultsMap.setCenter(results[0].geometry.location);
              var marker = new google.maps.Marker({
                map: resultsMap,
                position: results[0].geometry.location
              });
            } 
            else {
              alert('Geocode was not successful for the following reason: ' + status);
            }
          });
        }

            </script>
        

        <link rel="stylesheet" href="layout.css" type="text/css"/>
    </head>

    <body id="top" onload="loadMap()">

        <div class="wrapper">
            <div id="header"> 

                <div class="hd_left">

                    <img src="image/house.png"/>

                </div></div></div>

        <div class="wrapper">
            <br class="clear"/>

        </div>

        <div class="wrapper">
            <div class="container">

                <div class="whitebox"> 

       
                    <map_right>
                        <div id="map_container"></div>
                    </map_right> 
                    
                    <%                        
                        try {
                            String street = request.getParameter("street");
                            String citystatezip = request.getParameter("citystatezip");

                            RestResponse result4 = GoogleGeocodingService.geocode(street, citystatezip);

                            if (result4.getResponseCode() == 200) {
                                out.println("Response: " + result4.getDataAsString());
                            } else {
                                out.println("Not Working");
                            }

                            //TODO - Uncomment the print Statement below to print result.
                            //out.println("The SaasService returned: "+result.getDataAsString());
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    %>

                    <%
                        String street = request.getParameter("street");
                        String citystatezip = request.getParameter("citystatezip");

                        int zid = 0;
                        int value = 0;

                        String chartResult = "";
                        String propertyResult1 = "";
                        String propertyResult2 = "";

                        int yearBuilt = 0;
                        int finishedSqFt = 0;
                        int bathrooms = 0;
                        int bedrooms = 0;

                        String imgUrl = "";

                        try {
                            //search results; value, zpid

                            RestResponse result1 = ZillowRealEstateService.getSearchResults(street, citystatezip);

                            if (result1.getResponseCode() == 200) {
                                propertyResult1 = result1.getDataAsString();
                                //out.println(result.getDataAsString());
                            }

                            JSONObject jobject1 = XML.toJSONObject(propertyResult1);

                            zid = jobject1.getJSONObject("SearchResults:searchresults")
                                    .getJSONObject("response")
                                    .getJSONObject("results")
                                    .getJSONObject("result")
                                    .getInt("zpid");

                            value = jobject1.getJSONObject("SearchResults:searchresults")
                                    .getJSONObject("response")
                                    .getJSONObject("results")
                                    .getJSONObject("result")
                                    .getJSONObject("zestimate")
                                    .getJSONObject("amount")
                                    .getInt("content");

                            ///////deep search results
                            RestResponse result2 = ZillowRealEstateService.getDeepSearchResults(street, citystatezip);

                            if (result2.getResponseCode() == 200) {
                                propertyResult2 = result2.getDataAsString();
                                //out.println(result.getDataAsString());
                            }

                            JSONObject jobject2 = XML.toJSONObject(propertyResult2);

                            yearBuilt = jobject2.getJSONObject("SearchResults:searchresults")
                                    .getJSONObject("response")
                                    .getJSONObject("results")
                                    .getJSONObject("result")
                                    .getInt("yearBuilt");

                            bathrooms = jobject2.getJSONObject("SearchResults:searchresults")
                                    .getJSONObject("response")
                                    .getJSONObject("results")
                                    .getJSONObject("result")
                                    .getInt("bathrooms");

                            bedrooms = jobject2.getJSONObject("SearchResults:searchresults")
                                    .getJSONObject("response")
                                    .getJSONObject("results")
                                    .getJSONObject("result")
                                    .getInt("bedrooms");

                            finishedSqFt = jobject2.getJSONObject("SearchResults:searchresults")
                                    .getJSONObject("response")
                                    .getJSONObject("results")
                                    .getJSONObject("result")
                                    .getInt("finishedSqFt");

                            //region chart results
                            String zpid = String.valueOf(zid);
                            String unittype = "dollar";
                            String width = "250";
                            String height = "150";
                            String chartduration = "1year";

                            RestResponse result3 = ZillowRealEstateService.getChart(zpid, unittype, width, height, chartduration);

                            if (result3.getDataAsObject(zillow.realestateservice.chart.Chart.class) instanceof zillow.realestateservice.chart.Chart) {
                                zillow.realestateservice.chart.Chart result1Obj = result3.getDataAsObject(zillow.realestateservice.chart.Chart.class);
                            }

                            chartResult = result3.getDataAsString();

                            JSONObject jobject3 = XML.toJSONObject(chartResult);

                            imgUrl = jobject3.getJSONObject("Chart:chart")
                                    .getJSONObject("response")
                                    .getString("url");

                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }

                        out.println("<h4><b><u>Property Details</u></b></h4>" + "<br/>");

                        out.println("<h4>" + street + ", " + citystatezip + "</h4><br/>");

                        out.println("<b>Estimated Value: </b>$" + value + "<br/><br/>");

                        //out.println("<b>Year Built: </b>" + yearBuilt + "<br/><br/>");
                        out.println(bedrooms + " beds" + " . "
                                + bathrooms + " baths" + " . "
                                + finishedSqFt + " sqft" + "<br/><br/>");

                        //out.println("<b>Bathrooms: </b>" + bathrooms + "<br/><br/>");
                        //out.println("<b>Bedrooms: </b>" + bedrooms + "<br/><br/>");
                        //out.println(finishedSqFt + " sqft");
                        out.println("<img src=" + imgUrl + ">" + "<br/><br/>");
                    %>


                    
                    <!--<a href="map_test.html">Google Map</a><br/><br/><br/>-->
                    
                    <a href="index.html">Return to Main</a>      
                    


                    <div class="fl_right">

                    </div>

                    <div class="clear"></div></div><br/><br/>

                <div class="navi"/>
                <div class="clear"/></div></div>

        <div class="footer">
            <div id="name">
                <p class="fl_left">Professor Marcos Pinto</p>
                <p class="fl_right">Student Name: Sora Lee</p>

                <br class="clear"/></div></div>

    </body>
</html>