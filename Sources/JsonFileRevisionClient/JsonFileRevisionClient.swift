//
//  JsonFileRevisionClient.swift
//  JsonFileRevision
//
//  Created by Bernardo Breder on 11/01/17.
//
//

import Foundation

#if SWIFT_PACKAGE
    import DataStore
    import JsonFileChange
    import JsonFileRevisionBase
#endif

public class JsonFileRevisionClient: JsonFileRevisionBase {
    
    let track = JsonFileChange()
    
    var branch: String
    
    var revisionId: Int
    
    public init(reader: DataStoreReader) throws {
        self.revisionId = try reader.sequence(name: JsonFileRevisionTable)
        self.branch = JsonFileBranchMaster
        super.init()
    }
    
    public func read<T>(reader: DataStoreReader, _ callback: @escaping (JsonFileChangeFileReader) throws -> T) throws -> T {
        return try track.read(reader: reader, callback)
    }
    
    public func write(writer: DataStoreWriter, _ callback: @escaping (JsonFileChangeFileWriter) throws -> Void) throws {
        try track.write(writer: writer, callback)
    }
    
    public var changes: [JsonFileChangeProtocol] {
        return track.changes
    }
    
}

public enum JsonFileRevisionClientError: Error {
    case workspaceDirty
    case branchAlreadyExist(String)
    case branchNotExist(String)
}
