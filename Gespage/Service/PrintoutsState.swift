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
    private let printoutIdsSubject = PublishRelay<[Int]>()
    
    var printoutModelResponsePOST: Observable<[PrintoutModelResponse]?> {
        return printoutSubject.asObservable()
    }
    
    var printoutModelResponseDELETE: Observable<[Int]> {
        return printoutIdsSubject.asObservable()
    }
    
    func addPrintoutModelResponse(_ newValue: [PrintoutModelResponse]?) {
        printoutSubject.accept(newValue)
    }
    
    func removePrintoutModelResponse(_ newValue: [Int]) {
        printoutIdsSubject.accept(newValue)
    }
}
