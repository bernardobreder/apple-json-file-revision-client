//
//  JsonFileRevisionClientCommit.swift
//  JsonFileRevision
//
//  Created by Bernardo Breder on 02/02/17.
//
//

import Foundation

#if SWIFT_PACKAGE
    import DataStore
    import JsonFileRevisionBase
#endif

extension JsonFileRevisionClient {
    
    public func applyChanges(writer: DataStoreWriter, revisions: [JsonFileRevision]) throws {
        try track.write(writer: writer) { jdcw in
            for revision in revisions.sorted(by: { a, b in a.id <= b.id }) {
                try revision.commit(branch: self.branch, { c in try c.apply(writer: jdcw.writer) })
                try JsonFileRevisionBase.revisionInsert(writer: writer, data: revision)
                self.revisionId = revision.id
            }
        }
    }
    
    public func revertChanges(writer: DataStoreWriter) throws {
        try track.revert(writer: writer)
    }
    
    public func revertChanges() {
        track.changes.removeAll()
    }
    
    public func commitChanges(writer: DataStoreWriter) throws {
        let revision = JsonFileRevisionCommitBranch(id: revisionId + 1, branch: branch, changes: track.changes)
        try JsonFileRevisionBase.revisionInsert(writer: writer, data: revision)
        revisionId += 1
        track.changes.removeAll()
    }
    
}
