import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

  // MARK: - Properties

  var captureSession: AVCaptureSession!
  var previewLayer: AVCaptureVideoPreviewLayer!

  // MARK: - Navigation

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  // MARK: - View Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.black
    captureSession = AVCaptureSession()

    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
      return
    }

    let videoInput: AVCaptureDeviceInput

    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }

    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      showAlert(title: "Erreur", message: "Votre appareil ne prend pas en charge le scan de QR code. Veuillez utiliser un appareil avec une caméra.")
      captureSession = nil
      return
    }

    let metadataOutput = AVCaptureMetadataOutput()

    if (captureSession.canAddOutput(metadataOutput)) {
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.qr]
      captureSession.addOutput(metadataOutput)
    } else {
      showAlert(title: "Erreur", message: "Votre appareil ne prend pas en charge le scan de QR code. Veuillez utiliser un appareil avec une caméra.")
      captureSession = nil
      return
    }

    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.videoGravity = .resizeAspectFill

    view.layer.addSublayer(previewLayer)

    captureSession.startRunning()
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

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    captureSession.stopRunning()

    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
        return
      }

      guard let stringValue = readableObject.stringValue else {
        return
      }

      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

      handleMetadataObject(stringValue)
    }
  }

  func handleMetadataObject(_ metadataObject: String) {
    if (!metadataObject.hasPrefix("sportsfun:")) {
      showAlert(title: "Erreur", message: "Le QR code n'est pas valide")
    } else {
      showAlert(title: "Code trouvé", message: "Envoi en cours…", handler: { action in
        self.dismiss(animated: true)
      })
      sendToken(metadataObject)
    }
  }

  func sendToken(_ token: String) {
    print(token)
    // TODO Send the token
  }

  func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
    present(ac, animated: true)
  }

}
