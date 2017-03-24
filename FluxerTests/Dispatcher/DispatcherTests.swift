//
//  DispatcherTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class DispatcherTests: XCTestCase {
    
    class TestStore: Store {
        var value = 0
        
        required init(with dispatcher: Dispatcher) {}
    }
    
    class TestAction: Action {}
    
    class Test2Action: Action {}
    
    func testHandlerCallOrder() {
        
        let dispatcher = Dispatcher()
        
        var orderList = [Int]()
        
        _ = dispatcher.register { _ in
            orderList.append(0)
        }
        
        _ = dispatcher.register { _ in
            orderList.append(1)
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(orderList, [0, 1])
    }
    
    func testWaitFor() {
        
        let dispatcher = Dispatcher()
        
        var orderList = [Int]()
        var waitTokens = [String]()
        
        _ = dispatcher.register { action in
            dispatcher.waitFor(waitTokens, action: action)
            orderList.append(0)
        }
        
        let token = dispatcher.register { _ in
            orderList.append(1)
        }
        
        waitTokens.append(token)
        
        _ = dispatcher.register { _ in
            orderList.append(2)
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(orderList, [1, 0, 2])
    }
    
    func testStoreSubscribe() {
        
        let dispatcher = Dispatcher()
        let store = TestStore(with: dispatcher)
        
        _ = dispatcher.register { action in
            store.value = 10
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(store.value, 10)
    }
    
    func testActionHandler() {
        
        let dispatcher = Dispatcher()
        let store = TestStore(with: dispatcher)
        
        _ = dispatcher.register { action in
            
            switch action {
            case _ as TestAction:
                store.value = 10
            
            case _ as Test2Action:
                store.value = -1
                
            default:
                break
            }
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(store.value, 10)
        
        dispatcher.dispatch(Test2Action())
        
        XCTAssertEqual(store.value, -1)
    }
    
    func testAsyncActionCreator() {
        
        let expectation = self.expectation(description: #function)
        let dispatcher = Dispatcher()
        let store = TestStore(with: dispatcher)
        
        _ = dispatcher.register { _ in
            store.value = 10
        }
        
        dispatcher.dispatch { callback in
            callback(TestAction())
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(store.value, 10)
    }
    
    func testAsyncStoreUpdate() {
        
        let expectation = self.expectation(description: #function)
        let dispatcher = Dispatcher()
        let store = TestStore(with: dispatcher)
        
        _ = dispatcher.register { action in
            
            switch action {
            case _ as TestAction:
                store.value = 10
                
            case _ as Test2Action:
                store.value = -1
                
            default:
                break
            }
        }
        
        dispatcher.dispatch { callback in
            
            XCTAssertEqual(store.value, 0)
            
            DispatchQueue.global().async {
                sleep(2)
                
                XCTAssertEqual(store.value, -1)
                callback(TestAction())
                
                expectation.fulfill()
            }
        }
        
        dispatcher.dispatch(Test2Action())
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(store.value, 10)
    }
    
    func testUnregister() {
        
        let dispatcher = Dispatcher()
        let store = TestStore(with: dispatcher)
        
        let token = dispatcher.register { action in
            
            switch action {
            case _ as TestAction:
                store.value = 10
                
            case _ as Test2Action:
                store.value = -1
                
            default:
                break
            }
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(store.value, 10)
        
        dispatcher.unregister(registrationToken: token)
        
        dispatcher.dispatch(Test2Action())
        
        XCTAssertEqual(store.value, 10)
    }
}
