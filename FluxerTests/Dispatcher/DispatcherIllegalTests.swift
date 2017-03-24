//
//  DispatcherIllegalTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/25.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class DispatcherIllegalTests: XCTestCase {
    
    class TestStore: Store {
        var value = 0
        
        required init(with dispatcher: Dispatcher) {}
    }
    
    class TestAction: Action {}
    
    func testWaitForAtIllegalToken() {
        
        let dispatcher = Dispatcher()
        
        var orderList = [Int]()
        
        _ = dispatcher.register { action in
            dispatcher.waitFor(["hoge"], action: action)
            orderList.append(0)
        }
        
        _ = dispatcher.register { _ in
            orderList.append(1)
        }
        
        _ = dispatcher.register { _ in
            orderList.append(2)
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(orderList, [0, 1, 2])
    }
    
    func testReleaseDispatcher() {
        
        var value = 0
        var dispatcher = Dispatcher()
        let expectation = self.expectation(description: #function)
        
        _ = dispatcher.register { _ in
            value += 10
        }
        
        dispatcher.dispatch { callback in
            
            DispatchQueue.global().async {
                sleep(2)
                callback(TestAction())
                expectation.fulfill()
            }
        }
        
        dispatcher = Dispatcher()
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
        XCTAssertEqual(value, 0)
    }

}
