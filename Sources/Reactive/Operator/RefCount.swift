//
//  RefCount.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/04/11.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class RefCount<T>: Observable {
    
    private let _source: ConnectableObservable<T>
    
    private var subscriptionsCount = 0 {
        didSet {
            
            countLock.lock()
            defer { countLock.unlock() }
            
            if subscriptionsCount <= 0 {
                isConnected = false
                connectableDisposable?.dispose()
            }
        }
    }
    
    private var isConnected = false
    private var connectableDisposable: Disposable?
    
    private let countLock = NSLock()
    private let lock = NSLock()
    
    init(_ source: ConnectableObservable<T>) {
        _source = source
    }
    
    public func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        
        lock.lock()
        defer { lock.unlock() }
        
        subscriptionsCount += 1

        if !isConnected {
            isConnected = true
            connectableDisposable = _source.connect()
        }
        
        let sourceDisposable = _source.subscribe {
            onUpdateValue($0)
        }
        
        return BlockDisposable { [weak self] in
            sourceDisposable.dispose()
            self?.subscriptionsCount -= 1
        }
    }
}
