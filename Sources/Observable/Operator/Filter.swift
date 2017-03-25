//
//  Filter.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/25.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class Filter<T>: Observable {
    
    private let _source: AnyObservable<T>
    private let _filter: (T) -> Bool
    
    init<O: Observable>(_ source: O, filter: @escaping (T) -> Bool) where O.T == T {
        
        _source = AnyObservable(source)
        _filter = filter
    }
    
    public func subscribe(_ onUpdateValue: @escaping (T) -> ()) -> Disposable {
        
        return _source.subscribe { [weak self] in
            
            guard let strongSelf = self, strongSelf._filter($0) else {
                return
            }
            
            onUpdateValue($0)
        }
    }
}

public extension Observable {
    
    func filter(_ filter: @escaping (Self.T) -> Bool) -> Filter<Self.T> {
        return Filter(self, filter: filter)
    }
}
