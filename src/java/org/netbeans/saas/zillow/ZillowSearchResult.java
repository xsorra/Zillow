package org.netbeans.saas.zillow;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.netbeans.saas.RestResponse;

/**
 *
 * @author Sorra
 */
@WebServlet(urlPatterns = {"/ZillowSearchResult"})
public class ZillowSearchResult extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {

            try {
                String address = "";
                String citystatezip = "";
                String zillowResults = "";

                RestResponse result = ZillowRealEstateService.getSearchResults(address, citystatezip);
                if (result.getResponseCode() == 200) {
                    zillowResults = result.getDataAsString();
                }

            } catch (Exception ex) {
                ex.printStackTrace();
            }

        }
        
            try {
                String address = "";
                String citystatezip = "";
                String zillowResults = "";

                RestResponse result1 = ZillowRealEstateService.getDeepSearchResults(address, citystatezip);
                if (result1.getResponseCode() == 200) {
                    zillowResults = result1.getDataAsString();
                }
                 //TODO - Uncomment the print Statement below to print result.
            //out.println("The SaasService returned: "+result1.getDataAsString());
            } catch (Exception ex) {
                ex.printStackTrace();
            }

        }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
