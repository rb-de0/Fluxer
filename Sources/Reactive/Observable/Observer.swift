//
//  Observer.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/04/11.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class Observer<T> {
    
    private let _subscription: (T) -> ()
    
    init(_ subscription: @escaping (T) -> ()) {
        _subscription = subscription
    }
    
    func send(_ value: T) {
        _subscription(value)
    }
}
