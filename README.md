# A2_iOS_Libareo_101499536

**COMP3097 — iOS Development**
**George Brown College**
**Student:** Libareo Barbour | **ID:** 101499536
**GitHub:** [@Libareo13](https://github.com/Libareo13)

---

## Overview

An iPhone app built with **SwiftUI** and **Core Data** that manages a product catalogue.  
The app ships with **12 pre-seeded grocery products** and supports full CRUD navigation.

---

## Features

| Feature | Description |
|---|---|
| 🚀 Auto-load | Opens to the first product in the database on launch |
| ⬅️ ➡️ Navigate | Swipe through all products using Prev / Next controls |
| 🔍 Search | Search by product name or description keyword |
| ➕ Add | Add a new product via a validated form (name, description, price, provider) |
| 📋 List | Full scrollable product list with name, description, and price badge |
| 🗑️ Delete | Swipe-to-delete in the product list |
| 💾 Core Data | All data persisted locally; seeded once on first launch |

---

## Project Structure

```
A2_iOS_Libareo_101499536/
├── A2_iOS_Libareo_101499536App.swift   ← App entry point
├── ContentView.swift                   ← Main view + prev/next navigation
├── PersistenceController.swift         ← Core Data stack + 12 seed products
├── ProductModel.xcdatamodeld/          ← Core Data model (Product entity)
│   └── ProductModel.xcdatamodel/
│       └── contents
├── Views/
│   ├── ProductDetailCard.swift         ← Reusable product card UI
│   ├── ProductListView.swift           ← Full list + swipe-to-delete
│   ├── AddProductView.swift            ← Add new product form
│   └── SearchView.swift               ← Live search with dynamic predicate
├── Assets.xcassets/
└── Preview Content/
```

---

## Core Data Model — Product Entity

| Attribute | Type | Notes |
|---|---|---|
| `productID` | UUID | Auto-generated on save |
| `name` | String | Product name |
| `productDescription` | String | Full description |
| `price` | Double | CAD price |
| `provider` | String | Supplier / vendor |

---

## Requirements

- **Xcode 15+** (Swift 5.9)
- **iOS 16.0+** deployment target
- **iPhone** (TARGETED_DEVICE_FAMILY = 1)

---

## Setup

```bash
# Clone
git clone https://github.com/Libareo13/A2_iOS_Libareo_101499536.git
cd A2_iOS_Libareo_101499536

# Open in Xcode
open A2_iOS_Libareo_101499536.xcodeproj
```

Select an iPhone simulator or a connected device, then press **⌘R** to run.

---

## Git Workflow (20+ Commits)

See commit history on GitHub. Commit milestones include:

1. Initial project scaffold with Core Data template
2. Add Product entity to xcdatamodeld
3. Implement PersistenceController with Core Data stack
4. Add seed data for 12 grocery products
5. Build ContentView with FetchRequest
6. Implement prev/next navigation controls
7. Add ProductDetailCard component
8. Style card header with accent gradient
9. Add info rows with SF Symbols in card
10. Build ProductListView with List
11. Add ProductRowView with price badge
12. Implement swipe-to-delete in list
13. Add ProductFullDetailView sheet from list
14. Build AddProductView form
15. Add form validation logic to AddProductView
16. Implement success toast in AddProductView
17. Build SearchView with dynamic NSPredicate
18. Add empty state views to SearchView
19. Connect all sheets to ContentView toolbar
20. Polish animations and navigation transitions
21. Add README and .gitignore
22. Final cleanup and submission prep

---

## License

Academic submission — George Brown College COMP3097, Winter 2025.
