//
//  MoeAlertNameSpace.swift
//  MoeAlert
//
//  Created by Zed on 2020/12/31.
//

import Foundation


/// 类型包装协议
public protocol AlertTypeWrapperProtocol {
    /// 包装值的类型
    associatedtype WrappedType
    
    /// 被包装值，引用包装类型的实例
    var wrappedValue: WrappedType { get }
    /// 构造方法，为被包装值进行赋值
    init(value: WrappedType)
}


/// 命名空间包装器
/// `结构体`类型：WrapperType使用等号`==`限制类型
/// `对象`类型：WrapperType使用冒号`:`限制类型
public struct AlertNamespaceWrapper<WT>: AlertTypeWrapperProtocol {
    public typealias WrappedType = WT
    /// 被包装值，其类型由泛型指定
    public let wrappedValue: WT
    /// 构造方法，为被包装值进行赋值
    public init(value: WT) { self.wrappedValue = value }
}


/// 命名空间包装协议
public protocol AlertNamespaceWrappable {
    associatedtype WrapperType
    var alert: WrapperType { get }
    static var alert: WrapperType.Type { get }
}


/// 命名空间包装协议扩展
public extension AlertNamespaceWrappable {
    var alert: AlertNamespaceWrapper<Self> {
        return AlertNamespaceWrapper(value: self)
    }
    static var alert: AlertNamespaceWrapper<Self>.Type {
        return AlertNamespaceWrapper.self
    }
}
