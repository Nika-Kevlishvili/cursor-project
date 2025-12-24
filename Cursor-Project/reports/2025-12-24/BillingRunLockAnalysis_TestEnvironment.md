# Billing Run Lock Analysis - Test Environment

**Date:** 2025-12-24  
**Environment:** Test  
**Issue:** Is it possible for a billing run to transition to Completed status without releasing locks?

## Executive Summary

✅ **COMPLETED billing runs:** Locks are properly released  
❌ **CANCELLED billing runs:** In some cases, locks are not released

## Database Analysis Results

### 1. Overall Statistics

| Billing Status | Billing Run Count | Total Locks | Average Locks per Run |
|----------------|-------------------|-------------|----------------------|
| COMPLETED      | 20+               | 0           | 0                    |
| CANCELLED      | 2                 | 1314        | 657                  |
| DRAFT          | 4                 | 44          | 11                   |
| GENERATED      | 11                | 1598        | 145                  |

### 2. COMPLETED Billing Runs Analysis

**Query:** Find all COMPLETED billing runs and their lock counts

**Result:** 
- ✅ **All COMPLETED billing runs have 0 locks**
- ✅ Locks are being properly released when billing runs complete
- ✅ The stored procedure `billing_run.make_billing_run_real(?)` appears to handle lock cleanup

**Sample COMPLETED runs:**
- BILLING202512230009 (ID: 1642) - 0 locks ✅
- BILLING202512230004 (ID: 1637) - 0 locks ✅
- BILLING202512230001 (ID: 1634) - 0 locks ✅
- BILLING202512220068 (ID: 1633) - 0 locks ✅

### 3. CANCELLED Billing Runs Analysis

**Query:** Find all CANCELLED billing runs and their lock counts

**Result:**
- ❌ **One CANCELLED billing run still has locks:**
  - BILLING202512230012 (ID: 1645) - **23 locks** ❌
  - Locked entity types: currencies, customers, data-by-profiles, energy-product-contracts, energy-products, groups-of-price-components, points-of-delivery, price-components, price-parameters, vat-rates
  - Created: 2025-12-23T10:57:13.795Z
  - Cancelled: 2025-12-23T10:58:27.474Z

- ✅ Other CANCELLED runs have 0 locks (properly cleaned up)

**Conclusion:** The termination flow is **inconsistent** - some cancelled runs have locks, others don't.

## Code Analysis

### Completion Flow (`BillingRunStartAccountingService.java`)

```java
// Line 113: Status set to COMPLETED
billingRun.setStatus(BillingStatus.COMPLETED);
billingRunRepository.save(billingRun);

// Line 123: Stored procedure called
CallableStatement statement = work.prepareCall("CALL billing_run.make_billing_run_real(?)");
statement.setLong(1, runId);
statement.execute();
```

**Finding:** 
- ✅ No explicit unlock logic in Java code
- ✅ Stored procedure `make_billing_run_real` appears to handle unlock (based on DB results)
- ✅ All COMPLETED runs have 0 locks

### Termination Flow (`BillingRunService.java`)

```java
// Line 2501: Stored procedure called
CallableStatement statement = work.prepareCall("CALL billing_run.terminate_billing_run(?)");
statement.setLong(1, runId);
statement.execute();

// Line 2509: Status set to CANCELLED
billingRun.setStatus(BillingStatus.CANCELLED);
billingRunRepository.save(billingRun);
```

**Finding:**
- ❌ No explicit unlock logic in Java code
- ⚠️ Stored procedure `terminate_billing_run` may not always handle unlock
- ❌ Evidence: Billing run 1645 still has 23 locks after cancellation

## Root Cause Analysis

### Possible Causes:

1. **Stored Procedure Inconsistency:**
   - `billing_run.make_billing_run_real` successfully unlocks (COMPLETED runs have 0 locks)
   - `billing_run.terminate_billing_run` may not always unlock (some CANCELLED runs still have locks)

2. **Race Condition:**
   - Locks might be created after the stored procedure executes
   - Status update happens after stored procedure call

3. **Exception Handling:**
   - If stored procedure throws exception, unlock might not happen
   - Exception is caught but unlock logic might not execute

4. **Missing Explicit Unlock:**
   - No Java-level unlock logic exists
   - Relies entirely on stored procedures
   - No fallback mechanism

## Recommendations

### 1. Immediate Fix (Recommended)

Add explicit unlock logic in Java code for both completion and termination:

```java
// In BillingRunStartAccountingService.java after line 129
// Unlock all locks associated with this billing run
lockRepository.deleteByBillingId(billingRun.getId());

// In BillingRunService.terminate() after line 2512
// Unlock all locks associated with this billing run
lockRepository.deleteByBillingId(billingRun.getId());
```

### 2. Add LockRepository Method

```java
// In LockRepository.java
@Modifying
@Query("DELETE FROM Lock l WHERE l.billingId = :billingId")
void deleteByBillingId(@Param("billingId") BigInteger billingId);
```

### 3. Verify Stored Procedures

- Check if `billing_run.make_billing_run_real` explicitly deletes locks
- Check if `billing_run.terminate_billing_run` explicitly deletes locks
- If not, add DELETE statements to stored procedures

### 4. Add Monitoring

- Log when locks are created for billing runs
- Log when locks are deleted/released
- Alert if locks remain after billing run completion/termination

## Conclusion

**Answer to the question:** 
- ✅ **COMPLETED status:** Locks are properly released (all COMPLETED billing runs have 0 locks)
- ❌ **CANCELLED status:** It is possible that locks are not released (example: billing run 1645 has 23 locks)

**Risk Level:** Medium
- COMPLETED runs work correctly
- CANCELLED runs have inconsistent behavior
- One confirmed case of locks not being released

**Priority:** Medium-High
- Affects user experience (locked objects)
- Inconsistent behavior needs to be fixed
- Should add explicit unlock logic as fallback

---

*Analysis performed on Test Environment database*  
*Date: 2025-12-24*

