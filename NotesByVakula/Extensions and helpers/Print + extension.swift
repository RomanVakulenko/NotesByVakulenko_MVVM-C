//
//  Print + extension.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
    #endif
}
// This function signature matches the default Swift print so it overwrites the function throughout  project. If needed I can still access the original by using Swift.print().
// Will only print in debug builds
// так и не использовал)
