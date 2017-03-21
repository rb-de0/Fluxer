//
//  RenderTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class RenderTests: XCTestCase {
    
    func testCallOnMainThread() {
        
        let expectation = self.expectation(description: #function)
        
        var isMainThread: Bool?
        let value = ObservableValue(0)

        _ = value.asRender().subscribe { _ in
            isMainThread = Thread.isMainThread
            expectation.fulfill()
        }
        
        DispatchQueue.global().async {
            value.value = 10
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertEqual(isMainThread, true)
    }
    
    func testCallOnOtherThread() {
        
        let expectation = self.expectation(description: #function)
        
        var isMainThread: Bool?
        let value = ObservableValue(0)
        
        _ = value.subscribe { _ in
            isMainThread = Thread.isMainThread
            expectation.fulfill()
        }
        
        DispatchQueue.global().async {
            value.value = 10
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertEqual(isMainThread, false)
    }
}
