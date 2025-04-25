
import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    var onImageCaptured: () -> Void // Closure to call when image is captured

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView
        var captureSession: AVCaptureSession?
        var currentCameraPosition: AVCaptureDevice.Position = .back

        init(parent: CameraView) {
            self.parent = parent
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                print("Error capturing photo: \(error.localizedDescription)")
                return
            }

            guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
                print("Failed to create image from data")
                return
            }

            // Fix the image orientation
            let fixedImage = fixImageOrientation(image: image)
            // Convert to sRGB
            if let sRGBImage = convertToSRGB(image: fixedImage) {
                parent.capturedImage = sRGBImage
                parent.onImageCaptured() // Call the closure to dismiss the camera
            } else {
                print("Failed to convert image to sRGB")
            }
        }

        @objc func switchCamera() {
            guard let currentInput = captureSession?.inputs.first as? AVCaptureDeviceInput else { return }
            captureSession?.beginConfiguration()
            captureSession?.removeInput(currentInput)

            // Switching camera logic
            let newCameraPosition: AVCaptureDevice.Position = currentCameraPosition == .back ? .front : .back
            guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newCameraPosition) else { return }
            let newInput = try? AVCaptureDeviceInput(device: newCamera)

            if let newInput = newInput {
                captureSession?.addInput(newInput)
                currentCameraPosition = newCameraPosition // Update current camera position
            }
            captureSession?.commitConfiguration()
        }

        private func fixImageOrientation(image: UIImage) -> UIImage {
            guard image.imageOrientation != .up else { return image }

            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: image.size))
            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return normalizedImage ?? image
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        context.coordinator.captureSession = captureSession

        // Initialize the default camera (back)
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return viewController }
        let input = try? AVCaptureDeviceInput(device: camera)

        if let input = input {
            captureSession.addInput(input)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        let photoOutput = AVCapturePhotoOutput()
        captureSession.addOutput(photoOutput)

        captureSession.startRunning()

        // Take Photo Button
        let takePhotoButton = UIButton(frame: CGRect(x: (viewController.view.frame.width - 70) / 2, y: viewController.view.frame.height - 100, width: 70, height: 70))
        takePhotoButton.backgroundColor = .yellow
        takePhotoButton.layer.cornerRadius = 35
        takePhotoButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        takePhotoButton.tintColor = .black
        takePhotoButton.addTarget(context.coordinator, action: #selector(context.coordinator.capturePhoto), for: .touchUpInside)

        viewController.view.addSubview(takePhotoButton)

        // Switch Camera Button
        let switchCameraButton = UIButton(frame: CGRect(x: 20, y: viewController.view.frame.height - 100, width: 50, height: 50))
        switchCameraButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        switchCameraButton.tintColor = .black
        switchCameraButton.addTarget(context.coordinator, action: #selector(context.coordinator.switchCamera), for: .touchUpInside)

        viewController.view.addSubview(switchCameraButton)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update previewLayer frame for view bounds changes
        if let previewLayer = uiViewController.view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiViewController.view.bounds
        }
    }
}

extension CameraView.Coordinator {
    @objc func capturePhoto() {
        guard let photoOutput = self.captureSession?.outputs.first as? AVCapturePhotoOutput else { return }
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

func convertToSRGB(image: UIImage) -> UIImage? {
    guard let cgImage = image.cgImage else { return nil }

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: nil,
                            width: cgImage.width,
                            height: cgImage.height,
                            bitsPerComponent: 8,
                            bytesPerRow: 0,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

    context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
    guard let newCGImage = context?.makeImage() else { return nil }

    return UIImage(cgImage: newCGImage)
}
