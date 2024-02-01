//
//  Storage.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 01.02.2024.
//

import Foundation

//MARK: - Класс для хранения данных о заметке.
final class NoteModel: Codable {

    var name: String
    var noteText: String

    init(name: String, noteText: String) {
        self.name = name
        self.noteText = noteText
    }
}
/// сравнение
extension NoteModel: Equatable {
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        lhs.name == rhs.name
    }
}



//MARK: - Класс для сохранения и изменения заметок пользователя.
final class NoteStore {
    static let shared: NoteStore = .init()

    /// Список заметок, добавленных пользователем. Добавленные заметки сохраняются в UserDefaults и доступны после перезагрузки приложения.
    var notes: [NoteModel] = [] {
        didSet {
            save()
        }
    }
    // MARK: - Private properties
    private lazy var userDefaults: UserDefaults = .standard
    private lazy var decoder: JSONDecoder = .init()
    private lazy var encoder: JSONEncoder = .init()

    // MARK: - Public methods
    /// Сохраняет все изменения в заметках в UserDefaults.
    func save() {
        do {
            let data = try encoder.encode(notes)
            userDefaults.set(data, forKey: "notes")
        }
        catch {
            print("Ошибка кодирования заметок для сохранения", error)
        }
    }

    // MARK: - Init
    private init() {
        guard let data = userDefaults.data(forKey: "notes") else {
           /// Если в UserDefaults нет сохраненных заметок, то создаем новую заметку и сохраняем ее
            let newNote = NoteModel(name: "Название заметки по умолчанию", noteText: "Обязательное требование: При первом запуске приложение должно иметь одну заметку с текстом.")
            notes = [newNote]
            save()
            return
        }
        do {
            notes = try decoder.decode([NoteModel].self, from: data)
        }
        catch {
            print("Ошибка декодирования сохранённых заметок", error)
        }
    }
}
