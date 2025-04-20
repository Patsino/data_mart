# 🎧 Vinyl Store — Modern Vinyl Record Marketplace

## 📌 Project Description

We are developing a modern online platform for buying and selling **vinyl records** — similar to Discogs, but with a strong focus on **usability, clean design**, and **mobile-first experience**.  
The platform is designed to serve both **collectors** and **casual users**, with full localization for the **CIS market**.

---

## 📊 Market & Audience Analysis

The **vinyl market is steadily growing**, especially among:
- Audiophiles
- Collectors
- Fans of analog sound

### 🎯 Target Audience:
- Men and women aged **25–45**
- Willing to pay for:
  - Rare releases
  - High-quality service
  - Easy and modern user experience

### 💰 Monetization Potential:
- Sales commissions
- Subscription models
- Featured collections & promotions

---

## 🎯 Business Goals

- Launch a robust online marketplace for vinyl records
- Improve vinyl access across **CIS countries**
- Become the **#1 vinyl sales platform in the region** within 2 years

---

## ⚙️ Core Functionality

### ✅ Functional Requirements:
- User registration, login, and personal accounts
- Advanced search and filtering:
  - By **genre**
  - By **artist**
  - By **release year**
  - By **price**
- Product detail pages with full information
- Order processing & shopping cart
- Buyer and seller profiles

### ⚙️ Non-Functional Requirements:
- Scalability (to support high traffic)
- Secure data storage
- Mobile-friendly, responsive UI
- Integration with:
  - Payment systems
  - Shipping APIs

---

## 🆚 Competitor Analysis

Compared to **Discogs** and **Avito**, our platform stands out due to:

- ✅ Minimalist, modern, and user-friendly interface
- ✅ Full localization for CIS countries
- ✅ Seller support & features for collectors
- ✅ Strong mobile UX
- ✅ Structured catalog with filters by **year**, **genre**, and **artist**

**Avito**:
- Not vinyl-focused  
- Lacks proper filters  
- Mostly second-hand, unstructured listings

**Discogs**:
- Powerful, but has outdated and cluttered UI  
- Not friendly for casual users  

---

## 🌟 North Star Metric & KPIs

### 🎯 North Star:
- **Number of successful transactions**

### 📈 Key KPIs:
- Number of registered users
- Average order value
- Number of new vinyl listings
- Customer retention rate (repeat purchases)

---

## ⚠️ Risks & Mitigation

### 🚧 Potential Risks:
- **Low initial traffic**
- **Strong competition** from larger marketplaces

### 🛡️ Mitigation Strategies:
- Leverage social media & target niche communities
- Focus on **UX**, **local support**, and **community building**

---

## 🗄️ Database Overview

We use **PostgreSQL** as the primary relational database.

The schema includes 7 main tables:

- `Customer` — User data (buyers/sellers)
- `VinylRecord` — Record listings
- `Order` / `OrderItem` — Order and cart data
- `Artist` / `Genre` — Reference data
- `__EFMigrationsHistory` — For Entity Framework migrations

### ✅ Supported Features:
- Authentication and authorization
- Order/cart management
- Analytics: sales, genres, artists, users

---

## 🧩 Tables and Relationships

### 👤 Customer
Stores user data (buyers & sellers)
- `Id`, `FirstName`, `LastName`
- `Email`, `Phone`, `Password`
- `Role` (admin / buyer / seller)

🔗 **1-to-many**: A customer can place many orders

---

### 📦 Order
- `Id`, `OrderDate`, `CustomerId`

🔗 **1-to-many**: An order has many OrderItems

---

### 🧾 OrderItem
- `Id`, `OrderId`, `VinylRecordId`, `Quantity`, `Price`

---

### 💿 VinylRecord
- `Id`, `Title`, `Year`, `ArtistId`, `GenreId`, `Price`

🔗 Many-to-one: linked to Artist and Genre

---

### 🎸 Artist
- `Id`, `Name`

🔗 One-to-many: one artist → many records

---

### 🎼 Genre
- `Id`, `Name`

🔗 One-to-many: one genre → many records

---

### ⚙️ __EFMigrationsHistory
- Technical table for tracking EF Core migrations

---

## 🔑 Key Notes

- Fully normalized schema — no data duplication
- Built for scalability and growth
- Enables detailed analytics (e.g. most popular genres, top-selling artists)
- Secure and production-ready design

---

📍 *This document reflects the current architectural and business goals of the Vinyl Store project.*
