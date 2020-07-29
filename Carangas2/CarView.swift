//
//  CarView.swift
//  Carangas2
//
//  Created by Nazildo Souza on 22/04/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI
import WebKit

struct CarView: View {
    var car: Car
    @State private var showingAddView = false
    @ObservedObject var dataCars: DataCar
    @State private var dragAmount = CGSize.zero
    @State private var gestureName = CGFloat.zero
    
    var body: some View {
        ZStack(alignment: .center) {
            WebView(car: car)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Text(car.brand)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 5)
                    
                    Text(car.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 5)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(car.gas)
                        .font(.headline)
                        .padding(.top, 8)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity)
                    
                    Text("R$ \(car.price, specifier: "%.2f")")
                        .font(.headline)
                        .padding(.top, 8)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
//                Text(car._id ?? "sem id")
//                    .font(.caption)
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width - 350 : UIScreen.main.bounds.width - 50, height: 100)
            .background(Blur(style: .systemMaterial))
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.6), radius: 5, x: 2, y: 2)
            .offset(y: self.gestureName)
            .gesture(
                DragGesture()
                    .onChanged({ self.dragAmount = $0.translation })
                    .onEnded({ (value) in
                        if self.dragAmount.height > 150 {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)){
                                self.gestureName = UIScreen.main.bounds.height / 3
                            }
                        } else if self.dragAmount.height < -150 {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)){
                                self.gestureName = .zero
                            }
                        }
                        
                    })
            )
            
        }
        .navigationBarTitle(Text(car.name), displayMode: .inline)
        .navigationBarItems(trailing: Button("Edite"){
            if self.car._id != nil {
                self.dataCars.editOurAdd = 1
                self.dataCars.indexId = self.car._id ?? "sem id definido"
                self.dataCars.name = self.car.name
                self.dataCars.brandSelection = self.car.brand
                self.dataCars.gasType = self.car.gasType
                self.dataCars.price = String(format: "%.2f", Double(self.car.price))
                
            }
            self.showingAddView.toggle()
        })
            .sheet(isPresented: $showingAddView) {
                AddCarView(dataCars: self.dataCars)
        }
    }
}

struct WebView: UIViewRepresentable {
    var car: Car
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
        
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let name = (car.brand + "+" + car.name).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.google.com.br/search?q=\(name)&tbm=isch"
        guard let url = URL(string: urlString) else {
            print("Erro no url webView")
            return
        }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

//struct CarView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            CarView(car: Car(brand: "GM", gasType: 1, name: "Cruze", price: 125125555), dataCars: DataCar())
//        }
//    }
//}
