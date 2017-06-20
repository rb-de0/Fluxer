//
//  ColdObservableTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/04/11.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class ColdObservableTests: XCTestCase {
    
    func testSubscribeHandler() {
        
        let observable = ColdObservable.create { (observer: Observer<Int>) in
            
            observer.send(10)
            
            return BlockDisposable {}
        }
        
        var bindableValue: Int?
        
        _ = observable.subscribe {
            bindableValue = $0
        }
        
        XCTAssertEqual(bindableValue, 10)
    }
}
