//
//  EstimatedIncomeCreateView.swift
//  EnvelopeBudgetApp
//
//  Created by Neethu Kuruvilla on 1/9/23.
//

import SwiftUI

struct EstimatedIncomeCreateView: View {
    @Environment(\.managedObjectContext) var saver
    
    var paymentPeriods = ["Weekly", "Biweekly", "Semimonthly", "Monthly"]
    //@State private var selectedPaymentPeriod : PaymentPeriod = .Weekly
    
    @State private var selectedPaymentPeriod = "Weekly"
    
    //@State private var amountText : String = ""
    
    @State private var amount : Double = 0.00
    
    var formatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    var body: some View {
        VStack{
            HStack{
            
                TextField("Amount of regular paycheck", value: $amount, formatter: formatter)
                .keyboardType(.decimalPad)
            
                Picker("Select payment period", selection: $selectedPaymentPeriod) {
                    ForEach(paymentPeriods, id: \.self){
                        Text($0)
                    }
                }
            
            }
            Button("Save") {
                print("save")
                
                //saveIncome(amount, selectedPaymentPeriod)
                do{
                    
                    let roundedAmount = decimalRounding(amount)
                    
                    let monthlyAmount = try getMonthlyAmount(checkAmount: roundedAmount, paymentPeriod: selectedPaymentPeriod)
                    
                    if monthlyAmount != -1{
                        let paymentNumberRep = try getPaymentPeriodNumber(selectedPaymentPeriod)
                        
                        let income = Incomes(context: saver)
                         income.amount = roundedAmount
                         income.paymentPeriod = paymentNumberRep
                         income.monthlyAmount = monthlyAmount
                         
                         try? saver.save()
                    }
                    
                    
                    
                }catch{
                    print("Error in getting monthly amount. Payment Period: \(selectedPaymentPeriod)")
                }
                
                
                
               
                
                
                
            }
        }
    }
}

struct EstimatedIncomeCreateView_Previews: PreviewProvider {
    static var previews: some View {
        EstimatedIncomeCreateView()
    }
}
