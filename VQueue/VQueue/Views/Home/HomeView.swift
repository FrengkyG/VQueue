//
//  WelcomeView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 21/07/25.
//

import SwiftUI

struct HomeView: View {
    @State private var scannedResult: String?
    @State private var isPresentingScanner = false
    @State private var path: [String] = []
    @State private var isNavigatingToBooth = false
    @State private var isNavigatingToQueueList = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bgHome")
                    .resizable()
                    .scaledToFill()
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Image("iconBoothLogin")
                    }
                    
                    Group {
                        HStack {
                            Text("Welcome to")
                            Text("GetQ!")
                                .foregroundColor(.redColor)
                                .fontWeight(.bold)
                        }
                    }
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 25)
                    
                    Text("Your smart queue companion at JxB. \n")
                        .padding(.top, 30)
                    
                    Text("Queue at up to 3 booths at once, and feel free to shop around while you wait!")
                    
                    Image("imagePeopleScan")
                        .padding(.top, 30)

                    
                    Button(action: {
                        isPresentingScanner = true
                    }
                    ){
                        Text("Start Scan")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.redColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        isNavigatingToQueueList = true
                    }) {
                        Text("Queue List")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.redColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.redColor ?? Color.red, lineWidth: 2)
                            )
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
                .fullScreenCover(isPresented: $isPresentingScanner) {
                    QrScanView { result in
                        if scannedResult != result {
                            scannedResult = result
                            path.append(result)
                        }
                        isNavigatingToBooth = true
                        isPresentingScanner = false
                    }
                }
                .navigationDestination(isPresented: $isNavigatingToBooth) {
                    if let scannedResult = scannedResult {
                            BoothView(scannedCode: scannedResult)
                        } else {
                            Text("No scanned result.")
                        }
                }
                .navigationDestination(isPresented: $isNavigatingToQueueList) {
                    QueueListView()
                }
                .padding(.horizontal, 36)
                .padding(.vertical, 37)

            }
            
        }.onAppear {
            saveDeviceIDToUserDefaults()
        }
    }
    
    func saveDeviceIDToUserDefaults() {
            if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
                UserDefaults.standard.set(deviceID, forKey: "deviceID")
                print("✅ Device ID saved: \(deviceID)")
            } else {
                print("❌ Failed to get device ID")
            }
        }
}

#Preview {
    HomeView()
}
