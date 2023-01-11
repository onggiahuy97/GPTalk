//
//  PayWall.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/10/23.
//

import SwiftUI
import RevenueCat

struct PayWall: View {
    @EnvironmentObject var userVM: UserViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private(set) var isPurchasing = false
    @State private(set) var error: NSError?
    @State private var displayError: Bool = false
    @State private var selectedPackage: Package?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    makeInfoRow("Choose any model to use", icon: "cube.transparent")
                    makeInfoRow("Get full answer of every question", icon: "pencil.line")
                    
                    ForEach(userVM.offerings?.current?.availablePackages ?? []) { package in
                        PackageCellView(package: package) { package in
                            selectedPackage = package
                        }
                    }
                    
                    Button {
                        Task {
                            guard selectedPackage != nil else { return }

                            isPurchasing = true
                            
                            do {
                                let result = try await Purchases.shared.purchase(package: selectedPackage!)
                                self.isPurchasing = false
                                if !result.userCancelled {
                                    
                                }
                            } catch {
                                self.isPurchasing = false
                                self.error = error as NSError
                                self.displayError = true
                            }
                        }
                    } label: {
                        Text(isPurchasing ? "Processing..." : "Subscribe")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .bold()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(.blue)
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Subscriptions")
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.accentColor)
                }
            }
            .alert(
                isPresented: self.$displayError,
                error: self.error,
                actions: { _ in
                    Button(role: .cancel,
                           action: { self.displayError = false },
                           label: { Text("OK") })
                },
                message: { Text($0.localizedRecoverySuggestion ?? "Please try again") }
            )
        }
    }
    
    private func makeInfoRow(_ title: String, icon systemName: String) -> some View {
        Label(title, systemImage: systemName)
            .bold()
            .font(.title3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.gray)
    }
    
    
    struct PackageCellView: View {

        let package: Package
        let onSelection: (Package) async -> Void
        
        
        var body: some View {
            Button {
                Task {
                    await self.onSelection(self.package)
                }
            } label: {
                self.buttonLabel
            }
            .buttonStyle(.plain)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke()
                    .foregroundColor(.secondary)
            )
        }

        private var buttonLabel: some View {
            HStack {
                VStack {
                    HStack {
                        Text(package.storeProduct.localizedTitle)
                            .font(.title3)
                            .bold()
                        
                        Spacer()
                    }
                    HStack {
                        Text(package.terms(for: package))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .padding([.top, .bottom], 8.0)
                
                Spacer()
                
                VStack {
                    Text(package.localizedPriceString)
                        .font(.title3)
                        .bold()
                    Text(package.storeProduct.subscriptionPeriod?.periodTitle ?? "")
                        .foregroundColor(.secondary)
                }
            }
            .contentShape(Rectangle()) // Make the whole cell tappable
        }

    }
}


extension NSError: LocalizedError {

    public var errorDescription: String? {
        return self.localizedDescription
    }

}

struct PayWall_Previews: PreviewProvider {
    static var previews: some View {
        PayWall()
    }
}
