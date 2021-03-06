-- Load a user for each role for testing.
-- Note: password hash is for each user is the same as the username.
INSERT INTO `user`
  (username, firstname, lastname, password, note, updatedBy, updatedAt)
VALUES
  ('admin', 'admin', 'admin', '$2a$10$r93uzyhs73Bh88Hco63wTuOyq8rLg2jy2mWnP8g03pu8fkc9mQDb6',
  'This is the default admin account with password of "admin". In production systems, this account should be disabled once another administrator is created.',
  1, NOW()),
  ('guard', 'guard', 'guard', '$2a$10$vNSjSzQjcGyY0XZoJaawFev32JdUjZ6GW0Not6YBzQFLG2w7Mcmqm',
  'This is the default guard account with password of "guard".',
  1, NOW()),
  ('clerk', 'clerk', 'clerk', '$2a$10$0NNM2m/uylWV03qvvSVpXu2YwKBV0JWTTKjgLg2W2lUukgNRsM4ni',
  'This is the default clerk account with password of "clerk".',
  1, NOW()),
  ('attending', 'attending', 'attending', '$2a$10$B1gNzN65TBK2qIFweq1Q2.5B2oSV2tx/7WrerWapxYUswwzD2WpuK',
  'This is the default attending account with password of "attending".',
  1, NOW()),
  ('supervisor', 'supervisor', 'supervisor', '$2a$10$Q5oHzUPxwPJHzM/0qTWwbuP3Ir7NLZgrdbXKxPwP4eo8A.8yb45s2',
  'This is the default supervisor account with password of "supervisor".',
  1, NOW())
;

-- Load the roles.
INSERT INTO `role`
  (name, description, updatedBy, updatedAt)
VALUES
  ('administrator', 'Manages users, vaccination and lab types, and the system.', 1, NOW()),
  ('guard', 'Patient check-in and check-out.', 1, NOW()),
  ('clerk', 'No patient care with exception of BP and Wgt. Manages priority list.', 1, NOW()),
  ('attending', 'Patient care but always requires a supervisor.', 1, NOW()),
  ('supervisor', 'Patient care.', 1, NOW())
;

-- Assign the admin user to the administrator role.
-- TODO: this is very brittle and error prone so fix it.
INSERT INTO `user_role`
  (user_id, role_id, updatedBy, updatedAt)
VALUES
  (1, 1, 1, NOW()),
  (2, 2, 1, NOW()),
  (3, 3, 1, NOW()),
  (4, 4, 1, NOW()),
  (5, 5, 1, NOW())
;

-- Create some basic events
INSERT INTO `eventType`
  (name, description)
VALUES
  ('login', 'A user logged in'),
  ('logout', 'A user logged out'),
  ('supervisor', 'A user set a supervisor'),
  ('history', 'A user viewed changes from log tables'),
  ('prenatalCheckIn', 'Client checkin for a prenatal exam.'),
  ('prenatalCheckOut', 'Client checkout of a prenatal exam.'),
  ('prenatalChartPulled', 'Chart pulled for a prental exam.')
;

-- Load risk codes.
SELECT 'riskCode' AS 'Loading' FROM DUAL;
INSERT INTO `riskCode`
  (name, riskType, description)
VALUES
  ('A1', 'Present', 'Age > 35'),
  ('A2', 'Present', 'Age < 18'),
  ('B1', 'Present', 'Height < 4\' 9"'),
  ('B2', 'Present', 'Underweight'),
  ('B3', 'Present', 'Overweight'),
  ('C', 'Present', '4 or more children'),
  ('F', 'Present', 'Less than 3 years since last birth'),
  ('D1', 'ObHx', 'Hx C/s'),
  ('D2', 'ObHx', 'Hx stillbirth or neonatal death within 7 days'),
  ('D3', 'ObHx', 'Hx anenatal bleeding'),
  ('D4', 'ObHx', 'Hx hemorrhage'),
  ('D5', 'ObHx', 'Hx convulsions'),
  ('D6', 'ObHx', 'Hx forceps or vacuum'),
  ('D7', 'ObHx', 'Hx malpresentation'),
  ('E1', 'MedHx', 'Hx TB'),
  ('E2', 'MedHx', 'Hx heart disease'),
  ('E3', 'MedHx', 'Hx diabetes'),
  ('E4', 'MedHx', 'Hx dx asthma'),
  ('E5', 'MedHx', 'Hx Goiter'),
  ('E6', 'MedHx', 'Hx hypertension'),
  ('E7', 'MedHx', 'Hx malaria'),
  ('E8', 'MedHx', 'Hx parasites'),
  ('G1', 'Lifestyle', 'Smoking'),
  ('G2', 'Lifestyle', 'Drink alcohol'),
  ('G3', 'Lifestyle', 'Multiple partners'),
  ('G4', 'Lifestyle', 'Living with person with HIV/AIDS'),
  ('G5', 'Lifestyle', 'Exposure to communicable diseases'),
  ('G6', 'Lifestyle', 'Victim of violence')
;

-- Create the data for at least one select option.
INSERT INTO `selectData`
  (name, selectKey, label, selected, updatedBy, updatedAt)
VALUES
  ('maritalStatus', '', 'Unknown', 1, 1, NOW()),
  ('maritalStatus', 'Single', 'Single', 0, 1, NOW()),
  ('maritalStatus', 'Live-In', 'Live-In', 0, 1, NOW()),
  ('maritalStatus', 'Married', 'Married', 0, 1, NOW()),
  ('maritalStatus', 'Other', 'Other', 0, 1, NOW()),
  ('religion', '', 'Unknown', 1, 1, NOW()),
  ('religion', 'Christian', 'Christian', 0, 1, NOW()),
  ('religion', 'Roman Catholic', 'Roman Catholic', 0, 1, NOW()),
  ('religion', 'Muslim/Islam', 'Muslim/Islam', 0, 1, NOW()),
  ('religion', 'SDA', 'SDA', 0, 1, NOW()),
  ('religion', 'INC', 'INC', 0, 1, NOW()),
  ('religion', 'LDS', 'LDS', 0, 1, NOW()),
  ('religion', 'Other', 'Other', 0, 1, NOW()),
  ('education', '', 'Unknown', 1, 1, NOW()),
  ('education', 'Elem level', 'Elem level', 0, 1, NOW()),
  ('education', 'Elem grad', 'Elem grad', 0, 1, NOW()),
  ('education', 'HS level', 'HS level', 0, 1, NOW()),
  ('education', 'HS grad', 'HS grad', 0, 1, NOW()),
  ('education', 'College level', 'College level', 0, 1, NOW()),
  ('education', 'College grad', 'College grad', 0, 1, NOW()),
  ('edema', 'none', 'None', 1, 1, NOW()),
  ('edema', '+1', '+1', 0, 1, NOW()),
  ('edema', '+2', '+2', 0, 1, NOW()),
  ('edema', '+3', '+3', 0, 1, NOW()),
  ('edema', '+4', '+4', 0, 1, NOW()),
  ('incomePeriod', 'Day', 'Day', 0, 1, NOW()),
  ('incomePeriod', 'Week', 'Week', 0, 1, NOW()),
  ('incomePeriod', 'Two Weeks', 'Two Weeks', 0, 1, NOW()),
  ('incomePeriod', 'Twice Monthly', 'Twice Monthly', 0, 1, NOW()),
  ('incomePeriod', 'Month', 'Month', 1, 1, NOW()),
  ('incomePeriod', 'Quarter', 'Quarter', 0, 1, NOW()),
  ('incomePeriod', 'Year', 'Year', 0, 1, NOW()),
  ('yesNoUnanswered', '', '', 1, 1, NOW()),
  ('yesNoUnanswered', 'Y', 'Yes', 0, 1, NOW()),
  ('yesNoUnanswered', 'N', 'No', 0, 1, NOW()),
  ('yesNoUnknown', '', '', 1, 1, NOW()),
  ('yesNoUnknown', 'Y', 'Yes', 0, 1, NOW()),
  ('yesNoUnknown', 'N', 'No', 0, 1, NOW()),
  ('yesNoUnknown', '?', 'Unknown', 0, 1, NOW()),
  ('episTear', '', '', 1, 1, NOW()),
  ('episTear', 'T', 'Tear', 0, 1, NOW()),
  ('episTear', 'E', 'Epis', 0, 1, NOW()),
  ('episTear', 'N', 'No', 0, 1, NOW()),
  ('episTear', '?', 'Unknown', 0, 1, NOW()),
  ('attendant', 'Midwife', 'Midwife', 1, 1, NOW()),
  ('attendant', 'Doctor', 'Doctor', 0, 1, NOW()),
  ('attendant', 'Hilot', 'Hilot', 0, 1, NOW()),
  ('attendant', 'Other', 'Other', 0, 1, NOW()),
  ('wksMthsYrs', '', '', 1, 1, NOW()),
  ('wksMthsYrs', 'Weeks', 'Weeks', 0, 1, NOW()),
  ('wksMthsYrs', 'Months', 'Months', 0, 1, NOW()),
  ('wksMthsYrs', 'Years', 'Years', 0, 1, NOW()),
  ('wksMths', '', '', 1, 1, NOW()),
  ('wksMths', 'Weeks', 'Weeks', 0, 1, NOW()),
  ('wksMths', 'Months', 'Months', 0, 1, NOW()),
  ('maleFemale', '', '', 1, 1, NOW()),
  ('maleFemale', 'F', 'Female', 0, 1, NOW()),
  ('maleFemale', 'M', 'Male', 0, 1, NOW()),
  ('internalExternal', '', '', 1, 1, NOW()),
  ('internalExternal', 'Internal', 'Internal', 0, 1, NOW()),
  ('internalExternal', 'External', 'External', 0, 1, NOW()),
  ('location', 'Mercy', 'Mercy', 1, 1, NOW()),
  ('location', 'Agdao', 'Agdao', 0, 1, NOW()),
  ('location', 'Isla Verda', 'Isla Verda', 0, 1, NOW()),
  ('location', 'Samal', 'Samal', 0, 1, NOW()),
  ('scheduleType', '', '', 1, 1, NOW()),
  ('scheduleType', 'Prenatal', 'Prenatal', 0, 1, NOW()),
  ('dayOfWeek', '', '', 1, 1, NOW()),
  ('dayOfWeek', 'Monday', 'Monday', 0, 1, NOW()),
  ('dayOfWeek', 'Tuesday', 'Tuesday', 0, 1, NOW()),
  ('dayOfWeek', 'Wednesday', 'Wednesday', 0, 1, NOW()),
  ('dayOfWeek', 'Thursday', 'Thursday', 0, 1, NOW()),
  ('dayOfWeek', 'Friday', 'Friday', 0, 1, NOW()),
  ('dayOfWeek', 'Saturday', 'Saturday', 0, 1, NOW()),
  ('dayOfWeek', 'Sunday', 'Sunday', 0, 1, NOW()),
  ('placeOfBirth', '', '', 1, 1, NOW()),
  ('placeOfBirth', 'MMC', 'MMC', 0, 1, NOW()),
  ('placeOfBirth', 'Home', 'Home', 0, 1, NOW()),
  ('placeOfBirth', 'SPMC', 'SPMC', 0, 1, NOW()),
  ('placeOfBirth', 'Hospital', 'Hospital', 0, 1, NOW()),
  ('placeOfBirth', 'Lying-in Clinic', 'Lying-in Clinic', 0, 1, NOW()),
  ('placeOfBirth', 'Other', 'Other', 0, 1, NOW()),
  ('referrals', 'Dr/Dentist', 'Dr/Dentist', 0, 1, NOW()),
  ('referrals', 'U/A', 'U/A', 0, 1, NOW()),
  ('referrals', 'Hgb', 'Hgb', 0, 1, NOW()),
  ('referrals', 'U/A & Hgb', 'U/A & Hgb', 0, 1, NOW()),
  ('referrals', 'All labs', 'All labs', 0, 1, NOW()),
  ('teachingTopics', 'Nutr + FD', 'Nutr + FD', 1, 1, NOW()),
  ('teachingTopics', 'BF', 'BF', 0, 1, NOW()),
  ('teachingTopics', 'FP', 'FP', 0, 1, NOW()),
  ('teachingTopics', 'L & D', 'L & D', 0, 1, NOW()),
  ('teachingTopics', 'PP/NB', 'PP/NB', 0, 1, NOW()),
  ('teachingTopics', 'Cln Catch', 'Cln Catch', 0, 1, NOW()),
  ('teachingTopics', 'Labr/ROM', 'Labr/ROM', 0, 1, NOW()),
  ('teachingTopics', 'Iron/Vit', 'Iron/Vit', 0, 1, NOW())
;

SELECT 'vaccinationType' AS 'Loading' FROM DUAL;
INSERT INTO `vaccinationType`
  (name, description, updatedBy, updatedAt)
VALUES
  ('Tetanus Toxoid', 'Tetanus Toxoid', 1, NOW())
;

SELECT 'medicationType' AS 'Loading' FROM DUAL;
INSERT INTO `medicationType`
  (name, description, updatedBy, updatedAt)
VALUES
  ('Mebendazole 500mg PO', 'Mebendazole 500mg PO', 1, NOW()),
  ('Albendazole 400mg PO', 'Albendazole 400mg PO', 1, NOW()),
  ('Ferrous Sulfate', 'Ferrous Sulfate', 1, NOW()),
  ('Ferrous Fumarate', 'Ferrous Fumarate', 1, NOW()),
  ('Multivitamin', 'Multivitamin', 1, NOW()),
  ('Prenatal Vitamin', 'Prenatal Vitamin', 1, NOW())
;

-- Load default tests per client specifications.
SELECT 'labSuite' AS 'Loading' FROM DUAL;
INSERT INTO `labSuite`
  (name, description, category, viewTemplate, updatedBy, updatedAt)
VALUES
  ('Blood', '', 'Blood', 'defaultLab', 1, NOW()),
  ('Urinalysis', '', 'Urinalysis', 'defaultLab', 1, NOW()),
  ('Wet mount', '', 'Wet mount', 'defaultLab', 1, NOW()),
  ('Gram stain', '', 'Gram stain', 'defaultLab', 1, NOW()),
  ('UltraSound', '', 'UltraSound', 'defaultLab', 1, NOW())
;

SELECT 'labTest' AS 'Loading' FROM DUAL;
INSERT INTO `labTest`
  (name, abbrev, normal, unit, minRangeDecimal, maxRangeDecimal, minRangeInteger,
   maxRangeInteger, isRange, isText, labSuite_id, updatedBy, updatedAt)
VALUES
  -- Blood
  ('Hematocrit', 'Hct', '30-40', '%', NULL, NULL, 0, 60, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Blood'), 1, NOW()),
  ('Hemoglobin', 'Hgb', '100-140', 'g/L', NULL, NULL, 0, 170, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Blood'), 1, NOW()),
  ('Hepatitis B Surface Antigen', 'HBsAg', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Blood'), 1, NOW()),
  ('Blood Type', 'Blood type', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Blood'), 1, NOW()),
  ('RPR', 'RPR', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Blood'), 1, NOW()),
  ('VDRL', 'VDRL', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Blood'), 1, NOW()),
  -- Urinalysis
  ('Albumin/Protein', 'Albumin/Protein', NULL, 'mg/dL', NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Urinalysis'), 1, NOW()),
  ('Sugar/Glucose', 'Sugar/Glucose', NULL, 'mg/dL', NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Urinalysis'), 1, NOW()),
  ('Epithelial Cells-Urine', 'Epithelial Cells-Urine', '0-5', 'hpf', NULL, NULL, 0, 1000, 1, 0,
    (SELECT id FROM labSuite WHERE name = 'Urinalysis'), 1, NOW()),
  ('White Blood Cells', 'wbc', '0-4', 'hpf', NULL, NULL, 0, 1000, 1, 0,
    (SELECT id FROM labSuite WHERE name = 'Urinalysis'), 1, NOW()),
  ('Red Blood Cells', 'rbc-urine', NULL, 'hpf', NULL, NULL, 0, 1000, 1, 0,
    (SELECT id FROM labSuite WHERE name = 'Urinalysis'), 1, NOW()),
  ('Bacteria', 'Bacteria', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Urinalysis'), 1, NOW()),
  ('Mucous', 'Mucous', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Urinalysis'), 1, NOW()),
  ('Trichomonas-Urine', 'Trichomonas-Urine', '0', 'hpf', NULL, NULL, 0, 1000, 1, 0,
    (SELECT id FROM labSuite WHERE name = 'Urinalysis'), 1, NOW()),
  ('Trichomonas-WetMount', 'Trichomonas-WetMount', '0', 'hpf', NULL, NULL, 0, 1000, 1, 0,
    (SELECT id FROM labSuite WHERE name = 'Wet mount'), 1, NOW()),
  ('Yeast-Urine', 'Yeast-Urine', NULL, 'hpf', NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Wet mount'), 1, NOW()),
  ('Clue Cells', 'Clue Cells', NULL, 'hpf', NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Wet mount'), 1, NOW()),
  -- Gram stain
  ('Red Blood Cells-Gram', 'rbc-Gram', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Leukocytes', 'Leukocytes', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Epithelial Cells-Gram', 'Epithelial Cells-Gram', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Gram negative (-) cocci', 'Gram negative (-) cocci', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Gram positive (+) cocci', 'Gram positive (+) cocci', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Gram negative (-) coccobacilli', 'Gram negative (-) coccobacilli', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Gram positive (+) cocci in pairs', 'Gram positive (+) cocci in pairs', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Gram negative (-) bacilli', 'Gram negative (-) bacilli', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Gram positive (+) bacilli', 'Gram positive (+) bacilli', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Gram negative (-) extracellular diplococci', 'Gram negative (-) extracellular diplococci', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Gram negative (-) intracellular diplococci', 'Gram negative (-) intracellular diplococci', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Yeast-Gram', 'Yeast-Gram', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Fungi', 'Fungi', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Trichomonads', 'Trichomonads', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  ('Sperm Cells', 'Sperm Cells', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0,
    (SELECT id FROM labSuite WHERE name = 'Gram stain'), 1, NOW()),
  -- UltraSound
  ('UltraSound', 'UltraSound', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1,
    (SELECT id FROM labSuite WHERE name = 'UltraSound'), 1, NOW())
;

SELECT 'labTestValue' AS 'Loading' FROM DUAL;
INSERT INTO `labTestValue`
  (value, labTest_id, updatedBy, updatedAt)
VALUES
  -- HBsAg
  ('Reactive', (SELECT id FROM labTest WHERE abbrev = 'HBsAg'), 1, NOW()),
  ('Non-Reactive', (SELECT id FROM labTest WHERE abbrev = 'HBsAg'), 1, NOW()),
  ('A', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('A-', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('A+', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('B', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('B-', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('B+', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('O', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('O-', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('O+', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('AB', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('AB-', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('AB+', (SELECT id FROM labTest WHERE abbrev = 'Blood type'), 1, NOW()),
  ('+', (SELECT id FROM labTest WHERE abbrev = 'RPR'), 1, NOW()),
  ('-', (SELECT id FROM labTest WHERE abbrev = 'RPR'), 1, NOW()),
  ('+', (SELECT id FROM labTest WHERE abbrev = 'VDRL'), 1, NOW()),
  ('-', (SELECT id FROM labTest WHERE abbrev = 'VDRL'), 1, NOW()),
  ('0', (SELECT id FROM labTest WHERE abbrev = 'Albumin/Protein'), 1, NOW()),
  ('Trace', (SELECT id FROM labTest WHERE abbrev = 'Albumin/Protein'), 1, NOW()),
  ('+1', (SELECT id FROM labTest WHERE abbrev = 'Albumin/Protein'), 1, NOW()),
  ('+2', (SELECT id FROM labTest WHERE abbrev = 'Albumin/Protein'), 1, NOW()),
  ('+3', (SELECT id FROM labTest WHERE abbrev = 'Albumin/Protein'), 1, NOW()),
  ('+4', (SELECT id FROM labTest WHERE abbrev = 'Albumin/Protein'), 1, NOW()),
  ('0', (SELECT id FROM labTest WHERE abbrev = 'Sugar/Glucose'), 1, NOW()),
  ('Trace', (SELECT id FROM labTest WHERE abbrev = 'Sugar/Glucose'), 1, NOW()),
  ('+1', (SELECT id FROM labTest WHERE abbrev = 'Sugar/Glucose'), 1, NOW()),
  ('+2', (SELECT id FROM labTest WHERE abbrev = 'Sugar/Glucose'), 1, NOW()),
  ('+3', (SELECT id FROM labTest WHERE abbrev = 'Sugar/Glucose'), 1, NOW()),
  ('+4', (SELECT id FROM labTest WHERE abbrev = 'Sugar/Glucose'), 1, NOW()),
  ('TNTC', (SELECT id FROM labTest WHERE abbrev = 'Epithelial Cells-Urine'), 1, NOW()),
  ('TNTC', (SELECT id FROM labTest WHERE abbrev = 'wbc'), 1, NOW()),
  ('TNTC', (SELECT id FROM labTest WHERE abbrev = 'rbc-urine'), 1, NOW()),
  ('0', (SELECT id FROM labTest WHERE abbrev = 'Bacteria'), 1, NOW()),
  ('+1', (SELECT id FROM labTest WHERE abbrev = 'Bacteria'), 1, NOW()),
  ('+2', (SELECT id FROM labTest WHERE abbrev = 'Bacteria'), 1, NOW()),
  ('+3', (SELECT id FROM labTest WHERE abbrev = 'Bacteria'), 1, NOW()),
  ('+4', (SELECT id FROM labTest WHERE abbrev = 'Bacteria'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Bacteria'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Bacteria'), 1, NOW()),
  ('Abundant', (SELECT id FROM labTest WHERE abbrev = 'Bacteria'), 1, NOW()),
  ('0', (SELECT id FROM labTest WHERE abbrev = 'Mucous'), 1, NOW()),
  ('+1', (SELECT id FROM labTest WHERE abbrev = 'Mucous'), 1, NOW()),
  ('+2', (SELECT id FROM labTest WHERE abbrev = 'Mucous'), 1, NOW()),
  ('+3', (SELECT id FROM labTest WHERE abbrev = 'Mucous'), 1, NOW()),
  ('+4', (SELECT id FROM labTest WHERE abbrev = 'Mucous'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Mucous'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Mucous'), 1, NOW()),
  ('Abundant', (SELECT id FROM labTest WHERE abbrev = 'Mucous'), 1, NOW()),
  ('TNTC', (SELECT id FROM labTest WHERE abbrev = 'Trichomonas-Urine'), 1, NOW()),
  ('v. trichomonas seen or noted', (SELECT id FROM labTest WHERE abbrev = 'Trichomonas-Urine'), 1, NOW()),
  ('TNTC', (SELECT id FROM labTest WHERE abbrev = 'Trichomonas-WetMount'), 1, NOW()),
  ('v. trichomonas seen or noted', (SELECT id FROM labTest WHERE abbrev = 'Trichomonas-WetMount'), 1, NOW()),
  ('0', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Urine'), 1, NOW()),
  ('+1', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Urine'), 1, NOW()),
  ('+2', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Urine'), 1, NOW()),
  ('+3', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Urine'), 1, NOW()),
  ('+4', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Urine'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Urine'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Urine'), 1, NOW()),
  ('Abundant', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Urine'), 1, NOW()),
  ('0', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('+1', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('+2', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('+3', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('+4', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('Abundant', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('Present', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('Absent', (SELECT id FROM labTest WHERE abbrev = 'Clue Cells'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'rbc-Gram'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'rbc-Gram'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'rbc-Gram'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'rbc-Gram'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Leukocytes'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Leukocytes'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Leukocytes'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Leukocytes'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Epithelial Cells-Gram'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Epithelial Cells-Gram'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Epithelial Cells-Gram'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Epithelial Cells-Gram'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) cocci'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) cocci'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) cocci'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) cocci'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) cocci'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) cocci'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) cocci'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) cocci'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) coccobacilli'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) coccobacilli'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) coccobacilli'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) coccobacilli'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) cocci in pairs'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) cocci in pairs'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) cocci in pairs'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) cocci in pairs'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) bacilli'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) bacilli'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) bacilli'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) bacilli'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) bacilli'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) bacilli'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) bacilli'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Gram positive (+) bacilli'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) extracellular diplococci'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) extracellular diplococci'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) extracellular diplococci'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) extracellular diplococci'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) intracellular diplococci'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) intracellular diplococci'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) intracellular diplococci'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Gram negative (-) intracellular diplococci'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Gram'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Gram'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Gram'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Yeast-Gram'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Fungi'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Fungi'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Fungi'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Fungi'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Trichomonads'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Trichomonads'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Trichomonads'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Trichomonads'), 1, NOW()),
  ('Rare', (SELECT id FROM labTest WHERE abbrev = 'Sperm Cells'), 1, NOW()),
  ('Few', (SELECT id FROM labTest WHERE abbrev = 'Sperm Cells'), 1, NOW()),
  ('Mod', (SELECT id FROM labTest WHERE abbrev = 'Sperm Cells'), 1, NOW()),
  ('Many', (SELECT id FROM labTest WHERE abbrev = 'Sperm Cells'), 1, NOW())
;


SELECT 'customFieldType' AS 'Loading' FROM DUAL;
INSERT INTO `customFieldType`
  (name, title, description, label, valueFieldName)
VALUES
  ('Agdao', 'In Agdao?', 'Does the client reside in Agdao?', 'Agdao?', 'booleanVal');


SELECT 'roFieldsByRole' AS 'Loading' FROM DUAL;
INSERT INTO `roFieldsByRole`
  (roleName, tableName, fieldName)
VALUES
  ('clerk', 'prenatalExam', 'fh'),
  ('clerk', 'prenatalExam', 'fhNote'),
  ('clerk', 'prenatalExam', 'fht'),
  ('clerk', 'prenatalExam', 'fhtNote'),
  ('clerk', 'prenatalExam', 'pos'),
  ('clerk', 'prenatalExam', 'mvmt'),
  ('clerk', 'prenatalExam', 'edema'),
  ('clerk', 'prenatalExam', 'risk'),
  ('clerk', 'prenatalExam', 'vitamin'),
  ('clerk', 'prenatalExam', 'pray'),
  ('clerk', 'prenatalExam', 'note'),
  ('clerk', 'prenatalExam', 'returnDate'),
  ('clerk', 'pregnancy', 'lmp'),
  ('clerk', 'pregnancy', 'sureLMP'),
  ('clerk', 'pregnancy', 'alternateEdd'),
  ('clerk', 'pregnancy', 'useAlternateEdd'),
  ('clerk', 'pregnancy', 'riskNote'),
  ('clerk', 'pregnancy', 'pregnancyEndDate'),
  ('clerk', 'pregnancy', 'pregnancyEndResult'),
  ('clerk', 'risk', 'riskCode');

