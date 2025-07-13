package iotbay.controller;

import iotbay.model.Inventory;
import iotbay.model.InventoryItem;
import iotbay.model.dao.DAO;
import iotbay.model.dao.DBConnector;
import iotbay.model.dao.InventoryManager;
import iotbay.model.dao.ProductManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/InventoryServlet")
@MultipartConfig
public class InventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        InventoryManager inventoryManager = (InventoryManager) session.getAttribute("InventoryManager");
        DAO dao = (DAO) session.getAttribute("dao");
        String searchQuery = request.getParameter("searchQuery");
        List<InventoryItem> inventoryList;


        if (inventoryManager == null) {
            inventoryManager = dao.inventoryManager();
            session.setAttribute("InventoryManager", inventoryManager);
        }
        try {
            if(searchQuery != null && !searchQuery.isEmpty())
            {
                inventoryList = inventoryManager.searchInventory(searchQuery);
            }
            else
            {
                inventoryList = inventoryManager.fetchAllInventory();
            }
            request.setAttribute("inventoryList", inventoryList);
            request.getRequestDispatcher("/inventory.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving products.");
        }
    }




    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        InventoryManager inventoryManager = (InventoryManager) session.getAttribute("InventoryManager");
        DAO dao = (DAO) session.getAttribute("dao");

        if (inventoryManager == null || action == null || dao == null) {
            response.sendRedirect("inventory.jsp");
            return;
        }
        try {
            switch (action) {
                case "add":
                    addInventory(request, response, inventoryManager);
                    return;
                case "update":
                    updateInventory(request, inventoryManager);
                    break;
                case "delete":
                    deleteInventory(request, inventoryManager);
                    break;
            }
        }
        catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid format.");
        }
        catch (SQLException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        }
        response.sendRedirect("InventoryServlet");
    }

    private void addInventory(HttpServletRequest request,HttpServletResponse response, InventoryManager manager) throws SQLException, IOException, ServletException {
        int productID = Integer.parseInt(request.getParameter("productID"));
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        int targetStockLevel = Integer.parseInt(request.getParameter("targetStockLevel"));
        int restockThreshold = Integer.parseInt(request.getParameter("restockThreshold"));

        Part filePart = request.getPart("image"); 
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String imagesFolderPath = getServletContext().getRealPath("/images");
        File uploadDir = new File(imagesFolderPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();
        File file = new File(uploadDir, fileName);
        filePart.write(file.getAbsolutePath());
        String imagePath = "/images/" + fileName;

        if (manager.existsProductID(productID)) {
            request.setAttribute("error", "Product ID already exists.");
            List<InventoryItem> inventoryList = manager.fetchAllInventory();
            request.setAttribute("inventoryList", inventoryList);
            request.getRequestDispatcher("/inventory.jsp").forward(request, response);

            return;
        }

        if (manager.existsProductName(name)) {
            request.setAttribute("error", "Product name already exists.");
            List<InventoryItem> inventoryList = manager.fetchAllInventory();
            request.setAttribute("inventoryList", inventoryList);
            request.getRequestDispatcher("/inventory.jsp").forward(request, response);
            return;
        }

        // 4. Insert into DB
        manager.addProduct(productID, name, category, description, price, imagePath);
        manager.addInventory(productID, stockQuantity, targetStockLevel, restockThreshold);
        response.sendRedirect("InventoryServlet");

    }

    private void updateInventory(HttpServletRequest request, InventoryManager manager) throws SQLException, ServletException, IOException {
        int productID = Integer.parseInt(request.getParameter("productID"));
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        int targetStockLevel = Integer.parseInt(request.getParameter("targetStockLevel"));
        int restockThreshold = Integer.parseInt(request.getParameter("restockThreshold"));
        LocalDateTime now = LocalDateTime.now();

        Part filePart = request.getPart("image");
        boolean isImageUploaded = filePart != null && filePart.getSize() > 0;

        if (isImageUploaded) {
            // Save the uploaded image
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String imagesFolderPath = getServletContext().getRealPath("/images");
            File uploadDir = new File(imagesFolderPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            File file = new File(uploadDir, fileName);
            filePart.write(file.getAbsolutePath());
            String imagePath = "/images/" + fileName;

            // Update product including image path
            manager.updateProduct(productID, name, category, description, price, imagePath);
        } else {
            // Update product without changing the image
            manager.updateProduct(productID, name, category, description, price);
        }

        // Always update inventory details
        manager.updateInventory(productID, stockQuantity, targetStockLevel, restockThreshold, now);
    }

    private void deleteInventory(HttpServletRequest request, InventoryManager manager) throws SQLException {
        int productID = Integer.parseInt(request.getParameter("productID"));
        System.out.println("Deleting product " + productID);
        manager.deleteProduct(productID);
        manager.deleteInventory(productID);
    }
    }
