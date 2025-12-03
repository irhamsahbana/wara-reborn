import SwiftUI

struct ReportIssueSection: View {
    let toEmail: String
    let subject: String
    let englishName: String
    let koreanName: String
    let productId: String
    let isKmf: Bool

    @Environment(\.openURL) private var openURL

    private var mailtoURL: URL? {
        let safeEmail = toEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !safeEmail.isEmpty else { return nil }

        let subj = subject.isEmpty ? "Report/Request Update" : subject
        let source = isKmf ? "kmf" : "user"
        let bodyTemplate = "Hello Team, Please modify this Product information:\n- English Name: \(englishName)\n- Korean Name: \(koreanName)\n- Product ID: \(productId)\n- Source: \(source)\n\nWrite your response here:\n\n"

        let subjectEncoded = subj.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subj
        let bodyEncoded = bodyTemplate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? bodyTemplate
        return URL(string: "mailto:\(safeEmail)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
    }

    var body: some View {
        CardView(backgroundColor: Color.waraChipBackground, aligment: .leading, width: .infinity) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Report an Issue:")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)

                    Text("Noticed something off about this product? Let us know so our team can review and fix it. Your feedback helps keep Wara accurate and trustworthy!")
                        .font(.body)
                        .foregroundColor(.primary)
                }

                GeometryReader { geo in
                    HStack {
                        Spacer()
                        Button("Send Report") {
                            if let url = mailtoURL {
                                openURL(url)
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color.waraPrimary, cornerRadius: 28, isFullWidth: false, horizontalPadding: 10, verticalPadding: 10))
                        .frame(width: max(geo.size.width / 3, 160))
                        Spacer()
                    }
                }
                .frame(height: 56)
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ReportIssueSection(
        toEmail: "muslimfriendly.kr@gmail.com",
        subject: "Report/Request Update",
        englishName: "Strawberry Sticky Rice Cake",
        koreanName: "딸기 찹쌀떡",
        productId: "8801093174472",
        isKmf: true
    )
}
