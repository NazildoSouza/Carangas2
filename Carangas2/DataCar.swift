//
//  DataCar.swift
//  Carangas2
//
//  Created by Nazildo Souza on 22/04/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

class DataCar: ObservableObject {
    @Published var cars = [Car]()
    @Published var brands = [Brand]()
    @Published var responseCode = 0
    @Published var indexId = ""
   
    @Published var editOurAdd = 0 {
        didSet {
            if editOurAdd == 0 {
                name = ""
                brandSelection = ""
                price = ""
                gasType = 0
            }
        }
    }
    
    @Published var name = ""
    @Published var brandSelection = ""
    @Published var price = ""

    @Published var gasType = 0
    static let types = ["Flex", "Álcool", "Gasolina"]
    
    init() { self.loadCars() }
    
    func loadBrands() {
        guard let url = URL(string: "https://fipeapi.appspot.com/api/1/carros/marcas.json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let brands = try JSONDecoder().decode([Brand].self, from: data)
                
                DispatchQueue.main.async {
                    self.brands = brands.sorted(by: { $0.fipe_name < $1.fipe_name })
                }
            } catch {
                print("Erro ao decodificar JSON:\n\(error)")
            }
        }.resume()
    }
    
    func loadCars() {
        guard let url = URL(string: "https://carangas.herokuapp.com/cars") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse else { return }
            do {
                let cars = try JSONDecoder().decode([Car].self, from: data)
                
                DispatchQueue.main.async {
                    self.cars = cars
                    self.responseCode = response.statusCode
                }
            } catch {
                print("Erro ao decodificar JSON:\n\(error)")
            }
        }.resume()
    }
    
    func saveCar(car: Car) {
        guard let encoded = try? JSONEncoder().encode(car) else { return }
        
        guard let url = URL(string: "https://carangas.herokuapp.com/cars") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request).resume()
    }
    
    func updateCar(car: Car) {
        guard let encoded = try? JSONEncoder().encode(car) else { return }
        
        guard let url = URL(string: "https://carangas.herokuapp.com/cars/\(self.indexId)") else {
            print("erro na url")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request).resume()
    }
    
    func deleteCar(car: Car) {
        guard let encoded = try? JSONEncoder().encode(car) else { return }
        
        guard let url = URL(string: "https://carangas.herokuapp.com/cars/\(car._id ?? "")") else {return}
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request).resume()
    }

}
