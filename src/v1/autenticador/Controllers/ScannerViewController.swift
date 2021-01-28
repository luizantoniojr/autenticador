//
//  ScannerViewController.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 27/01/21.
//

import Foundation
import AVFoundation
import UIKit

protocol AddOtpAutomaticallyProtocol {
    func add(_ otp:Otp)
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: AddOtpAutomaticallyProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(otpauth: stringValue)
        }

        dismiss(animated: true)
    }

    func found(otpauth: String) {
        //otpauth://totp/dev-cgzvdhow:silvajuniorluizantonio%40gmail.com?secret=GBYUMJLWLIZTSPZ3N4YEGUTUG45HE4KO&issuer=dev-cgzvdhow&algorithm=SHA1&digits=6&period=30
        if
            let url = URLComponents(string: otpauth),
            let queryItems = url.queryItems,
            let queryItemSecret = queryItems.first(where: {$0.name == "secret" }),
            let queryItemIssuer = queryItems.first(where: {$0.name == "issuer" }),
            let queryItemDigits = queryItems.first(where: {$0.name == "digits" }),
            let queryItemPeriod = queryItems.first(where: {$0.name == "period" }),
            let digitsString = queryItemDigits.value,
            let periodString = queryItemPeriod.value,
            let secret = queryItemSecret.value,
            let issuer = queryItemIssuer.value,
            let digits = Int(digitsString),
            let period = Int(periodString),
            let delegate = delegate {
                let otp = Otp(issuer, secret, digits, period)
                print(otpauth)
                delegate.add(otp)
                navigationController?.popViewController(animated: true)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
