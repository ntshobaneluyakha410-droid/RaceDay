-- =============================================
-- SECTION C: SQL DATABASE SCRIPT
-- RaceDay System
-- =============================================

-- Drop tables if they exist (for clean installation)
DROP TABLE IF EXISTS Results;
DROP TABLE IF EXISTS Enrolments;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Venues;
DROP TABLE IF EXISTS Users;

-- =============================================
-- 1. USERS TABLE
-- =============================================
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    Phone NVARCHAR(20) NOT NULL,
    DateRegistered DATETIME DEFAULT GETDATE()
);

-- =============================================
-- 2. VENUES TABLE
-- =============================================
CREATE TABLE Venues (
    VenueID INT IDENTITY(1,1) PRIMARY KEY,
    VenueName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Province NVARCHAR(50) NOT NULL,
    PostalCode NVARCHAR(20) NOT NULL,
    Capacity INT DEFAULT 0
);

-- =============================================
-- 3. EVENTS TABLE
-- =============================================
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    VenueID INT NOT NULL,
    EventName NVARCHAR(100) NOT NULL,
    EventDate DATETIME NOT NULL,
    RegistrationDeadline DATETIME NOT NULL,
    Description NVARCHAR(500),
    MaxParticipants INT DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Draft' CHECK (Status IN ('Draft', 'Published', 'Closed', 'Cancelled')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OrganiserID) REFERENCES Users(UserID),
    FOREIGN KEY (VenueID) REFERENCES Venues(VenueID)
);

-- =============================================
-- 4. CATEGORIES TABLE
-- =============================================
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName NVARCHAR(50) NOT NULL,
    Distance FLOAT NOT NULL,
    AgeGroup NVARCHAR(50),
    GenderRestriction NVARCHAR(10) CHECK (GenderRestriction IN ('Male', 'Female', 'Open')),
    EntryFee DECIMAL(10,2) NOT NULL,
    StartTime DATETIME,
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

-- =============================================
-- 5. ENROLMENTS TABLE
-- =============================================
CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    CategoryID INT NOT NULL,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    PaymentStatus NVARCHAR(20) DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending', 'Paid', 'Refunded')),
    EnrolmentStatus NVARCHAR(20) DEFAULT 'Active' CHECK (EnrolmentStatus IN ('Active', 'Withdrawn', 'Transferred')),
    SpecialRequests NVARCHAR(200),
    FOREIGN KEY (ParticipantID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- =============================================
-- 6. RESULTS TABLE
-- =============================================
CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT UNIQUE NOT NULL,
    FinishTime TIME,
    ChipTime TIME,
    GunTime TIME,
    OverallPosition INT,
    AgeGroupPosition INT,
    Disqualification BIT DEFAULT 0,
    DisqualificationReason NVARCHAR(200),
    FOREIGN KEY (EnrolmentID) REFERENCES Enrolments(EnrolmentID)
);

-- =============================================
-- CREATE INDEXES FOR PERFORMANCE
-- =============================================
CREATE INDEX idx_events_organiser ON Events(OrganiserID);
CREATE INDEX idx_events_venue ON Events(VenueID);
CREATE INDEX idx_categories_event ON Categories(EventID);
CREATE INDEX idx_enrolments_participant ON Enrolments(ParticipantID);
CREATE INDEX idx_enrolments_category ON Enrolments(CategoryID);
CREATE INDEX idx_results_enrolment ON Results(EnrolmentID);

-- =============================================
-- SEED DATA
-- =============================================

-- 2 Organisers
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Role, Phone)
VALUES 
('John', 'Doe', 'john@organiser.com', 'hashed123', 'Organiser', '0821111111'),
('Jane', 'Smith', 'jane@organiser.com', 'hashed456', 'Organiser', '0822222222');

-- 2 Participants
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Role, Phone)
VALUES 
('Bob', 'Johnson', 'bob@runner.com', 'hashed789', 'Participant', '0833333333'),
('Alice', 'Williams', 'alice@runner.com', 'hashed101', 'Participant', '0834444444');

-- Venues
INSERT INTO Venues (VenueName, Address, City, Province, PostalCode, Capacity)
VALUES 
('Cape Town Stadium', 'Fritz Sonnenberg Rd', 'Cape Town', 'Western Cape', '8005', 55000),
('Johannesburg Stadium', 'Bertrams Road', 'Johannesburg', 'Gauteng', '2094', 30000),
('Durban ICC', '45 Bram Fischer Rd', 'Durban', 'KwaZulu-Natal', '4001', 10000);

-- 3 Events
INSERT INTO Events (OrganiserID, VenueID, EventName, EventDate, RegistrationDeadline, Description, MaxParticipants, Status)
VALUES 
(1, 1, 'Cape Town Marathon 2026', '2026-10-15 06:00:00', '2026-10-01 23:59:59', 'The premier marathon event in South Africa', 15000, 'Published'),
(1, 2, 'Johannesburg 10k Challenge', '2026-11-20 07:00:00', '2026-11-10 23:59:59', 'Fast and flat 10km through the city', 5000, 'Published'),
(2, 3, 'Durban Ultra 50km', '2026-12-05 05:00:00', '2026-11-25 23:59:59', 'Ultra marathon along the Durban coast', 2000, 'Draft');

-- Categories for each event
INSERT INTO Categories (EventID, CategoryName, Distance, AgeGroup, GenderRestriction, EntryFee, StartTime)
VALUES 
-- Cape Town Marathon categories
(1, 'Full Marathon', 42.2, 'Open', 'Open', 850.00, '2026-10-15 06:00:00'),
(1, 'Half Marathon', 21.1, 'Open', 'Open', 650.00, '2026-10-15 07:00:00'),
(1, '10km Run', 10.0, 'Open', 'Open', 350.00, '2026-10-15 08:00:00'),
-- Johannesburg 10k categories
(2, 'Elite 10km', 10.0, 'Open', 'Open', 450.00, '2026-11-20 07:00:00'),
(2, 'Age Group 10km', 10.0, '40-49', 'Open', 350.00, '2026-11-20 07:15:00'),
-- Durban Ultra categories
(3, '50km Ultra', 50.0, 'Open', 'Open', 1200.00, '2026-12-05 05:00:00'),
(3, '25km', 25.0, 'Open', 'Open', 800.00, '2026-12-05 06:00:00');

-- Sample Enrolments
INSERT INTO Enrolments (ParticipantID, CategoryID, PaymentStatus, EnrolmentStatus)
VALUES 
(3, 1, 'Paid', 'Active'),  -- Bob - Cape Town Full Marathon
(3, 5, 'Paid', 'Active'),  -- Bob - Joburg Age Group
(4, 1, 'Paid', 'Active');  -- Alice - Cape Town Full Marathon

-- Sample Results
INSERT INTO Results (EnrolmentID, FinishTime, ChipTime, GunTime, OverallPosition, AgeGroupPosition)
VALUES 
(1, '03:45:22', '03:43:15', '03:45:22', 120, 15),
(3, '04:12:45', '04:10:30', '04:12:45', 245, 22);
