# BEARS Entitlements Request Guide

> Reference guide for requesting BEARS entitlements for ENTITY application users based on ELEVEL requirements.

---

## Overview

The ENTITY application uses **ELEVEL (Elevation Level)** to determine user permissions. ELEVEL is derived from two factors stored in the employee's profile:

1. **ICS Access Level** (ICSACC) - The IRS Computer Security access level
2. **Position Title** - The employee's job title

These two values are mapped through the **ENTTITLES** lookup table to produce the ELEVEL.

---

## ELEVEL to BEARS Entitlement Mapping

| ELEVEL | Role Name | ICS Access Level | Description |
|--------|-----------|------------------|-------------|
| **0** | National | A | Full system access - All Areas, All PODs |
| **2** | Area | 8, A, B, C | Area-level access - All PODs within assigned Area |
| **4** | Territory | 6 | Territory-level access - All PODs within Territory |
| **6** | Group Manager | 1 | Group-level access + Case Assignment |
| **7** | Acting GM | 3 | Group-level access + Limited Case Assignment |
| **8** | Employee | (Default) | Self only - Own assigned cases |

---

## What to Request in BEARS

When submitting a BEARS entitlement request, provide the following information:

### For Each User

| Field | Description | Example |
|-------|-------------|---------|
| **SEID** | Employee's SEID | `AB1CD` |
| **Name** | Employee's full name | `John Smith` |
| **Position Title** | Official job title (must match ENTTITLES) | `MANAGER`, `TERRITORY MANAGER`, `ANALYST` |
| **ICS Access Level** | Required ICS level for their role | `1`, `6`, `8`, `A`, etc. |
| **Area Code** | Assigned Area (3-digit code) | `123` |
| **POD Code** | Assigned POD (3-character code) | `A01` |
| **Requested ELEVEL** | The access level needed | `0`, `2`, `4`, `6`, `7`, or `8` |

---

## Sample Request Templates

### Template 1: Group Manager (ELEVEL 6)

```
Application: ENTITY Case Management System
Request Type: New User / Modify Access

User Information:
- SEID: _____
- Name: _____
- Position Title: MANAGER
- ICS Access Level Needed: 1
- Area Code: ___
- POD Code: ___

Requested Access Level: ELEVEL 6 (Group Manager)
- Can view all cases within their POD
- Can access Case Assignment menu
- Can access Weekly Time Verification menu

Justification: [User's job duties require group management capabilities]
```

### Template 2: Territory Manager (ELEVEL 4)

```
Application: ENTITY Case Management System
Request Type: New User / Modify Access

User Information:
- SEID: _____
- Name: _____
- Position Title: TERRITORY MANAGER
- ICS Access Level Needed: 6
- Area Code: ___
- POD Code: N/A (Territory-wide access)

Requested Access Level: ELEVEL 4 (Territory)
- Can view all cases within their Territory
- Can access Realignment menu
- Cannot access Case Assignment (Group-level only)

Justification: [User manages territory operations and requires territory-wide visibility]
```

### Template 3: Area Director (ELEVEL 2)

```
Application: ENTITY Case Management System
Request Type: New User / Modify Access

User Information:
- SEID: _____
- Name: _____
- Position Title: AREA DIRECTOR
- ICS Access Level Needed: 8
- Area Code: ___
- POD Code: N/A (Area-wide access)

Requested Access Level: ELEVEL 2 (Area)
- Can view all cases within their Area
- Can access Realignment menu
- Full reporting access for Area

Justification: [User is Area Director and requires area-wide management access]
```

### Template 4: National Analyst (ELEVEL 0)

```
Application: ENTITY Case Management System
Request Type: New User / Modify Access

User Information:
- SEID: _____
- Name: _____
- Position Title: NATIONAL ANALYST - WI
- ICS Access Level Needed: A
- Area Code: N/A (National access)
- POD Code: N/A (National access)

Requested Access Level: ELEVEL 0 (National)
- Full system access across all Areas and PODs
- Can access all menus including Realignment
- Query Builder access for national reporting

Justification: [User performs national-level analysis and requires enterprise-wide data access]
```

### Template 5: Employee/Revenue Officer (ELEVEL 8)

```
Application: ENTITY Case Management System
Request Type: New User / Modify Access

User Information:
- SEID: _____
- Name: _____
- Position Title: REVENUE OFFICER
- ICS Access Level Needed: (Standard)
- Area Code: ___
- POD Code: ___

Requested Access Level: ELEVEL 8 (Employee)
- Can view only their own assigned cases
- Standard menu access (Views, Reports, Change Access)
- No Case Assignment or Time Verification access

Justification: [Standard employee access for case work]
```

---

## Staff User Requests

Staff users require a **special ROID prefix** (`859062`) in addition to their ELEVEL. Staff status provides:

- Access to **Utilities** menu (regardless of ELEVEL)
- Access to **Realignment** menu (regardless of ELEVEL)
- Ability to change **ORG code** (CF, CP, WI, AD)

### Staff User Template

```
Application: ENTITY Case Management System
Request Type: New Staff User

User Information:
- SEID: _____
- Name: _____
- Position Title: _____
- ICS Access Level Needed: _____
- ROID: Must begin with 859062 (Staff designation)
- ORG Code: CF / CP / WI / AD (select one)

Requested Access:
- ELEVEL: ___ (as appropriate for role)
- Staff Privileges: YES
  - Utilities menu access
  - Realignment access (regardless of ELEVEL)
  - ORG management capability

Justification: [User is staff member supporting ENTITY system operations]
```

---

## ENTTITLES Reference

The following ICS Access Level + Title combinations produce each ELEVEL:

### ELEVEL 0 (National)

| ICS Access Level | Title |
|------------------|-------|
| A | NATIONAL ANALYST - WI |
| A | NATIONAL ANALYST - TECHCP |
| A | NATIONAL ANALYST - SB/SE |
| A | NATIONAL ANALYST - CP |

### ELEVEL 2 (Area)

| ICS Access Level | Title |
|------------------|-------|
| 8 | AREA DIRECTOR |
| A | ANALYST |
| B | HEADQUARTERS-READ ONLY |
| A | CADRE MANAGER |
| A | STAFF ASSISTANT |
| 2 | SECRETARY-AREA |
| A | CAC |
| A | POLICY ANALYST |
| C | ICS/ENT QUALITY ANALYST |

### ELEVEL 4 (Territory)

| ICS Access Level | Title |
|------------------|-------|
| 6 | TERRITORY MANAGER |
| 6 | ACT. TERRITORY MANAGER |
| 6 | TERRITORY ADVISORY MGR |
| 2 | SECRETARY-TERRITORY |
| 6 | TER INSOL SUPRT MGR |
| 6 | TER TECH SERVICES MGR |

### ELEVEL 6 (Group Manager)

| ICS Access Level | Title |
|------------------|-------|
| 1 | MANAGER |
| 1 | INSOLVENCY MANAGER |
| 1 | CASE PROC. SUPPORT MGR |
| 1 | INSOLVENCY SUPPORT MGR |
| 2 | SECRETARY-GROUP |
| 1 | TECH SERVICES GRP MGR |
| 1 | ADVISORY GROUP MANAGER |
| 1 | COLLECTION SUPPORT MGR |
| 1 | FIELD ASSISTANCE MGR |

### ELEVEL 7 (Acting GM)

| ICS Access Level | Title |
|------------------|-------|
| 3 | OFFER SPECIALIST |

---

## Menu Access by ELEVEL (Quick Reference)

| Menu Item | 0 | 2 | 4 | 6 | 7 | 8 | Staff* |
|-----------|---|---|---|---|---|---|--------|
| Views | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Reports and Queries | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Change Access | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Case Assignment | | | | ✓ | ✓ | | |
| Weekly Time Verification | | | | ✓ | ✓ | | |
| End of Month | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Realignment | ✓ | ✓ | ✓ | | | | ✓ |
| Utilities | | | | | | | ✓ |

*Staff users get Realignment and Utilities regardless of their ELEVEL

---

## Important Notes

1. **ELEVEL is calculated, not directly assigned** - It comes from the combination of ICS Access Level and Position Title in ENTTITLES

2. **Title must match exactly** - The position title in BEARS must match an entry in the ENTTITLES table

3. **Staff status is determined by ROID** - Not by a checkbox or flag. ROID must start with `859062`

4. **Users can have multiple assignments** - A single SEID can have multiple ROIDs with different ELEVELs

5. **Area/POD determines data scope** - Even with the same ELEVEL, users only see data within their assigned Area/POD

---

## Contact

For questions about ELEVEL assignments or ENTTITLES mappings, contact the ENTITY application team.

---

*Last Updated: December 2025*
