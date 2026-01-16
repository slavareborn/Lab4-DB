-- === 1. Рейтинг найактивніших читачів ===
SELECT 
    m.FullName AS "Ім'я читача", 
    m.Email, 
    COUNT(l.Loan_ID) AS "Кількість взятих книг"
FROM Member m
INNER JOIN Loan l ON m.Member_ID = l.Member_ID
GROUP BY m.Member_ID, m.FullName, m.Email
ORDER BY "Кількість взятих книг" DESC
LIMIT 2;

-- === 2. Вибір з умовою фільтрації та агрегуванням ===
SELECT 
    m.FullName AS "Читач",
    m.Phone,
    SUM(f.Amount) AS "Загальна сума штрафів"
FROM Member m
JOIN Fine f ON m.Member_ID = f.Member_ID
GROUP BY m.Member_ID, m.FullName, m.Phone
HAVING SUM(f.Amount) > 50
ORDER BY "Загальна сума штрафів" DESC;

-- === 3. Вибір з кількома JOIN та обчисленням прострочених днів ===
SELECT 
    b.Title AS "Книга",
    m.FullName AS "Хто тримає",
    l.DueDate AS "Мав повернути",
    (CURRENT_DATE - l.DueDate) AS "Днів прострочення",
    s.FullName AS "Хто видав книгу"
FROM Loan l
JOIN Book b ON l.Book_ID = b.Book_ID
JOIN Member m ON l.Member_ID = m.Member_ID
JOIN Staff s ON l.Staff_ID = s.Staff_ID
WHERE l.ReturnDate IS NULL 
  AND l.DueDate < CURRENT_DATE
ORDER BY "Днів прострочення" DESC;

-- === 4. Вибір книг, які наразі не позичені ===
SELECT 
    b.Title AS "Назва книги",
    a.SecondName AS "Автор",
    g.Title AS "Жанр"
FROM Book b
LEFT JOIN Loan l ON b.Book_ID = l.Book_ID
JOIN Author a ON b.Author_ID = a.Author_ID
JOIN Genre g ON b.Genre_ID = g.Genre_ID
WHERE l.Loan_ID IS NULL;

-- === 5. Вибір з умовною логікою (CASE) для категоризації книг за ціною ===
SELECT 
    b.Title,
    b.Cost,
    CASE 
        WHEN b.Cost < 200 THEN 'Бюджетна'
        WHEN b.Cost BETWEEN 200 AND 500 THEN 'Середня ціна'
        WHEN b.Cost > 500 THEN 'Дорога/Рідкісна'
        ELSE 'Ціну не вказано'
    END AS "Категорія ціни"
FROM Book b
ORDER BY b.Cost DESC;

-- === 6. Підрахунок загальної кількості назв книг у бібліотеці ===
SELECT COUNT(*) AS "Загальна кількість назв книг" 
FROM Book;

-- === 7. Підрахунок загальної суми всіх штрафів, накладених на читачів ===
SELECT SUM(Amount) AS "Загальна сума всіх штрафів (грн)" 
FROM Fine;

-- === 8. Обчислення середньої ціни книги в бібліотеці ===
-- ROUND використовується для округлення до 2 знаків після коми
SELECT ROUND(AVG(Cost), 2) AS "Середня ціна книги" 
FROM Book;

-- === 9. Знаходження найстарішої книги за роком видання ===
SELECT MIN(PublisherYear) AS "Рік видання найстарішої книги" 
FROM Book;

-- === 10. Знаходження книги з максимальною кількістю сторінок ===
SELECT MAX(AmountOfPages) AS "Максимальна кількість сторінок" 
FROM Book;