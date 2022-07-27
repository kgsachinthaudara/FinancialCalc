//
//  SavingsView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-27.
//

import SwiftUI

enum PlusMinus: String {
    case plus = "+"
    case minus = "-"
}

struct SavingsView: View {
    
    @ObservedObject private var viewModel = SavingsViewModel()
    @State private var plusMinus = PlusMinus.plus
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemGreen
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black], for: .selected
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Form view design
                Form {
                    Section {
                        VStack(alignment: .leading) {
                            TextField("Present Value", text: $viewModel.presentValue.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.presentValue.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            TextField("Future Value", text: $viewModel.futureValue.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.futureValue.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            TextField("Interest (%)", text: $viewModel.interest.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.interest.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                    }
                    
                    Section {
                        VStack(alignment: .leading) {
                            TextField("No of Payments Per Year", text: $viewModel.paymentsPerYear.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.paymentsPerYear.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            TextField("Compounds Per Year", text: $viewModel.compundsPerYear.value)
                                .keyboardType(.decimalPad)
                            
                            if viewModel.compundsPerYear.isError {
                                Text("Invalid entry")
                                    .foregroundColor(.red).opacity(0.7)
                                    .font(.system(size: 10, weight: .semibold)
                                    )
                            }
                        }
                    }
                    
                    Section(header: Text("Payment")) {
                        HStack(spacing: 16) {
                            Picker("", selection: $plusMinus) {
                                Text(PlusMinus.plus.rawValue)
                                    .tag(PlusMinus.plus)
                                Text(PlusMinus.minus.rawValue)
                                    .tag(PlusMinus.minus)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 100)
                            
                            VStack(alignment: .leading) {
                                TextField("Value", text: $viewModel.payment.value)
                                    .keyboardType(.decimalPad)
                                
                                if viewModel.payment.isError {
                                    Text("Invalid entry")
                                        .foregroundColor(.red).opacity(0.7)
                                        .font(.system(size: 10, weight: .semibold)
                                        )
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Payment Made At")) {
                        Picker("", selection: $viewModel.paymentMadeAtEnd) {
                            Text("Beginning")
                                .tag(false)
                            Text("End")
                                .tag(true)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Calculate button
                    Button(action: {
                        viewModel.onPressCalc()
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .overlay(
                                Text("Calculat")
                                    .foregroundColor(
                                        Color(.white)
                                    )
                            )
                    }
                    
                }
            }
            
            // Navigation view config
            .navigationTitle("Savings")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    /* MARK: TODO
                     1. Calculate button
                     2. Keyboard dismiss button
                    */
            
                    Button {
                        print("On click history")
                    } label: {
                        VStack {
                            Label("", systemImage: "clock.arrow.circlepath")
                            Text(NSLocalizedString("history", comment: ""))
                                .font(
                                    .system(size: 8, weight: .heavy, design: .rounded)
                                )
                        }
                    }
                    
                    Button {
                        print("On click help")
                    } label: {
                        VStack {
                            Label("", systemImage: "questionmark.circle")
                            Text(NSLocalizedString("help", comment: ""))
                                .font(
                                    .system(size: 8, weight: .heavy, design: .rounded)
                                )
                        }
                        
                    }
                    
                    Button {
                        viewModel.clearValues()
                    } label: {
                        VStack {
                            Label("", systemImage: "clear")
                            Text(NSLocalizedString("clear", comment: ""))
                                .font(
                                    .system(size: 8, weight: .heavy, design: .rounded)
                                )
                        }
                        
                    }
                    
                }
            }
        }
//         Hide the keyboard when tap on outside
//        .onTapGesture {
//            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        }
//        .gesture(
//            DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ gesture in
//                if gesture.translation.height > 0 {
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }
//        }))
    }
}

struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsView()
    }
}
