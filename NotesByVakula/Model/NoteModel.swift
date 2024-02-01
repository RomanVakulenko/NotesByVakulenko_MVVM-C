//
//  NoteModel.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import Foundation

protocol NoteProtocol: Any {
    var name: String { get set }
    var noteText: String { get set }
    var noteFileURLWithPathInFM: URL { get set }
}


// MARK: - Into this struct we save Note info
struct NoteModel: Codable, NoteProtocol {
    var name: String
    var noteText: String
    var noteFileURLWithPathInFM: URL
}
