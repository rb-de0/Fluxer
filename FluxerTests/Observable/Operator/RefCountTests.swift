//
//  RefCountTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/04/11.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class RefCountTests: XCTestCase {
    
    func testNotShare() {
        
        let value = ObservableValue(0)
        var mapCalledCount = 0
        
        let map = value.map { value -> Int in
            mapCalledCount += 1
            return value * 2
        }
        
        _ = map.subscribe {
            print($0)
        }
        
        _ = map.subscribe {
            print($0)
        }
        
        value.value = 10
        
        XCTAssertEqual(mapCalledCount, 2)
    }
    
    func testShare() {
        
        let value = ObservableValue(0)
        var mapCalledCount = 0
        
        let map = value.map { value -> Int in
            mapCalledCount += 1
            return value * 2
        }.share()
        
        _ = map.subscribe {
            print($0)
        }
        
        _ = map.subscribe {
            print($0)
        }
        
        value.value = 10
        
        XCTAssertEqual(mapCalledCount, 1)
    }
    
    func testDisconnect() {
        
        let value = ObservableValue(0)
        var mapCalledCount = 0
        
        let map = value.map { value -> Int in
            mapCalledCount += 1
            return value * 2
        }.share()
        
        let disposable = map.subscribe {
            print($0)
        }
        
        value.value = 10
        
        XCTAssertEqual(mapCalledCount, 1)
        
        disposable.dispose()
        
        value.value = 10
        
        XCTAssertEqual(mapCalledCount, 1)
    }
}
