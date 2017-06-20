//
//  ConnectableObservable.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/04/11.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class ConnectableObservable<T>: Observable {
    
    private let _source: AnyObservable<T>
    
    private var subscriptions = [String: ((T) -> ())]() 
    
    init<O: Observable>(_ source: O) where O.T == T {
        _source = AnyObservable(source)
    }
    
    func connect() -> Disposable {
        
        return _source.subscribe { [weak self] value in
            self?.subscriptions.values.forEach { $0(value) }
        }
    }
    
    public func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        
        let token = generateRegistrationToken()
        subscriptions[token] = onUpdateValue
        
        return BlockDisposable { [weak self] in
            self?.subscriptions[token] = nil
        }
    }
}

public extension Observable {
    
    func share() -> RefCount<Self.T> {
        return RefCount(ConnectableObservable(self))
    }
}
