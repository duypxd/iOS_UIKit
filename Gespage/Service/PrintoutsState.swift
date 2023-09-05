//
//  PrintoutsState.swift
//  Gespage
//
//  Created by duy.pham on 05/09/2023.
//

import Foundation
import RxCocoa
import RxSwift

class PrintoutState {
    static let shared = PrintoutState()
    
    private let printoutSubject = PublishRelay<[PrintoutModelResponse]?>()
    
    var printoutModelResponse: Observable<[PrintoutModelResponse]?> {
        return printoutSubject.asObservable()
    }
    
    // Function to update the value
    func updatePrintoutModelResponse(_ newValue: [PrintoutModelResponse]?) {
        printoutSubject.accept(newValue)
    }
}
