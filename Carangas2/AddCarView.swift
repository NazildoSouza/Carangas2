//
//  AddCarView.swift
//  Carangas2
//
//  Created by Nazildo Souza on 22/04/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct AddCarView: View {
    
    @ObservedObject var dataCars: DataCar
    @Environment(\.presentationMode) var endAddCar
    
    var brand: [String] {
        var brands: [String] = []
        for i in self.dataCars.brands {
            brands.append(i.fipe_name)
        }
        return brands
    }
    
    let formatter = NumberFormatter()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Marca do Veículo")) {
                    Picker("Marca", selection: $dataCars.brandSelection) {
                        ForEach(self.brand, id: \.self ) {
                            Text($0)
                        }
                    }
                    .onAppear(perform: dataCars.loadBrands)
                }
                
                Section(header: Text("Nome do Veículo")) {
                    TextField("Nome", text: $dataCars.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .onTapGesture {
                    self.hiddenKeyboard()
                }
                
                Section(header: Text("Preço do Veículo")) {
                    TextField("Preço", text: $dataCars.price)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .onTapGesture {
                    self.hiddenKeyboard()
                }
                
                Section(header: Text("Combustivel do Veículo")) {
                    Picker("Combustivel", selection: $dataCars.gasType) {
                        ForEach(0 ..< DataCar.types.count) {
                            Text(DataCar.types[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                HStack(alignment: .top) {
                    Spacer()
                    Button(action: {
                        
                        if self.dataCars.editOurAdd == 0 {
                            print("id nil \(String(describing: self.dataCars.indexId))")
                            
                            if let actualPrice = Double(self.dataCars.price) {
                                let car = Car(brand: self.dataCars.brandSelection, gasType: self.dataCars.gasType, name: self.dataCars.name, price: actualPrice)
                                
                                DispatchQueue.main.async {
                                    self.dataCars.saveCar(car: car)
                                }
                            }
                        } else {
                            print("id salvo \(String(describing: self.dataCars.indexId))")
                            
                            if let actualPrice = Double(self.dataCars.price) {
                                let car = Car(_id: self.dataCars.indexId, brand: self.dataCars.brandSelection, gasType: self.dataCars.gasType, name: self.dataCars.name, price: actualPrice)
                                
                                DispatchQueue.main.async {
                                    self.dataCars.updateCar(car: car)
                                    
                                }
                            }
                        }
                        self.endAddCar.wrappedValue.dismiss()
                    }) {
                        
                        Text(dataCars.editOurAdd == 0 ? "Cadastrar Carro" : "Alterar Carro")
                        
                    }
                    .disabled(self.dataCars.name.isEmpty || self.dataCars.brandSelection.isEmpty || self.dataCars.price.isEmpty)
                    Spacer()
                }
                
            }
            .onDisappear(perform: dataCars.loadCars)
            .navigationBarTitle(dataCars.editOurAdd == 0 ? "Cadastro" : "Alterar Cadastro")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func hiddenKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddCarView_Previews: PreviewProvider {
    static var previews: some View {
        AddCarView(dataCars: DataCar())
    }
}
