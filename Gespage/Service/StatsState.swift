//
//  StatsState.swift
//  Gespage
//
//  Created by duy.pham on 27/08/2023.
//

import Foundation
import RxCocoa
import RxSwift

class StatsState {
    static let shared = StatsState()
    
    private let statsSubject = BehaviorRelay<StatsModelResponse?>(value: nil)
    
    var statsModelResponse: Observable<StatsModelResponse?> {
        return statsSubject.asObservable()
    }
}
