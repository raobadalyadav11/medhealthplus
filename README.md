# Product Requirements Document (PRD) - Updated Version

## Document Information
- **Project Name**: X-Ray, Ultrasound & Blood Test Online Booking System
- **Version**: 2.0
- **Date**: August 11, 2025
- **Author**: Grok (based on updated requirements)
- **Status**: Draft
- **Approval**: Pending

This updated PRD builds on the initial version, incorporating Model-View-Controller (MVC) architecture in the system design, Flutter for frontend (web and mobile), Firebase for backend services, email-based login, India-specific adaptations (INR currency, multiple languages: English and Hindi initially), and comprehensive details across all sections. The platform is targeted for the Indian market, focusing on urban and semi-urban users with features like INR pricing, Razorpay integration for payments, and multilingual support. No code is provided; this document focuses on requirements and design.

## 1. Product Overview
### 1.1 Purpose and Vision
The platform is a web and mobile (Android/iOS) application for Indian users to book diagnostic tests (X-ray, ultrasound, blood tests) at nearby centers, compare prices in INR, and manage bookings with online/offline payments. Lab owners can manage operations, and admins oversee the system. It supports multiple languages (English and Hindi) for accessibility in India.

**Vision Statement**: Empower Indian patients with a seamless, multilingual platform for diagnostic bookings, using location-based services and secure INR transactions, while enabling labs to efficiently handle operations in a digital marketplace.

### 1.2 Business Opportunity
In India's growing healthcare sector (valued at over ₹20 lakh crore as of 2025), online diagnostic booking addresses pain points like fragmented services and language barriers. Competitors like Practo or Thyrocare exist, but this platform differentiates with Firebase-powered real-time updates, Flutter's cross-platform UI, and focused MVC architecture for maintainable code.

### 1.3 Scope
- **In Scope**: All features from initial PRD, plus multilingual support (English/Hindi), INR currency, email-based login via Firebase Auth, Razorpay for payments, Google Maps for location (India-focused), Firebase notifications.
- **Out of Scope**: Advanced AI features, international expansion.
- **Initial Release (MVP)**: Core booking with English/Hindi, INR payments.
- **Future Releases**: Additional languages (e.g., Tamil, Telugu), home collection.

### 1.4 Target Audience and User Personas
- Tailored for India: Patients in Tier 1-3 cities, labs in urban areas.
- Personas updated for India: Priya (Hindi-speaking user in Delhi), Dr. Raj (lab owner in Mumbai using INR reports).

### 1.5 Stakeholders
- External additions: Indian regulatory bodies (e.g., for data privacy under DPDP Act), Razorpay for payments.

## 2. Goals and Objectives
### 2.1 Business Objectives
- Launch in major Indian cities (Delhi, Mumbai, Bangalore) with 100,000 downloads in Year 1.
- Support INR transactions with 15% commission model.
- Achieve multilingual adoption: 40% users opting for Hindi.

### 2.2 Success Metrics
- KPIs: Bookings in INR, language switch rate, Firebase analytics for user retention.

### 2.3 Non-Goals
- No support for other currencies; INR only.

## 3. Features and Functional Requirements
All features from initial PRD remain, with additions:
- **Multilingual Support**: UI strings in English/Hindi; user-selectable via settings (using Flutter's localization packages).
- **Currency**: All prices in INR (₹ symbol).
- **Login/Authentication**: Email-based login/register with Firebase Auth (email verification, password reset). No social login in MVP.
- **Payments**: Razorpay integration for online INR payments (UPI, cards, wallets); offline pay-at-center option.
- **Notifications**: Firebase Cloud Messaging for push notifications (e.g., booking confirmations in selected language).

Updated Feature Tables (Priorities unchanged):

### 3.1 Customer/Patient Side
| Feature | User Story | Acceptance Criteria | Priority |
|---------|------------|---------------------|----------|
| Search & Browse | As an Indian patient, I want multilingual search for nearby labs so I can find options in my language. | - Location-based (Google Maps, India geofencing).<br>- Filters in English/Hindi.<br>- Prices in INR. | High |
| Test Details Page | As a patient, I want test details in my preferred language. | - Info in English/Hindi, INR prices, preparation instructions translated. | High |
| Booking & Payment | As a patient, I want to book and pay in INR securely. | - Date/time selection.<br>- Razorpay for online (UPI, etc.); offline option.<br>- Coupons in INR discounts. | High |
| Booking History | As a patient, I want to view history in my language. | - List with INR totals, status in English/Hindi. | Medium |
| Reports Download | As a patient, I want to download reports. | - PDF downloads via Firebase Storage. | High |
| Discounts & Coupons | As a patient, I want INR-based discounts. | - Apply codes, show savings in INR. | Medium |
| **New: Language Settings** | As a user, I want to switch languages. | - Toggle English/Hindi; persist via Firebase user profile. | High |

### 3.2 Lab/Clinic Owner Side
| Feature | User Story | Acceptance Criteria | Priority |
|---------|------------|---------------------|----------|
| Lab Profile Management | As a lab owner in India, I want to set INR prices and hours. | - Add tests with INR pricing, holidays (e.g., Indian festivals). | High |
| Booking Management | As a lab owner, I want multilingual notifications. | - Accept/reject in English/Hindi UI. | High |
| Report Upload | As a lab owner, I want to upload reports. | - Firebase Storage for PDFs. | High |
| Earnings Report | As a lab owner, I want INR earnings tracking. | - Reports in INR, exportable. | Medium |
| Offers Management | As a lab owner, I want to create INR discounts. | - Set offers in INR. | Low |

### 3.3 Admin Side
| Feature | User Story | Acceptance Criteria | Priority |
|---------|------------|---------------------|----------|
| User Management | As an admin, I want to manage Indian users. | - Approve labs with Indian licenses. | High |
| Commission Settings | As an admin, I want to set INR commissions. | - 10-20% on INR bookings. | High |
| Payments & Payouts | As an admin, I want to handle INR payouts. | - Track via Firebase, release post-commission. | High |
| Reports & Analytics | As an admin, I want India-specific analytics. | - Bookings by city, language usage. | Medium |
| Marketing Tools | As an admin, I want multilingual notifications. | - Send in English/Hindi via Firebase. | Low |

## 4. User Experience and Design
- **User Flows**: Updated for email login: Splash → Login (email) → Home (language selection prompt).
- **Design Principles**: Flutter widgets for responsive UI; Hindi font support (e.g., Devanagari). India-themed icons (e.g., rupee symbol).
- **Accessibility**: VoiceOver support, high contrast; comply with Indian accessibility standards.
- **Multilingual UI**: Dynamic text switching; right-to-left not needed for Hindi.

## 5. Non-Functional Requirements
- **Performance**: Real-time updates via Firebase (e.g., booking slots).
- **Security**: Firebase Auth for email login; encrypt INR transactions; comply with India's DPDP Act for health data.
- **Usability**: Offline viewing of bookings (Flutter cache); multilingual error messages.
- **Scalability**: Firebase's serverless model for Indian user growth.

## 6. Technical Requirements
- **Platforms**: Web (Flutter Web) + Mobile (Android/iOS via Flutter).
- **Frontend**: Flutter for cross-platform UI, with MVC pattern implementation.
- **Backend**: Firebase (Firestore for database, Auth for email login, Cloud Functions for business logic, Storage for reports, Messaging for notifications).
- **Database**: Firebase Firestore (real-time, schema for users, bookings, labs in INR).
- **Payment Gateway**: Razorpay (INR support, UPI integration).
- **Location Service**: Google Maps API (India-focused, with Hindi labels).
- **Notification**: Firebase Cloud Messaging (multilingual payloads).
- **File Storage**: Firebase Storage (for reports, lab docs).
- **Localization**: Flutter Intl for English/Hindi strings.
- **Deployment**: Firebase Hosting for web; Google Play/App Store for mobile.

## 7. System Design
### 7.1 High-Level Architecture
The system follows a client-server architecture with Flutter on the client side and Firebase as the backend. Data flows from user inputs (Flutter app) to Firebase services, ensuring real-time sync.

- **Components**:
  - **Client (Flutter App)**: Handles UI, local state, and API calls to Firebase.
  - **Backend (Firebase)**: Manages auth, data storage, notifications, and functions for computations (e.g., commission calculation).
  - **External Services**: Razorpay for payments, Google Maps for location.

- **Data Flow**:
  1. User logs in via email (Firebase Auth).
  2. Patient searches tests (Flutter UI queries Firestore for labs).
  3. Booking created (Firestore document, Razorpay for payment).
  4. Lab notified (Firebase Messaging).
  5. Report uploaded (Firebase Storage).
  6. Admin views analytics (Firestore queries).

### 7.2 MVC Architecture
The application adopts Model-View-Controller (MVC) pattern, adapted for Flutter's declarative UI. This ensures separation of concerns: Models for data, Views for UI, Controllers for logic.

- **Model**: Represents data structures (e.g., BookingModel with INR price, test type). Fetches/persists data from Firebase Firestore. Handles business entities like User (with language preference), Lab, Test (INR-priced).
  - Example: BookingModel includes fields like patientId, labId, date, priceInINR, status, language.

- **View**: Flutter widgets rendering UI (e.g., SearchResultsView displaying lab cards in selected language). Passive; receives data from Controller and displays it. Supports multilingual text via localization.
  - Example: TestDetailsView shows INR price, Hindi/English instructions.

- **Controller**: Manages logic and state (e.g., BookingController handles slot selection, Razorpay payment initiation, Firestore updates). Listens to user events from View, updates Model, and refreshes View. Uses Firebase SDKs directly.
  - Example: AuthController for email login (Firebase Auth signInWithEmailAndPassword), LanguageController for switching locales and updating UI.

- **Implementation Notes**:
  - In Flutter, MVC is implemented using packages like flutter_mvc (or custom) for structure.
  - Controllers inject dependencies (e.g., Firebase instances).
  - Real-time listeners: Controllers subscribe to Firestore streams for live updates (e.g., booking status).
  - Error Handling: Controllers manage Firebase exceptions, show localized alerts in Views.
  - Multilingual Integration: Controllers load language resources; Models store user language preference in Firestore.

- **Benefits for India Focus**: MVC allows easy localization (update Views for Hindi), scalable for INR calculations in Controllers, and maintainable for Firebase integrations.

- **Diagram Description** (Textual, no code):
  - View (UI) → Event → Controller (Logic + Firebase Calls) → Model (Data) → Update → View.
  - Example Workflow: Patient books → View sends event → Controller validates INR payment → Updates Model in Firestore → Notifies View of success.

## 8. Workflow
Updated for email login and INR:
1. User registers/logs in via email (Firebase Auth).
2. Selects language (English/Hindi).
3. Searches test (e.g., Ultrasound in INR).
4. Views labs, books slot, pays via Razorpay (INR).
5. Lab accepts via app (notification in language).
6. Test done; report uploaded to Firebase Storage.
7. System deducts commission (INR), payouts via Razorpay.

## 9. Monetization Model
- Commission: 10–20% on INR bookings.
- Subscriptions: Monthly INR fees for labs.
- Sponsored: INR payments for top listings.
- Ads: Healthcare ads in INR context.

**Example**:
- Test: ₹1200 (INR).
- Commission: ₹200.
- Lab: ₹1000.
- Discount: ₹50 → Patient pays ₹1150.
- Net: ₹150 to system.

## 10. Assumptions, Risks, and Dependencies
- Assumptions: Indian users have email access; Firebase supports INR/Razorpay.
- Risks: Language translation accuracy (mitigation: professional translators); Firebase costs for scale.
- Dependencies: Firebase SDKs, Razorpay API, Google Maps (India API keys).

## 11. Test, Release, and Iteration Plan
- Testing: Unit (MVC components), integration (Firebase), UAT with Indian users (Hindi testing).
- Release: MVP in India via app stores; A/B test languages.
- Iteration: Firebase Analytics for feedback.

## 12. Go-to-Market (GTM) Strategy
- Launch: India-focused marketing (Hindi ads on social media).
- Partnerships: Indian labs, Razorpay promotions.
- Support: Multilingual helpdesk.

## 13. Extra Features (Future Scope)
- Home collection with INR pricing.
- Doctor referrals in multiple languages.
- Corporate tie-ups for bulk INR bookings.
- Additional languages (e.g., regional Indian languages).



Based on the Product Requirements Document (PRD) for the X-Ray, Ultrasound & Blood Test Online Booking System, below is a comprehensive list of pages required for the web and mobile application. The pages are organized by user type (Customer/Patient, Lab/Clinic Owner, Admin) and include both core MVP pages and additional pages for usability, authentication, and future scope. Each page is mapped to the features described in the PRD to ensure full coverage of functionality.

## Application Page List

### General Pages (Shared Across All Users)
These pages are accessible to all user types or are part of the public-facing system.
1. **Homepage**  
   - Purpose: Entry point with search bar, test categories, and featured labs.  
   - Features: Search & Browse (location-based, test category filter).  
   - Components: Search input, filters (location, test type, price, ratings), lab list preview, banners for promotions.  
   - Priority: High (MVP).

2. **Login Page**  
   - Purpose: User authentication for patients, labs, and admins.  
   - Features: Supports email/phone + password, OTP login, social login (future scope).  
   - Components: Login form, forgot password link, signup redirect.  
   - Priority: High (MVP).

3. **Signup Page**  
   - Purpose: Registration for patients and lab owners.  
   - Features: Form for patient (name, email, phone) and lab (business details, license upload).  
   - Components: Input fields, file upload for labs, terms & conditions checkbox.  
   - Priority: High (MVP).

4. **Forgot Password Page**  
   - Purpose: Password recovery.  
   - Features: Email/phone-based password reset link/OTP.  
   - Components: Input field for email/phone, submit button.  
   - Priority: High (MVP).

5. **About Us Page**  
   - Purpose: Information about the platform.  
   - Features: Static content about mission, vision, and contact info.  
   - Components: Text, images, contact form.  
   - Priority: Medium.

6. **Help/Support Page**  
   - Purpose: User assistance and FAQs.  
   - Features: FAQs, contact form, live chat (future scope).  
   - Components: Searchable FAQ list, support ticket form.  
   - Priority: Medium.

7. **Terms & Conditions Page**  
   - Purpose: Legal terms for platform usage.  
   - Features: Static content.  
   - Components: Text, downloadable PDF.  
   - Priority: High (MVP).

8. **Privacy Policy Page**  
   - Purpose: Data usage and privacy details.  
   - Features: Static content, GDPR/HIPAA compliance info.  
   - Components: Text, downloadable PDF.  
   - Priority: High (MVP).

### Customer/Patient Pages
These pages support patient interactions for searching, booking, and managing tests.
9. **Search Results Page**  
   - Purpose: Display labs based on search criteria.  
   - Features: Location-based results, filters (test type, price, ratings), sorting options.  
   - Components: Lab cards (name, price, distance, ratings), Google Maps integration.  
   - Priority: High (MVP).

10. **Test Details Page**  
    - Purpose: Detailed information about a test and lab.  
    - Features: Test name, price, preparation instructions, lab details (hours, location), ratings/reviews.  
    - Components: Test info, lab info, map, book now button.  
    - Priority: High (MVP).

11. **Booking Page**  
    - Purpose: Select date/time and confirm booking.  
    - Features: Calendar for date selection, time slot picker, coupon input, payment options (online: UPI, PayPal, Card; offline: pay at center).  
    - Components: Calendar, time slots, payment gateway integration, coupon field.  
    - Priority: High (MVP).

12. **Booking Confirmation Page**  
    - Purpose: Confirm booking details.  
    - Features: Booking summary (test, lab, date, time, price), receipt download.  
    - Components: Summary table, download button, email/SMS confirmation trigger.  
    - Priority: High (MVP).

13. **Booking History Page**  
    - Purpose: View past and upcoming bookings.  
    - Features: List of bookings (upcoming/completed), cancel/reschedule options.  
    - Components: Booking cards, status indicators, action buttons.  
    - Priority: Medium.

14. **Reports Download Page**  
    - Purpose: Access and download test reports.  
    - Features: List of completed tests with downloadable PDFs, secure access.  
    - Components: Report list, download buttons, preview option.  
    - Priority: High (MVP).

15. **Profile Page (Patient)**  
    - Purpose: Manage patient account details.  
    - Features: Edit name, email, phone; view saved addresses; payment method management.  
    - Components: Form fields, address list, payment settings.  
    - Priority: Medium.

### Lab/Clinic Owner Pages
These pages support lab owners in managing their profiles, bookings, and reports.
16. **Lab Dashboard Page**  
    - Purpose: Overview of lab operations.  
    - Features: Summary of bookings, earnings, pending actions (e.g., accept/reject).  
    - Components: Widgets for bookings, revenue, alerts.  
    - Priority: High (MVP).

17. **Lab Profile Management Page**  
    - Purpose: Update lab details and test offerings.  
    - Features: Add/edit tests (name, price, availability), set working hours/holidays.  
    - Components: Forms for test details, time picker, file upload for certifications.  
    - Priority: High (MVP).

18. **Booking Management Page**  
    - Purpose: Handle incoming bookings.  
    - Features: View bookings, accept/reject, mark as completed.  
    - Components: Booking list, action buttons, filters (date, status).  
    - Priority: High (MVP).

19. **Report Upload Page**  
    - Purpose: Upload patient test reports.  
    - Features: Upload PDF, notify patient automatically.  
    - Components: File upload field, patient selection, submit button.  
    - Priority: High (MVP).

20. **Earnings Report Page**  
    - Purpose: Track lab earnings and payments.  
    - Features: View total bookings, earnings, pending payouts; export reports.  
    - Components: Earnings table, export button, filters (date range).  
    - Priority: Medium.

21. **Offers Management Page**  
    - Purpose: Create and manage discounts.  
    - Features: Set coupon codes, discount percentages, track usage.  
    - Components: Coupon creation form, usage analytics.  
    - Priority: Low.

### Admin Pages
These pages enable system oversight and management.
22. **Admin Dashboard Page**  
    - Purpose: Overview of platform performance.  
    - Features: Total bookings, revenue, top labs, best-selling tests.  
    - Components: Charts, KPIs, quick action links.  
    - Priority: Medium.

23. **User Management Page**  
    - Purpose: Manage patients and labs.  
    - Features: Approve/reject lab registrations, suspend users, view user details.  
    - Components: User list, filters, action buttons.  
    - Priority: High (MVP).

24. **Commission Settings Page**  
    - Purpose: Configure commission rates.  
    - Features: Set global or per-lab commission (e.g., 15%).  
    - Components: Form for percentage input, apply/cancel buttons.  
    - Priority: High (MVP).

25. **Payments & Payouts Page**  
    - Purpose: Manage financial transactions.  
    - Features: Track lab earnings, release payouts after commission deduction.  
    - Components: Payout list, payment status, release button.  
    - Priority: High (MVP).

26. **Reports & Analytics Page**  
    - Purpose: Detailed platform analytics.  
    - Features: Total bookings, revenue trends, top labs/tests, user demographics.  
    - Components: Interactive charts, exportable reports.  
    - Priority: Medium.

27. **Marketing Tools Page**  
    - Purpose: Manage promotions and notifications.  
    - Features: Create/send push notifications, manage banners, run offers.  
    - Components: Notification composer, banner upload, offer settings.  
    - Priority: Low.

### Future Scope Pages
These pages support features planned for post-MVP releases.
28. **Home Sample Collection Booking Page**  
    - Purpose: Book home sample collection for blood tests.  
    - Features: Select test, address, date/time; payment integration.  
    - Components: Address input, calendar, time slots.  
    - Priority: Low (Future).

29. **Doctor Referral Page**  
    - Purpose: Connect patients with doctors for follow-ups.  
    - Features: List of doctors, booking for consultations.  
    - Components: Doctor profiles, booking form.  
    - Priority: Low (Future).

30. **Corporate Tie-up Page**  
    - Purpose: Manage bulk test bookings for companies.  
    - Features: Corporate account setup, bulk booking options.  
    - Components: Account form, booking interface.  
    - Priority: Low (Future).

## Notes
- **Total Pages**: 30 (23 for MVP, 7 for future scope).
- **Navigation**: Mobile app uses bottom navigation (Home, Search, Bookings, Profile); web uses sidebar/topbar. Admin and lab dashboards have separate navigation menus.
- **Responsive Design**: All pages must be mobile-friendly (Flutter/React Native ensures consistency).
- **Dynamic Pages**: Pages like Test Details and Booking Management use dynamic content based on user input or database queries.
- **Security**: Pages handling sensitive data (e.g., Reports Download, Payments) require authentication and encryption.
- **Analytics Integration**: Pages like Admin Dashboard and Reports & Analytics should include charts for visualizing data (e.g., booking trends).

This page list covers all functional requirements from the PRD and ensures a complete user experience across all user types. If you need wireframes, specific UI/UX details, or a breakdown of any page’s components, let me know!