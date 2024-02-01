//
//  TableViewModel.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import UIKit

protocol DownloadProtocol: AnyObject {
    func downloadAndSaveVideo(at videoID: String, and url: URL)
}

// MARK: - Enum
enum State {
    case none, createNoteAndReloadTable
    case reloadEditedNoteInTable(at: [IndexPath])
}

final class TableViewModel {

    // MARK: - Public properties
    private(set) var notesModel: [NoteModel] = []
    
    var closureChangingState: ((State) -> Void)?
//    let fManager: LocalFilesManagerProtocol

    var state: State = .none {
        didSet {
            closureChangingState?(state)
        }
    }

    // MARK: - Private properties
    private weak var notesCoordinator: NotesCoordinatorProtocol?
    private var noteModels: [NoteModel]

    // MARK: - Init
    init(coordinator: NotesCoordinatorProtocol) {
        self.notesCoordinator = coordinator
    }

    // MARK: - Public methods
    func loadNotes() {
        // Здесь вы можете использовать FileManager для получения списка файлов и создания моделей заметок на основе этих файлов
        // Пример:
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for url in fileURLs {
                let note = NoteModel(name: url.lastPathComponent, fileURL: url)
                notes.append(note)
            }
        } catch {
            print("Ошибка загрузки заметок: \(error)")
        }
    }

    func didTapAddNote() {
        notesCoordinator?.pushSecondVC()
    }

}


// MARK: - DownloadProtocol
extension DownloadViewModel: DownloadProtocol {

    func downloadAndSaveVideo(at videoID: String, and url: URL) {
        state = .noteIsShowing //сразу после того как нажали на ячейку

    }
}


// MARK: - ExtensionDelegate
extension TableViewModel: AddNoteDelegate {
    // происходит в момент нажатия Save в AddOrEditHabitVC
    func reloadData() {
        notesModel = HabitsStore.shared.habits //место, где хранятся заметки
        state = .createHabitAndReloadCollection
    }
}


extension TableViewModel: EditNoteDelegate {
    // происходит в момент нажатия Save в AddOrEditHabitVC
    func reloadEditedNoteAt(_ indexPath: IndexPath, dueTo tappedButton: HabitVCState) {
        notesModel = HabitsStore.shared.habits

        if tappedButton == .edit {
            state = .reloadEditedHabit(at: [indexPath])
        } else if tappedButton == .delete {
            state = .deleteHabitAndReloadCollection
        }
    }
}

