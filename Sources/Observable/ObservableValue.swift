//
//  ObservableValue.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class ObservableValue<T>: Observable {
    
    private var _value: T
    
    private var subscriptions = [String: ((T) -> ())]()
    
    public var value: T {
        get {
            return _value
        }
        set(newValue) {
            _value = newValue
            subscriptions.values.forEach { $0(newValue) }
        }
    }
    
    public init(_ value: T) {
        self._value = value
    }
    
    public func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        
        let token = generateRegistrationToken()
        subscriptions[token] = onUpdateValue
        
        return BlockDisposable { [weak self] in
            self?.subscriptions[token] = nil
        }
    }
}
