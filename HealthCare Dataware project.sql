-- Create the Healthcare Data Warehouse Database
CREATE DATABASE HealthcareDataWarehouse;

-- 1. Dim_Patients Table (Patient Information)
CREATE TABLE Dim_Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender CHAR(1),
    Address VARCHAR(255),
    Phone VARCHAR(15)
);

-- 2. Dim_Doctors Table (Doctor Information)
CREATE TABLE Dim_Doctors (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Specialty VARCHAR(100),
    ContactInfo VARCHAR(255)
);

-- 3.Dim_DiagnosisCodes Table (Diagnosis Information)
CREATE TABLE Dim_DiagnosisCodes (
    DiagnosisCode VARCHAR(10) PRIMARY KEY,
    DiagnosisDescription VARCHAR(255)
);

-- 4. Dim_Dates Table (Date Information)
CREATE TABLE Dim_Dates (
    DateID INT PRIMARY KEY,
    Date DATE,
    Week INT,
    Month INT,
    Year INT
);

-- 5. Dim_Departments Table (Hospital Departments)
CREATE TABLE Dim_Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

-- 6. Dim_TreatmentPlans Table (Treatment Plans)
CREATE TABLE Dim_TreatmentPlans (
    TreatmentPlanID INT PRIMARY KEY,
    TreatmentDescription VARCHAR(255),
    DurationWeeks INT
);

-- 7.Dim_Insurance Table (Insurance Information)
CREATE TABLE Dim_Insurance (
    InsuranceID INT PRIMARY KEY,
    InsuranceProvider VARCHAR(100),
    CoverageType VARCHAR(100)
);

-- 8. Dim_Medications Table (Medications)
CREATE TABLE Dim_Medications (
    MedicationID INT PRIMARY KEY,
    MedicationName VARCHAR(100),
    Dosage VARCHAR(50),
    SideEffects VARCHAR(255)
);

-- 9. Dim_Resources Table (Hospital Resources like Beds, Machines)
CREATE TABLE Dim_Resources (
    ResourceID INT PRIMARY KEY,
    ResourceType VARCHAR(100),
    AvailabilityStatus VARCHAR(50)
);

-- 10. Dim_Locations Table (Hospital Location Data)
CREATE TABLE Dim_Locations (
    LocationID INT PRIMARY KEY,
    RoomNumber VARCHAR(50),
    FloorNumber INT,
    Wing VARCHAR(50)
);

-- 11. Fact_Patient_Visits Table (Fact Table for Patient Visits)
CREATE TABLE Fact_Patient_Visits (
    VisitID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AdmissionDate DATE,
    DischargeDate DATE,
    DiagnosisCode VARCHAR(10),
    TreatmentPlanID INT,
    InsuranceID INT,
    LocationID INT,
    ResourceID INT,
    DepartmentID INT,
    FOREIGN KEY (PatientID) REFERENCES Dim_Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Dim_Doctors(DoctorID),
    FOREIGN KEY (DiagnosisCode) REFERENCES Dim_DiagnosisCodes(DiagnosisCode),
    FOREIGN KEY (TreatmentPlanID) REFERENCES Dim_TreatmentPlans(TreatmentPlanID),
    FOREIGN KEY (InsuranceID) REFERENCES Dim_Insurance(InsuranceID),
    FOREIGN KEY (LocationID) REFERENCES Dim_Locations(LocationID),
    FOREIGN KEY (ResourceID) REFERENCES Dim_Resources(ResourceID),
    FOREIGN KEY (DepartmentID) REFERENCES Dim_Departments(DepartmentID)
);

-- 12. Fact_Treatment_Medications Table 
-- (Fact Table for Medications given during Treatment)

CREATE TABLE Fact_Treatment_Medications (
    TreatmentID INT PRIMARY KEY,
    VisitID INT,
    MedicationID INT,
    DoseAdministered VARCHAR(50),
    AdministeredDate DATE,
    FOREIGN KEY (VisitID) REFERENCES Fact_Patient_Visits(VisitID),
    FOREIGN KEY (MedicationID) REFERENCES Dim_Medications(MedicationID)
);

-- 13. Fact_Doctor_Schedules Table (Doctor Schedules)
CREATE TABLE Fact_Doctor_Schedules (
    ScheduleID INT PRIMARY KEY,
    DoctorID INT,
    LocationID INT,
    DateID INT,
    ShiftStartTime TIME,
    ShiftEndTime TIME,
    FOREIGN KEY (DoctorID) REFERENCES Dim_Doctors(DoctorID),
    FOREIGN KEY (LocationID) REFERENCES Dim_Locations(LocationID),
    FOREIGN KEY (DateID) REFERENCES Dim_Dates(DateID)
);

-- 14. Fact_Resource_Utilization Table (Hospital Resource Usage)
CREATE TABLE Fact_Resource_Utilization (
    UtilizationID INT PRIMARY KEY,
    ResourceID INT,
    VisitID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (ResourceID) REFERENCES Dim_Resources(ResourceID),
    FOREIGN KEY (VisitID) REFERENCES Fact_Patient_Visits(VisitID)
);

-- 15. Fact_Patient_Billing Table (Patient Billing)
CREATE TABLE Fact_Patient_Billing (
    BillingID INT PRIMARY KEY,
    VisitID INT,
    TotalCost DECIMAL(10, 2),
    PaymentMethod VARCHAR(50),
    InsuranceCoverage DECIMAL(10, 2),
    PatientPayment DECIMAL(10, 2),
    FOREIGN KEY (VisitID) REFERENCES Fact_Patient_Visits(VisitID)
);


------------ Insert Data into Tables -------------
-- 1. Inserting Data into Dim_Patients
INSERT INTO Dim_Patients (PatientID, Name, Age, Gender, Address, Phone)
VALUES 
(1, 'John Doe', 45, 'M', '123 Elm St, Springfield', '555-1234'),
(2, 'Jane Smith', 34, 'F', '456 Oak St, Springfield', '555-5678'),
(3, 'Alice Johnson', 29, 'F', '789 Pine St, Springfield', '555-9101'),
(4, 'Robert Brown', 50, 'M', '101 Maple St, Springfield', '555-1122'),
(5, 'Emily Davis', 42, 'F', '202 Birch St, Springfield', '555-3344'),
(6, 'Michael Wilson', 38, 'M', '303 Cedar St, Springfield', '555-5566'),
(7, 'Linda Miller', 31, 'F', '404 Elm St, Springfield', '555-7788'),
(8, 'James Taylor', 47, 'M', '505 Oak St, Springfield', '555-9900'),
(9, 'Maria Anderson', 40, 'F', '606 Pine St, Springfield', '555-1235'),
(10, 'David Lee', 36, 'M', '707 Maple St, Springfield', '555-6789'),
(11, 'Sarah Thompson', 27, 'F', '808 Birch St, Springfield', '555-2345'),
(12, 'Daniel Martinez', 55, 'M', '909 Cedar St, Springfield', '555-3456'),
(13, 'Jessica White', 44, 'F', '1010 Elm St, Springfield', '555-4567'),
(14, 'Christopher Harris', 30, 'M', '1111 Oak St, Springfield', '555-5678'),
(15, 'Amanda Clark', 39, 'F', '1212 Pine St, Springfield', '555-6789'),
(16, 'Matthew Lewis', 33, 'M', '1313 Maple St, Springfield', '555-7890'),
(17, 'Olivia Walker', 26, 'F', '1414 Birch St, Springfield', '555-8901'),
(18, 'William Hall', 48, 'M', '1515 Cedar St, Springfield', '555-9012'),
(19, 'Sophia Allen', 41, 'F', '1616 Elm St, Springfield', '555-0123'),
(20, 'James Young', 35, 'M', '1717 Oak St, Springfield', '555-1234'),
(21, 'Isabella King', 32, 'F', '1818 Pine St, Springfield', '555-2345'),
(22, 'Benjamin Scott', 53, 'M', '1919 Maple St, Springfield', '555-3456'),
(23, 'Charlotte Adams', 28, 'F', '2020 Birch St, Springfield', '555-4567'),
(24, 'Ethan Baker', 46, 'M', '2121 Cedar St, Springfield', '555-5678'),
(25, 'Amelia Nelson', 29, 'F', '2222 Elm St, Springfield', '555-6789'),
(26, 'Alexander Carter', 37, 'M', '2323 Oak St, Springfield', '555-7890'),
(27, 'Mia Mitchell', 25, 'F', '2424 Pine St, Springfield', '555-8901'),
(28, 'Daniel Roberts', 43, 'M', '2525 Maple St, Springfield', '555-9012'),
(29, 'Lily Stewart', 30, 'F', '2626 Birch St, Springfield', '555-0123'),
(30, 'Jack Morris', 52, 'M', '2727 Cedar St, Springfield', '555-1234');

Select * from Dim_Patients;

-- 2. Inserting Data into Dim_Doctors
INSERT INTO Dim_Doctors (DoctorID, Name, Specialty, ContactInfo)
VALUES 
(101, 'Dr. Ahmed Parker',	'Cardiology', 'ahmed.parker@hospital.com'),
(102, 'Dr. Bob Green',		'Neurology', 'bob.green@hospital.com'),
(103, 'Dr. Emily Johnson',	'Dermatology', 'emily.johnson@hospital.com'),
(104, 'Dr. David Brown',	'Pediatrics', 'david.brown@hospital.com'),
(105, 'Dr. Jonthan Miller',	'Oncology', 'jonthan.miller@hospital.com'),
(106, 'Dr. Spider Wilson',	'Orthopedics', 'spider.wilson@hospital.com'),
(107, 'Dr. Patricia Taylor', 'Gastroenterology', 'patricia.taylor@hospital.com'),
(108, 'Dr. Michael Davis',	'Pulmonology', 'michael.davis@hospital.com'),
(109, 'Dr. Kareena Smith',	'Nephrology', 'Kareena.smith@hospital.com'),
(110, 'Dr. Daniel Anderson', 'Endocrinology', 'daniel.anderson@hospital.com'),
(111, 'Dr. Karen Jackson',	'Rheumatology', 'karen.jackson@hospital.com'),
(112, 'Dr. William Harris', 'Urology', 'william.harris@hospital.com'),
(113, 'Dr. Linda Clark',	'Hematology', 'linda.clark@hospital.com'),
(114, 'Dr. Steven Lewis',	'Allergy & Immunology', 'steven.lewis@hospital.com'),
(115, 'Dr. Barbara Walker', 'Infectious Disease', 'barbara.walker@hospital.com'),
(116, 'Dr. Thomas Hall',	'Ophthalmology', 'thomas.hall@hospital.com'),
(117, 'Dr. Jennifer Young', 'Obstetrics & Gynecology', 'jennifer.young@hospital.com'),
(118, 'Dr. George King',	'Anesthesiology', 'george.king@hospital.com'),
(119, 'Dr. Sarah Scott',	'Otolaryngology', 'sarah.scott@hospital.com'),
(120, 'Dr. Robert Hill',	'Psychiatry', 'robert.hill@hospital.com'),
(121, 'Dr. Nancy Adams',	'Palliative Care', 'nancy.adams@hospital.com'),
(122, 'Dr. Charles Baker',	'Plastic Surgery', 'charles.baker@hospital.com'),
(123, 'Dr. Betty Wright',	'Vascular Surgery', 'betty.wright@hospital.com'),
(124, 'Dr. John Carter',	'Neurosurgery', 'john.carter@hospital.com'),
(125, 'Dr. Amy Mitchell',	'Emergency Medicine', 'amy.mitchell@hospital.com'),
(126, 'Dr. Mark Perez',		'Geriatrics', 'mark.perez@hospital.com'),
(127, 'Dr. Rebecca Turner', 'General Surgery', 'rebecca.turner@hospital.com'),
(128, 'Dr. Paul Roberts',	'Radiology', 'paul.roberts@hospital.com'),
(129, 'Dr. Angela Phillips', 'Pathology', 'angela.phillips@hospital.com'),
(130, 'Dr. Carol Black',	'Orthopedics', 'carol.black@hospital.com');

Select * from Dim_Doctors;

-- 3. Inserting Data into Dim_DiagnosisCodes
INSERT INTO Dim_DiagnosisCodes (DiagnosisCode, DiagnosisDescription)
VALUES 
('D01', 'Hypertension'),('D02', 'Migraine'),('D03', 'Diabetes Mellitus Type 2'),
('D04', 'Asthma'),('D05', 'Chronic Obstructive Pulmonary Disease (COPD)'),
('D06', 'Coronary Artery Disease'),('D07', 'Stroke'),('D08', 'Chronic Kidney Disease'),
('D09', 'Osteoarthritis'),('D10', 'Rheumatoid Arthritis'),('D11', 'Epilepsy'),
('D12', 'Depression'),('D13', 'Anxiety Disorder'),('D14', 'Schizophrenia'),
('D15', 'Bipolar Disorder'),('D16', 'Pneumonia'),('D17', 'Tuberculosis'),
('D18', 'HIV/AIDS'),('D19', 'Cancer - Breast'),('D20', 'Cancer - Lung'),
('D21', 'Heart Failure'),('D22', 'Arrhythmia'),('D23', 'Chronic Liver Disease'),
('D24', 'Pancreatitis'),('D25', 'Irritable Bowel Syndrome'),('D26', 'Gastric Ulcer'),
('D27', 'Multiple Sclerosis'),('D28', 'Alzheimer’s Disease'),
('D29', 'Parkinson’s Disease'),('D30', 'Fractured Leg');

Select * from Dim_DiagnosisCodes;

-- 4. Inserting Data into Dim_Dates
INSERT INTO Dim_Dates (DateID, Date, Week, Month, Year)
VALUES 
(1, '2024-01-01', 1, 1, 2024),(2, '2024-01-02', 1, 1, 2024),(3, '2024-01-03', 1, 1, 2024),
(4, '2024-01-04', 1, 1, 2024),(5, '2024-01-05', 1, 1, 2024),(6, '2024-01-06', 1, 1, 2024),
(7, '2024-01-07', 2, 1, 2024),(8, '2024-01-08', 2, 1, 2024),(9, '2024-01-09', 2, 1, 2024),
(10, '2024-01-10', 2, 1, 2024),(11, '2024-01-11', 2, 1, 2024),(12, '2024-01-12', 2, 1, 2024),
(13, '2024-01-13', 2, 1, 2024),(14, '2024-01-14', 2, 1, 2024),(15, '2024-01-15', 3, 1, 2024),
(16, '2024-01-16', 3, 1, 2024),(17, '2024-01-17', 3, 1, 2024),(18, '2024-01-18', 3, 1, 2024),
(19, '2024-01-19', 3, 1, 2024),(20, '2024-01-20', 3, 1, 2024),(21, '2024-01-21', 4, 1, 2024),
(22, '2024-01-22', 4, 1, 2024),(23, '2024-01-23', 4, 1, 2024),(24, '2024-01-24', 4, 1, 2024),
(25, '2024-01-25', 4, 1, 2024),(26, '2024-01-26', 4, 1, 2024),(27, '2024-01-27', 4, 1, 2024),
(28, '2024-01-28', 4, 1, 2024),(29, '2024-01-29', 5, 1, 2024),(30, '2024-02-01', 5, 2, 2024);

Select * from Dim_Dates;

-- 5. Inserting Data into Dim_Departments
INSERT INTO Dim_Departments (DepartmentID, DepartmentName)
VALUES 
(1, 'Cardiology'),(2, 'Neurology'),(3, 'Oncology'),(4, 'Pediatrics'),
(5, 'Orthopedics'),(6, 'Gastroenterology'),(7, 'Pulmonology'),(8, 'Nephrology'),
(9, 'Endocrinology'),(10, 'Rheumatology'),(11, 'Urology'),(12, 'Hematology'),
(13, 'Allergy & Immunology'),(14, 'Infectious Disease'),(15, 'Ophthalmology'),
(16, 'Obstetrics & Gynecology'),(17, 'Anesthesiology'),(18, 'Otolaryngology'),
(19, 'Psychiatry'),(20, 'Palliative Care'),(21, 'Plastic Surgery'),
(22, 'Vascular Surgery'),(23, 'Neurosurgery'),(24, 'Emergency Medicine'),
(25, 'Geriatrics'),(26, 'General Surgery'),(27, 'Radiology'),
(28, 'Pathology'),(29, 'Dermatology'),(30, 'Orthopedics');

 Select * from Dim_Departments;


 SELECT * FROM Dim_TreatmentPlans;
 DELETE FROM Dim_TreatmentPlans WHERE TreatmentPlanID IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30);


 -- 6. Inserting Data into Dim_TreatmentPlans
 INSERT INTO Dim_TreatmentPlans (TreatmentPlanID, TreatmentDescription, DurationWeeks)
VALUES 
(1, 'Cardiac Rehabilitation', 12),(2, 'Neurological Therapy', 10),(3, 'Physical Therapy', 8),(4, 'Chemotherapy', 24),
(5, 'Radiation Therapy', 6),(6, 'Dialysis Treatment', 16),(7, 'Diabetes Management', 52),(8, 'Asthma Care', 4),
(9, 'Hypertension Management', 12),(10, 'Weight Loss Program', 26),(11, 'Sleep Apnea Therapy', 8),
(12, 'Post-Surgery Recovery', 6),(13, 'Prenatal Care', 40),(14, 'Postnatal Care', 12),(15, 'Smoking Cessation Program', 12),
(16, 'Cholesterol Management', 12),(17, 'Allergy Desensitization', 52),(18, 'Bone Marrow Transplantation', 20),
(19, 'Organ Transplantation', 18),(20, 'Palliative Care', 52),(21, 'Orthopedic Rehabilitation', 16),
(22, 'HIV/AIDS Treatment', 52),(23, 'Mental Health Counseling', 20),(24, 'Addiction Recovery', 28),
(25, 'Skin Cancer Treatment', 12),(26, 'COPD Management', 10),(27, 'Heart Failure Management', 24),
(28, 'Epilepsy Treatment', 16),(29, 'Cognitive Behavioral Therapy', 8),(30, 'Fracture Care', 8);

Select * from Dim_TreatmentPlans;

-- 7. Inserting Data into Dim_Insurance
INSERT INTO Dim_Insurance (InsuranceID, InsuranceProvider, CoverageType)
VALUES 
(1, 'HealthPlus', 'Full Coverage'),(2, 'MediCare', 'Partial Coverage'),(3, 'WellCare', 'Full Coverage'),
(4, 'CareMax', 'Partial Coverage'),(5, 'SecureHealth', 'Full Coverage'),(6, 'TrustMed', 'Full Coverage'),
(7, 'GlobalCare', 'Partial Coverage'),(8, 'LifeSecure', 'Full Coverage'),(9, 'EasyCare', 'Partial Coverage'),
(10, 'HealthFirst', 'Full Coverage'),(11, 'OptiCare', 'Partial Coverage'),(12, 'TotalHealth', 'Full Coverage'),
(13, 'BetterHealth', 'Full Coverage'),(14, 'MediPlan', 'Partial Coverage'),(15, 'AllCare', 'Full Coverage'),
(16, 'QuickHealth', 'Partial Coverage'),(17, 'PrimeCare', 'Full Coverage'),(18, 'EliteHealth', 'Full Coverage'),
(19, 'HealthGuard', 'Partial Coverage'),(20, 'ComfortCare', 'Full Coverage'),(21, 'MaxHealth', 'Partial Coverage'),
(22, 'SuperiorCare', 'Full Coverage'),(23, 'HealthNet', 'Partial Coverage'),(24, 'MediPlus', 'Full Coverage'),
(25, 'TotalCare', 'Partial Coverage'),(26, 'SafeHealth', 'Full Coverage'),(27, 'CareSecure', 'Partial Coverage'),
(28, 'HealthAdvantage', 'Full Coverage'),(29, 'MedGuard', 'Partial Coverage'),(30, 'PremiumCare', 'Full Coverage');

Select * from Dim_Insurance;

-- 8. Inserting Data into Dim_Medications
INSERT INTO Dim_Medications (MedicationID, MedicationName, Dosage, SideEffects)
VALUES 
(1, 'Aspirin', '100mg', 'Nausea'),(2, 'Ibuprofen', '200mg', 'Stomach pain'),(3, 'Paracetamol', '500mg', 'Rash'),
(4, 'Amoxicillin', '250mg', 'Diarrhea'),(5, 'Metformin', '500mg', 'Abdominal discomfort'),(6, 'Lisinopril', '10mg', 'Cough'),
(7, 'Simvastatin', '20mg', 'Muscle pain'),(8, 'Omeprazole', '20mg', 'Headache'),(9, 'Cetirizine', '10mg', 'Drowsiness'),
(10, 'Losartan', '50mg', 'Dizziness'),(11, 'Hydrochlorothiazide', '25mg', 'Increased urination'),(12, 'Prednisone', '5mg', 'Weight gain'),
(13, 'Gabapentin', '300mg', 'Fatigue'),(14, 'Metoprolol', '50mg', 'Bradycardia'),(15, 'Azithromycin', '250mg', 'Nausea'),
(16, 'Furosemide', '40mg', 'Dehydration'),(17, 'Alprazolam', '0.5mg', 'Drowsiness'),(18, 'Clopidogrel', '75mg', 'Bleeding'),
(19, 'Warfarin', '5mg', 'Bruising'),(20, 'Levothyroxine', '100mcg', 'Insomnia'),(21, 'Venlafaxine', '75mg', 'Dry mouth'),
(22, 'Propranolol', '40mg', 'Fatigue'),(23, 'Diphenhydramine', '25mg', 'Sedation'),(24, 'Ranitidine', '150mg', 'Headache'),
(25, 'Sildenafil', '50mg', 'Flushing'),(26, 'Lorazepam', '1mg', 'Drowsiness'),(27, 'Ezetimibe', '10mg', 'Muscle pain'),
(28, 'Carvedilol', '12.5mg', 'Dizziness'),(29, 'Amlodipine', '5mg', 'Swelling'),(30, 'Antibiotics', '500mg', 'Drowsiness');

Select * from Dim_Medications;

-- 9.  Inserting Data into Dim_Resources
INSERT INTO Dim_Resources (ResourceID, ResourceType, AvailabilityStatus)
VALUES 
(1, 'Bed', 'Available'),(2, 'MRI Machine', 'In Use'),(3, 'X-Ray Machine', 'Available'),
(4, 'Ultrasound Machine', 'In Use'),(5, 'CT Scanner', 'Available'),(6, 'Ventilator', 'In Use'),
(7, 'Infusion Pump', 'Available'),(8, 'ECG Machine', 'Available'),(9, 'Patient Monitor', 'In Use'),
(10, 'Surgical Instrument Set', 'Available'),(11, 'Oxygen Tank', 'In Use'),(12, 'Anesthesia Machine', 'Available'),
(13, 'Defibrillator', 'Available'),(14, 'Wheelchair', 'In Use'),(15, 'Stretcher', 'Available'),
(16, 'Dialysis Machine', 'In Use'),(17, 'Electrocardiograph', 'Available'),(18, 'Blood Pressure Monitor', 'In Use'),
(19, 'Thermometer', 'Available'),(20, 'Surgical Table', 'Available'),(21, 'IV Stand', 'In Use'),
(22, 'Nebulizer', 'Available'),(23, 'Laboratory Equipment', 'In Use'),(24, 'Recovery Bed', 'Available'),
(25, 'Patient Lift', 'In Use'),(26, 'Sterilizer', 'Available'),(27, 'Phlebotomy Chair', 'In Use'),
(28, 'Ventilation Machine', 'Available'),(29, 'Defibrillator Pads', 'In Use'),(30, 'X-Ray Machine', 'Available');

Select * from Dim_Resources;

-- 10. Inserting Data into Dim_Locations
INSERT INTO Dim_Locations (LocationID, RoomNumber, FloorNumber, Wing)
VALUES 
(1, '101', 1, 'Karachi North'),(2, '102', 1, 'Karachi East'),(3, '103', 1, 'Karachi South'),
(4, '104', 1, 'Karachi West'),(5, '105', 1, 'Karachi North'),(6, '106', 1, 'Karachi East'),
(7, '107', 1, 'Karachi South'),(8, '108', 1, 'Karachi West'),(9, '109', 1, 'Karachi North'),
(10, '110', 1, 'Karachi East'),(11, '201', 2, 'Karachi North'),(12, '202', 2, 'Karachi East'),
(13, '203', 2, 'Karachi South'),(14, '204', 2, 'Karachi West'),(15, '205', 2, 'Karachi North'),
(16, '206', 2, 'Karachi East'),(17, '207', 2, 'Karachi South'),(18, '208', 2, 'Karachi West'),
(19, '209', 2, 'Karachi North'),(20, '210', 2, 'Karachi East'),(21, '301', 3, 'Karachi North'),
(22, '302', 3, 'Karachi East'),(23, '303', 3, 'Karachi South'),(24, '304', 3, 'Karachi West'),
(25, '305', 3, 'Karachi North'),(26, '306', 3, 'Karachi East'),(27, '307', 3, 'Karachi South'),
(28, '308', 3, 'Karachi West'),(29, '309', 3, 'Karachi North'),(30, '310', 3, 'Karachi South');

Select * from Dim_Locations;

-- 11. Inserting Data into Fact_Patient_Visits
INSERT INTO Fact_Patient_Visits (VisitID, PatientID, DoctorID, AdmissionDate, DischargeDate, DiagnosisCode, TreatmentPlanID, InsuranceID, LocationID, ResourceID, DepartmentID)
VALUES 
(1001, 1, 101, '2024-01-01', '2024-01-10', 'D01', 1, 1, 1, 1, 1),
(1002, 2, 102, '2024-01-15', '2024-01-20', 'D02', 2, 2, 2, 2, 2),
(1003, 3, 103, '2024-01-22', '2024-01-30', 'D03', 3, 3, 3, 3, 3),
(1004, 4, 104, '2024-01-25', '2024-02-05', 'D04', 4, 4, 4, 4, 4),
(1005, 5, 105, '2024-02-01', '2024-02-10', 'D05', 5, 5, 5, 5, 5),
(1006, 6, 106, '2024-02-05', '2024-02-15', 'D06', 6, 6, 6, 6, 6),
(1007, 7, 107, '2024-02-10', '2024-02-20', 'D07', 7, 7, 7, 7, 7),
(1008, 8, 108, '2024-02-15', '2024-02-25', 'D08', 8, 8, 8, 8, 8),
(1009, 9, 109, '2024-02-20', '2024-03-01', 'D09', 9, 9, 9, 9, 9),
(1010, 10, 110, '2024-02-25', '2024-03-05', 'D10', 10, 10, 10, 10, 10),
(1011, 11, 111, '2024-03-01', '2024-03-10', 'D11', 11, 11, 11, 11, 11),
(1012, 12, 112, '2024-03-05', '2024-03-15', 'D12', 12, 12, 12, 12, 12),
(1013, 13, 113, '2024-03-10', '2024-03-20', 'D13', 13, 13, 13, 13, 13),
(1014, 14, 114, '2024-03-15', '2024-03-25', 'D14', 14, 14, 14, 14, 14),
(1015, 15, 115, '2024-03-20', '2024-03-30', 'D15', 15, 15, 15, 15, 15),
(1016, 16, 116, '2024-03-25', '2024-04-05', 'D16', 16, 16, 16, 16, 16),
(1017, 17, 117, '2024-03-30', '2024-04-10', 'D17', 17, 17, 17, 17, 17),
(1018, 18, 118, '2024-04-01', '2024-04-15', 'D18', 18, 18, 18, 18, 18),
(1019, 19, 119, '2024-04-05', '2024-04-20', 'D19', 19, 19, 19, 19, 19),
(1020, 20, 120, '2024-04-10', '2024-04-25', 'D20', 20, 20, 20, 20, 20),
(1021, 21, 121, '2024-04-15', '2024-05-01', 'D21', 21, 21, 21, 21, 21),
(1022, 22, 122, '2024-04-20', '2024-05-05', 'D22', 22, 22, 22, 22, 22),
(1023, 23, 123, '2024-04-25', '2024-05-10', 'D23', 23, 23, 23, 23, 23),
(1024, 24, 124, '2024-05-01', '2024-05-15', 'D24', 24, 24, 24, 24, 24),
(1025, 25, 125, '2024-05-05', '2024-05-20', 'D25', 25, 25, 25, 25, 25),
(1026, 26, 126, '2024-05-10', '2024-05-25', 'D26', 26, 26, 26, 26, 26),
(1027, 27, 127, '2024-05-15', '2024-05-30', 'D27', 27, 27, 27, 27, 27),
(1028, 28, 128, '2024-05-20', '2024-06-05', 'D28', 28, 28, 28, 28, 28),
(1029, 29, 129, '2024-05-25', '2024-06-10', 'D29', 29, 29, 29, 29, 29),
(1030, 30, 130, '2024-06-01', '2024-06-15', 'D30', 30, 30, 30, 30, 30);

Select * from Fact_Patient_Visits;

--- 12. Inserting Data into Fact_Treatment_Medications
INSERT INTO Fact_Treatment_Medications (TreatmentID, VisitID, MedicationID, DoseAdministered, AdministeredDate)
VALUES 
(2001, 1001, 1, '100mg', '2024-01-02'),(2002, 1002, 2, '200mg', '2024-01-16'),(2003, 1003, 3, '150mg', '2024-01-23'),
(2004, 1004, 4, '250mg', '2024-01-28'),(2005, 1005, 5, '300mg', '2024-02-01'),(2006, 1006, 6, '50mg', '2024-02-05'),
(2007, 1007, 7, '400mg', '2024-02-10'),(2008, 1008, 8, '200mg', '2024-02-15'),(2009, 1009, 9, '100mg', '2024-02-20'),
(2010, 1010, 10, '250mg', '2024-02-25'),(2011, 1011, 11, '500mg', '2024-03-01'),(2012, 1012, 12, '150mg', '2024-03-05'),
(2013, 1013, 13, '200mg', '2024-03-10'),(2014, 1014, 14, '300mg', '2024-03-15'),(2015, 1015, 15, '100mg', '2024-03-20'),
(2016, 1016, 16, '400mg', '2024-03-25'),(2017, 1017, 17, '250mg', '2024-04-01'),(2018, 1018, 18, '500mg', '2024-04-05'),
(2019, 1019, 19, '150mg', '2024-04-10'),(2020, 1020, 20, '200mg', '2024-04-15'),(2021, 1021, 21, '300mg', '2024-04-20'),
(2022, 1022, 22, '100mg', '2024-04-25'),(2023, 1023, 23, '400mg', '2024-04-30'),(2024, 1024, 24, '250mg', '2024-05-05'),
(2025, 1025, 25, '500mg', '2024-05-10'),(2026, 1026, 26, '150mg', '2024-05-15'),(2027, 1027, 27, '200mg', '2024-05-20'),
(2028, 1028, 28, '300mg', '2024-05-25'),(2029, 1029, 29, '100mg', '2024-06-01'),(2030, 1030, 30, '500mg', '2024-06-05');

Select * from Fact_Treatment_Medications;


--- 13. Inserting Data into Fact_Doctor_Schedules
INSERT INTO Fact_Doctor_Schedules (ScheduleID, DoctorID, LocationID, DateID, ShiftStartTime, ShiftEndTime)
VALUES 
(3001, 101, 1, 1, '08:00', '16:00'),(3002, 102, 2, 2, '09:00', '17:00'),(3003, 103, 3, 3, '07:00', '15:00'),
(3004, 104, 4, 4, '10:00', '18:00'),(3005, 105, 5, 5, '08:30', '16:30'),(3006, 106, 6, 6, '09:00', '17:00'),
(3007, 107, 7, 7, '08:00', '16:00'),(3008, 108, 8, 8, '10:00', '18:00'),(3009, 109, 9, 9, '07:00', '15:00'),
(3010, 110, 10, 10, '08:00', '16:00'),(3011, 111, 11, 11, '09:00', '17:00'),(3012, 112, 12, 12, '07:30', '15:30'),
(3013, 113, 13, 13, '08:00', '16:00'),(3014, 114, 14, 14, '09:00', '17:00'),(3015, 115, 15, 15, '08:30', '16:30'),
(3016, 116, 16, 16, '07:00', '15:00'),(3017, 117, 17, 17, '10:00', '18:00'),(3018, 118, 18, 18, '09:00', '17:00'),
(3019, 119, 19, 19, '08:00', '16:00'),(3020, 120, 20, 20, '10:00', '18:00'),(3021, 121, 21, 21, '07:30', '15:30'),
(3022, 122, 22, 22, '08:00', '16:00'),(3023, 123, 23, 23, '09:00', '17:00'),(3024, 124, 24, 24, '07:00', '15:00'),
(3025, 125, 25, 25, '08:30', '16:30'),(3026, 126, 26, 26, '10:00', '18:00'),(3027, 127, 27, 27, '09:00', '17:00'),
(3028, 128, 28, 28, '07:00', '15:00'),(3029, 129, 29, 29, '08:30', '16:30'),(3030, 130, 30, 30, '10:00', '18:00');

Select * from Fact_Doctor_Schedules;

--- 14. Inserting Data into Fact_Resource_Utilization
INSERT INTO Fact_Resource_Utilization (UtilizationID, ResourceID, VisitID, StartDate, EndDate)
VALUES 
(4001, 1, 1001, '2024-01-01', '2024-01-05'),(4002, 2, 1002, '2024-01-15', '2024-01-18'),
(4003, 3, 1003, '2024-01-10', '2024-01-12'),(4004, 4, 1004, '2024-01-20', '2024-01-22'),
(4005, 5, 1005, '2024-01-25', '2024-01-28'),(4006, 6, 1006, '2024-01-30', '2024-02-02'),
(4007, 7, 1007, '2024-02-01', '2024-02-05'),(4008, 8, 1008, '2024-02-10', '2024-02-12'),
(4009, 9, 1009, '2024-02-15', '2024-02-18'),(4010, 10, 1010, '2024-02-20', '2024-02-22'),
(4011, 11, 1011, '2024-02-25', '2024-02-28'),(4012, 12, 1012, '2024-03-01', '2024-03-05'),
(4013, 13, 1013, '2024-03-10', '2024-03-12'),(4014, 14, 1014, '2024-03-15', '2024-03-18'),
(4015, 15, 1015, '2024-03-20', '2024-03-22'),(4016, 16, 1016, '2024-03-25', '2024-03-28'),
(4017, 17, 1017, '2024-04-01', '2024-04-05'),(4018, 18, 1018, '2024-04-10', '2024-04-12'),
(4019, 19, 1019, '2024-04-15', '2024-04-18'),(4020, 20, 1020, '2024-04-20', '2024-04-22'),
(4021, 21, 1021, '2024-04-25', '2024-04-28'),(4022, 22, 1022, '2024-05-01', '2024-05-05'),
(4023, 23, 1023, '2024-05-10', '2024-05-12'),(4024, 24, 1024, '2024-05-15', '2024-05-18'),
(4025, 25, 1025, '2024-05-20', '2024-05-22'),(4026, 26, 1026, '2024-05-25', '2024-05-28'),
(4027, 27, 1027, '2024-06-01', '2024-06-05'),(4028, 28, 1028, '2024-06-10', '2024-06-12'),
(4029, 29, 1029, '2024-06-15', '2024-06-18'),(4030, 30, 1030, '2024-06-20', '2024-06-22');

Select * from Fact_Resource_Utilization;

-- 15. Inserting Data into Fact_Patient_Billing
INSERT INTO Fact_Patient_Billing (BillingID, VisitID, TotalCost, PaymentMethod, InsuranceCoverage, PatientPayment)
VALUES 
(5001, 1001, 5000.00, 'Credit Card', 3000.00, 2000.00),(5002, 1002, 4000.00, 'Insurance', 3500.00, 500.00),
(5003, 1003, 3500.00, 'Debit Card', 2000.00, 1500.00),(5004, 1004, 6000.00, 'Cash', 4000.00, 2000.00),
(5005, 1005, 4500.00, 'Insurance', 3000.00, 1500.00),(5006, 1006, 7000.00, 'Credit Card', 5000.00, 2000.00),
(5007, 1007, 5500.00, 'Debit Card', 3500.00, 2000.00),(5008, 1008, 8000.00, 'Insurance', 6000.00, 2000.00),
(5009, 1009, 6200.00, 'Cash', 4000.00, 2200.00),(5010, 1010, 4800.00, 'Credit Card', 2500.00, 2300.00),
(5011, 1011, 5200.00, 'Debit Card', 3500.00, 1700.00),(5012, 1012, 4300.00, 'Insurance', 3000.00, 1300.00),
(5013, 1013, 6000.00, 'Cash', 4000.00, 2000.00),(5014, 1014, 7500.00, 'Credit Card', 5000.00, 2500.00),
(5015, 1015, 5400.00, 'Insurance', 4000.00, 1400.00),(5016, 1016, 6900.00, 'Debit Card', 5000.00, 1900.00),
(5017, 1017, 5800.00, 'Cash', 3500.00, 2300.00),(5018, 1018, 7100.00, 'Credit Card', 6000.00, 1100.00),
(5019, 1019, 4600.00, 'Insurance', 3500.00, 1100.00),(5020, 1020, 6200.00, 'Debit Card', 4000.00, 2200.00),
(5021, 1021, 5200.00, 'Cash', 3000.00, 2200.00),(5022, 1022, 7800.00, 'Credit Card', 6000.00, 1800.00),
(5023, 1023, 5600.00, 'Insurance', 4500.00, 1100.00),(5024, 1024, 6300.00, 'Debit Card', 4000.00, 2300.00),
(5025, 1025, 7100.00, 'Cash', 5000.00, 2100.00),(5026, 1026, 4900.00, 'Credit Card', 3000.00, 1900.00),
(5027, 1027, 5500.00, 'Insurance', 4000.00, 1500.00),(5028, 1028, 6800.00, 'Debit Card', 5000.00, 1800.00),
(5029, 1029, 6300.00, 'Cash', 4000.00, 2300.00),(5030, 1030, 8000.00, 'Debit Card', 6000.00, 2000.00);

Select * from Fact_Patient_Billing;

------------- Queries for Data Analysis ----------------
--- Query to Fetch All Patient Visits with Details
SELECT 
    p.Name AS PatientName, 
    d.Name AS DoctorName, 
    dc.DiagnosisDescription, 
    tp.TreatmentDescription, 
    i.InsuranceProvider, 
    pv.AdmissionDate, 
    pv.DischargeDate
FROM 
    Fact_Patient_Visits pv
JOIN 
    Dim_Patients p ON pv.PatientID = p.PatientID
JOIN 
    Dim_Doctors d ON pv.DoctorID = d.DoctorID
JOIN 
    Dim_DiagnosisCodes dc ON pv.DiagnosisCode = dc.DiagnosisCode
JOIN 
    Dim_TreatmentPlans tp ON pv.TreatmentPlanID = tp.TreatmentPlanID
JOIN 
    Dim_Insurance i ON pv.InsuranceID = i.InsuranceID;


--------  Query to Track Resource Usage

SELECT 
    r.ResourceType, 
    COUNT(ru.UtilizationID) AS UsageCount 
FROM 
    Fact_Resource_Utilization ru
JOIN 
    Dim_Resources r ON ru.ResourceID = r.ResourceID
GROUP BY 
    r.ResourceType;

