
//
//  Created by Rusty Zarse on 3/11/22.
//

public struct PersonProfile {
    public let profileID: String
    public let imageName: String
    
    public init(
        profileID: String,
        imageName: String
    ) {
        self.profileID = profileID
        self.imageName = imageName
    }
}

extension PersonProfile: Hashable { }
extension PersonProfile: Identifiable {
    public var id: String { self.profileID }
}
