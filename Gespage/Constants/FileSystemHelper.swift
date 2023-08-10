//
//  FileSystemHelper.swift
//  Gespage
//
//  Created by Duy Pham on 08/08/2023.
//

import UIKit
import MobileCoreServices

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
        let documentTypes = [
          "com.adobe.pdf", // .pdf
          "org.openxmlformats.wordprocessingml.document", // .docx
          "com.microsoft.word.doc", // .doc
          "org.openxmlformats.presentationml.presentation", // .pptx
          "com.microsoft.powerpoint.ppt", // .ppt
          "org.openxmlformats.spreadsheetml.sheet", // .xlsx
          "org.oasis-open.opendocument.text", // .odt
          "org.oasis-open.opendocument.presentation", // .odp
          "org.oasis-open.opendocument.spreadsheet", // .ods
          "public.plain-text", // .txt
          "public.rtf", // .rtf
          "com.microsoft.xps", // .xps
          "public.heif", // .heif
          "public.jpeg", // .jpg
          "public.jpeg", // .jpeg
          "public.png" // .png
        ];
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        
        return documentPicker
    }
    
    static func isImageFile(atPath path: String) -> Bool {
        let imageExtensions = [
            "heif",
            "jpg",
            "jpeg",
            "png"
        ]
        let fileExtension = (path as NSString).pathExtension.lowercased()
        return imageExtensions.contains(fileExtension)
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
