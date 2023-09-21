//
//  SectionArrayBuilder.swift
//  ResultBuilderForCollectionView
//
//  Created by 김종헌 on 2023/09/21.
//

import Foundation

struct Section {
    var items: [any Item]

    init(@SectionBuilder _ items: () -> [any Item]) {
        self.items = items()
    }
}

protocol Item {
    var id: String { get }
}

@resultBuilder
enum SectionArrayBuilder {
    static func buildExpression(_ expression: Section) -> [Section] {
        return [expression]
    }
    
    static func buildBlock(_ components: [Section]...) -> [Section] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [Section]?) -> [Section] {
        return component ?? []
    }
    
    static func buildEither(first component: [Section]) -> [Section] {
        return component
    }
    
    static func buildEither(second component: [Section]) -> [Section] {
        return component
    }
    
    static func buildArray(_ components: [[Section]]) -> [Section] {
        return components.flatMap { $0 }
    }
}

@resultBuilder
enum SectionBuilder {
    static func buildExpression(_ expression: any Item) -> [any Item] {
        return [expression]
    }
    
    static func buildBlock(_ components: [any Item]...) -> [any Item] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [any Item]?) -> [any Item] {
        return component ?? []
    }
    
    static func buildEither(first component: [any Item]) -> [any Item] {
        return component
    }
    
    static func buildEither(second component: [any Item]) -> [any Item] {
        return component
    }
    
    static func buildArray(_ components: [[any Item]]) -> [any Item] {
        return components.flatMap { $0 }
    }
}
