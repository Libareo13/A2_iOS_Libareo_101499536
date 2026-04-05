import SwiftUI

struct ProductDetailCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PRODUCT DETAILS")
                        .font(.caption2.bold())
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.75))
                    Text(product.name ?? "Unnamed Product")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                Spacer()
                Text(String(format: "$%.2f", product.price))
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.accentColor, Color.accentColor.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}