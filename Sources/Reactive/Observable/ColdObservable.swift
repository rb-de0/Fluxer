//
//  ColdObservable.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/04/11.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class ColdObservable<T>: Observable {
    
    public typealias SubscribeHandler = (Observer<T>) -> Disposable
    
    private let _subscribeHandler: SubscribeHandler
    
    init(_ subscribeHandler: @escaping SubscribeHandler) {
        _subscribeHandler = subscribeHandler
    }
    
    public func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        
        let observer = Observer(onUpdateValue)
        return _subscribeHandler(observer)
    }
}

public extension Observable {
    
    static func create<T>(_ subscribeHandler: @escaping ColdObservable<T>.SubscribeHandler) -> ColdObservable<T> {
        return ColdObservable(subscribeHandler)
    }
}

