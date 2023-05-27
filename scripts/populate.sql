--
--		File: populate.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: DML that populates the tables with synthetic test data.

---------------------
-- Customer
---------------------
INSERT INTO customer
VALUES
(1111, 'Joaquim Souza', 'joaquim.souza@gmail.com', 91294337, 'Rua das Flores, 45, 6300-250, Guarda, Portugal'),
(1112, 'Jane Doe', 'jane.doe@hotmail.com', 12345678, 'Hensbury Street, 22, B74 5PQ, Birmingham, England'),
(1113, 'Hans Joanssen', 'hans_joanssen@gmail.com', 90695443, 'Nygade, 13, 1309, Aarhus, Denmark'),
(1114, 'Julia Teixeira', 'julia.teixeira@gmail.com', 956254228, 'Rua Alves Redol, 106, 2100-203, Lisboa, Portugal'),
(1115, 'Rui Pereira', 'rui.pereira@sapo.pt', 88899438, 'Rua do Sol, 157, 2100-322, Lisboa, Portugal'),
(1116, 'Siobhan Santos', 'siobhan.santos@gmail.com', 988899438, 'Rua do Ouro, 36, 2100-245, Lisboa, Portugal'),
(1117, 'Victor Alejandro', 'victor.alejandro@gmail.com', 988899438, 'Avenida del Libertador, 55, 99-209-056, Santiago, Chile'),
(1118, 'João Silva', 'joao.silva@gmail.com', 78899438, 'Travessa da Amizade, 21, 5005-056, Porto, Portugal'),
(1119, 'Dinis Matos', 'dinis.matos@gmail.com', 988899438, 'Avenida Central, 122, 4715-075, Braga, Portugal'),
(1120, 'Sophie Turner', 'sophie.turner@gmail.com', 77123456, 'Oak Street, 10, M34 5AB, Manchester, England'),
(1121, 'Isabella Rossi', 'isabella.rossi@hotmail.com', 88456732, 'Via Roma, 22, 20121, Milan, Italy'),
(1122, 'Alexander Petrov', 'alexander.petrov@gmail.com', 77994362, 'Nevsky Prospect, 45, 190000, Saint Petersburg, Russia'),
(1123, 'Michael Johnson', 'michael.johnson@gmail.com', 67324561, 'Main Street, 123, 90210, Los Angeles, USA'),
(1124, 'Raphael Costa', 'raphael.costa@gmail.com', 98988776, 'Avenida Paulista, 1000, 01310-100, São Paulo, Brazil'),
(1125, 'Maria Santos', 'maria.santos@gmail.com', 99004433, 'Rua das Oliveiras, 56, 4000-123, Porto, Portugal'),
(1126, 'Luisa Fernandez', 'luisa.fernandez@gmail.com', 89564213, 'Calle del Sol, 8, 28001, Madrid, Spain'),
(1127, 'Andreas Müller', 'andreas.mueller@yahoo.com', 99029381, 'Hauptstraße, 5, 10115, Berlin, Germany'),
(1128, 'Liam Murphy', 'liam.murphy@yahoo.com', 55667788, 'Baker Street, 221B, NW1 6XE, London, England'),
(1129, 'Emma Wong', 'emma.wong@hotmail.com', 66238899, 'Victoria Street, 27, 8001, Melbourne, Australia');

---------------------
-- Package
---------------------
INSERT INTO package
VALUES
(764903, '2023/05/22', 1112),
(892541, '2015/08/27', 1113),
(631085, '2023/03/11', 1117),
(219346, '2016/02/14', 1119),
(845672, '2023/01/05', 1118),
(587341, '2023/06/30', 1116),
(943815, '2023/07/22', 1114),
(356790, '2022/04/17', 1115),
(498217, '2023/09/14', 1111),
(127503, '2019/09/06', 1113),
(708291, '2023/01/07', 1112),
(905213, '2021/04/08', 1111),
(763459, '2021/10/20', 1114),
(534672, '2023/12/31', 1119),
(436127, '2022/09/02', 1116),
(794516, '2018/09/19', 1113),
(128457, '2023/04/18', 1117),
(725943, '2020/08/21', 1120),
(309871, '2022/12/31', 1121),
(516420, '2017/11/07', 1122),
(598317, '2023/02/01', 1129),
(972638, '2023/01/05', 1115),
(834176, '2019/10/11', 1123),
(461582, '2021/12/08', 1124),
(305972, '2023/07/22', 1128),
(187359, '2021/10/20', 1125),
(592813, '2022/03/15', 1126);

---------------------
-- Sale
---------------------
INSERT INTO sale
VALUES
(764903),
(892541),
(631085),
(219346),
(845672),
(587341),
(943815),
(356790),
(498217),
(127503),
(708291),
(534672),
(461582),
(305972),
(187359),
(972638);

---------------------
-- Pay
---------------------
INSERT INTO pay
VALUES
(764903, 1112),
(892541, 1113),
(631085, 1117),
(219346, 1119),
(845672, 1118),
(587341, 1116),
(943815, 1114),
(356790, 1115),
(498217, 1111),
(127503, 1113),
(708291, 1112),
(534672, 1119),
(972638, 1115);

---------------------
-- Product
---------------------
INSERT INTO product
VALUES
('E5F6G7H8', 'Laptop', 'Ultra-thin and lightweight laptop for productivity', 999.99),
('M3N4O5P6', 'Smart Watch', 'Elegant smartwatch with fitness tracking capabilities', 199.99),
('C9D0E1F2', 'Gaming Mouse', 'Precision gaming mouse with customizable settings', 69.99),
('G3H4I5J6', 'Smart TV', 'Ultra-HD smart TV with built-in streaming apps', 799.99),
('P1Q2R3S4', 'Wireless Keyboard', 'Slim and ergonomic wireless keyboard', 89.99),
('B3C4D5E6', 'Printers', 'Fast and reliable printers for home or office use', 129.99),
('A1B2C3D4', 'Smartphone', 'Powerful smartphone with advanced features', 599.99),
('I9J0K1L2', 'Headphones', 'High-quality headphones for immersive audio experience', 149.99),
('Q7R8S9T0', 'Bluetooth Speaker', 'Portable speaker with wireless connectivity', 79.99),
('F7G8H9I0', 'Gaming Chair', 'A comfortable chair to sit on while gaming', 2001.99),
('U1U2W3X4', 'Watch', 'Stylish analog watch with leather strap', 49.99),
('Y5Z6A7B4', 'Sports Shoes', 'Durable and comfortable sports shoes for running', 39.99),
('C5D6E7F8', 'Cookware Set', 'High-quality stainless steel cookware set', 39.99),
('G2H3I4J5', 'Digital Camera', 'Compact digital camera with high-resolution sensor', 299.99),
('U1V2W3X4', 'Travel Backpack', 'Durable backpack with multiple compartments for convenient travel', 49.99),
('Y5Z6A7B1', 'Gourmet Coffee Set', 'Assortment of premium coffee beans from around the world', 129.99),
('C1D2E3F4', 'Yoga Mat', 'High-quality non-slip yoga mat for comfortable and stable practice', 39.99),
('G5H6I7J8', 'Cookware Set', 'Complete set of non-stick pots and pans for versatile cooking', 29.99),
('K9L0M1N2', 'Fragrance Sampler', 'Collection of popular perfumes and colognes for sampling', 59.99),
('O3P4Q5R6', 'Indoor Plant Set', 'Assortment of low-maintenance indoor plants to liven up your space', 99.99),
('S7T8U9V0', 'Art Supplies Kit', 'Comprehensive set of art materials for creative expression and crafting', 149.99),
('A1B2C3D6', 'Fitness Exercise Ball', 'High-quality exercise ball for core strengthening and balance training', 34.99),
('E5F6G7H7', 'Gourmet Chocolate Box', 'Deluxe assortment of premium chocolates from renowned chocolatiers', 79.99),
('I9J0K1L6', 'Travel Luggage Set', 'Stylish and durable luggage set for all your travel needs', 179.99),
('U1V2W3G4', 'Wireless Earbuds', 'True wireless earbuds with noise cancellation', 129.99),
('J5K6L7M8', 'Wireless Earbuds', 'Long battery standing brand new wireless earbuds', 109.99),
('Y5Z6A7B8', 'Tablet', 'Versatile tablet for work and entertainment', 299.99),
('K7L8M9N0', 'Fitness Tracker', 'Activity tracker for monitoring health and fitness', 49.99),
('T5U6V7W8', 'Camera', 'High-resolution camera for capturing memorable moments', 399.99),
('X9Y0Z1A2', 'External Hard Drive', 'Portable storage device with large capacity', 149.99),
('K6L7M8N9', 'Yoga Mat', 'Eco-friendly and non-slip yoga mat', 29.99),
('M3N4O5Y6', 'Essential Oil Diffuser', 'Aromatherapy diffuser with soothing LED lights for a relaxing ambiance', 49.99),
('Q7R6S9T0', 'Gardening Tool Set', 'Complete set of essential tools for gardening and landscaping', 39.99),
('U172W3X4', 'Wireless Charging Pad', 'Sleek wireless charging pad compatible with Qi-enabled devices', 29.99),
('Y5Z6A7B6', 'Cookbook Collection', 'Collection of bestselling cookbooks featuring diverse cuisines and recipes', 69.99);

---------------------
-- EAN Product
---------------------
INSERT INTO ean_product
VALUES
('U1V2W3G4', '6789012345678'),
('J5K6L7M8', '0706092335134'),
('Y5Z6A7B8', '7890123456789'),
('K7L8M9N0', '0123456789012'),
('T5U6V7W8', '2345678901234'),
('X9Y0Z1A2', '3456789012345'),
('K6L7M8N9', '9780735619678'),
('M3N4O5Y6', '8712345600029'),
('Q7R6S9T0', '4265432100036'),
('U172W3X4', '9356789000045'),
('Y5Z6A7B6', '3689012345006');

---------------------
-- Contains
---------------------
INSERT INTO contains
VALUES
(764903, 'A1B2C3D4', 2),
(892541, 'E5F6G7H8', 1),
(631085, 'I9J0K1L2', 3),
(219346, 'M3N4O5P6', 2),
(845672, 'Q7R8S9T0', 3),
(587341, 'U1V2W3G4', 1),
(943815, 'Y5Z6A7B8', 2),
(356790, 'C9D0E1F2', 3),
(498217, 'G3H4I5J6', 1),
(127503, 'K7L8M9N0', 2),
(708291, 'P1Q2R3S4', 1),
(534672, 'T5U6V7W8', 3),
(905213, 'X9Y0Z1A2', 2),
(128457, 'B3C4D5E6', 1),
(763459, 'F7G8H9I0', 3),
(764903, 'I9J0K1L2', 1),
(892541, 'M3N4O5P6', 3),
(631085, 'Q7R8S9T0', 2),
(219346, 'U1V2W3G4', 1),
(845672, 'Y5Z6A7B8', 2),
(587341, 'C9D0E1F2', 3),
(943815, 'G3H4I5J6', 2),
(356790, 'K7L8M9N0', 1),
(498217, 'P1Q2R3S4', 2),
(127503, 'T5U6V7W8', 3),
(708291, 'X9Y0Z1A2', 1),
(534672, 'B3C4D5E6', 2),
(905213, 'F7G8H9I0', 3),
(128457, 'I9J0K1L2', 2),
(763459, 'M3N4O5P6', 1),
(598317, 'U1U2W3X4', 1),
(972638, 'U1V2W3X4', 4),
(972638, 'Y5Z6A7B4', 7),
(972638, 'X9Y0Z1A2', 77),
(972638, 'J5K6L7M8', 78),
(309871, 'I9J0K1L6', 1),
(834176, 'C1D2E3F4', 3),
(834176, 'G5H6I7J8', 2),
(834176, 'K9L0M1N2', 7),
(461582, 'O3P4Q5R6', 1),
(461582, 'S7T8U9V0', 3),
(305972, 'K6L7M8N9', 1),
(305972, 'U1U2W3X4', 1),
(187359, 'F7G8H9I0', 1),
(187359, 'Y5Z6A7B6', 9),
(592813, 'K9L0M1N2', 4),
(436127, 'Q7R6S9T0', 5),
(794516, 'S7T8U9V0', 20),
(725943, 'K9L0M1N2', 13),
(516420, 'M3N4O5Y6', 1);

---------------------
-- Supplier
---------------------
INSERT INTO supplier
VALUES
('123456789', 'Tech Distributors', 'Rua da Liberdade, 123, 1000-001, Lisbon, Portugal', 'A1B2C3D4', '2022/01/15'),
('987654321', 'Euro Electronics', 'Via Roma, 456, 00100, Rome, Italy', 'E5F6G7H8', '2022/02/05'),
('246813579', 'Tech Solutions', 'Rue de la Paix, 789, 75008, Paris, France', 'I9J0K1L2', '2022/03/20'),
('135792468', 'Global Gadgets', 'Kurfurstendamm, 101, 10709, Berlin, Germany', 'M3N4O5P6', '2022/04/10'),
('864209753', 'Mega Tech', 'Gran Via, 987, 28013, Madrid, Spain', 'Q7R8S9T0', '2022/05/05'),
('370592864', 'Euro Gadgets', 'Strada Mihai Eminescu, 543, 030167, Bucharest, Romania', 'U1V2W3G4', '2022/06/18'),
('519273846', 'Nordic Electronics', 'Guldbergsgade, 246, 2200, Copenhagen, Denmark', 'Y5Z6A7B8', '2022/07/25'),
('672849153', 'Inovar Tech', 'Avenida da Liberdade, 456, 1250-123, Lisbon, Portugal', 'C9D0E1F2', '2022/08/14'),
('294753618', 'Smartech Solutions', 'Plaza de Catalunya, 789, 08002, Barcelona, Spain', 'G3H4I5J6', '2022/09/30'),
('618295743', 'Italia Electronica', 'Corso Italia, 123, 00198, Rome, Italy', 'K7L8M9N0', '2022/10/22'),
('837649521', 'Scandinavian Tech', 'Drottninggatan, 456, 11151, Stockholm, Sweden', 'P1Q2R3S4', '2022/11/08'),
('452187396', 'Connectech', 'Gran Via de les Corts Catalanes, 789, 08015, Barcelona, Spain', 'T5U6V7W8', '2022/12/01'),
('197864325', 'Dutch Electronics', 'Kalverstraat, 123, 1012 NX, Amsterdam, Netherlands', 'X9Y0Z1A2', '2022/12/15'),
('526493178', 'Tech Empire', 'Karntner Strasse, 456, 1010, Vienna, Austria', 'B3C4D5E6', '2022/12/28'),
('318274965', 'Porto Tech', 'Rua do Carmo, 789, 4050-164, Porto, Portugal', 'F7G8H9I0', '2022/12/31'),
('123456788', 'Global Solutions', 'Avenida da Liberdade, 123, 1000-200, Lisbon, Portugal', 'J5K6L7M8', '2023/09/30'),
('234567897', 'ABC Corporation', '123 Main Street, Anytown, USA', 'U1U2W3X4', '2023/05/26'),
('345678101', 'XYZ Enterprises', '456 Elm Avenue, Sometown, Canada', 'Y5Z6A7B4', '2023/05/27'),
('456089012', 'PQR Ltd', '789 Oak Road, Cityville, Australia', 'C5D6E7F8', '2023/05/28'),
('567898123', 'LMN Industries', '321 Pine Court, Villageland, Germany', 'G2H3I4J5', '2023/05/29'),
('978901234', 'UVW Corporation', '987 Cedar Lane, Metropolis, France', 'U1V2W3X4', '2023/05/30'),
('789012145', 'ABC Corporation', '654 Maple Drive, Townsville, Spain', 'Y5Z6A7B1', '2023/05/31'),
('890123256', 'XYZ Enterprises', '321 Elm Street, Countryside, Italy', 'C1D2E3F4', '2023/06/01'),
('901234367', 'PQR Ltd', '987 Oak Avenue, Riverside, Brazil', 'G5H6I7J8', '2023/06/02'),
('012345978', 'LMN Industries', '654 Birch Road, Mountainville, India', 'K9L0M1N2', '2023/06/03'),
('123451089', 'UVW Corporation', '321 Pine Lane, Lakeside, China', 'O3P4Q5R6', '2023/06/04'),
('234567890', 'ABC Corporation', '987 Cedar Court, Oceanside, Japan', 'S7T8U9V0', '2023/06/05'),
('345678901', 'XYZ Enterprises', '654 Elm Lane, Seaside, South Africa', 'A1B2C3D6', '2023/06/06'),
('456789012', 'PQR Ltd', '321 Oak Road, Beachville, Argentina', 'E5F6G7H7', '2023/06/07'),
('567890123', 'LMN Industries', '987 Pine Drive, Islandtown, Mexico', 'I9J0K1L6', '2023/06/08'),
('678901234', 'UVW Corporation', '654 Birch Street, Desertville, United Kingdom', 'K6L7M8N9', '2023/06/09'),
('789012345', 'ABC Corporation', '321 Maple Avenue, Forestville, Canada', 'M3N4O5Y6', '2023/06/10'),
('890123456', 'XYZ Enterprises', '987 Cedar Road, Mountainside, Australia', 'Q7R6S9T0', '2023/06/11'),
('901234567', 'PQR Ltd', '172 Pine Lane, Lakeside, China', 'U172W3X4', '2023/06/12'),
('012345678', 'LMN Industries', '654 Elm Court, Seaside, South Africa', 'Y5Z6A7B6', '2023/06/13');

---------------------
-- Department
---------------------
INSERT INTO department
VALUES
('Sales'),
('Marketing'),
('Human Resources'),
('Finance'),
('Research and Development'),
('Operations'),
('Customer Service'),
('IT'),
('Procurement'),
('Quality Assurance');

---------------------
-- Workplace
---------------------
INSERT INTO workplace
VALUES
('Rua das Oliveiras, 123, 4700-100, Braga, Portugal', 41.554792, -8.410972),
('Rua da Boa Sorte, 123, 4765-770, Guimaraes, Portugal', 41.594792, -8.417472),
('Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal', 41.333242, -8.570115),
('Estrada da Maia, 789, 4470-110, Maia, Portugal', 41.236560, -8.633450),
('Rua das Flores, 987, 4425-010, Gondomar, Portugal', 41.147832, -8.550700),
('Avenida dos Carvalhos, 321, 4760-150, Vila Nova de Famalicão, Portugal', 41.420987, -8.533674);

---------------------
-- Warehouse
---------------------
INSERT INTO warehouse
VALUES
('Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal'),
('Estrada da Maia, 789, 4470-110, Maia, Portugal'),
('Rua das Flores, 987, 4425-010, Gondomar, Portugal'),
('Avenida dos Carvalhos, 321, 4760-150, Vila Nova de Famalicão, Portugal');

---------------------
-- Delivery
---------------------
INSERT INTO delivery
VALUES
('Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal', '123456789'),
('Estrada da Maia, 789, 4470-110, Maia, Portugal', '987654321'),
('Rua das Flores, 987, 4425-010, Gondomar, Portugal', '246813579'),
('Avenida dos Carvalhos, 321, 4760-150, Vila Nova de Famalicão, Portugal', '135792468'),
('Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal', '864209753'),
('Estrada da Maia, 789, 4470-110, Maia, Portugal', '370592864'),
('Rua das Flores, 987, 4425-010, Gondomar, Portugal', '519273846'),
('Avenida dos Carvalhos, 321, 4760-150, Vila Nova de Famalicão, Portugal', '672849153'),
('Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal', '294753618'),
('Estrada da Maia, 789, 4470-110, Maia, Portugal', '618295743'),
('Rua das Flores, 987, 4425-010, Gondomar, Portugal', '837649521'),
('Avenida dos Carvalhos, 321, 4760-150, Vila Nova de Famalicão, Portugal', '452187396'),
('Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal', '197864325'),
('Estrada da Maia, 789, 4470-110, Maia, Portugal', '526493178'),
('Rua das Flores, 987, 4425-010, Gondomar, Portugal', '318274965');

---------------------
-- Office
---------------------
INSERT INTO office
VALUES
('Rua das Oliveiras, 123, 4700-100, Braga, Portugal'),
('Rua da Boa Sorte, 123, 4765-770, Guimaraes, Portugal'),
('Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal');

---------------------
-- Employee
---------------------
INSERT INTO employee
VALUES
('123456789', '987654321', '1980/05/10', 'Antonio Silva'),
('234567890', '876543210', '1985/03/15', 'Marta Pereira'),
('345678901', '765432109', '1992/08/22', 'Pedro Santos'),
('456789012', '654321098', '1990/11/01', 'Sofia Costa'),
('567890123', '543210987', '1987/09/18', 'Tiago Rodrigues'),
('678901234', '432109876', '1989/07/06', 'Ana Oliveira'),
('789012345', '321098765', '1983/12/03', 'Ricardo Sousa'),
('890123456', '210987654', '1986/04/28', 'Carla Fernandes'),
('901234567', '109876543', '1993/02/14', 'Hugo Matos'),
('012345678', '098765432', '1984/06/07', 'Ines Ferreira'),
('210987654', '887766554', '1981/09/30', 'Joao Santos'),
('109876543', '998877665', '1988/11/26', 'Luis Pereira');

---------------------
-- Works
---------------------
INSERT INTO works
VALUES
('123456789', 'Sales', 'Rua das Oliveiras, 123, 4700-100, Braga, Portugal'),
('234567890', 'Operations', 'Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal'),
('345678901', 'Operations', 'Estrada da Maia, 789, 4470-110, Maia, Portugal'),
('456789012', 'Operations', 'Rua das Flores, 987, 4425-010, Gondomar, Portugal'),
('567890123', 'Finance', 'Avenida dos Carvalhos, 321, 4760-150, Vila Nova de Famalicão, Portugal'),
('678901234', 'Customer Service', 'Rua das Oliveiras, 123, 4700-100, Braga, Portugal'),
('789012345', 'Marketing', 'Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal'),
('890123456', 'Operations', 'Estrada da Maia, 789, 4470-110, Maia, Portugal'),
('901234567', 'Operations', 'Rua das Flores, 987, 4425-010, Gondomar, Portugal'),
('012345678', 'Sales', 'Avenida dos Carvalhos, 321, 4760-150, Vila Nova de Famalicão, Portugal'),
('210987654', 'Finance', 'Rua das Oliveiras, 123, 4700-100, Braga, Portugal'),
('109876543', 'Operations', 'Avenida dos Pinheiros, 456, 4780-200, Trofa, Portugal');

---------------------
-- Proccess
---------------------
INSERT INTO process
VALUES
('345678901', 764903),
('345678901', 892541),
('456789012', 631085),
('345678901', 219346),
('567890123', 845672),
('345678901', 587341),
('345678901', 943815),
('345678901', 356790),
('567890123', 498217),
('456789012', 127503),
('345678901', 708291),
('456789012', 534672),
('456789012', 905213),
('345678901', 128457),
('345678901', 763459),
('456789012', 598317),
('567890123', 972638),
('345678901', 436127),
('345678901', 305972),
('456789012', 794516);
