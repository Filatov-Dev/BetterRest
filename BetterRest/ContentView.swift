//
//  ContentView.swift
//  BetterRest
//
//  Created by Юрий Филатов on 19.07.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defoltWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMasage = ""
    @State private var shouingAlert = false
    
    var body: some View {
        
        NavigationView{
            
            Form{
                
                Text("When do you want to wake up")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                
                Text("Desered amount of sleep")
                    .font(.headline)
            
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                .padding()
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(value: $coffeeAmount, in: 1...20){
                    if coffeeAmount == 1 {
                        Text("1 cup")
                    } else {
                        Text("\(coffeeAmount) cups")
                    }
                }
                    
                    
                .padding()
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: calculateBedTime){
                    Text("Calculate")
                }
            )
            .alert(isPresented: $shouingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMasage), dismissButton: .default(Text("OK")))
            }
            
            
        }
        
        
    }
    
    
    static var defoltWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    
    func calculateBedTime(){
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
                model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMasage = formatter.string(from: sleepTime)
            alertTitle = "You ideal bedtime is..."
            
        } catch {
            alertTitle = "Error"
            alertMasage = "Sorry, there was a problem calculating you bedtime"
        }
        shouingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
