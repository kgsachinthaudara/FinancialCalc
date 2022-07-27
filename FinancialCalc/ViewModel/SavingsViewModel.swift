//
//  SavingsViewModel.swift
//  FinancialCalc
//
//  Created by user on 2022-07-28.
//

import SwiftUI

class SavingsViewModel: ObservableObject {
    
    private let userDefaults = UserDefaults.standard;
    private let commonFunctions = CommonFunctions()
    
    @Published var futureValue = FormComponentModel(value: "", keyTag: "futureValue") {
            didSet {
                userDefaults.set(futureValue.value, forKey: futureValue.keyTag)
                futureValue.clearError()
            }
        }
    @Published var compundsPerYear = FormComponentModel(value: "", keyTag: "compundsPerYear") {
            didSet {
                userDefaults.set(compundsPerYear.value, forKey: compundsPerYear.keyTag)
                compundsPerYear.clearError()
            }
        }
    
    @Published var interest = FormComponentModel(value: "", keyTag: "interest") {
            didSet {
                userDefaults.set(interest.value, forKey: interest.keyTag)
                interest.clearError()
            }
        }
    @Published var payment = FormComponentModel(value: "", keyTag: "payment") {
            didSet {
                userDefaults.set(payment.value, forKey: payment.keyTag)
                payment.clearError()
            }
        }
    @Published var paymentMadeAtEnd = false {
            didSet {
                userDefaults.set(paymentMadeAtEnd, forKey:"paymentMadeAtEnd")
            }
        }
    @Published var paymentsPerYear = FormComponentModel(value: "", keyTag: "paymentsPerYear") {
            didSet {
                userDefaults.set(paymentsPerYear.value, forKey: paymentsPerYear.keyTag)
                paymentsPerYear.clearError()
            }
        }
    @Published var presentValue = FormComponentModel(value: "", keyTag: "presentValue") {
            didSet {
                userDefaults.set(presentValue.value, forKey: presentValue.keyTag)
                presentValue.clearError()
            }
        }
    
    init() {
        // get user default values if available and set to the each instance value property
        self.compundsPerYear.value = userDefaults.string(forKey: compundsPerYear.keyTag) ?? ""
        self.futureValue.value = userDefaults.string(forKey: futureValue.keyTag) ?? ""
        self.interest.value = userDefaults.string(forKey: interest.keyTag) ?? ""
        self.payment.value = userDefaults.string(forKey: payment.keyTag) ?? ""
        self.paymentsPerYear.value = userDefaults.string(forKey: paymentsPerYear.keyTag) ?? ""
        self.presentValue.value = userDefaults.string(forKey: presentValue.keyTag) ?? ""
        
        if userDefaults.object(forKey: "paymentMadeAtEnd") != nil
        {
            self.paymentMadeAtEnd = userDefaults.bool(forKey: "paymentMadeAtEnd")
        } else {
            self.paymentMadeAtEnd = false
        }
    }
    
    // calc button press handler
    func onPressCalc() {
        self.prepareEachValue(formComponent: paymentsPerYear)
        self.prepareEachValue(formComponent: futureValue)
        self.prepareEachValue(formComponent: presentValue)
        self.prepareEachValue(formComponent: interest)
        self.prepareEachValue(formComponent: payment)
        self.prepareEachValue(formComponent: compundsPerYear)

        self.validateForm()
        objectWillChange.send()
    }
    
    private func prepareEachValue(formComponent: FormComponentModel)
    {
        if let value = Double(formComponent.value) {
            formComponent.isEmpty = false
            let formattedValue  = commonFunctions.getFormattedDecimalDouble(value: value)
            formComponent.formattedValue = formattedValue
            formComponent.value = commonFunctions.getFormattedDecimalString(value: formattedValue)
        } else {
            formComponent.isEmpty = true
            formComponent.formattedValue = 0
        }
    }
    
    private func validateForm()
    {
        // Empty fields store
        var emptyFormComponents = [FormComponentModel] ()

        // Calculation method store
        var functionToPerform : (() -> ())?

        if(presentValue.isEmpty)
        {
            emptyFormComponents.append(presentValue)
            functionToPerform = calculatePresentValue
        }
        if(futureValue.isEmpty)
        {
            emptyFormComponents.append(futureValue)
            functionToPerform = calculateFutureValue
        }
        if(interest.isEmpty)
        {
            emptyFormComponents.append(interest)
            functionToPerform = calculateInterest
        }
        if(paymentsPerYear.isEmpty)
        {
            emptyFormComponents.append(paymentsPerYear)
            functionToPerform = calculateNoOfPayment
        }
        if(compundsPerYear.isEmpty)
        {
            emptyFormComponents.append(compundsPerYear)
        }


        // If not empty field, display alert
        if(emptyFormComponents.count == 0)
        {
            displayAlert()
        }

        // found exaclty one empty field to perform our operation
        else if(emptyFormComponents.count == 1)
        {
            interest.formattedValue = interest.formattedValue/100 //0.50

            //calculate future value based on PMT
            if(futureValue.formattedValue == 0)
            {
               calculateFutureValue()
            }
            else
            {
                if functionToPerform != nil
                {
                    // we need the payment value only when calculating future value, therefore clear payment value
                    payment.value = "0"
                    prepareEachValue(formComponent: payment)

                    functionToPerform!()
                }
            }

            // !!! TODO
//            storeCalculatedData()
        }
        else
        {
            // Show red text fields
            emptyFormComponents.forEach {formCoponent in
                formCoponent.setError()
            }
        }

    }

   // Different calculators
    func calculatePresentValue()
     {
         let a =  compundsPerYear.formattedValue * paymentsPerYear.formattedValue
         let b =   1 + (interest.formattedValue/compundsPerYear.formattedValue)
         presentValue.formattedValue = futureValue.formattedValue / pow(b,a)
         presentValue.value = commonFunctions.getFormattedDecimalString(value: presentValue.formattedValue)
     }

    func calculateInterest()
    {
//        let a =  1 / (noOfCompounds * noOfPayments)
//        let b =  futureValue / presentValue
//        interestRate = (pow(b,a) - 1) * noOfCompounds * 100
//        interestTF.text = commonFunctions.getFormattedDecimalString(value: interestRate)
//        interestTF.answerDetected()
    }

    func calculateNoOfPayment()
    {
//        let a =  log(futureValue / presentValue)
//        let b =   log(1 + (interestRate/noOfCompounds)) * noOfCompounds
//        noOfPayments = a/b
//        noOfPaymentsTF.text = commonFunctions.getFormattedDecimalString(value: noOfPayments)
//        noOfPaymentsTF.answerDetected()
    }

    func calculateFutureValue()
    {
//        let a = noOfCompounds * noOfPayments
//        let b =  1 + (interestRate/noOfCompounds)
//        futureValue = pow(b,a) * presentValue
//
//        if(payment > 0)
//        {
//            if(isPMTEnd)
//            {
//                futureValue += calculateFutureValueofSeriesEnd(a: a, b: b)
//            }
//            else
//            {
//                futureValue += calculateFutureValueofSeriesBegining(a: a, b: b)
//            }
//        }
//
//        paymentTF.text = commonFunctions.getFormattedDecimalString(value: payment)
//        futureValueTF.text = commonFunctions.getFormattedDecimalString(value: futureValue)
//        futureValueTF.answerDetected()

    }


    func calculateFutureValueofSeriesEnd(a: Double, b: Double) -> Double
    {
        let answer: Double = payment.formattedValue * ((pow(b,a) - 1)/(interest.formattedValue/compundsPerYear.formattedValue))
        return answer
    }

    func calculateFutureValueofSeriesBegining(a: Double, b: Double) -> Double
    {
        let answer: Double = calculateFutureValueofSeriesEnd(a: a, b: b) * b
        return answer
    }

    func calculatePayment()
    {
//        interestRate = interestRate/100
//
//        let a =  noOfCompounds * noOfPayments
//        let b =   1 + (interestRate/noOfCompounds)
//        let c = ((pow(b,a) - 1)/(interestRate/noOfCompounds))
//
//        let futureValueOfSeries: Double = futureValue - (pow(b,a) * presentValue)
//        var finalAnswer: Double = 0
//
//        if(isPMTEnd)
//        {
//            finalAnswer = futureValueOfSeries / c
//        }
//        else
//        {
//            finalAnswer = futureValueOfSeries / (c * b)
//        }
//        paymentTF.text = commonFunctions.getFormattedDecimalString(value: finalAnswer)
//        paymentTF.answerDetected()
    }

    func displayAlert()
    {
//         let alert = UIAlertController(title: "Alert", message: "Please leave one of the values blank to perform the calculation", preferredStyle: .alert)
//         alert.addAction(UIAlertAction(title: "OK", style: .default))
//         self.present(alert, animated: true, completion: nil)
    }
    
    func clearValues() {
        self.compundsPerYear.value = ""
        self.futureValue.value = ""
        self.interest.value = ""
        self.payment.value = ""
        self.paymentMadeAtEnd = false
        self.paymentsPerYear.value = ""
        self.presentValue.value = ""
    }
}
