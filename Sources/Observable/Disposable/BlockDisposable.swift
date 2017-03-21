//
//  BlockDisposable.swift
//  Fluxer
//
//  Created by rb_de0 on 2017/03/21.
//  Copyright © 2017年 rb_de0. All rights reserved.
//

public class BlockDisposable: Disposable {
    
    private let block: () -> ()
    
    public init(_ block: @escaping () -> ()) {
        self.block = block
    }
    
    public func dispose() {
        block()
    }
}
