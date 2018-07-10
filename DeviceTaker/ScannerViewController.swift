//
//  ViewController.swift
//  DeviceTaker
//
//  Created by Stefan V. de Moraes on 25/06/2018.
//  Copyright © 2018 Stefan V. de Moraes. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController {
    @IBOutlet var msgQRLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Acessar a camera traseira
        var deviceDiscoverySession: AVCaptureDevice.DiscoverySession
        
        if AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) != nil {
            
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
            
        } else {
            
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            
        }
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("FALHA AO TENTAR ACESSAR A CAMERA")
            return
        }
        
        do {
            // Instancia da classe AVCaptureDeviceInput usando o objeto do device.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Setar a entrada do device na capture session.
            captureSession.addInput(input)
            
            // Inicializar o objeto AVCaptureMetadataOutput e setar a saida do device para capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Setar o delegate/protocolo e usar o dispatch padrão para executar a chamada
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // Em caso de erro, printar e Error e Retornar/Parar
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Começar a captura de Video.
        captureSession.startRunning()
        
        // Mover as Labels de mensagem para frente da View
        view.bringSubview(toFront: msgQRLabel)
        view.bringSubview(toFront: topbar)
        
        // Inicializar QR Code Frame para dar destaque ao QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Equipamento", message: "Você irá pegar o Equipamento de Cód.: \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if URL(string: decodedURL) != nil {
                self.performSegue(withIdentifier: "stats_segue", sender: self)

            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
}  // END ScannerViewController

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Checar se  o arry metadataObjects  não é  nil (nulo) e se contem, pelo menos, um objeto.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            msgQRLabel.text = "Nenhum código detectado"
            return
        }
        
        // Get do objeto metadata.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // Se encontrar um metadata igual o QR code metadata (or barcode), então da update no texto da UILabel' e seta o bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
                msgQRLabel.text = metadataObj.stringValue
            }
        }
    }
    
}


