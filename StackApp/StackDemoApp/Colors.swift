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
    background: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x181818, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x2E2E2E, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0x181818, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x2E2E2E, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x50C4CF, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xFBDD74, opacity: 1)
  )

  static let type2: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x00214D, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x1B2D45, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xF2F4F6, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x00214D, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x1B2D45, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0x00214D, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xFF5470, opacity: 1)
  )

  static let type3: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x094067, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x5F6C7B, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0x094067, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x5F6C7B, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x3DA9FC, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xEF4565, opacity: 1)
  )

  static let type4: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0x16161A, opacity: 1),
    headline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x94A1B2, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0x242629, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x94A1B2, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x7F5AF0, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1)
  )

  static let type5: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xF2F7F5, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x00473E, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x475D5B, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x00473E, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x475D5B, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xFAAE2C, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0x00473E, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xD8779A, opacity: 1)
  )

  static let type6: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x2B2C34, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x2B2C34, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xD1D1E9, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x2B2C34, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x2B2C34, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x6246EA, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xE45858, opacity: 1)
  )

  static let type7: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xFEC7D7, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x0E172C, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x0E172C, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x0E172C, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x0E172C, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x0E172C, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xA786DF, opacity: 1)
  )

  static let type8: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xF8F5F2, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x232323, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x222525, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x232323, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x222525, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x078080, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0x078080, opacity: 1)
  )

  static let type9: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xEFF0F3, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x0D0D0D, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x2A2A2A, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x0D0D0D, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x2A2A2A, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xFF8E3C, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0x0D0D0D, opacity: 1)
  )

  static let type10: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0x004643, opacity: 1),
    headline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0xABD1C6, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xE8E4E6, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x001E1D, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0xABD1C6, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x004643, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0x001E1D, opacity: 1)
  )

  static let type11: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xF9F4EF, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x020826, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x716040, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x020826, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x716040, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x8C7851, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xF25042, opacity: 1)
  )

  static let type12: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0x232946, opacity: 1),
    headline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0xB8C1EC, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x232946, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x232946, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0x232946, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xB8C1EC, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xD4939D, opacity: 1)
  )

  static let type13: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0x0F0E17, opacity: 1),
    headline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0xA7A9BE, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x0F0E17, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0xA7A9BE, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xFF8906, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xE53170, opacity: 1)
  )

  static let type14: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x272343, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x2D334A, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0x272343, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x2D334A, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xBAE8E8, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0x272343, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xBAE8E8, opacity: 1)
  )

  static let type15: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xFAEEE7, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x33272A, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x594A4E, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x33272A, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x594A4E, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xFFC6C7, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0x33272A, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0x33272A, opacity: 1)
  )

  static let type16: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0x55423D, opacity: 1),
    headline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0xFFF3EC, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0xFFC0AD, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0x271C19, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0xFFF3EC, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0x271C19, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0x9656A1, opacity: 1)
  )

  static let type17: ColorScheme = .init(
    background: .init(.displayP3, hexInt: 0xFEF6E4, opacity: 1),
    headline: .init(.displayP3, hexInt: 0x001858, opacity: 1),
    paragraph: .init(.displayP3, hexInt: 0x172C66, opacity: 1),
    cardBackground: .init(.displayP3, hexInt: 0x001858, opacity: 1),
    cardHeadline: .init(.displayP3, hexInt: 0xFFFFFE, opacity: 1),
    cardParagraph: .init(.displayP3, hexInt: 0x172C66, opacity: 1),
    cardTagBackground: .init(.displayP3, hexInt: 0xFEF6E4, opacity: 1),
    cardTagText: .init(.displayP3, hexInt: 0x001858, opacity: 1),
    cardHighlight: .init(.displayP3, hexInt: 0xF582AE, opacity: 1)
  )

  static var allTypes: [ColorScheme] = [
    .type1,
    .type2,
    .type3,
    .type4,
    .type5,
    .type6,
    .type7,
    .type8,
    .type9,
    .type10,
    .type11,
    .type12,
    .type13,
    .type14,
    .type15,
    .type16,
    .type17,
  ]

  static func takeOne(except one: ColorScheme) -> ColorScheme {

    let i = allTypes.firstIndex(of: one)!

    let next = i.advanced(by: 1)

    guard allTypes.indices.contains(next) else {
      return allTypes.first!
    }

    return allTypes[next]
  }

}



struct ColorSchemePreview_Previews: PreviewProvider {

  struct ColorSchemePreview: View {
    let colorScheme: ColorScheme

    /*
     let background: Color
     let headline: Color
     let paragraph: Color
     let cardBackground: Color
     let cardHeadline: Color
     let cardParagraph: Color
     let cardTagBackground: Color
     let cardTagText: Color
     let cardHighlight: Color
     */

    var body: some View {
      HStack {
        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.background)
          .frame(height: 60)
        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.headline)
          .frame(height: 60)
        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.paragraph)
          .frame(height: 60)
        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.cardBackground)
          .frame(height: 60)
        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.cardHeadline)
          .frame(height: 60)
        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.cardParagraph)
          .frame(height: 60)
        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.cardTagBackground)
          .frame(height: 60)

        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.cardTagText)
          .frame(height: 60)
        RoundedRectangle(cornerRadius: 10)
          .fill(colorScheme.cardHighlight)
          .frame(height: 60)
      }
      .padding()
    }
  }

  static var previews: some View {
    ScrollView {
      Group {
        ColorSchemePreview(colorScheme: ColorScheme.type1)
        ColorSchemePreview(colorScheme: ColorScheme.type2)
        ColorSchemePreview(colorScheme: ColorScheme.type3)
        ColorSchemePreview(colorScheme: ColorScheme.type4)
        ColorSchemePreview(colorScheme: ColorScheme.type5)
        ColorSchemePreview(colorScheme: ColorScheme.type6)
        ColorSchemePreview(colorScheme: ColorScheme.type7)
        ColorSchemePreview(colorScheme: ColorScheme.type8)
      }
      Group {
        ColorSchemePreview(colorScheme: ColorScheme.type9)
        ColorSchemePreview(colorScheme: ColorScheme.type10)
        ColorSchemePreview(colorScheme: ColorScheme.type11)
        ColorSchemePreview(colorScheme: ColorScheme.type12)
        ColorSchemePreview(colorScheme: ColorScheme.type13)
        ColorSchemePreview(colorScheme: ColorScheme.type14)
        ColorSchemePreview(colorScheme: ColorScheme.type15)
        ColorSchemePreview(colorScheme: ColorScheme.type16)
        ColorSchemePreview(colorScheme: ColorScheme.type17)
      }
    }
    .background(Color.gray)
    .previewLayout(.sizeThatFits)
    .padding()
  }
}
