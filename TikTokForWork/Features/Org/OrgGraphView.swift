import SwiftUI

struct OrgGraphView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    private var graph: OrganizationGraph { appState.organization }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                    let people = graph.nodes.filter { $0.kind == .person }
                    let agents = graph.nodes.filter { $0.kind == .agent }
                    let teams = graph.nodes.filter { $0.kind == .team }
                    let projects = graph.nodes.filter { $0.kind == .project }

                    if !people.isEmpty { section("People", items: people) }
                    if !agents.isEmpty { section("Agents", items: agents) }
                    if !teams.isEmpty { section("Teams", items: teams) }
                    if !projects.isEmpty { section("Projects", items: projects) }

                    if !graph.edges.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                            Text("Relationships")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.Colors.textTertiary)

                            ForEach(graph.edges) { edge in
                                Text(relationshipLabel(for: edge))
                                    .font(.system(size: 13, design: .monospaced))
                                    .foregroundStyle(Theme.Colors.textSecondary)
                            }
                        }
                    }

                    if graph.nodes.isEmpty {
                        Text("No organization data yet. Connect GitHub and your team will appear here.")
                            .font(Theme.TypeScale.caption)
                            .foregroundStyle(Theme.Colors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, Theme.Spacing.xl)
                    }
                }
                .padding(Theme.Spacing.screen)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Organization")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
        }
        .presentationBackground(Theme.Colors.background)
    }

    private func section(_ title: LocalizedStringKey, items: [OrgNode]) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(Theme.Colors.textTertiary)

            ForEach(items) { node in
                Text(node.label)
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.horizontal, Theme.Spacing.md)
                    .background(Theme.Colors.surfaceRaised)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
            }
        }
    }

    private func relationshipLabel(for edge: OrgEdge) -> String {
        let from = graph.nodes.first { $0.id == edge.fromID }?.label ?? edge.fromID
        let to = graph.nodes.first { $0.id == edge.toID }?.label ?? edge.toID
        return "\(from)  \(edge.kind.rawValue)  \(to)"
    }
}

#Preview {
    OrgGraphView()
        .environmentObject(AppState())
}
