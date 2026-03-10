# Financial Reporting Control Framework

A standardized SQL validation layer that runs automated control checkpoints across 5 financial reporting domains — Revenue, P&L, Inventory, Expenses, and Payroll — producing a control scorecard for audit review and exception management.

---

## Problem Statement

Financial reporting systems across multiple domains often lack a unified validation layer. Each team runs ad-hoc checks in spreadsheets, leading to inconsistent standards, manual effort, and blind spots that surface as audit findings. This framework replaces those scattered checks with a single, repeatable SQL-based control engine.

---

## What This Framework Does

| Step | Description |
|------|-------------|
| 1. Control Classification | Evaluates each control with tolerance-aware pass/fail logic |
| 2. Domain Scorecard | Aggregates pass rates per reporting domain with risk ranking |
| 3. Validation Type Analysis | Identifies which check types (NULL, duplicate, aggregate) fail most |
| 4. Exception Report | Surfaces all failures with priority (CRITICAL / HIGH / MEDIUM) |
| 5. Framework Health Summary | Single overall pass rate metric for leadership reporting |

---

## Reporting Domains Covered

| Domain | Report | Controls |
|--------|--------|----------|
| Revenue | Monthly Revenue Report | Row count, nulls, aggregate match, duplicates |
| P&L | P&L Summary Report | Row count, nulls, aggregate match, duplicates |
| Inventory | Inventory Movement Report | Row count, nulls, value match, referential integrity |
| Expenses | Expense Report | Row count, nulls, aggregate match |
| Payroll | Payroll Summary | Row count, nulls, aggregate match |

---

## Validation Types

| Type | What It Checks |
|------|----------------|
| `ROW_COUNT` | Actual record count matches expected |
| `NULL_CHECK` | No unexpected null values in critical fields |
| `AGGREGATE_MATCH` | Sum/total matches source system within tolerance |
| `DUPLICATE_CHECK` | No duplicate transaction IDs or records |
| `REF_INTEGRITY` | Foreign key references resolve correctly |

---

## Key SQL Techniques Used

- **CTEs** — 5-stage modular pipeline from raw controls to exception report
- **RANK() OVER()** — Domain risk ranking by failure count
- **Conditional aggregation** — Pass/fail counts using `CASE WHEN` inside `SUM()`
- **Tolerance-aware logic** — Deviations within acceptable threshold classified as PASS_WITH_TOLERANCE
- **Priority classification** — CRITICAL / HIGH / MEDIUM based on domain sensitivity and deviation size

---

## Sample Results (from sample_data.csv)

- **20 controls run** across 5 domains
- **4 failures** identified: P&L row count, P&L nulls, Expense nulls, P&L duplicates
- **P&L domain** ranked highest risk (2 failures, 67% pass rate)
- All Revenue controls passed (100% pass rate)

---

## Files

```
reporting-control-framework/
├── validation.sql     ← Full control framework SQL (5 CTEs + 2 output queries)
├── sample_data.csv    ← 20 sample control execution records across 5 domains
└── README.md          ← This file
```

---

## Business Impact (Real-World Application)

- Standardized validation templates across **5 reporting domains**
- Improved traceability for audit reviews, reducing manual adjustment cycles
- Reduced manual reporting adjustments by **~25%**
- Enabled consistent exception management across finance and engineering teams

---

## Author

**Yash Sonawane** — Business Analyst, Financial Systems  
[LinkedIn](https://linkedin.com/in/yash-sonawane25)
