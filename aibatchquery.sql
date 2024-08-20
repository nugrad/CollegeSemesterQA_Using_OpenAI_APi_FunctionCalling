CREATE TABLE fees (
    studentname VARCHAR(255),
    semester INT,
    totalfees FLOAT,
    paidfees FLOAT,
    pendingfees FLOAT,
    PRIMARY KEY (studentname, semester)
);
INSERT INTO marks (studentname, semester, gpa) VALUES
('Hamza Jafri', 1, 3.5),
('Bilal Mamji', 1, 3.6),
('Azaan Farooqui', 1, 3.7),
('Umer Vohra', 1, 3.8),
('Maqbool Ahmed', 1, 3.9),

('Ali Iqbal', 2, 3.2),
('Aqmer Ijaz', 2, 3.3),
('Affan Zahoor', 2, 3.4),
('Mujtaba Ahmed', 2, 3.1),
('Hamza Zafar', 2, 3.0),

('Shaheer Khan', 3, 2.7),
('Abdul Rafay', 3, 2.6),
('Daniyal Ahmed', 3, 2.5),
('Zain Vohra', 3, 2.8),
('Ahmed Umer', 3, 2.9),

('Azhan Mughal', 4, 3.1),
('Taha Sabir', 4, 3.2),
('Hamzah Tariq', 4, 3.3),
('Farzan Ansari', 4, 3.4),
('Usman Yaqoob', 4, 3.5);

INSERT INTO fees (studentname, semester, totalfees, paidfees, pendingfees) VALUES
('Hamza Jafri', 1, 50000, 30000, 20000),
('Bilal Mamji', 1, 52000, 52000, 0),
('Azaan Farooqui', 1, 48000, 40000, 8000),
('Umer Vohra', 1, 50000, 45000, 5000),
('Maqbool Ahmed', 1, 51000, 51000, 0),

('Ali Iqbal', 2, 50000, 25000, 25000),
('Aqmer Ijaz', 2, 53000, 30000, 23000),
('Affan Zahoor', 2, 49000, 49000, 0),
('Mujtaba Ahmed', 2, 47000, 47000, 0),
('Hamza Zafar', 2, 48000, 20000, 28000),

('Shaheer Khan', 3, 52000, 50000, 2000),
('Abdul Rafay', 3, 54000, 54000, 0),
('Daniyal Ahmed', 3, 50000, 45000, 5000),
('Zain Vohra', 3, 48000, 48000, 0),
('Ahmed Umer', 3, 51000, 51000, 0),

('Azhan Mughal', 4, 55000, 30000, 25000),
('Taha Sabir', 4, 57000, 57000, 0),
('Hamzah Tariq', 4, 53000, 53000, 0),
('Farzan Ansari', 4, 51000, 51000, 0),
('Usman Yaqoob', 4, 52000, 45000, 7000);
DELIMITER $$
CREATE PROCEDURE get_marks (
    IN student_name VARCHAR(100), 
    IN semester INT, 
    IN operation VARCHAR(10)
)
BEGIN
    DECLARE result DECIMAL(3,2);

    IF student_name <> '' THEN
        SELECT gpa INTO result
        FROM marks
        WHERE LOWER(marks.studentname) = LOWER(student_name) AND marks.semester = semester;
    ELSEIF operation = 'max' THEN
        SELECT MAX(gpa) INTO result
        FROM marks
        WHERE marks.semester = semester;
    ELSEIF operation = 'min' THEN
        SELECT MIN(gpa) INTO result
        FROM marks
        WHERE marks.semester = semester;
    ELSEIF operation = 'avg' THEN
        SELECT AVG(gpa) INTO result
        FROM marks
        WHERE marks.semester = semester;
    END IF;

    -- Handling when no records are found
    IF result IS NULL THEN
        SET result = -1;
    END IF;

    SELECT result AS GPA;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_fees (
    IN student_name VARCHAR(100), 
    IN semester INT, 
    IN fees_type VARCHAR(10)
)
BEGIN
    DECLARE result DECIMAL(10,2);

    IF student_name <> '' THEN
        IF fees_type = 'paid' THEN
            SELECT paidfees INTO result
            FROM fees
            WHERE LOWER(fees.studentname) = LOWER(student_name) AND fees.semester = semester;
        ELSEIF fees_type = 'pending' THEN
            SELECT pendingfees INTO result
            FROM fees
            WHERE LOWER(fees.studentname) = LOWER(student_name) AND fees.semester = semester;
        ELSEIF fees_type = 'total' THEN
            SELECT totalfees INTO result
            FROM fees
            WHERE LOWER(fees.studentname) = LOWER(student_name) AND fees.semester = semester;
        END IF;
    ELSE
        IF fees_type = 'paid' THEN
            SELECT SUM(paidfees) INTO result
            FROM fees
            WHERE fees.semester = semester;
        ELSEIF fees_type = 'pending' THEN
            SELECT SUM(pendingfees) INTO result
            FROM fees
            WHERE fees.semester = semester;
        ELSEIF fees_type = 'total' THEN
            SELECT SUM(totalfees) INTO result
            FROM fees
            WHERE fees.semester = semester;
        END IF;
    END IF;

    -- Handling when no records are found
    IF result IS NULL THEN
        SET result = -1;
    END IF;

    SELECT result AS Fees;
END$$
DELIMITER ;
select avg(gpa) from marks where semester=4




