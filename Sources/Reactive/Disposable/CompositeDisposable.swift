//
//  CompositeDisposable.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class CompositeDisposable: Disposable {
    
    private var disposables = [Disposable]()
    
    public init(_ disposables: [Disposable] = []) {
        self.disposables = disposables
    }
    
    func append(_ disposable: Disposable) {
        disposables.append(disposable)
    }
    
    func append(_ disposables: [Disposable]) {
        self.disposables.append(contentsOf: disposables)
    }
    
    public func dispose() {
        
        disposables.forEach {
            $0.dispose()
        }
    }
}

public func += (container: CompositeDisposable, item: Disposable) {
    container.append(item)
}

public func += (container: CompositeDisposable, items: [Disposable]) {
    container.append(items)
}
