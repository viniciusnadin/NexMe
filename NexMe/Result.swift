// Result.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

// MARK: - Result

public enum Result<T> {
    case Success(T)
    case Failure(Error)

    public init(value: T) {
        self = .Success(value)
    }
    
    public init(error: Error) {
        self = .Failure(error)
    }
}

// MARK: - Unwrappers

extension Result {
    public var value: T? {
        switch self {
        case .Success(let value): return value
        case .Failure(_): return .none
        }
    }

    public var succeeded: Bool {
        switch self {
        case .Success(_): return true
        case .Failure(_): return false
        }
    }

    public var error: Error? {
        switch self {
        case .Success(_): return .none
        case .Failure(let error): return error
        }
    }

    public var failed: Bool {
        switch self {
        case .Success(_): return false
        case .Failure(_): return true
        }
    }
    
    public func check() throws {
        switch self {
        case .Success(_): return
        case .Failure(let error): throw error
        }
    }
    
    public func getValue() throws -> T {
        switch self {
        case .Success(let value): return value
        case .Failure(let error): throw error
        }
    }
}

public func strive<T>( f: @escaping (Void) throws -> T?) -> Result<T> {
    return Result<T>.strive(f: f)
}

public func strive<T>(completion: @escaping (Result<T>) -> Void,
    runQueue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.default.qosClass),
    resultQueue: DispatchQueue = DispatchQueue.main,
    f: @escaping (Void) throws -> T?) {
        
    
    runQueue.async {
        let result = Result<T>.strive(f: f)
        resultQueue.async {
            completion(result)
        }

    }
}

public func strive<T>(completion: @escaping (Result<T>) -> Void,
    runQueue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.default.qosClass),
    resultQueue: DispatchQueue = DispatchQueue.main,
    f: @escaping ((T) -> Void) throws -> Void) {

    
    runQueue.async {
        let result = Result<T>.strive(f: f)
        resultQueue.async {
            completion(result)
        }
    }
}

public func deliver<T>(
    completion: @escaping (Result<T>) -> Void,
    f: @escaping((_ success: @escaping ((T) -> Void), _ failure: @escaping ((Error) -> Void)) -> Void)) {
        
    let s = { (v: T) in
        completion(Result<T>(value: v))
    }
    
    let fl = { (e: Error) in
        completion(Result<T>(error: e))
    }
    
    f(s, fl)
}

public func strive<T>(
    completion: @escaping (Result<T>) -> Void,
    runQueue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.default.qosClass),
    resultQueue: DispatchQueue = DispatchQueue.main,
    f: @escaping ((_ success: ((T) -> Void), _ failure: ((Error) -> Void)) throws -> Void)) {

    let s = { (v: T) in
        resultQueue.async {
            completion(Result<T>(value: v))

        }
    }

    let fl = { (e: Error) in
        
        resultQueue.async {
            completion(Result<T>(error: e))
        }
    }
    
    runQueue.async {
        do {
            try f(s, fl)
        } catch {
            resultQueue.async {
                completion(Result<T>(error: error))
            }
        }
    }
}

enum ResultError: Error {
    case NoValue
}

extension Result {
    public static func strive<T>( f: @escaping (Void) throws -> T?) -> Result<T> {
        let e: Error?
        let v: T?

        do {
            v = try f()
            e = nil
        } catch {
            v = nil
            e = error
        }

        if let e = e {
            return Result<T>(error: e)
        }
        
        if let value = v {
            return Result<T>(value: value)
        }
        
        return Result<T>(error: ResultError.NoValue)
    }

    public static func strive<T>( f: @escaping((T) -> Void) throws -> Void) -> Result<T> {
        var e: Error?
        var v: T?

        do {
            try f { value in
                v = value
                e = nil
            }
        } catch {
            v = nil
            e = error
        }

        if let v = v {
            return Result<T>(value: v)
        }

        if let e = e {
            return Result<T>(error: e)
        }
        
        return Result<T>(error: ResultError.NoValue)
    }

//    public func failure(@noescape f: ErrorType -> Void) -> Result<T> {
//        if let errors = errors {
//            for error in errors {
//                f(error)
//            }
//        }
//
//        return self
//    }
//
//    public func failure<E: ErrorType>(type: E.Type, @noescape f: E -> Void) -> Result<T> {
//        if let errors = errors {
//            for error in errors {
//                if let error = error as? E {
//                    f(error)
//                }
//            }
//        }
//
//        return self
//    }
//
//    public func success(@noescape f: T -> Void) -> Result<T> {
//        if let value = value {
//            f(value)
//        }
//
//        return self
//    }
//
//    public func finally(@noescape finally: Void -> Void) -> Result<T> {
//        finally()
//        return self
//    }

}

// MARK: - Functional

public func ??<T>(result: Result<T>, defaultValue: @autoclosure () -> T) -> T {
    switch result {
    case .Success(let value): return value
    case .Failure(_): return defaultValue()
    }
}

extension Result {
    public func map<U>(f: @escaping (T) throws -> U) -> Result<U> {
        switch self {
        case .Success(let value):
            do {
                return Result<U>(value: try f(value))
            } catch {
                return Result<U>(error: error)
            }
        case .Failure(let error):
            return Result<U>(error: error)
        }
    }
    
    public func mapError<U>(f: @escaping (T) throws -> Error) -> Result<U> {
        switch self {
        case .Success(let value):
            do {
                return Result<U>(error: try f(value))
            } catch {
                return Result<U>(error: error)
            }
        case .Failure(let error):
            return Result<U>(error: error)
        }
    }

    public func flatMap<U>(flatMap: @escaping(T) -> Result<U>) -> Result<U> {
        switch self {
        case .Success(let value): return flatMap(value)
        case .Failure(let errors): return .Failure(errors)
        }
    }
}

// MARK: - Printable

extension Result: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Success(let value): return "Success:\n\(value)"
        case .Failure(let errors): return "Failure:\n\(errors)"
        }
    }
}
