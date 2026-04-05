// Reusable card component for displaying full product details
// ProductDetailCard.swift
// A2_iOS_Libareo_101499536
// Libareo Barbour — 101499536
// COMP3097 — George Brown College

import SwiftUI

struct ProductDetailCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header bar with category colour
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PRODUCT info")
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
            .padding(.bottom, 1)

            // Body
            VStack(alignment: .leading, spacing: 16) {

                // ID Row
                infoRow(
                    icon: "number.circle.fill",
                    label: "Product ID",
                    value: product.productID?.uuidString ?? "N/A",
                    isMonospaced: true
                )

                Divider()

                // Provider Row
                infoRow(
                    icon: "building.2.fill",
                    label: "Provider",
                    value: product.provider ?? "Unknown"
                )

                Divider()

                // Description
                VStack(alignment: .leading, spacing: 6) {
                    Label("Description", systemImage: "doc.text.fill")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    Text(product.productDescription ?? "No description available.")
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }

    // MARK: - Helper row
    @ViewBuilder
    private func infoRow(icon: String, label: String, value: String, isMonospaced: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(value)
                    .font(isMonospaced ? .caption.monospaced() : .body)
                    .foregroundColor(.primary)
                    .lineLimit(isMonospaced ? 2 : nil)
                    .truncationMode(.middle)
            }
        }
    }
}
