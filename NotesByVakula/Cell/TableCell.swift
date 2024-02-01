//
//  TableCell.swift
//  NotesByVakula
//
//  Created by Roman Vakulenko on 31.01.2024.
//

import UIKit


final class TableCell: UITableViewCell {

    // MARK: - Private properties
    private var notes: NoteModel?

    private var urlOfNoteInFM: URL?

    private let noteTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    ///c помощью UINoteModel которая  имеет URL  к mp4 в FileManager
//    func configure(with uiNoteModel: NoteProtocol?) {
//
//        if let uiNote = uiNoteModel {
//            urlOfNoteInFM = uiNote.noteFileURLWithPathInFM
//        }
//    }

    // MARK: - Private methods
    private func setupView() {
        contentView.addSubview(noteTitle)
        contentView.backgroundColor = .lightGray
    }

    private func layout() {
        NSLayoutConstraint.activate([
            noteTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            noteTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            noteTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            noteTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
