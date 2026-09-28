-- 08_course_cohort_ranking.sql
--
-- Question:
-- Which course + cohort combinations have the lowest
-- attendance and completion rates?


-- 1. Calculate attendance for each course + cohort

WITH attendance_summary AS (

    SELECT
        e.course_id,e.cohort_id,
        ROUND(
            100.0 * SUM(a.status IN ('Present', 'Late') ) / COUNT(*), 1) AS attendance_rate

    FROM enrolments e
    JOIN attendance a USING(enrolment_id)
    WHERE a.status != 'Not Recorded'
    GROUP BY e.course_id, e.cohort_id
),


-- 2. Calculate completion for each course + cohort

completion_summary AS (

    SELECT
        course_id,cohort_id,
        ROUND(
            100.0 * SUM( status = 'Completed') / COUNT(*),1
        ) AS completion_rate,

        COUNT(*) AS enrolled

    FROM enrolments
    GROUP BY course_id, cohort_id
)


-- 3. Combine the two results

SELECT
    c.course_name,
    a.cohort_id,
    a.attendance_rate,
    cs.completion_rate,
    cs.enrolled

FROM attendance_summary a

JOIN completion_summary cs
    ON cs.course_id = a.course_id
    AND cs.cohort_id = a.cohort_id

JOIN courses c USING(course_id)

ORDER BY a.attendance_rate ASC;


-- Insight:
-- Cohorts 4, 5, and 6 have the weakest attendance.
-- Six of the eight lowest attendance rates are from Cohorts 4 and 5,
-- and the other two are from Cohort 6. Every Cohort 4 and 5 offering
-- is below 60% attendance.
--
-- Completion rates are also low in Cohorts 4, 5, and 6, mainly because
-- many students have an Unknown final status. Cohort 6 is also still running.