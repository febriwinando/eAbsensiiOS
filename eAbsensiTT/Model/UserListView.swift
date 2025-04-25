
import SwiftUI
import SwiftData

struct UserListView: View {
    @Query var users: [User]

    var body: some View {
        List(users) { user in
            VStack(alignment: .leading) {
                Text("Username: \(user.employee_id)")
                    .font(.headline)
                Text("Token: \(user.token)")
                    .font(.subheadline)
                Text("Created At: \(user.created_at)")
                    .font(.caption)
            }
            .padding()
        }
        .navigationTitle("Saved Users")
    }
}
