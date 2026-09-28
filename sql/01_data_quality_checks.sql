-- 01_data_quality_checks.sql
-- Purpose: check the underlying records before trusting any analysis built on them.


-- Enrolments per status --How large is Unknown
SELECT status, COUNT(*) AS total_enrolments
FROM enrolments
GROUP BY status
ORDER BY total_enrolments DESC;

-- 31.5%(178) of the enrolment records are unknown

-- What share of student records are missing contact information
SELECT
	SUM(email ='') mising_email,
    SUM(phone = '') missing_phone
FROM students;
-- 75% of students have missing contact details

-- How many attendance sessions have no status recorded at all
SELECT status, COUNT(*) AS n
FROM attendance
GROUP BY status
ORDER BY n DESC;

-- Not Recorded sessions as a share of the whole attendance table
SELECT
  ROUND(100.0 * SUM(status = 'Not Recorded') / COUNT(*), 2) AS pct_not_recorded
FROM attendance;

-- Decision made from these results, applied in every query from here on:
--   * Not Recorded attendance rows are excluded from attendance-rate calculations
--     (neither counted as attended nor as absent)
--   * Unknown enrolment status is kept as its own category, never folded into
--     Completed or Dropped
