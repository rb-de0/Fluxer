//
//  Render.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

import Foundation

public class Render<T>: Observable {
    
    private let _source: AnyObservable<T>
    
    init<O: Observable>(_ source: O) where O.T == T {
        _source = AnyObservable(source)
    }
    
    public func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        
        return _source.subscribe { value in
            DispatchQueue.main.async {
                onUpdateValue(value)
            }
        }
    }
}

public extension Observable {
    
    func asRender() -> Render<Self.T> {
        return Render(self)
    }
}
