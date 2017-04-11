//
//  ConnectableObservableTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/04/11.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class ConnectableObservableTests: XCTestCase {

    func testNotConnect() {
        
        let value = ObservableValue(0)
        let connectableValue = ConnectableObservable(value)
        var bindableValue = -1
        
        _ = connectableValue.subscribe {
            bindableValue = $0
        }
        
        value.value = 10
        
        XCTAssertEqual(bindableValue, -1)
    }
    
    func testConnect() {
        
        let value = ObservableValue(0)
        let connectableValue = ConnectableObservable(value)
        var bindableValue = -1
        let disposeBag = DisposeBag()
        
        connectableValue.connect().addTo(disposeBag)
        
        _ = connectableValue.subscribe {
            bindableValue = $0
        }
        
        value.value = 10
        
        XCTAssertEqual(bindableValue, 10)
    }
    
    func testDispose() {
        
        let value = ObservableValue(0)
        let connectableValue = ConnectableObservable(value)
        var bindableValue = -1
        let disposeBag = DisposeBag()
        
        connectableValue.connect().addTo(disposeBag)
        
        let disposable = connectableValue.subscribe {
            bindableValue = $0
        }
        
        value.value = 10
        
        XCTAssertEqual(bindableValue, 10)
        
        disposable.dispose()
        
        value.value = 5
        
        XCTAssertEqual(bindableValue, 10)
    }
    
    func testDisconnect() {
        
        let value = ObservableValue(0)
        let connectableValue = ConnectableObservable(value)
        var bindableValue = -1
        
        let disposable = connectableValue.connect()
        
        _ = connectableValue.subscribe {
            bindableValue = $0
        }
        
        value.value = 10
        
        XCTAssertEqual(bindableValue, 10)
        
        disposable.dispose()
        
        value.value = 5
        
        XCTAssertEqual(bindableValue, 10)
    }
}
