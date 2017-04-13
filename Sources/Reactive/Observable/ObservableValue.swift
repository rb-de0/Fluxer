//
//  ObservableValue.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class ObservableValue<T>: Observable {
    
    fileprivate var subscriptions = [String: ((T) -> ())]()
    
    public var value: T {
        didSet {
            subscriptions.values.forEach { $0(value) }
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        
        let token = generateRegistrationToken()
        subscriptions[token] = onUpdateValue
        
        return BlockDisposable { [weak self] in
            self?.subscriptions[token] = nil
        }
    }
}

// MARK: - Publishable
extension ObservableValue: Publishable {
    
    func publish() {
        subscriptions.values.forEach { $0(value) }
    }
}
