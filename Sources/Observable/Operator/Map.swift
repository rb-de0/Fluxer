//
//  Map.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/25.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class Map<T, U>: Observable {
    
    private let _source: AnyObservable<T>
    private let _transform: (T) -> U
    
    init<O: Observable>(_ source: O, transform: @escaping (T) -> U) where O.T == T {
        
        _source = AnyObservable(source)
        _transform = transform
    }
    
    public func subscribe(_ onUpdateValue: @escaping (U) -> ()) -> Disposable {
        
        return _source.subscribe { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            onUpdateValue(strongSelf._transform($0))
        }
    }
}

public extension Observable {
    
    func map<U>(_ transform: @escaping (Self.T) -> U) -> Map<Self.T, U> {
        return Map(self, transform: transform)
    }
}
