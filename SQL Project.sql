-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
--\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\Public\Books.csv'
DELIMITER ','
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Users\Public\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\Public\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
Select * from Books
where Genre = 'Fiction'


-- 2) Find books published after the year 1950:
select * from Books 
where published_year > 1950

-- 3) List all customers from the Canada:
Select * from Customers
where Country = 'Canada'

-- 4) Show orders placed in November 2023:
Select * from Orders
where date_part('month',order_date) = 11

-- 5) Retrieve the total stock of books available:
Select Book_id,Stock from Books


-- 6) Find the details of the most expensive book:
Select * from Books
order by Price desc
limit 1


-- 7) Show all customers who ordered more than 1 quantity of a book:
Select Customer_id,Quantity from Orders 
where Quantity > 1

-- 8) Retrieve all orders where the total amount exceeds $20:
Select * from Orders
where Total_Amount > 20

-- 9) List all genres available in the Books table:
Select Distinct(Genre) from Books 
                                       
-- 10) Find the book with the lowest stock:
Select * from Books
order by Stock asc 
limit 1

-- 11) Calculate the total revenue generated from all orders:
Select Sum(Total_Amount) from Orders 

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
Select b.Genre,Sum(o.Quantity) as Total_Books_Sold
from Books b
join Orders o
on o.book_id = b.book_id
group by b.Genre



-- 2) Find the average price of books in the "Fantasy" genre:
Select Avg(Price) from Books
where Genre = 'Fantasy'


-- 3) List customers who have placed at least 2 orders:
Select c.name,c.customer_id, Count(o.order_id) from Orders o
join customers c
on c.customer_id = o.customer_id
group by c.customer_id
having count(order_id) >=2

-- 4) Find the most frequently ordered book:
Select b.title, o.Book_id, Count(o.order_id) as Order_Count
from orders o
join Books b 
on b.book_id = o.book_id
group by o.book_id,b.title
order by order_Count desc 
limit 1

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
Select * from Books
where Genre = 'Fantasy'
order by Price desc limit 3



-- 6) Retrieve the total quantity of books sold by each author:
Select b.author,sum(o.Quantity) as total_books_sold
from orders o
join books b 
on o.book_id = b.book_id
group by b.author
order by Total_books_sold desc


-- 7) List the cities where customers who spent over $30 are located:
Select distinct c.city,o.Total_amount from orders o
join customers c 
on o.customer_id = c.customer_id
where o.total_amount > 30


-- 8) Find the customer who spent the most on orders:
Select c.name,c.customer_id,sum(o.total_amount) as Total_Rev from orders o
join customers c
on c.customer_id = o.customer_id
group by c.customer_id,c.name
order by Total_Rev desc limit 1


--9) Calculate the stock remaining after fulfilling all orders:
Select b.title,b.book_id,b.stock, coalesce(sum(o.quantity),0) as order_quantity,
b.stock - coalesce(sum(o.quantity),0) as Remaining_Stock
from books b
left join orders o on
b.book_id = o.book_id
group by b.book_id
order by b.book_id







