//
//  JsonFileRevisionClientBranch.swift
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
    
    public func listBranch(reader: DataStoreReader) throws -> [String] {
        return try JsonFileRevisionBase.branchList(reader: reader).map { d in d.name }
    }
    
    public func createdBranch(writer: DataStoreWriter, name: String) throws {
        guard try JsonFileRevisionBase.branchList(reader: writer).filter({ d in d.name == name }).isEmpty else { throw JsonFileRevisionClientError.branchAlreadyExist(name) }
        
        let branchData = JsonFileRevisionBranch(id: try JsonFileRevisionBase.branchSequence(writer: writer), name: name, createdId: revisionId + 1, lastReintegratedId: revisionId + 1)
        try JsonFileRevisionBase.branchInsert(writer: writer, data: branchData)
        
        let revisionData = JsonFileRevisionCreateBranch(id: revisionId + 1, name: name)
        try JsonFileRevisionBase.revisionInsert(writer: writer, data: revisionData)
        
        revisionId += 1
    }
    
    public func switchBranch(writer: DataStoreWriter, branch: String) throws {
        guard self.branch != branch else { return }
        guard track.changes.isEmpty else { throw JsonFileRevisionClientError.workspaceDirty }
        guard let branchData = try JsonFileRevisionBase.branchList(reader: writer).appendAndReturn(JsonFileRevisionBranch(id: 0, name: JsonFileBranchMaster, createdId: 0, lastReintegratedId: 0)).filter({ d in d.name == branch }).first else { throw JsonFileRevisionClientError.branchNotExist(branch) }
        try track.databaseFileSystem.write(writer: writer) { dfsw in
            var rev = try JsonFileRevisionBase.revisionExist(reader: writer, id: revisionId)
            if self.branch != JsonFileBranchMaster {
                while let revision = rev, !revision.createBranch(branch: self.branch) {
                    rev = try revision
                        .commit(branch: self.branch) { r in try r.revert(writer: dfsw) }
                        .prev(reader: writer)
                }
            }
            if branch != JsonFileBranchMaster {
                let branchRevision = try JsonFileRevisionBase.revisionGet(reader: writer, id: branchData.createdId)
                if let revision = rev, revision.id <= branchRevision.id {
                    while let revision = rev, revision.id <= branchRevision.id {
                        rev = try revision
                            .commit(branch: JsonFileBranchMaster) { r in try r.apply(writer: dfsw) }
                            .next(reader: writer)
                    }
                } else {
                    while let revision = rev, !revision.createBranch(branch: branch) {
                        rev = try revision
                            .commit(branch: JsonFileBranchMaster) { r in try r.revert(writer: dfsw) }
                            .prev(reader: writer)
                    }
                }
            }
            while let revision = rev, revision.id <= revisionId {
                rev = try revision
                    .commit(branch: branch) { r in try r.apply(writer: dfsw) }
                    .next(reader: writer)
            }
        }
        self.branch = branch
    }
    
}
