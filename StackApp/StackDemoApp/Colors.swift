import SwiftUI

extension Color {
  static var hhueBackground: Color {
    .init(.displayP3, hexInt: 0xd1d1e9, opacity: 1)
  }
  static var hhueHeadline: Color {
    .init(.displayP3, hexInt: 0x2b2c34, opacity: 1)
  }
  static var hhueParagraph: Color {
    .init(.displayP3, hexInt: 0x2b2c34, opacity: 1)
  }
  static var hhueLink: Color {
    .init(.displayP3, hexInt: 0x6246ea, opacity: 1)
  }
  static var hhueCardBackground: Color {
    .init(.displayP3, hexInt: 0xfffffe, opacity: 1)
  }
  static var hhueCardHeadline: Color {
    .init(.displayP3, hexInt: 0x2b2c34, opacity: 1)
  }
  static var hhueCardParagraph: Color {
    .init(.displayP3, hexInt: 0x2b2c34, opacity: 1)
  }
  static var hhueNewsletterBackground: Color {
    .init(.displayP3, hexInt: 0xe45858, opacity: 1)
  }
  static var hhueFormInput: Color {
    .init(.displayP3, hexInt: 0xfffffe, opacity: 1)
  }
  static var hhueLabelPlaceholder: Color {
    .init(.displayP3, hexInt: 0x2b2c34, opacity: 1)
  }
  static var hhueFormButton: Color {
    .init(.displayP3, hexInt: 0x6246ea, opacity: 1)
  }
  static var hhueFormButtonText: Color {
    .init(.displayP3, hexInt: 0xfffffe, opacity: 1)
  }
}

struct ColorScheme: Equatable {
  let background: Color
  let headline: Color
  let paragraph: Color
  let cardBackground: Color
  let cardHeadline: Color
  let cardParagraph: Color
  let cardTagBackground: Color
  let cardTagText: Color
  let cardHighlight: Color

  static let type1: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0x004643, opacity: 1),
    headline: .init(.displayP3, hexInt: 0xfffffe, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0xabd1c6, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xe8e4e6, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x001e1d, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x0f3433, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x004643, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0x001e1d, opacity: 1)
  )

  static let type2: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xf9f4ef, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x020826, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x716040, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x020826, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x716040, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x8c7851, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xf25042, opacity: 1)
  )

  static let type3: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xfffffe, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x2b2c34, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x2b2c34, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xd1d1e9, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x2b2c34, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x2b2c34, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x6246ea, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xe45858, opacity: 1)
  )

  static let type4: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0x55423d, opacity: 1),
    headline: .init(.displayP3, hexInt: 0xfffffe, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0xfff3ec, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xffc0ad, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x271c19, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0xfff3ec, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0x271c19, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0x9656a1, opacity: 1)
  )

  static let type5: ColorScheme = .init(
    background: Color(.displayP3, hexInt: 0x0f0e17, opacity: 1),
    headline: Color(.displayP3, hexInt: 0xfffffe, opacity: 1),
    paragraph: Color(.displayP3, hexInt: 0xa7a9be, opacity: 1),
    cardBackground: Color(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardHeadline: Color(.displayP3, hexInt: 0x0f0e17, opacity: 1),
    cardParagraph: Color(.displayP3, hexInt: 0xa7a9be, opacity: 1),
    cardTagBackground: Color(.displayP3, hexInt: 0xff8906, opacity: 1),
    cardTagText: Color(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardHighlight: Color(.displayP3, hexInt: 0xe53170, opacity: 1)
  )

  static let type6: ColorScheme = .init(
    background: Color(.displayP3, hexInt: 0xfec7d7, opacity: 1),
    headline: Color(.displayP3, hexInt: 0x0e172c, opacity: 1),
    paragraph: Color(.displayP3, hexInt: 0x0e172c, opacity: 1),
    cardBackground: Color(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardHeadline: Color(.displayP3, hexInt: 0x0e172c, opacity: 1),
    cardParagraph: Color(.displayP3, hexInt: 0x0e172c, opacity: 1),
    cardTagBackground: Color(.displayP3, hexInt: 0x0e172c, opacity: 1),
    cardTagText: Color(.displayP3, hexInt: 0xfffffe, opacity: 1),
    cardHighlight: Color(.displayP3, hexInt: 0xa786df, opacity: 1)
  )

  static var allTypes: [ColorScheme] = [
    .type1,
    .type2,
    .type3,
    .type4,
    .type5,
    .type6
  ]

  static func takeOne(except one: ColorScheme) -> ColorScheme {
    allTypes.filter { $0 != one }.randomElement()!
  }

}

import SwiftUI

struct ColorSchemePreview: View {
  let colorScheme: ColorScheme

  var body: some View {
    VStack {
      Text("Headline")
        .font(.title)
        .foregroundColor(colorScheme.headline)
      Text("Paragraph")
        .font(.title)
        .foregroundColor(colorScheme.paragraph)
    }
    .padding()
    .background(colorScheme.background)
    .cornerRadius(10)
  }
}

struct ColorSchemePreview_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ColorSchemePreview(colorScheme: ColorScheme.type1)
        .previewDisplayName("Type 1")

      ColorSchemePreview(colorScheme: ColorScheme.type2)
        .previewDisplayName("Type 2")

      ColorSchemePreview(colorScheme: ColorScheme.type3)
        .previewDisplayName("Type 3")

      ColorSchemePreview(colorScheme: ColorScheme.type4)
        .previewDisplayName("Type 4")
    }
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
