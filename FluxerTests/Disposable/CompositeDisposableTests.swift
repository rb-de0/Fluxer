//
//  CompositeDisposableTests.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import XCTest
@testable import Fluxer

class CompositeDisposableTests: XCTestCase {

    func testAppendSingle() {
        
        var calledCount = 0
        
        let compositeDisposable = CompositeDisposable()
        
        compositeDisposable.append(BlockDisposable{
            calledCount += 1
        })
        
        compositeDisposable.append(BlockDisposable{
            calledCount += 1
        })
        
        compositeDisposable.dispose()
        
        XCTAssertEqual(calledCount, 2)
    }
    
    func testAppendMultiple() {
        
        var calledCount = 0
        
        let compositeDisposable = CompositeDisposable()
        
        compositeDisposable.append([
            BlockDisposable{ calledCount += 1 },
            BlockDisposable{ calledCount += 1 }
        ])

        compositeDisposable.dispose()
        
        XCTAssertEqual(calledCount, 2)
    }
    
    func testAppendMix() {
        
        var calledCount = 0
        
        let compositeDisposable = CompositeDisposable()
        
        compositeDisposable.append([
            BlockDisposable{ calledCount += 1 },
            BlockDisposable{ calledCount += 1 }
        ])
        
        compositeDisposable.append(BlockDisposable{
            calledCount += 1
        })
        
        compositeDisposable.dispose()
        
        XCTAssertEqual(calledCount, 3)
    }
    
    func testSingleAppendOperator() {
        
        var calledCount = 0
        
        let compositeDisposable = CompositeDisposable()
        
        compositeDisposable += BlockDisposable{ calledCount += 1 }
        
        compositeDisposable.dispose()
        
        XCTAssertEqual(calledCount, 1)
    }
    
    func testMultipleAppendOperator() {
        
        var calledCount = 0
        
        let compositeDisposable = CompositeDisposable()
        
        compositeDisposable += [BlockDisposable{ calledCount += 1 }, BlockDisposable{ calledCount += 1 }]
        
        compositeDisposable.dispose()
        
        XCTAssertEqual(calledCount, 2)
    }
}
