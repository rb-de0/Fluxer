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
    
    func testDispose() {
        
        var bindableValue = 0
        let value = ObservableValue(0)
        
        let disposable = value.subscribe {
            bindableValue = $0
        }
        
        value.value = 10
        
        disposable.dispose()
        
        value.value = 1
        
        XCTAssertEqual(bindableValue, 10)
    }
    
    func testCompositeDispose() {
        
        var bindableValue = 0
        let value = ObservableValue(0)
        
        let disposable = value.subscribe { _ in
            bindableValue += 1
        }
        
        let disposable2 = value.subscribe { _ in
            bindableValue += 1
        }
        
        let compositeDisposable = CompositeDisposable([disposable, disposable2])
        
        value.value = 10
        
        XCTAssertEqual(bindableValue, 2)
        
        compositeDisposable.dispose()
        
        value.value = 1
        
        XCTAssertEqual(bindableValue, 2)
    }
}
