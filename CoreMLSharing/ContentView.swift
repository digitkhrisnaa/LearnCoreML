//
//  ContentView.swift
//  CoreMLSharing
//
//  Created by Aurum on 24/08/20.
//  Copyright © 2020 Digital Khrisna. All rights reserved.
//

import SwiftUI

internal struct ContentView: View {
    @State private var showSheet: Bool = false
    @State private var showPicker: Bool = false
    @State private var images: [UIImage] = []
    @State private var identifierResult: String = ""
    
    private let imageClassifier = ImageClassifier(coreMLModel: FoodClassifier_1().model)
    
    internal var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        if images.isEmpty {
                            Button(" + ") {
                                self.showSheet = true
                            }
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .frame(width: 60, height: 60)
                            .actionSheet(isPresented: $showSheet) {
                                ActionSheet(title: Text("Select Recipe"), message: Text("Choose"), buttons: [
                                    .default(Text("Gallery")) {
                                        self.showPicker = true
                                    }
                                ])
                            }
                        } else {
                            ForEach(images, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: ContentMode.fill)
                                    .frame(width: 60, height: 60)
                                    .padding()
                            }
                            
                            Button(" + ") {
                                self.showSheet = true
                            }
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .frame(width: 50, height: 50)
                            .actionSheet(isPresented: $showSheet) {
                                ActionSheet(title: Text("Select Image"), message: Text("Choose"), buttons: [
                                    .default(Text("Gallery")) {
                                        self.showPicker = true
                                    }
                                ])
                            }
                        }
                    }
                    
                    HStack {
                        Button("Classify") {
                            self.imageClassifier?.classify(images: self.images, completion: { result in
                                self.identifierResult = result
                            })
                        }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .cornerRadius(8)
                        
                        Button("Clear Image") {
                            self.images = []
                            self.identifierResult = ""
                        }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                    
                    Text(self.identifierResult)
                }
            }
            .navigationBarTitle("iOS Sharing Session")
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(isShown: self.$showPicker) { image in
                self.images.append(image)
            }
        }
    }
}


internal struct ContentView_Previews: PreviewProvider {
    internal static var previews: some View {
        ContentView()
    }
}
