-- Jelly Belly Sample Data
-- Run this script in Oracle SQL*Plus or SQL Developer

-- Delete existing data (optional)
-- DELETE FROM product WHERE prod_no >= 10001;

-- Insert sample candy products
INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Rainbow Jelly Beans', 'Colorful assorted jelly beans with 20 different fruity flavors. Perfect for parties!', '20250101', 5900, 'candy01.jpg', SYSDATE - 15);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Strawberry Gummy Bears', 'Soft and chewy strawberry flavored gummy bears. Made with real fruit juice.', '20250105', 4500, 'candy02.jpg', SYSDATE - 14);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Milk Chocolate Truffles', 'Premium Belgian milk chocolate truffles with creamy ganache center.', '20250103', 12000, 'candy03.jpg', SYSDATE - 13);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Sour Watermelon Slices', 'Tangy and sweet watermelon flavored sour candies. Coating with sugar crystals.', '20250102', 3900, 'candy04.jfif', SYSDATE - 12);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Butter Caramel Swirls', 'Hand-crafted butter caramels with sea salt. Melt-in-your-mouth texture.', '20250104', 8500, 'candy05.jfif', SYSDATE - 11);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Mixed Fruit Lollipops', 'Assorted fruit flavored lollipops in fun shapes. Great for kids!', '20250106', 2500, 'candy06.jfif', SYSDATE - 10);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Dark Chocolate Almonds', 'Roasted almonds covered in rich dark chocolate. 70% cacao.', '20250101', 9800, 'candy07.jfif', SYSDATE - 9);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Peach Rings', 'Sweet peach flavored gummy rings with sugar coating. Soft and fruity!', '20250105', 3500, 'candy08.jfif', SYSDATE - 8);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Cotton Candy Clouds', 'Fluffy cotton candy in pastel colors. Vanilla and strawberry flavors.', '20250107', 4200, 'candy09.jfif', SYSDATE - 7);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Mint Chocolate Bars', 'Refreshing mint cream filling with milk chocolate coating.', '20250102', 6500, 'candy10.jfif', SYSDATE - 6);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Tropical Mix Gummies', 'Exotic tropical fruit gummies - mango, pineapple, passion fruit, coconut!', '20250106', 5200, 'candy11.jfif', SYSDATE - 5);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Honey Toffee Bites', 'Traditional English toffee made with pure honey. Crunchy and sweet.', '20250103', 7200, 'candy12.jfif', SYSDATE - 4);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Blue Raspberry Twists', 'Twisted blue raspberry licorice. Perfect tangy-sweet balance!', '20250104', 3200, 'candy13.jfif', SYSDATE - 3);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'White Chocolate Hearts', 'Creamy white chocolate hearts with strawberry filling. Gift box included.', '20250108', 15000, 'candy14.jfif', SYSDATE - 2);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Sour Cola Bottles', 'Cola flavored gummies shaped like bottles. Fizzy sour coating!', '20250107', 3800, 'candy15.jfif', SYSDATE - 1);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Matcha Green Tea Mochi', 'Japanese style mochi candies with premium matcha flavor. Chewy and aromatic.', '20250108', 8900, 'candy16.jfif', SYSDATE);

INSERT INTO product (prod_no, prod_name, prod_detail, manufacture_day, price, image_file, reg_date)
VALUES (seq_product_prod_no.NEXTVAL, 'Hazelnut Pralines', 'Luxurious hazelnut pralines with whole hazelnuts. Perfect gift choice.', '20250109', 18000, 'candy17.jfif', SYSDATE);

COMMIT;

-- Check inserted data
SELECT prod_no, prod_name, price, image_file FROM product ORDER BY reg_date DESC;
