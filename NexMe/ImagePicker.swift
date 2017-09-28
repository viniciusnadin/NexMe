import UIKit
import Foundation

enum ImagePickerError: Error {
    case UserDidNotPickImage
}

class ImagePicker: NSObject {
    var viewController: UIViewController?
    var result: ((Result<UIImage>) -> Void)?
    var previousStatusBarStyle: UIStatusBarStyle?
    
    lazy var addPhotoActionSheet: UIActionSheet = {
        let addPhotoActionSheet = UIActionSheet()
        addPhotoActionSheet.delegate = self
        addPhotoActionSheet.addButton(withTitle: "Câmera")
        addPhotoActionSheet.addButton(withTitle: "Galeria")
        addPhotoActionSheet.addButton(withTitle: "Cancelar")
        addPhotoActionSheet.cancelButtonIndex = 2
        
        return addPhotoActionSheet
    }()
    
    func pickImageFromViewController(viewController: UIViewController, result: @escaping (Result<UIImage>) -> Void) {
        self.viewController = viewController
        self.result = result
        
        previousStatusBarStyle = UIApplication.shared.statusBarStyle
        addPhotoActionSheet.show(in: viewController.view)
    }
}

// MARK: Action Sheet Delegate

extension ImagePicker: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if (buttonIndex == 0) {
            addPhotoFromCamera()
        } else if (buttonIndex == 1) {
            addPhotoFromLibrary()
        }
    }
    
    func addPhotoFromCamera() {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        imagePickerViewController.sourceType = .camera
        
        viewController!.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    func addPhotoFromLibrary() {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        imagePickerViewController.sourceType = .photoLibrary
        imagePickerViewController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        viewController!.present(imagePickerViewController, animated: true, completion: nil)
    }
}

// MARK: Image Picker Controller Delegate

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            result?(.Success(selectedImage))
        } else {
            result?(.Failure(ImagePickerError.UserDidNotPickImage))
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

