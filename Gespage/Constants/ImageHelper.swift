import UIKit

struct ImageHelper {
    static let splashImage = UIImage(named: "splash")
    
    static let onBoard1 = UIImage(named: "onboard1")
    static let onBoard2 = UIImage(named: "onboard2")
    static let onBoard3 = UIImage(named: "onboard3")
    
    static let page = UIImage(named: "page")
    static let pageSelected = UIImage(named: "pageSelected")
    
    static let homeIcon = UIImage(named: "home")
    static let printerIcon = UIImage(named: "printer")
    static let scanIcon = UIImage(named: "scan")
    static let moreIcon = UIImage(named: "more")
}

class PickerImageHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    typealias CompletionHandler = (URL?) -> Void
    
    var viewController: UIViewController?
    var completionHandler: CompletionHandler?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func pickImage(completion: @escaping CompletionHandler) {
        completionHandler = completion
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        viewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let imageURL = info[.imageURL] as? URL else {
            completionHandler?(nil)
            completionHandler = nil
            return
        }
        
        completionHandler?(imageURL)
        completionHandler = nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        completionHandler?(nil)
        completionHandler = nil
    }
}

