//
//  AnyObservable.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

final class AnyObservable<O: Observable>: Observable {
    
    typealias T = O.T
    
    private let _subscribe: (@escaping (T) -> ()) -> Disposable
    
    init(base: O) {
        self._subscribe = base.subscribe
    }
    
    func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        return _subscribe(onUpdateValue)
    }
}
