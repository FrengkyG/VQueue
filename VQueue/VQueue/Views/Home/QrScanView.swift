//
//  QrScanView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 21/07/25.
//
import AVFoundation
import SwiftUI

struct QrScanView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isTorchOn = false
    @State private var scannedCode: String? = nil
    var onScan: (String) -> Void
    
    var body: some View {
        ZStack {
            ScannerCameraView { code in
                onScan(code)
            }
            
            // MARK: Overlay UI
            VStack {
                Spacer().frame(height: 50)
                
                Text("Find a code to scan")
                    .fontWeight(.semibold)
                    .padding(16)
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                
                Spacer()
                
                ScannerCornerOverlay()
                
                Spacer()
                
                // MARK: Torch Button
                Button(action: {
                    isTorchOn.toggle()
                    ScannerCameraView.toggleTorch(on: isTorchOn)
                }) {
                    Image(systemName: "flashlight.on.fill")
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                }
                
                Spacer().frame(height: 80)
            }
            .padding()
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Inner UIViewControllerRepresentable
    struct ScannerCameraView: UIViewControllerRepresentable {
        var onScan: (String) -> Void
        
        static func toggleTorch(on: Bool) {
            guard let device = AVCaptureDevice.default(for: .video),
                  device.hasTorch else { return }
            try? device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        }
        
        class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
            var parent: ScannerCameraView
            
            init(_ parent: ScannerCameraView) {
                self.parent = parent
            }
            
            func metadataOutput(_ output: AVCaptureMetadataOutput,
                                didOutput metadataObjects: [AVMetadataObject],
                                from connection: AVCaptureConnection) {
                if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                   metadataObject.type == .qr,
                   let value = metadataObject.stringValue {
                    DispatchQueue.main.async {
                        self.parent.onScan(value)
                    }
                }
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> UIViewController {
            let controller = UIViewController()
            let session = AVCaptureSession()
            
            guard let videoDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  session.canAddInput(videoInput) else {
                return controller
            }
            
            session.addInput(videoInput)
            
            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
                metadataOutput.metadataObjectTypes = [.qr]
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = UIScreen.main.bounds
            controller.view.layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
            
            return controller
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
}

struct CustomQRScannerViewWrapper: View {
    let onResult: (String) -> Void
    
    var body: some View {
        QrScanView(onScan: onResult)
    }
}



 
