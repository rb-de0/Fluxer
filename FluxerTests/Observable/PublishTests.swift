//
//  PublishTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/04/13.
//  Copyright © 2017年 rb_de0. All rights reserved.
//


import XCTest
@testable import Fluxer

class PublishTests: XCTestCase {
    
    class PublishStore: Store {
        
        let value = ObservableValue(0)
        
        required init(with dispatcher: Dispatcher) {}
    }
    
    func testPublish() {
        
        let store = PublishStore(with: Dispatcher())
        var bindableValue: Int?
        
        _ = store.value.subscribe {
            bindableValue = $0
        }
        
        store.publish()
        
        XCTAssertEqual(bindableValue, 0)
    }
    
    func testNotPublish() {
        
        let store = PublishStore(with: Dispatcher())
        var bindableValue: Int?
        
        _ = store.value.subscribe {
            bindableValue = $0
        }
        
        XCTAssertNotEqual(bindableValue, 0)
    }
}

