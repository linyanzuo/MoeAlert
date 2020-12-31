//
//  MoeAlertNameSpace.swift
//  MoeAlert
//
//  Created by Zed on 2020/12/31.
//
// 命名空间包装协议

import Foundation


/// 类型包装协议
/// 针对`对象`处理，WrapperType使用冒号`:`限制类型
public protocol TypeWrapperProtocol {
    /// 包装类型，取遵守该协议对象的数据类型
    associatedtype WrappedType
    
    /// 被包装值，引用包装类型的实例
    var wrappedValue: WrappedType { get }
    /// 构造方法，为被包装值进行赋值
    init(value: WrappedType)
}


/// 命名空间包装器
/// 针对`结构体`处理, WrapperType使用等号`==`限制类型
public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    /// 被包装值，其类型由泛型指定
    public let wrappedValue: T
    /// 构造方法，为被包装值进行赋值
    public init(value: T) { self.wrappedValue = value }
}


/// 命名空间包装协议（对象）
public protocol AlertNamespaceWrappable {
    associatedtype WrapperType
    var alert: WrapperType { get }
    static var alert: WrapperType.Type { get }
}


/// 命名空间包装扩展（结构体）
public extension AlertNamespaceWrappable {
    var alert: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    static var alert: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}
