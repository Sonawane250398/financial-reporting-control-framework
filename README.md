# Financial Reporting Control Framework

A SQL-based validation and monitoring framework that runs automated control checkpoints across financial reporting pipelines.
The framework evaluates reporting accuracy across multiple domains and produces a control scorecard for audit review and exception management.

---

## Business Problem

Financial reporting systems across multiple domains often lack a unified validation layer. Teams frequently run ad-hoc checks in spreadsheets, resulting in inconsistent validation standards, manual effort, and blind spots that only surface during audits or reporting reviews.

This project demonstrates a centralized SQL-based control framework that standardizes validation across financial reporting pipelines.

---

## What This Framework Does

| Step                     | Description                                                    |
| ------------------------ | -------------------------------------------------------------- |
| Control Classification   | Evaluates each control using tolerance-aware pass/fail logic   |
| Domain Scorecard         | Aggregates pass rates per reporting domain with risk ranking   |
| Validation Analysis      | Identifies which validation types fail most frequently         |
| Exception Reporting      | Surfaces all failures with severity levels                     |
| Framework Health Summary | Produces an overall control pass rate for leadership reporting |

---

## Reporting Domains Covered

| Domain    | Report                    | Controls                                             |
| --------- | ------------------------- | ---------------------------------------------------- |
| Revenue   | Monthly Revenue Report    | Row count, nulls, aggregate match, duplicates        |
| P&L       | P&L Summary Report        | Row count, nulls, aggregate match, duplicates        |
| Inventory | Inventory Movement Report | Row count, nulls, value match, referential integrity |
| Expenses  | Expense Report            | Row count, nulls, aggregate match                    |
| Payroll   | Payroll Summary           | Row count, nulls, aggregate match                    |

---

## Validation Types

| Type              | What It Checks                                                |
| ----------------- | ------------------------------------------------------------- |
| `ROW_COUNT`       | Actual record count matches expected                          |
| `NULL_CHECK`      | Ensures critical fields do not contain unexpected null values |
| `AGGREGATE_MATCH` | Validates totals against source systems within tolerance      |
| `DUPLICATE_CHECK` | Detects duplicate transaction IDs or records                  |
| `REF_INTEGRITY`   | Ensures foreign key references resolve correctly              |

---

## Key SQL Techniques Used

• Common Table Expressions (CTEs) to build modular validation pipelines
• `RANK() OVER()` window function to rank reporting domains by risk
• Conditional aggregation using `CASE WHEN` within `SUM()`
• Tolerance-aware validation logic for acceptable deviations
• Priority classification (CRITICAL / HIGH / MEDIUM) for exception management

---

## Example Results (Sample Dataset)

Using the included dataset:

• **20 validation controls executed** across 5 reporting domains
• **4 failures detected** across multiple validation types
• **P&L domain ranked highest risk** with a 67% pass rate
• **Revenue domain achieved 100% pass rate**

These results demonstrate how the framework helps identify high-risk reporting domains and prioritize investigation.

---

## Repository Structure

```
financial-reporting-control-framework
│
├── validation.sql      ← SQL validation framework
├── sample_data.csv     ← Example dataset for control execution
└── README.md
```

---

## Business Impact

Structured reporting control frameworks help organizations:

• standardize financial data validation across domains
• improve traceability for audit reviews
• reduce manual reporting adjustments
• strengthen data governance and reporting reliability

In real-world financial reporting environments, implementing standardized validation controls can significantly reduce reporting discrepancies and improve audit readiness.

---

## Author

**Yash Sonawane**
Business Systems Analyst — Financial Data & Reporting

LinkedIn
https://linkedin.com/in/yash-sonawane25

Portfolio
https://portfolio-delta-silk-82.vercel.app
