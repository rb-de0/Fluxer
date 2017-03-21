//
//  BlockDisposableTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class BlockDisposableTests: XCTestCase {
    
    func testBlockCall() {
        
        var calledCount = 0
        
        let disposable = BlockDisposable {
            calledCount += 1
        }
        
        disposable.dispose()
        
        XCTAssertEqual(calledCount, 1)
    }
}
