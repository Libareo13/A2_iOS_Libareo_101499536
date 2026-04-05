// Displays all products in a scrollable list with swipe-to-delete
// Added ProductRowView below
// ProductListView.swift
// A2_iOS_Libareo_101499536
// Libareo Barbour — 101499536
// COMP3097 — George Brown College

import SwiftUI
import CoreData

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<Product>

    @State private var selectedProduct: Product? = nil

    var body: some View {
        NavigationView {
            Group {
                if products.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No products yet.")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(products) { product in
                            Button {
                                selectedProduct = product
                            } label: {
                                ProductRowView(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: deleteProducts)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("All Products (\(products.count))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $selectedProduct) { product in
                ProductFullDetailView(product: product)
            }
        }
    }

    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

// MARK: - Row used in the list
struct ProductRowView: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            // Price badge
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 60, height: 44)
                Text(String(format: "$%.2f", product.price))
                    .font(.caption.bold())
                    .foregroundColor(.accentColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(product.name ?? "Unnamed")
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(product.productDescription ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.systemGray3))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Full detail sheet opened from list
struct ProductFullDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let product: Product

    var body: some View {
        NavigationView {
            ScrollView {
                ProductDetailCard(product: product)
                    .padding()
            }
            .navigationTitle("Product Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Previews
struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
