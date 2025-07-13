DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Inventory;

CREATE TABLE Product
(
    productID INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL,
    description VARCHAR(500) NOT NULL,
    price DOUBLE NOT NULL,
    imageURL VARCHAR(255) NOT NULL
);

CREATE TABLE Inventory
(
    productID INTEGER(8) PRIMARY KEY,
    stockQuantity INTEGER NOT NULL,
    targetStockLevel INTEGER NOT NULL,
    restockThreshold INTEGER NOT NULL,
    lastUpdatedAt DATETIME NOT NULL,
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

INSERT INTO Product (name, category, description, price, imageURL)
VALUES
('DS18B20', 'Temperature / Humidity / Air Pressure / Gas', '1-Wire temperature sensor. Waterproof version available. Suitable for outdoor use. Range -55°C to +125°C.', 4.00, 'src/main/webapp/images/DS18B20.webp'),
('BMP180 Barometer', 'Temperature / Humidity / Air Pressure / Gas', 'I2C barometric sensor that also provides temperature and altitude readings', 5.50, 'src/main/webapp/images/BMP180_Barometer.webp'),
(' Moisture Sensor', 'Temperature / Humidity / Air Pressure / Gas', 'Analog soil moisture sensor for automatic irrigation. Requires MCP3008 for analog reading.', 4.50, 'src/main/webapp/images/Moisture_Sensor.webp'),
('Capacitive Ground Moisture Sensor', 'Temperature / Humidity / Air Pressure / Gas', 'Long-lasting and corrosion-resistant capacitive soil sensor with frequency-based readings.', 6.00, 'src/main/webapp/images/Capacative_Ground_Moisture_Sensor.webp'),
('MQ2 Gas Sensor', 'Temperature / Humidity / Air Pressure / Gas', 'Detects methane, butane, LPG, and smoke. Needs MCP3008 and level shifter.', 2.00, 'src/main/webapp/images/MQ-2_Gas_Sensor.webp'),
('PIR Motion Sensor', 'Motion Sensor', 'Passive Infrared sensor. Detects movement using signal changes. Adjustable sensitivity.', 2.00, 'src/main/webapp/images/PIR_Motion_Sensor.webp'),
('HC-SR04 Ultrasonic Sensor', 'Motion Sensor', 'Ultrasonic sensor for measuring distance using echo timing. Range of a few meters.', 3.00, 'src/main/webapp/images/HC-SR04_Ultrasonic_Sensor.webp'),
('GP2Y0A02YK Infrared Distance Meter', 'Motion Sensor', 'Infrared proximity sensor with a range of 20–150 cm. More precise than ultrasonic sensors.', 10.00, 'src/main/webapp/images/GP2Y0A02YK_Infrared_Distance_Meter.webp'),
('RFID-RC522 – Inductive RFID card reader', 'Motion Sensor', 'Inductive RFID card reader using SPI. Suitable for contactless access control.', 4.50, 'RFID-RC522_Inductive_RFID_CARD_READER.webp'),
('GPS NEO-6M Module', 'Navigation Modules', 'Compact GPS module with serial interface. Provides accurate location data.', 10.00, 'src/main/webapp/images/GPS_NEO-6M_Module.webp'),
('USB GPS Receiver', 'Navigation Modules', 'Plug-and-play GPS receiver that connects via USB. Compatible with Windows, Linux, and Mac. Offers high accuracy with no GPIO setup required.', 15.00, 'src/main/webapp/images/USB_GPS_Receiver.webp'),
('MPU-6050 Gyroscope', 'Navigation Modules', '6-axis sensor combining a 3-axis gyroscope and a 3-axis accelerometer. Useful for detecting orientation and rotation in robotics.', 3.50, 'src/main/webapp/images/MPU-6050_Gyroscope.webp'),
('DS1307 RTC', 'Navigation Modules', 'Real-time clock module with battery backup. Keeps time even when offline.', 2.50, 'src/main/webapp/images/DS1307_RTC.webp'),
('433MHz Set', 'Raspberry Pi Sensors - Wireless/ Infrared / Bluetooth', 'Basic wireless communication module for sending and receiving data.', 2.50, 'src/main/webapp/images/433MHz_Set.webp'),
('2.4 GHz NRF24L01+ Modul','Raspberry Pi Sensors - Wireless/ Infrared / Bluetooth', 'Advanced 2.4 GHz wireless module for high-speed communication between devices.', 3.50, 'src/main/webapp/images/2.4 GHz_NRF24L01+_Modul.webp'),
('Radio Controlled Power Socket', 'Raspberry Pi Sensors - Wireless/ Infrared / Bluetooth', '433 MHz radio sockets controllable via Raspberry Pi. Used to automate power to lamps or appliances. Choose models with fixed or user-settable codes for ease of control.', 12.50, 'src/main/webapp/images/Radio_Controlled_Power_Socket.webp' ),
('Si4703 Radio Receiver', 'Raspberry Pi Sensors - Wireless/ Infrared / Bluetooth','Digital FM radio receiver module for Raspberry Pi-based jukeboxes or car PCs.', 10.00, 'src/main/webapp/images/Si4703_Radio_Reciever.webp'),
('Bluetooth Adapter', 'Raspberry Pi Sensors - Wireless / Infrared / Bluetooth', 'USB Bluetooth dongle for Pi Zero or older models. Enables wireless communication.', 8.00, 'src/main/webapp/images/Bluetooth_Adapter.webp'),
('GSM Surfstick', 'Raspberry Pi Sensors - Wireless / Infrared / Bluetooth','Allows Raspberry Pi to connect to the internet using a mobile data SIM. Enables remote access and SMS functionality.' ,30.00, 'src/main/webapp/images/GSM_Surfstick.webp'),
('Infrared Diodes', 'Raspberry Pi Sensors - Wireless / Infrared / Bluetooth', 'Used for transmitting/receiving remote control signals or light barriers.', 3.00, 'src/main/webapp/images/Infrared_dIodes.webp');

INSERT INTO Inventory (productID, stockQuantity, targetStockLevel, restockThreshold, lastUpdatedAt)
VALUES
    (1, 85, 120, 30, '2025-04-10 10:12:00'),
    (2, 60, 100, 20, '2025-04-12 15:30:00'),
    (3, 45, 80, 25, '2025-04-13 09:00:00'),
    (4, 110, 150, 40, '2025-04-10 18:22:00'),
    (5, 30, 90, 20, '2025-04-09 11:47:00'),
    (6, 72, 100, 30, '2025-04-11 08:10:00'),
    (7, 95, 130, 35, '2025-04-14 14:00:00'),
    (8, 50, 90, 25, '2025-04-08 12:15:00'),
    (9, 33, 70, 20, '2025-04-13 16:20:00'),
    (10, 47, 75, 18, '2025-04-12 10:05:00'),
    (11, 28, 60, 15, '2025-04-10 09:45:00'),
    (12, 76, 100, 25, '2025-04-10 13:33:00'),
    (13, 66, 90, 20, '2025-04-11 17:00:00'),
    (14, 89, 110, 30, '2025-04-15 19:21:00'),
    (15, 92, 130, 40, '2025-04-10 11:59:00'),
    (16, 39, 100, 20, '2025-04-12 08:17:00'),
    (17, 58, 90, 30, '2025-04-13 13:45:00'),
    (18, 44, 85, 25, '2025-04-11 14:12:00'),
    (19, 72, 100, 30, '2025-04-14 10:10:00'),
    (20, 99, 120, 30, '2025-04-10 15:30:00');


-- To change column types, create a new user table.
DROP TABLE IF EXISTS user;

CREATE TABLE IF NOT EXISTS user
(
    userID       INTEGER PRIMARY KEY AUTOINCREMENT,
    firstName    VARCHAR(50) NOT NULL,
    lastName     VARCHAR(50) NOT NULL,
    email        VARCHAR(255) UNIQUE NOT NULL,
    password     VARCHAR(100) NOT NULL,
    phoneNum     VARCHAR(20) NOT NULL,
    street       VARCHAR(100),
    suburb       VARCHAR(100),
    state        VARCHAR(50),
    postcode     VARCHAR(10),
    createdAt    VARCHAR(50),
    userType     INTEGER NOT NULL,
    status       VARCHAR(10) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deleted'))

);

INSERT INTO user (
    firstName, lastName, email, password, phoneNum,
    street, suburb, state, postcode,
    createdAt, userType, status
)
VALUES
    --Admin user
    ('admin', 'manager', 'admin@iotbay.com', '1234', '0400000000','1 Admin St', 'Sydney', 'NSW', '2000','2025-04-23', 1, 'active'),
    -- Staff Managers (Order, Product, Payment)
    ('order', 'manager', 'order@iotbay.com', '1234', '0400001001','2 Order Ln', 'Sydney', 'NSW', '2001','2025-04-23', 1, 'active'),
    ('product', 'manager', 'product@iotbay.com', '1234', '0400001002','3 Product St', 'Melbourne', 'VIC', '3000','2025-04-23', 1, 'active'),
    ('payment', 'manager', 'payment@iotbay.com', '1234', '0400001003','4 Payment Ave', 'Brisbane', 'QLD', '4000','2025-04-23', 1, 'active'),
    -- staff & customer
    ('Liam', 'Miller', 'staff1@iotbay.com', 'staff1', '0400002001', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'active'),
    ('Emma', 'Smith', 'staff2@iotbay.com', 'staff2', '0400002002', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'active'),
    ('Noah', 'Johnson', 'staff3@iotbay.com', 'staff3', '0400002003', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'inactive'),
    ('Olivia', 'Brown', 'staff4@iotbay.com', 'staff4', '0400002004', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'deleted'),
    ('William', 'Wilson', 'staff5@iotbay.com', 'staff5', '0400002005', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'active'),
    ('Ava', 'Taylor', 'staff6@iotbay.com', 'staff6', '0400002006', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'inactive'),
    ('Lucas', 'Anderson', 'staff7@iotbay.com', 'staff7', '0400002007', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'active'),
    ('Mia', 'Thomas', 'staff8@iotbay.com', 'staff8', '0400002008', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'deleted'),
    ('Ethan', 'Jackson', 'staff9@iotbay.com', 'staff9', '0400002009', NULL, NULL, NULL, NULL, '2025-04-23', 1, 'active'),
    ('Charlotte', 'Martin', 'cust1@iotbay.com', 'cust1', '0400003001', '10 Main St', 'Sydney', 'NSW', '2000', '2025-04-23', 0, 'active' ),
    ('Henry', 'Lee', 'cust2@iotbay.com', 'cust2', '0400003002', NULL, NULL, NULL, NULL, '2025-04-23', 0, 'inactive' ),
    ('Amelia', 'Clark', 'cust3@iotbay.com', 'cust3', '0400003003', '20 Side St', 'Perth', 'WA', '6000', '2025-04-23', 0, 'active'),
    ('Leo', 'Hall', 'cust4@iotbay.com', 'cust4', '0400003004', NULL, NULL, NULL, NULL, '2025-04-23', 0, 'deleted'),
    ('Isabella', 'King', 'cust5@iotbay.com', 'cust5', '0400003005', '30 Hill Rd', 'Brisbane', 'QLD', '4000', '2025-04-23', 0, 'active');



DROP TABLE IF EXISTS Order_Item;

CREATE TABLE IF NOT EXISTS Orders(
    orderID INTEGER PRIMARY KEY AUTOINCREMENT,
    memberID INTEGER,
    orderDate VARCHAR(50) NOT NULL,
    orderStatus VARCHAR(20) NOT NULL,
    FOREIGN KEY (memberID) REFERENCES user(userID)
);





CREATE TABLE IF NOT EXISTS Payment (
                         PaymentID INTEGER PRIMARY KEY AUTOINCREMENT,
                         OrderID INTEGER NOT NULL,
                         PaymentMethod VARCHAR(50) NOT NULL,
                         CardNumber VARCHAR(20) NOT NULL,
                         CardHolder VARCHAR(100) NOT NULL,
                         ExpiryDate VARCHAR(10) NOT NULL,
                         CVV VARCHAR(4) NOT NULL,
                         Amount DOUBLE NOT NULL,
                         PaymentDate DATE NOT NULL,
                         Address VARCHAR(255),
                         Suburb VARCHAR(100),
                         State VARCHAR(100),
                         Postcode VARCHAR(20),

                         FOREIGN KEY (OrderID) REFERENCES Orders(orderID)
);





CREATE TABLE IF NOT EXISTS UserCard (
                                        cardID INTEGER PRIMARY KEY AUTOINCREMENT,
                                        userID INTEGER NOT NULL,
                                        cardNumber VARCHAR(20) NOT NULL,
                                        cardHolder VARCHAR(100) NOT NULL,
                                        expiryDate VARCHAR(10) NOT NULL,
                                        cvv VARCHAR(4) NOT NULL,
                                        paymentMethod VARCHAR(50) NOT NULL,
                                        FOREIGN KEY (userID) REFERENCES user(userID) ON DELETE CASCADE
);

-- use this for dummy value testing but make sure delete these value after run so database can actually delete and stored value forever
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 1, '4111 1111 1111 0001', 'admin manager', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 1);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 2, '4111 1111 1111 0002', 'order manager', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 2);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 3, '4111 1111 1111 0003', 'product manager', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 3);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 4, '4111 1111 1111 0004', 'payment manager', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 4);
--
-- -- Staff
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 5, '4111 1111 1111 0005', 'Liam Miller', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 5);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 6, '4111 1111 1111 0006', 'Emma Smith', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 6);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 7, '4111 1111 1111 0007', 'Noah Johnson', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 7);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 8, '4111 1111 1111 0008', 'Olivia Brown', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 8);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 9, '4111 1111 1111 0009', 'William Wilson', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 9);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 10, '4111 1111 1111 0010', 'Ava Taylor', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 10);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 11, '4111 1111 1111 0011', 'Lucas Anderson', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 11);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 12, '4111 1111 1111 0012', 'Mia Thomas', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 12);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 13, '4111 1111 1111 0013', 'Ethan Jackson', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 13);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 14, '4111 1111 1111 0014', 'Charlotte Martin', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 14);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 15, '4111 1111 1111 0015', 'Henry Lee', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 15);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 16, '4111 1111 1111 0016', 'Amelia Clark', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 16);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 17, '4111 1111 1111 0017', 'Leo Hall', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 17);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 18, '4111 1111 1111 0018', 'Isabella King', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 18);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 19, '4111 1111 1111 0019', 'Isabsadella King', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 19);
--
-- INSERT INTO UserCard (userID, cardNumber, cardHolder, expiryDate, cvv, paymentMethod)
-- SELECT 20, '4111 1111 1111 0020', 'awd King', '12/26', '123', 'Visa'
-- WHERE NOT EXISTS (SELECT 1 FROM UserCard WHERE userID = 20);


SELECT
    u.userID,
    u.firstName,
    u.email,
    c.cardID,
    c.cardNumber,
    c.cardHolder,
    c.expiryDate,
    c.paymentMethod
FROM
    user u
        LEFT JOIN
    UserCard c ON u.userID = c.userID
ORDER BY u.userID;









CREATE TABLE IF NOT EXISTS OrderItem(
    orderID INTEGER NOT NULL,
    productID INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (orderID, productID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID),
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

INSERT INTO Orders (memberID, orderDate, orderStatus)
VALUES
    (13, '2025-04-20', 'Pending'),
    (14, '2025-04-20', 'Confirmed'),
    (15, '2025-04-21', 'Pending'),
    (16, '2025-04-21', 'Cancelled'),
    (17, '2025-04-22', 'Pending'),
    (18, '2025-04-22', 'Pending'),
    (19, '2025-04-23', 'Confirmed'),
    (20, '2025-04-23', 'Pending'),
    (13, '2025-04-24', 'Cancelled'),
    (14, '2025-04-24', 'Pending'),
    (15, '2025-04-25', 'Confirmed'),
    (16, '2025-04-25', 'Pending'),
    (17, '2025-04-26', 'Cancelled'),
    (18, '2025-04-26', 'Pending'),
    (19, '2025-04-27', 'Pending'),
    (20, '2025-04-27', 'Confirmed'),
    (13, '2025-04-28', 'Pending'),
    (14, '2025-04-28', 'Cancelled'),
    (15, '2025-04-29', 'Pending'),
    (16, '2025-04-29', 'Confirmed');

INSERT OR REPLACE INTO OrderItem (orderID, productID, quantity) VALUES
                                                                    (1, 1, 2),
                                                                    (2, 3, 1),
                                                                    (3, 5, 4),
                                                                    (4, 7, 2),
                                                                    (5, 2, 1),
                                                                    (6, 4, 5),
                                                                    (7, 6, 1),
                                                                    (8, 8, 3),
                                                                    (9, 10, 2),
                                                                    (10, 12, 1),
                                                                    (11, 9, 1),
                                                                    (12, 11, 3),
                                                                    (13, 13, 1),
                                                                    (14, 14, 2),
                                                                    (15, 15, 2),
                                                                    (16, 17, 1),
                                                                    (17, 18, 1),
                                                                    (18, 19, 4),
                                                                    (19, 20, 2),
                                                                    (20, 16, 2);


UPDATE Product
SET imageURL = REPLACE(imageURL, 'src/main/webapp/', '/')
WHERE imageURL LIKE 'src/main/webapp/%';

SET imageURL = '/images/61f-Y-vFplL._SL1500_A.jpg'
WHERE name = 'Capacitive Ground Moisture Sensor';

UPDATE Product
SET imageURL = '/images/RFID-RC522_Inductive_RFID_CARD_READER.webp'
WHERE name = 'RFID-RC522 – Inductive RFID card reader';

CREATE TABLE IF NOT EXISTS AccessLog (
     LogID INTEGER PRIMARY KEY AUTOINCREMENT,
     UserID INTEGER NOT NULL,
     LoginTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     LogoutTime TIMESTAMP,
     FOREIGN KEY (UserID) REFERENCES User(UserID)
);

INSERT INTO AccessLog (UserID, LoginTime, LogoutTime)
VALUES
          (1, '2025-04-29 08:00:00', '2025-04-29 09:15:00'),
          (2, '2025-04-29 08:30:00', '2025-04-29 09:00:00'),
          (3, '2025-04-29 09:10:00', '2025-04-29 10:40:00'),
          (4, '2025-04-29 09:20:00', '2025-04-29 09:50:00'),
          (5, '2025-04-29 10:00:00', '2025-04-29 11:00:00'),
          (1, '2025-04-29 12:30:00', '2025-04-29 13:00:00'),
          (2, '2025-04-29 13:15:00', '2025-04-29 14:00:00'),
          (3, '2025-04-29 14:10:00', '2025-04-29 14:45:00'),
          (4, '2025-04-29 15:00:00', '2025-04-29 16:00:00'),
          (5, '2025-04-29 15:30:00', '2025-04-29 16:15:00'),
          (1, '2025-04-30 08:00:00', '2025-04-30 08:45:00'),
          (2, '2025-04-30 08:20:00', '2025-04-30 09:00:00'),
          (3, '2025-04-30 09:30:00', '2025-04-30 10:10:00'),
          (4, '2025-04-30 10:00:00', '2025-04-30 11:00:00'),
          (5, '2025-04-30 11:15:00', '2025-04-30 12:00:00'),
          (1, '2025-04-30 13:00:00', '2025-04-30 13:45:00'),
          (2, '2025-04-30 14:00:00', '2025-04-30 14:30:00'),
          (3, '2025-04-30 14:50:00', '2025-04-30 15:20:00'),
          (4, '2025-04-30 15:10:00', '2025-04-30 15:55:00'),
          (5, '2025-04-30 16:00:00', '2025-04-30 16:30:00');

UPDATE User SET status = 'active' WHERE status = 'deleted';
