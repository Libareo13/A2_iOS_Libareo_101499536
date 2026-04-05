// SearchView.swift
// A2_iOS_Libareo_101499536
// Libareo Barbour — 101499536
// COMP3097 — George Brown College

import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedProduct: Product? = nil

    // Dynamic fetch using the search predicate
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        predicate: nil,
        animation: .default
    )
    private var results: FetchedResults<Product>

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)

                    TextField("Search by name or description…", text: $searchText)
                        .submitLabel(.search)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: searchText) { newValue in
                            updatePredicate(query: newValue)
                        }

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                            updatePredicate(query: "")
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding()

                Divider()

                // Results
                if searchText.isEmpty {
                    emptyStateView(
                        icon: "magnifyingglass",
                        title: "Search Products",
                        subtitle: "Type a product name or keyword from its description to find matching products."
                    )
                } else if results.isEmpty {
                    emptyStateView(
                        icon: "tray.fill",
                        title: "No Results",
                        subtitle: "No products matched "\(searchText)". Try a different keyword."
                    )
                } else {
                    List {
                        Section {
                            ForEach(results) { product in
                                Button {
                                    selectedProduct = product
                                } label: {
                                    ProductRowView(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        } header: {
                            Text("\(results.count) result\(results.count == 1 ? "" : "s") for "\(searchText)"")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $selectedProduct) { product in
                ProductFullDetailView(product: product)
            }
        }
    }

    // MARK: - Predicate update
    private func updatePredicate(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            results.nsPredicate = nil
        } else {
            results.nsPredicate = NSPredicate(
                format: "name CONTAINS[cd] %@ OR productDescription CONTAINS[cd] %@",
                trimmed, trimmed
            )
        }
    }

    // MARK: - Empty state
    @ViewBuilder
    private func emptyStateView(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(Color(.systemGray3))
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
