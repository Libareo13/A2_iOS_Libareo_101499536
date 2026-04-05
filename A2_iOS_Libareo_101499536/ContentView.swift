// Main view - displays first product and handles navigation


// ContentView.swift
// A2_iOS_Libareo_101499536
// Libareo Barbour — 101499536
// COMP3097 — George Brown College

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<Product>

    @State private var currentIndex: Int = 0
    @State private var showingList   = false
    @State private var showingAdd    = false
    @State private var showingSearch = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if products.isEmpty {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.4)
                        Text("Loading products…")
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack(spacing: 0) {
                        // Product card
                        ProductDetailCard(product: products[currentIndex])
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .id(currentIndex) // triggers re-render and animation on index change
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                            .animation(.easeInOut(duration: 0.25), value: currentIndex)

                        Spacer(minLength: 16)

                        // Navigation bar
                        navigationControls
                            .padding(.horizontal, 32)
                            .padding(.bottom, 28)
                    }
                }
            }
            .navigationTitle("-Product Viewer-")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSearch = true
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingList = true
                    } label: {
                        Label("All Products", systemImage: "list.bullet")
                    }
                    Button {
                        showingAdd = true
                    } label: {
                        Label("Add Product", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingList) {
                ProductListView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $showingAdd) {
                AddProductView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $showingSearch) {
                SearchView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Navigation Controls
    private var navigationControls: some View {
        HStack {
            Button {
                withAnimation { currentIndex -= 1 }
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(currentIndex > 0 ? .accentColor : Color(.systemGray4))
            }
            .disabled(currentIndex == 0)

            Spacer()

            VStack(spacing: 2) {
                Text("\(currentIndex + 1)")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                Text("of \(products.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button {
                withAnimation { currentIndex += 1 }
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(currentIndex < products.count - 1 ? .accentColor : Color(.systemGray4))
            }
            .disabled(currentIndex == products.count - 1)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
