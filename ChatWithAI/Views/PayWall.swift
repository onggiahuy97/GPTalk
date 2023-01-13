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
                    Text("With subscription, you will get full potential of the app ♥️")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 25)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    
                    Divider()
                        .padding()
                    
                    makeInfoRow("Choose any model to use", icon: "cube.transparent")
                    makeInfoRow("Get full answer of every question", icon: "pencil.line")
                    makeInfoRow("Fix more grammar with AI", icon: "wrench.and.screwdriver")
                    makeInfoRow("Delete all or any chat", icon: "trash")
                        .padding(.bottom)
                    
                    if let packages = userVM.offerings?.current?.availablePackages, !packages.isEmpty {
                        ForEach(packages) { package in
                            PackageCellView(package: package, selectedPackage: $selectedPackage) { package in
                                withAnimation {
                                    selectedPackage = package
                                }
                            }
                        }
                    } else {
                        Text("Fetching Subscriptions Package...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .foregroundColor(.secondary)
                    }
                    
                    Button {
                        Task {
                            guard selectedPackage != nil else { return }

                            isPurchasing = true
                            
                            do {
                                let result = try await Purchases.shared.purchase(package: selectedPackage!)
                                self.isPurchasing = false
                                if !result.userCancelled {
                                    Purchases.shared.getCustomerInfo { customerInfo, _ in
                                        userVM.subscriptionActive = customerInfo?.entitlements[Constants.entitlementID]?.isActive == true
                                    }
                                    self.dismiss()
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
                
                Button("Restore Purchases") {
                    Purchases.shared.restorePurchases { customerInfo, _ in
                        userVM.subscriptionActive = customerInfo?.entitlements[Constants.entitlementID]?.isActive == true
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.secondary)
                
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
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: systemName)
                .frame(width: 44, height: 44)
            Text(title)
        }
            .bold()
            .font(.title3)
            .foregroundColor(.gray)
    }
    
    
    
}

struct PackageCellView: View {

    let package: Package
    
    @Binding var selectedPackage: Package?
    
    let onSelection: (Package) async -> Void
    
    var isSelected: Bool {
        package == selectedPackage
    }
    
    var body: some View {
        Button {
            Task {
                await self.onSelection(self.package)
            }
        } label: {
            self.buttonLabel
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke()
                .foregroundColor(isSelected ? .accentColor : .secondary)
        )
    }

    private var buttonLabel: some View {
        HStack {
            if isSelected {
                Image(systemName: "checkmark")
            }
            
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
