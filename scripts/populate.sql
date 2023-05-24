--
--		File: populate.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--             - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: DML that populates the tables with synthetic test data.

---------------------
-- Customer
---------------------
INSERT INTO customer
VALUES
(1, 'Joaquim Souza', 'joaquim.souza@gmail.com', 91294337, 'Rua das Flores, 45, 6300-250, Guarda, Portugal'),
(2, 'Jane Doe', 'jane.doe@hotmail.com', 12345678, 'Hensbury Street, 22, B74 5PQ, Birmingham, England'),
(3, 'Hans Joanssen', 'hans_joanssen@gmail.com', 90695443, 'Nygade, 13, 1309, Aarhus, Denmark'),
(4, 'Julia Teixeira', 'julia.teixeira@gmail.com', 966254228, 'Rua Alves Redol, 106, 2100-203, Lisboa, Portugal'),
(5, 'Rui Pereira', 'rui.pereira@sapo.pt', 988899438, 'Rua do Sol, 157, 2100-322, Lisboa, Portugal'),
(6, 'Siobhan Santos', 'siobhan.santos@gmail.com', 988899438, 'Rua do Ouro, 36, 2100-245, Lisboa, Portugal'),
(8, 'João Silva', 'joao.silva@gmail.com', 988899438, 'Travessa da Amizade, 21, 5005-056, Porto, Portugal'),
(9, 'Dinis Matos', 'dinis.matos@gmail.com', 988899438, 'Avenida Central, 122, 4715-075, Braga, Portugal'),
(7, 'Victor Alejandro', 'victor.alejandro@gmail.com', 988899438, 'Avenida del Libertador, 55, 99-209-056, Santiago, Chile');

---------------------
-- package
---------------------
INSERT INTO package
VALUES
(764903, '2023/05/22', 2),
(892541, '2023/04/18', 3),
(631085, '2023/03/11', 7),
(219346, '2023/02/09', 9),
(845672, '2023/01/05', 8),
(587341, '2023/06/30', 6),
(943815, '2023/07/22', 4),
(356790, '2023/08/17', 5),
(498217, '2023/09/14', 1),
(127503, '2023/10/11', 3),
(708291, '2023/11/07', 2),
(534672, '2023/12/31', 9),
(905213, '2023/05/22', 1),
(128457, '2023/04/18', 7),
(763459, '2023/03/11', 4),
(598317, '2023/02/09', 8),
(972638, '2023/01/05', 5),
(436127, '2023/06/30', 6),
(305972, '2023/07/22', 2),
(794516, '2023/08/17', 3);

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
(534672);

---------------------
-- Pay
---------------------
INSERT INTO pay
VALUES
(764903, 2),
(892541, 3),
(631085, 7),
(219346, 9),
(845672, 8),
(587341, 6),
(943815, 4),
(356790, 5),
(498217, 1),
(127503, 3),
(708291, 2),
(534672, 9);

---------------------
-- Product
---------------------
INSERT INTO product
VALUES
('A1B2C3D4', 'Smartphone', 'Powerful smartphone with advanced features', 599.99, '1234567890123'),
('E5F6G7H8', 'Laptop', 'Ultra-thin and lightweight laptop for productivity', 999.99, NULL),
('I9J0K1L2', 'Headphones', 'High-quality headphones for immersive audio experience', 149.99, '3456789012345'),
('M3N4O5P6', 'Smart Watch', 'Elegant smartwatch with fitness tracking capabilities', 199.99, NULL),
('Q7R8S9T0', 'Bluetooth Speaker', 'Portable speaker with wireless connectivity', 79.99, '5678901234567'),
('U1V2W3X4', 'Wireless Earbuds', 'True wireless earbuds with noise cancellation', 129.99, '6789012345678'),
('Y5Z6A7B8', 'Tablet', 'Versatile tablet for work and entertainment', 299.99, '7890123456789'),
('C9D0E1F2', 'Gaming Mouse', 'Precision gaming mouse with customizable settings', 69.99, NULL),
('G3H4I5J6', 'Smart TV', 'Ultra-HD smart TV with built-in streaming apps', 799.99, NULL),
('K7L8M9N0', 'Fitness Tracker', 'Activity tracker for monitoring health and fitness', 49.99, '0123456789012'),
('P1Q2R3S4', 'Wireless Keyboard', 'Slim and ergonomic wireless keyboard', 89.99, NULL),
('T5U6V7W8', 'Camera', 'High-resolution camera for capturing memorable moments', 399.99, '2345678901234'),
('X9Y0Z1A2', 'External Hard Drive', 'Portable storage device with large capacity', 149.99,'3456789012345'),
('B3C4D5E6', 'Printers', 'Fast and reliable printers for home or office use', 129.99, NULL),
('F7G8H9I0', 'Wireless Router', 'High-speed wireless router for seamless internet connectivity', 79.99, NULL);

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
(587341, 'U1V2W3X4', 1),
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
(219346, 'U1V2W3X4', 1),
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
(763459, 'M3N4O5P6', 1);

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
('370592864', 'Euro Gadgets', 'Strada Mihai Eminescu, 543, 030167, Bucharest, Romania', 'U1V2W3X4', '2022/06/18'),
('519273846', 'Nordic Electronics', 'Guldbergsgade, 246, 2200, Copenhagen, Denmark', 'Y5Z6A7B8', '2022/07/25'),
('672849153', 'Inovar Tech', 'Avenida da Liberdade, 456, 1250-123, Lisbon, Portugal', 'C9D0E1F2', '2022/08/14'),
('294753618', 'Smartech Solutions', 'Plaza de Catalunya, 789, 08002, Barcelona, Spain', 'G3H4I5J6', '2022/09/30'),
('618295743', 'Italia Electronica', 'Corso Italia, 123, 00198, Rome, Italy', 'K7L8M9N0', '2022/10/22'),
('837649521', 'Scandinavian Tech', 'Drottninggatan, 456, 11151, Stockholm, Sweden', 'P1Q2R3S4', '2022/11/08'),
('452187396', 'Connectech', 'Gran Via de les Corts Catalanes, 789, 08015, Barcelona, Spain', 'T5U6V7W8', '2022/12/01'),
('197864325', 'Dutch Electronics', 'Kalverstraat, 123, 1012 NX, Amsterdam, Netherlands', 'X9Y0Z1A2', '2022/12/15'),
('526493178', 'Tech Empire', 'Karntner Strasse, 456, 1010, Vienna, Austria', 'B3C4D5E6', '2022/12/28'),
('318274965', 'Porto Tech', 'Rua do Carmo, 789, 4050-164, Porto, Portugal', 'F7G8H9I0', '2022/12/31');

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
