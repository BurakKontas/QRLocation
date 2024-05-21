//
//  ViewController.swift
//  QRLocation
//
//  Created by Trakya14 on 25.03.2024.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var enlemLabel: UILabel!
    @IBOutlet weak var boylamLabel: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            enlemLabel.text = "\(location.coordinate.latitude)"
            boylamLabel.text = "\(location.coordinate.longitude)"
            
            let coordinateString = "http://maps.apple.com/?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
            
            generateQR(coordinateString)
        }
    }
    
    func generateQR(_ qrdata: String) {
        if let data = qrdata.data(using: .isoLatin1) {
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter?.outputImage {
                let scaleX = qrImage.frame.size.width / outputImage.extent.size.width
                let scaleY = qrImage.frame.size.height / outputImage.extent.size.height
                let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                
                if let cgImage = CIContext().createCGImage(transformedImage, from: transformedImage.extent) {
                    let uiImage = UIImage(cgImage: cgImage)
                    if let imageData = uiImage.pngData() {
                        qrImage.image = UIImage(data: imageData)
                    } else {
                        print("Failed to convert QR code image to PNG data")
                    }
                } else {
                    print("Failed to create CGImage from CIImage")
                }
            } else {
                print("Failed to generate QR code")
            }
        } else {
            print("Failed to convert data for QR code")
        }
    }

}

