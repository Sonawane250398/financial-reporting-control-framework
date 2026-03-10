# Tableau Dashboard Design — Reporting Control Framework Monitor

## Dashboard Title
**Financial Reporting Control Health Dashboard**

---

## Purpose
Give finance leadership and internal audit a single view of control health across all reporting domains — without needing to run SQL or read raw data.

---

## Dashboard Layout (3 Sections)

### Section 1 — Framework Health (Top Row)
Four KPI tiles:

| Tile | Metric | Colour Logic |
|------|--------|--------------|
| Total Controls Run | COUNT of all controls | Neutral (blue) |
| Overall Pass Rate % | % with PASS status | Green >95%, amber 85–95%, red <85% |
| Critical Exceptions | COUNT where priority = CRITICAL | Red if >0 |
| Domains at Risk | COUNT where pass_rate_pct < 90% | Red if >0 |

---

### Section 2 — Domain View (Middle Row)

**Left: Domain Pass Rate — Horizontal Bar Chart**
- X-axis: pass_rate_pct
- Y-axis: domain (sorted by risk_rank)
- Colour: Green (100%) → Red (0%)
- Reference line at 95% as the control threshold
- Purpose: Instant view of which domain needs attention

**Right: Failure Type Breakdown — Stacked Bar**
- X-axis: domain
- Colour segments: NULL_CHECK / ROW_COUNT / AGGREGATE_MATCH / DUPLICATE_CHECK
- Purpose: Shows what kind of controls are failing per domain

---

### Section 3 — Exception Detail (Bottom)

**Exception Priority Table**
- Columns: Priority, Domain, Report Name, Control Name, Expected, Actual, Deviation
- Row colour: Red = CRITICAL, Amber = HIGH, Grey = MEDIUM
- Sorted by priority then domain
- Filterable by: Domain, Validation Type, Priority, Date

---

## Filters (Applied Globally)
- Domain multi-select
- Validation Type multi-select
- Exception Priority (CRITICAL / HIGH / MEDIUM)
- Last Run Date range

---

## Calculated Fields in Tableau

```
// Final Status (with tolerance)
IF [Status] = "PASS" THEN "PASS"
ELSEIF ABS([Actual Value] - [Expected Value]) <= [Tolerance] THEN "PASS_WITH_TOLERANCE"
ELSE "FAIL"
END

// Deviation
ABS([Actual Value] - [Expected Value])

// Exception Priority
IF [Domain] = "Revenue" OR [Domain] = "P&L" THEN
    IF [Deviation] > 0 THEN "CRITICAL" ELSE "HIGH" END
ELSEIF [Deviation] > 100 THEN "HIGH"
ELSE "MEDIUM"
END

// Pass Rate %
SUM(IF [Final Status] = "PASS" THEN 1 ELSE 0 END) / COUNT([Control Id])
```
