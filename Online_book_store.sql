CREATE TABLE Book(
	book_id SERIAL PRIMARY KEY,
	tittle VARCHAR(200),
	author VARCHAR(200),
	genre VARCHAR(200),
	published_year INT,
	price NUMERIC(10,2),
	stock INT
);

DROP TABLE Book;
SELECT * FROM Book;

CREATE TABLE Customer(

	Customer_id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	email VARCHAR(100),
	phone VARCHAR(100),
	city VARCHAR(50),
	country VARCHAR(120)
);

SELECT * FROM Customer;

CREATE TABLE Orders(
	Order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES Customer(customer_id),
	book_id INT REFERENCES Book(Book_id),
	order_date DATE,
	quantity INT,
	TOTAL_AMOUNT numeric(10,2)
);

SELECT * FROM Orders;

-- Retrive all the books from Fiction genre.

SELECT tittle,author,genre FROM Book WHERE genre='Fiction';

--Find all the book published after the year 1950

SELECT * FROM Book WHERE published_year>1950;

--List all the customer from canada.

SELECT * FROM Customer WHERE country='Canada';

----4> show order placed in november 2023.

SELECT * FROM orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5> retrive the total stock of book available.

SELECT sum(stock) AS total_stock FROM Book;

--6> Find the details of mostr expensve book.

SELECT * FROM Book ORDER BY price DESC LIMIT 1;

--7> Show all customers who ordered more than 1 quantity of a book.

SELECT * FROM orders WHERE quantity>1;

--8> retrive all the column where the total amount exceds $20.

SELECT * FROM orders WHERE total_amount>20;

--9> list all the general avialable in the books table.

SELECT DISTINCT genre FROM Book; 

--10> find the book with the lowest stock.

SELECT * FROM Book ORDER BY stock LIMIT 1;

--11> generate the total revenue genrate from all orders.

SELECT SUM(total_amount) AS total_revenue FROM Orders; 

-- ADVANCE QUERYS.

--1> retrive the total number of books sold for each genre.

SELECT b.genre,SUM(o.quantity) AS total_book_sold
FROM Orders o
JOIN
Book b
ON o.book_id = b.book_id
GROUP BY b.genre;

--12> Find average price of book in the fantasy genre

SELECT AVG(price) AS average_price
FROM book WHERE genre='Fantasy';

--13> list the customer who have placed atleast 2 orders.

SELECT customer_id, COUNT(order_id) AS Order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) >= 2;

--14> find the most fequently order book.

SELECT book_id,COUNT(order_id) AS total_count
FROM orders
GROUP BY book_id
ORDER BY total_count DESC LIMIT 1;

--15> SHOW THAT THE TOP MOST EXPENSIVE BOOK OF FANTASY GENRE.

SELECT * FROM book
WHERE genre='Fantasy' ORDER BY price DESC LIMIT 3;

--16> retrive the total quantity of book sold by the each author

SELECT b.author, COUNT(o.quantity) AS Total_quantity
FROM orders o
JOIN 
book b
ON o.book_id = b.book_id
GROUP BY b.author; 

--17> list the city where Customers who spent over $30 are loacated

SELECT DISTINCT c.city, total_amount
FROM Customer c
JOIN
orders o
ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;

--18> Find the customer who spend most on orders.

SELECT c.customer_id,c.name,SUM(total_amount) AS total_spend
FROM customer c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
Order by total_spend DESC LIMIT 1; 

--19> calaculate the stock remaining after fulfilling all the orders.

SELECT b.book_id,b.tittle,b.stock,COALESCE(SUM(o.quantity),0) AS total_quantity, 
b.stock-COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM book b
LEFT JOIN 
ORDERS o
ON b.book_id = o.book_id
GROUP BY b.book_id ORDER BY b.book_id;