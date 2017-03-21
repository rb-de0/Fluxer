//
//  DisposeBagTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class DisposeBagTests: XCTestCase {
    
    func testDeinit() {
        
        var disposeBag = DisposeBag()
        
        var bindableValue = 0
        let value = ObservableValue(0)
        
        value.subscribe {
            bindableValue = $0
        }.addTo(disposeBag)
        
        value.value = 10
        
        XCTAssertEqual(bindableValue, 10)
        
        disposeBag = DisposeBag()
        
        value.value = -1
        
        XCTAssertEqual(bindableValue, 10)
    }
}
