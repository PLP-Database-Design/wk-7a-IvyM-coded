-- Achieving 1NF by splitting the Products column into individual rows
SELECT OrderID, CustomerName, TRIM(product) AS Product
FROM (
    -- Use string_to_array to split the Products string into an array
    SELECT OrderID, CustomerName, UNNEST(string_to_array(Products, ',')) AS product
    FROM ProductDetail
) AS ProductsList;

-- Create Orders table to store OrderID and CustomerName
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert unique OrderID and CustomerName into the Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create OrderDetails table with composite primary key (OrderID, Product)
CREATE TABLE OrderDetails (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert the order-specific data (OrderID, Product, and Quantity) into OrderDetails table
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
