//
//  Storage.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 01.02.2024.
//

import Foundation


final class Storage {

    // MARK: - Public properties
    public static let shared = Storage(mapper: DataMapper())

    public var dataModelsStoredInFM: [NoteModelData] = [] {
        didSet{
            encodeAndSaveModelsArrAsJsonFileToFM(dataModels: dataModelsStoredInFM)
        }
    }

    // MARK: - Private properties
    private let mapper: MapperProtocol


    // MARK: - Init
    private init(mapper: MapperProtocol) {
        self.mapper = mapper
    }

    // MARK: - Private methods
    private func encodeAndSaveModelsArrAsJsonFileToFM(dataModels: [NoteModelData]) {
        do {
            ///кодируем data из [NoteModelData] для сохранения videoItemData в FM
            let data = try mapper.encode(from: dataModels)
            ///сохраняем в FM по уникальному url
            try data.write(to: JsonModelsURL.inFM)
            print("\(dataModels), this array encoded to \(data) & saved to \(JsonModelsURL.inFM)")
        } catch {
            print("Error saving data to FileManager: \(error.localizedDescription)")
        }
    }

}
