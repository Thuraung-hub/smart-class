# Product Requirement Document (PRD)

## Smart Class Check-in & Learning Reflection App

---

# 1. Problem Statement

In many universities, class attendance is still recorded manually using paper or simple sign-in systems. These methods are unreliable because students may sign in for others and they do not confirm whether students are physically present in the classroom.

The Smart Class Check-in & Learning Reflection App aims to improve attendance tracking and encourage student participation by using modern mobile technology.

The system verifies student attendance using **GPS location** and **QR code scanning**, and it also allows students to reflect on what they learned in class.

---

# 2. Target Users

### Primary Users

University students who attend classes.

### Secondary Users

Instructors who want to monitor attendance and receive student feedback about the class.

---

# 3. Product Goals

The application aims to:

* Ensure students are physically present in the classroom
* Provide a simple digital attendance system
* Encourage students to reflect on their learning
* Allow instructors to understand student learning experience

---

# 4. Core Features

## 4.1 Class Check-in (Before Class)

Students must perform the following steps before the class begins:

1. Press **Check-in**
2. Scan the **class QR code**
3. The system records:

   * GPS location
   * Timestamp

Students must then fill in:

* Topic covered in the **previous class**
* Topic they **expect to learn today**
* Their **mood before class**

### Mood Scale

| Score | Mood          |
| ----- | ------------- |
| 1     | Very negative |
| 2     | Negative      |
| 3     | Neutral       |
| 4     | Positive      |
| 5     | Very positive |

---

## 4.2 Finish Class (After Class)

At the end of the class session, students must:

1. Press **Finish Class**
2. Scan the **QR code again**
3. The system records GPS location

Students must also fill in:

* **What they learned today**
* **Feedback** about the class or instructor

---

# 5. User Flow

### Step 1 — Open Application

The student opens the mobile application and sees the **Home Screen**.

---

### Step 2 — Check-in Process

1. Student presses the **Check-in button**
2. QR code scanner opens
3. Student scans the classroom QR code
4. System records GPS location and timestamp
5. Student fills in the pre-class reflection form
6. Data is saved

---

### Step 3 — Finish Class Process

1. Student presses **Finish Class**
2. Student scans the QR code again
3. GPS location is recorded
4. Student submits reflection and feedback
5. Data is stored in the system

---

# 6. Application Screens

The application includes the following main screens:

### Home Screen

* Displays two main actions:

  * Check-in
  * Finish Class

### Check-in Screen

Functions:

* QR Code scanning
* GPS location capture
* Form input for pre-class reflection

### Finish Class Screen

Functions:

* QR Code scanning
* GPS location capture
* Reflection and feedback form

---

# 7. Data Fields

### Check-in Data

| Field          | Type     |
| -------------- | -------- |
| Student ID     | String   |
| Timestamp      | DateTime |
| GPS Latitude   | Double   |
| GPS Longitude  | Double   |
| QR Code Value  | String   |
| Previous Topic | String   |
| Expected Topic | String   |
| Mood           | Integer  |

---

### Class Completion Data

| Field               | Type     |
| ------------------- | -------- |
| Timestamp           | DateTime |
| GPS Latitude        | Double   |
| GPS Longitude       | Double   |
| QR Code Value       | String   |
| Learning Reflection | String   |
| Feedback            | String   |

---

# 8. Technology Stack

Frontend Framework:

Flutter

Key Flutter Packages:

* mobile_scanner (QR Code scanning)
* geolocator (GPS location)
* shared_preferences (local data storage)
* permission_handler (device permissions)

Backend / Cloud Services:

Firebase

Firebase Services Used:

* Firebase Hosting for web deployment
* Optional Firebase database for storing attendance records

---

# 9. Deployment

The application will be deployed using **Firebase Hosting**.

Deployment allows the Flutter web version of the app to be accessed through a public URL.

Example deployment process:

1. Build Flutter web application
2. Deploy using Firebase CLI
3. Access the application via the Firebase hosting URL

---

# 10. MVP Scope

The Minimum Viable Product (MVP) will include:

* Home screen
* Check-in functionality
* Finish class functionality
* QR code scanning
* GPS location capture
* Form inputs
* Local data storage
* Web deployment

Advanced analytics and instructor dashboards are not included in the MVP version.

---

# 11. Success Criteria

The project is considered successful if:

* Students can check in successfully
* QR scanning works correctly
* GPS location is recorded
* Reflection forms can be submitted
* The application can be accessed through a deployed web URL

---
