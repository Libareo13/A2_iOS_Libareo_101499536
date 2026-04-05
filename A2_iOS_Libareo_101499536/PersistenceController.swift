// PersistenceController.swift
// A2_iOS_Libareo_101499536
// Libareo Barbour — 101499536
// COMP3097 — George Brown College

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // MARK: - Preview helper
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ProductModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        seedDataIfNeeded()
    }

    // MARK: - Seed 12 products on first launch
    private func seedDataIfNeeded() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let count = (try? context.count(for: fetchRequest)) ?? 0
        guard count == 0 else { return }

        let seed: [(name: String, desc: String, price: Double, provider: String)] = [
            (
                name: "Organic Fuji Apples (3 lb bag)",
                desc: "Crisp, sweet Fuji apples grown on certified organic Ontario family farms. No pesticides, no wax coating. Perfect for snacking, salads, or baking.",
                price: 4.99,
                provider: "Ontario Orchard Co."
            ),
            (
                name: "Artisan Sourdough Loaf",
                desc: "Hand-shaped sourdough made with a 72-hour wild yeast starter. Thick crackly crust, open crumb, and a mildly tangy flavour. Baked fresh daily.",
                price: 7.49,
                provider: "The Bread Society"
            ),
            (
                name: "Free-Range Eggs (12 pack)",
                desc: "Farm-fresh eggs from free-range hens raised without hormones or antibiotics. Rich golden yolks from hens fed an all-vegetarian diet.",
                price: 5.99,
                provider: "Sunny Meadow Farms"
            ),
            (
                name: "Aged Ontario Cheddar (200g)",
                desc: "Cave-aged 24 months for a sharp, crumbly texture and complex flavour. Sourced from grass-fed cow dairy co-ops in Wellington County.",
                price: 8.99,
                provider: "Maple Crest Dairy"
            ),
            (
                name: "Extra Virgin Olive Oil (500ml)",
                desc: "Cold-pressed from first-harvest Taggiasca olives. Unfiltered and unblended, with a fruity aroma and a peppery finish. Imported from a family estate in Liguria, Italy.",
                price: 14.99,
                provider: "Terra Nova Imports"
            ),
            (
                name: "Raw Wildflower Honey (375g)",
                desc: "Unpasteurized wildflower honey harvested from hives across Ontario meadows. Naturally crystallizes over time — simply warm the jar to restore. No additives.",
                price: 11.49,
                provider: "Honeybee Haven"
            ),
            (
                name: "Grass-Fed Ground Beef (500g)",
                desc: "100% grass-fed and grass-finished beef, ground fresh daily. Lean with a deep, clean flavour. Raised on pasture without growth hormones.",
                price: 9.99,
                provider: "Greenfield Ranch"
            ),
            (
                name: "Organic Baby Spinach (142g)",
                desc: "Tender young spinach leaves, triple-washed and ready to eat straight from the bag. High in iron, folate, and vitamins A and C. USDA and Canada Organic certified.",
                price: 3.49,
                provider: "Green Valley Organics"
            ),
            (
                name: "Dark Roast Coffee Beans (340g)",
                desc: "Single-origin Ethiopian Yirgacheffe roasted to a full dark. Notes of dark chocolate, dried cherry, and a smooth, low-acid finish. Roasted locally in small batches.",
                price: 16.99,
                provider: "Roast & Republic"
            ),
            (
                name: "Natural Almond Butter (500g)",
                desc: "Stone-ground from dry-roasted whole almonds. No added sugar, no palm oil, no salt — just almonds. Stir once and refrigerate. Creamy, rich, and filling.",
                price: 10.49,
                provider: "Nutcraft Foods"
            ),
            (
                name: "Plain Greek Yogurt (750g)",
                desc: "Thick, strained whole-milk Greek yogurt with live active bacterial cultures. No artificial flavours, thickeners, or preservatives. High in protein — 17g per serving.",
                price: 6.49,
                provider: "Aegean Creamery"
            ),
            (
                name: "Canadian Shield Sparkling Water (1L)",
                desc: "Naturally carbonated mineral water sourced from a protected aquifer in the Laurentian Shield. Zero calories, zero sweeteners. Clean, crisp, and refreshing.",
                price: 2.99,
                provider: "Shield Spring Co."
            )
        ]

        for item in seed {
            let product = Product(context: context)
            product.productID = UUID()
            product.name = item.name
            product.productDescription = item.desc
            product.price = item.price
            product.provider = item.provider
        }

        do {
            try context.save()
        } catch {
            print("Seed data save failed: \(error)")
        }
    }

    // MARK: - Save helper
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Save error: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
