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
    }
    
    class TestAction: Action {}
    
    class Test2Action: Action {}
    
    func testHandlerCallOrder() {
        
        let store = TestStore()
        let dispatcher = Dispatcher(store: store)
        
        var orderList = [Int]()
        
        _ = dispatcher.register { _, _ in
            orderList.append(0)
        }
        
        _ = dispatcher.register { _, _ in
            orderList.append(1)
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(orderList, [0, 1])
    }
    
    func testWaitFor() {
        
        let store = TestStore()
        let dispatcher = Dispatcher(store: store)
        
        var orderList = [Int]()
        var waitTokens = [String]()
        
        _ = dispatcher.register { action, _ in
            dispatcher.waitFor(waitTokens, action: action)
            orderList.append(0)
        }
        
        let token = dispatcher.register { _, _ in
            orderList.append(1)
        }
        
        waitTokens.append(token)
        
        _ = dispatcher.register { _, _ in
            orderList.append(2)
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(orderList, [1, 0, 2])
    }
    
    func testStoreSubscribe() {
        
        let store = TestStore()
        let dispatcher = Dispatcher(store: store)
        
        _ = dispatcher.register { action, _ in
            store.value = 10
        }
        
        dispatcher.dispatch(TestAction())
        
        XCTAssertEqual(store.value, 10)
    }
    
    func testActionHandler() {
        
        let store = TestStore()
        let dispatcher = Dispatcher(store: store)
        
        _ = dispatcher.register { action, _ in
            
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
        let store = TestStore()
        let dispatcher = Dispatcher(store: store)
        
        _ = dispatcher.register { _, _ in
            store.value = 10
        }
        
        dispatcher.dispatch { store, callback in
            callback { store in TestAction() }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(store.value, 10)
    }
    
    func testAsyncStoreUpdate() {
        
        let expectation = self.expectation(description: #function)
        let store = TestStore()
        let dispatcher = Dispatcher(store: store)
        
        _ = dispatcher.register { action, _ in
            
            switch action {
            case _ as TestAction:
                store.value = 10
                
            case _ as Test2Action:
                store.value = -1
                
            default:
                break
            }
        }
        
        dispatcher.dispatch { store, callback in
            
            XCTAssertEqual(store.value, 0)
            
            DispatchQueue.global().async {
                sleep(2)
                
                callback { store in
                    XCTAssertEqual(store.value, -1)
                    return TestAction()
                }
                
                expectation.fulfill()
            }
        }
        
        dispatcher.dispatch(Test2Action())
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(store.value, 10)
    }
    
    func testUnregister() {
        
        let store = TestStore()
        let dispatcher = Dispatcher(store: store)
        
        let token = dispatcher.register { action, _ in
            
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
