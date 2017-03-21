//
//  ObservableValueTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class ObservableValueTests: XCTestCase {
    
    func testSubscribe() {
        
        var bindableValue = 0
        let value = ObservableValue(0)
        
        _ = value.subscribe {
            bindableValue = $0
        }
        
        value.value = 10
        
        XCTAssertEqual(bindableValue, 10)
    }
}
