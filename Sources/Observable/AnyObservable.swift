//
//  AnyObservable.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

final class AnyObservable<T>: Observable {
    
    private let _subscribe: (@escaping (T) -> ()) -> Disposable
    
    init<O: Observable>(_ base: O) where O.T == T {
        self._subscribe = base.subscribe
    }
    
    func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        return _subscribe(onUpdateValue)
    }
}
