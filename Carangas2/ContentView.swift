//
//  ContentView.swift
//  Carangas2
//
//  Created by Nazildo Souza on 22/04/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @ObservedObject var dataCars = DataCar()
    @State private var showingAddView = false
    
    var body: some View {
        
        ZStack {
            if self.dataCars.responseCode != 200 {
                Loading()
                
            } else {
                NavigationView {
                    VStack {
                        if self.dataCars.cars.count == 0 {
                            HStack {
                                Spacer()
                                Text("Não há carros adicionados.")
                                    .font(.headline)
                                Spacer()
                            }
                            
                        } else {
                            List {
                                ForEach(dataCars.cars, id: \._id) { car in
                                    NavigationLink(destination: CarView(car: car, dataCars: self.dataCars )) {
                                        HStack {
                                            Text(car.name)
                                                .font(.headline)
                                            Spacer()
                                            Text(car.brand)
                                        }
                                        .contextMenu {
                                            Button(action: {
                                                let utterance = AVSpeechUtterance(string: car.brand + car.name)
                                                utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
                                                let synthesyzer = AVSpeechSynthesizer()
                                                synthesyzer.speak(utterance)
                                                
                                            }) {
                                                Text("Ouça o nome do carro")
                                                Image(systemName: "speaker.2")
                                            }
                                        }
                                    }
                                }
                                .onDelete { index in
                                    let car = self.dataCars.cars[index.first!]
                                    self.dataCars.deleteCar(car: car)
                                    self.dataCars.cars.remove(atOffsets: index)
                                }
                                .onMove { (index, int) in
                                    self.dataCars.cars.move(fromOffsets: index, toOffset: int)
                                }
                                
                            }
                        }
                    }
                    .navigationBarTitle("Carangas")
                    .navigationBarItems(leading: EditButton(),
                                        trailing: Button(action: {
                                            self.dataCars.editOurAdd = 0
                                            self.showingAddView.toggle()
                                        }){
                                            Image(systemName: "plus")} )
                        
                        .sheet(isPresented: $showingAddView) {
                            AddCarView(dataCars: self.dataCars)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataCars: DataCar())
    }
}
