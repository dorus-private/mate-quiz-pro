import SwiftUI
import AVFoundation // To access the camera related swift classes and methods

struct CameraPreview: UIViewRepresentable { // for attaching AVCaptureVideoPreviewLayer to SwiftUI View
 
  let session: AVCaptureSession
 
  // creates and configures a UIKit-based video preview view
  func makeUIView(context: Context) -> VideoPreviewView {
     let view = VideoPreviewView()
     view.backgroundColor = .black
     view.videoPreviewLayer.session = session
     view.videoPreviewLayer.videoGravity = .resizeAspect
     view.videoPreviewLayer.connection?.videoOrientation = .portrait
     return view
  }
 
  // updates the video preview view
  public func updateUIView(_ uiView: VideoPreviewView, context: Context) { }
 
  // UIKit-based view for displaying the camera preview
  class VideoPreviewView: UIView {

     // specifies the layer class used
     override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
     }
  
     // retrieves the AVCaptureVideoPreviewLayer for configuration
     var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
     }
  }
}

class CameraManager: ObservableObject {

 // Represents the camera's status
 enum Status {
    case configured
    case unconfigured
    case unauthorized
    case failed
 }
 
 // Observes changes in the camera's status
 @Published var status = Status.unconfigured
 
 // AVCaptureSession manages the camera settings and data flow between capture inputs and outputs.
 // It can connect one or more inputs to one or more outputs
 let session = AVCaptureSession()

 // AVCapturePhotoOutput for capturing photos
 let photoOutput = AVCapturePhotoOutput()

 // AVCaptureDeviceInput for handling video input from the camera
 // Basically provides a bridge from the device to the AVCaptureSession
 var videoDeviceInput: AVCaptureDeviceInput?

 // Serial queue to ensure thread safety when working with the camera
 private let sessionQueue = DispatchQueue(label: "com.demo.sessionQueue")
 
 // Method to configure the camera capture session
 func configureCaptureSession() {
    sessionQueue.async { [weak self] in
      guard let self, self.status == .unconfigured else { return }
   
      // Begin session configuration
      self.session.beginConfiguration()

      // Set session preset for high-quality photo capture
      self.session.sessionPreset = .photo
   
      // Add video input from the device's camera
      self.setupVideoInput()
   
      // Add the photo output configuration
      self.setupPhotoOutput()
   
      // Commit session configuration
      self.session.commitConfiguration()

      // Start capturing if everything is configured correctly
      self.startCapturing()
   }
 }
 
 // Method to set up video input from the camera
 private func setupVideoInput() {
   do {
      // Get the default wide-angle camera for video capture
      // AVCaptureDevice is a representation of the hardware device to use
       let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

      guard let camera else {
         print("CameraManager: Video device is unavailable.")
         status = .unconfigured
         session.commitConfiguration()
         return
      }
   
      // Create an AVCaptureDeviceInput from the camera
      let videoInput = try AVCaptureDeviceInput(device: camera)
   
      // Add video input to the session if possible
      if session.canAddInput(videoInput) {
         session.addInput(videoInput)
         videoDeviceInput = videoInput
         status = .configured
      } else {
         print("CameraManager: Couldn't add video device input to the session.")
         status = .unconfigured
         session.commitConfiguration()
         return
      }
   } catch {
      print("CameraManager: Couldn't create video device input: \(error)")
      status = .failed
      session.commitConfiguration()
      return
   }
 }
 
 // Method to configure the photo output settings
 private func setupPhotoOutput() {
   if session.canAddOutput(photoOutput) {
      // Add the photo output to the session
      session.addOutput(photoOutput)

      // Configure photo output settings
      photoOutput.isHighResolutionCaptureEnabled = true
      photoOutput.maxPhotoQualityPrioritization = .quality // work for ios 15.6 and the older versions
      //photoOutput.maxPhotoDimensions = .init(width: 4032, height: 3024) // for ios 16.0*

      // Update the status to indicate successful configuration
      status = .configured
   } else {
      print("CameraManager: Could not add photo output to the session")
      // Set an error status and return
      status = .failed
      session.commitConfiguration()
      return
   }
 }
 
 // Method to start capturing
 private func startCapturing() {
   if status == .configured {
      // Start running the capture session
      self.session.startRunning()
   } else if status == .unconfigured || status == .unauthorized {
      DispatchQueue.main.async {
        // Handle errors related to unconfigured or unauthorized states
        
      }
   }
 }

 // Method to stop capturing
 func stopCapturing() {
   // Ensure thread safety using `sessionQueue`.
   sessionQueue.async { [weak self] in
      guard let self else { return }

      // Check if the capture session is currently running.
      if self.session.isRunning {
         // stops the capture session and any associated device inputs.
         self.session.stopRunning()
      }
   }
 }
}

class CameraViewModel: ObservableObject {
 
  // Reference to the CameraManager.
  @ObservedObject var cameraManager = CameraManager()
 
  // Published properties to trigger UI updates.
  @Published var isFlashOn = false
  @Published var showAlertError = false
  @Published var showSettingAlert = false
  @Published var isPermissionGranted: Bool = false

  // Reference to the AVCaptureSession.
  var session: AVCaptureSession = .init()

  // Cancellable storage for Combine subscribers.
 
  init() {
    // Initialize the session with the cameraManager's session.
    session = cameraManager.session
  }

  deinit {
    // Deinitializer to stop capturing when the ViewModel is deallocated.
    cameraManager.stopCapturing()
  }
 
  // Setup Combine bindings for handling publisher's emit values
  func setupBindings() {
    
  }
 
  // Check for camera device permission.
  func checkForDevicePermission() {
    let videoStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    if videoStatus == .authorized {
       // If Permission granted, configure the camera.
       isPermissionGranted = true
       configureCamera()
    } else if videoStatus == .notDetermined {
       // In case the user has not been asked to grant access we request permission
       AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { _ in })
    } else if videoStatus == .denied {
       // If Permission denied, show a setting alert.
       isPermissionGranted = false
       showSettingAlert = true
    }
  }
 
  // Configure the camera through the CameraManager to show a live camera preview.
  func configureCamera() {
     cameraManager.configureCaptureSession()
  }
}

struct CameraFinalView: View {
 
 @ObservedObject var viewModel = CameraViewModel()

 var body: some View {
   GeometryReader { geometry in
     ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
    
        VStack(spacing: 0) {
           
     
           CameraPreview(session: viewModel.session)
                .ignoresSafeArea()
        }
     }
     .onAppear {
        viewModel.setupBindings()
        viewModel.checkForDevicePermission()
     }
   }
 }
 
 // use to open app's setting
 func openSettings() {
    let settingsUrl = URL(string: UIApplication.openSettingsURLString)
    if let url = settingsUrl {
       UIApplication.shared.open(url, options: [:])
    }
  }
}
