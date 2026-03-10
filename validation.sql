-- ============================================================
-- Financial Reporting Control Framework
-- Author: Yash Sonawane
-- Description: Standardized SQL validation layer that runs
--              control checkpoints across 5 reporting domains.
--              Produces a control scorecard for audit review
--              and flags failures for exception management.
-- ============================================================


-- ============================================================
-- STEP 1: Control execution results — classify each control
-- ============================================================

WITH control_results AS (
    SELECT
        control_id,
        control_name,
        domain,
        report_name,
        validation_type,
        expected_value,
        actual_value,
        tolerance,
        status,
        last_run_date,
        -- Determine if failure is within acceptable tolerance
        CASE
            WHEN status = 'PASS' THEN 'PASS'
            WHEN ABS(actual_value - expected_value) <= tolerance THEN 'PASS_WITH_TOLERANCE'
            ELSE 'FAIL'
        END AS final_status,
        ABS(actual_value - expected_value) AS deviation
    FROM reporting_controls
),


-- ============================================================
-- STEP 2: Domain-level scorecard
-- Summarises control health per reporting domain
-- ============================================================

domain_scorecard AS (
    SELECT
        domain,
        COUNT(*)                                                AS total_controls,
        SUM(CASE WHEN final_status = 'PASS'
                 THEN 1 ELSE 0 END)                            AS controls_passed,
        SUM(CASE WHEN final_status = 'FAIL'
                 THEN 1 ELSE 0 END)                            AS controls_failed,
        ROUND(
            SUM(CASE WHEN final_status = 'PASS'
                     THEN 1 ELSE 0 END) * 100.0
            / COUNT(*), 2
        )                                                       AS pass_rate_pct,
        -- Rank domains by failure count for prioritisation
        RANK() OVER (
            ORDER BY SUM(CASE WHEN final_status = 'FAIL'
                              THEN 1 ELSE 0 END) DESC
        )                                                       AS risk_rank
    FROM control_results
    GROUP BY domain
),


-- ============================================================
-- STEP 3: Validation type breakdown
-- Shows which types of checks fail most often
-- ============================================================

validation_type_analysis AS (
    SELECT
        validation_type,
        COUNT(*)                                               AS total_checks,
        SUM(CASE WHEN final_status = 'FAIL'
                 THEN 1 ELSE 0 END)                           AS failed_checks,
        ROUND(
            SUM(CASE WHEN final_status = 'FAIL'
                     THEN 1 ELSE 0 END) * 100.0
            / COUNT(*), 2
        )                                                      AS failure_rate_pct
    FROM control_results
    GROUP BY validation_type
    ORDER BY failure_rate_pct DESC
),


-- ============================================================
-- STEP 4: Exception report — all failed controls
-- Sent to finance team for investigation
-- ============================================================

exception_report AS (
    SELECT
        cr.control_id,
        cr.domain,
        cr.report_name,
        cr.control_name,
        cr.validation_type,
        cr.expected_value,
        cr.actual_value,
        cr.deviation,
        cr.final_status,
        cr.last_run_date,
        -- Assign priority based on domain and deviation
        CASE
            WHEN cr.domain IN ('Revenue', 'P&L')
             AND cr.deviation > 0    THEN 'CRITICAL'
            WHEN cr.deviation > 100  THEN 'HIGH'
            ELSE                          'MEDIUM'
        END AS exception_priority
    FROM control_results cr
    WHERE cr.final_status = 'FAIL'
),


-- ============================================================
-- STEP 5: Overall control framework health summary
-- Top-level metric for leadership reporting
-- ============================================================

framework_health AS (
    SELECT
        COUNT(*)                                              AS total_controls_run,
        SUM(CASE WHEN final_status = 'PASS'
                 THEN 1 ELSE 0 END)                          AS total_passed,
        SUM(CASE WHEN final_status = 'FAIL'
                 THEN 1 ELSE 0 END)                          AS total_failed,
        ROUND(
            SUM(CASE WHEN final_status = 'PASS'
                     THEN 1.0 ELSE 0 END)
            / COUNT(*) * 100, 2
        )                                                     AS overall_pass_rate_pct,
        MAX(last_run_date)                                    AS last_run_date
    FROM control_results
)


-- ============================================================
-- FINAL OUTPUT 1: Exception report for finance review
-- ============================================================

SELECT
    e.exception_priority,
    e.domain,
    e.report_name,
    e.control_name,
    e.validation_type,
    e.expected_value,
    e.actual_value,
    e.deviation,
    d.pass_rate_pct AS domain_pass_rate
FROM exception_report e
JOIN domain_scorecard d USING (domain)
ORDER BY
    CASE e.exception_priority
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH'     THEN 2
        ELSE                 3
    END,
    e.domain;


-- ============================================================
-- FINAL OUTPUT 2: Domain scorecard for leadership dashboard
-- ============================================================

SELECT
    domain,
    total_controls,
    controls_passed,
    controls_failed,
    pass_rate_pct,
    risk_rank
FROM domain_scorecard
ORDER BY risk_rank;
