//
//  FileSystemHelper.swift
//  Gespage
//
//  Created by Duy Pham on 08/08/2023.
//

import UIKit

class FileSystemHelper: NSObject {
    typealias CompletionHandler = ([URL]) -> Void
    
    var viewController: UIViewController?
    var completionHandler: CompletionHandler?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func pickFiles(completion: @escaping CompletionHandler) {
        completionHandler = completion
        
        let documentPicker = createDocumentPicker()
        viewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    private func createDocumentPicker() -> UIDocumentPickerViewController {
        let documentTypes = ["public.image", "public.pdf", "org.openxmlformats.wordprocessingml.document", "org.openxmlformats.spreadsheetml.sheet"]
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        
        return documentPicker
    }
}

extension FileSystemHelper: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        completionHandler?(urls)
        completionHandler = nil
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completionHandler?([])
        completionHandler = nil
    }
}
