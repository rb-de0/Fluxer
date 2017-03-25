//
//  Render.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//


import Foundation

public class Render<O: Observable>: Observable {
    
    private let source: AnyObservable<O>
    
    init(_ source: O) {
        self.source = AnyObservable(base: source)
    }
    
    public func subscribe(_ onUpdateValue: @escaping (O.T) -> ()) -> Disposable {
        
        return source.subscribe { value in
            DispatchQueue.main.async {
                onUpdateValue(value)
            }
        }
    }
}
