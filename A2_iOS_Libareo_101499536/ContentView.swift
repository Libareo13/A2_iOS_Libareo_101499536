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

    var body: some View {
        NavigationView {
            VStack {
                if products.isEmpty {
                    ProgressView("Loading products...")
                } else {
                    Text(products[currentIndex].name ?? "Unknown")
                        .font(.title)
                        .padding()

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
                        Text("\(currentIndex + 1) of \(products.count)")
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
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Product Viewer")
        }
        .navigationViewStyle(.stack)
    }
}