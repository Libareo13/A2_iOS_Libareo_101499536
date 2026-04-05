// Form view for adding a new product to Core Data
// AddProductView.swift
// A2_iOS_Libareo_101499536
// Libareo Barbour — 101499536
// COMP3097 — George Brown College

import SwiftUI

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var name        = ""
    @State private var description = ""
    @State private var priceText   = ""
    @State private var provider    = ""

    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    @State private var showingSuccessToast = false

    private var priceDouble: Double? { Double(priceText) }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        fieldLabel("Product Name")
                        TextField("e.g. Organic Honey (500g)", text: $name)
                            .textInputAutocapitalization(.words)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        fieldLabel("Provider / Supplier")
                        TextField("e.g. Honeybee Haven", text: $provider)
                            .textInputAutocapitalization(.words)
                    }
                } header: {
                    Text("Basic Info")
                }

                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        fieldLabel("Price (CAD)")
                        TextField("e.g. 12.99", text: $priceText)
                            .keyboardType(.decimalPad)
                    }
                } header: {
                    Text("Pricing")
                } footer: {
                    if !priceText.isEmpty && priceDouble == nil {
                        Label("Enter a valid number (e.g. 9.99)", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        fieldLabel("Product Description")
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                            .overlay(
                                Group {
                                    if description.isEmpty {
                                        Text("Describe the product, its origin, key features…")
                                            .foregroundColor(Color(.placeholderText))
                                            .font(.body)
                                            .padding(.top, 8)
                                            .padding(.leading, 5)
                                            .allowsHitTesting(false)
                                    }
                                },
                                alignment: .topLeading
                            )
                    }
                } header: {
                    Text("Description")
                }

                Section {
                    // Auto-generated info preview
                    HStack {
                        Label("Product ID", systemImage: "number.circle")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        Spacer()
                        Text("Auto-generated UUID")
                            .font(.caption)
                            .foregroundColor(Color(.tertiaryLabel))
                    }
                } header: {
                    Text("Auto-generated")
                } footer: {
                    Text("A unique Product ID (UUID) will be assigned automatically when you save.")
                        .font(.caption)
                }
            }
            .navigationTitle("Add New Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProduct()
                    }
                    .bold()
                    .disabled(!isFormValid)
                }
            }
            .alert("Missing Information", isPresented: $showingValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
            .overlay(
                Group {
                    if showingSuccessToast {
                        VStack {
                            Spacer()
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Product saved successfully!")
                                    .font(.subheadline.bold())
                            }
                            .padding()
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .padding(.bottom, 32)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            )
        }
    }

    // MARK: - Validation
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !provider.trimmingCharacters(in: .whitespaces).isEmpty &&
        priceDouble != nil && priceDouble! >= 0
    }

    // MARK: - Save
    private func saveProduct() {
        guard isFormValid else {
            validationMessage = "Please fill in all fields and enter a valid price."
            showingValidationAlert = true
            return
        }

        let product = Product(context: viewContext)
        product.productID          = UUID()
        product.name               = name.trimmingCharacters(in: .whitespaces)
        product.productDescription = description.trimmingCharacters(in: .whitespaces)
        product.price              = priceDouble ?? 0
        product.provider           = provider.trimmingCharacters(in: .whitespaces)

        do {
            try viewContext.save()
            withAnimation {
                showingSuccessToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        } catch {
            validationMessage = "Failed to save: \(error.localizedDescription)"
            showingValidationAlert = true
        }
    }

    // MARK: - Label helper
    @ViewBuilder
    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption.bold())
            .foregroundColor(.secondary)
            .textCase(.uppercase)
    }
}

// MARK: - Preview
struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
