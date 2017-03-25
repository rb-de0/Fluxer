//
//  MapTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/25.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class MapTests: XCTestCase {
    
    func testTransform() {
        
        var bindableValue = 0
        let source = ObservableValue(0)
        let map = source.map { $0 + 1 }
        
        _ = map.subscribe {
            bindableValue = $0
        }
        
        source.value = 10
        
        XCTAssertEqual(bindableValue, 11)
    }
    
    func testLifeCycle() {
        
        var bindableValue = 0
        var source = ObservableValue(0)
        let map = source.map { $0 + 1 }
        
        _ = map.subscribe {
            bindableValue = $0
        }
        
        source.value = 10
        
        XCTAssertEqual(bindableValue, 11)
        
        source = ObservableValue(0)
        
        source.value = 20
        
        XCTAssertEqual(bindableValue, 11)
    }
}
