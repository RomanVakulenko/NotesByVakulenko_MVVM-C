//
//  TableViewModel.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import UIKit


final class TableViewModel {

    // MARK: - Enum
    enum State {
        case none, createNoteAndReloadTable
        case reloadEditedNoteInTable(at: [IndexPath])
    }

    // MARK: - Public properties
    private(set) var notesModel: [NoteModel] = NoteStore.shared.notes

    var closureChangingState: ((State) -> Void)?
    
    var state: State = .none {
        didSet {
            closureChangingState?(state)
        }
    }

    // MARK: - Private properties
    private weak var notesCoordinator: NotesCoordinatorProtocol?

    // MARK: - Init
    init(coordinator: NotesCoordinatorProtocol) {
        self.notesCoordinator = coordinator
    }

    // MARK: - Public methods
    func didTapAddNote() {
        notesCoordinator?.pushAddNewNoteVC(noteVCState: .add, delegate: self)
    }

    func didTapAtNote(at indexPath: IndexPath) {
        let tappedNote = notesModel[indexPath.item]

        notesCoordinator?.pushEditNoteVC(
            modelForEdit: tappedNote,
            noteState: .edit,
            delegate: self,
            indexPath: indexPath
        )
    }

}



// MARK: - ExtensionDelegate
extension TableViewModel: AddNoteDelegate {
    func reloadData() {
        notesModel = NoteStore.shared.notes
        state = .createNoteAndReloadTable
    }
}

extension TableViewModel: EditNoteDelegate {
    func reloadEditedNoteAt(_ indexPath: IndexPath, dueTo noteState: NoteVCState) {
        notesModel = NoteStore.shared.notes
        if noteState == .edit {
            state = .reloadEditedNoteInTable(at: [indexPath])
        }
    }
}

