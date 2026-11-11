// Cashflow "Today" widget (systemSmall, 170×170 design): what you spent today.
// The Flutter app writes the values (already formatted and localized) through
// home_widget into the shared App Group; this extension only draws them.
// Tapping opens the app's Add sheet (cashflow://add).

import SwiftUI
import WidgetKit

private let appGroupId = "group.com.cashflow.cashflow"

struct TodayEntry: TimelineEntry {
    let date: Date
    let amount: String
    let isZero: Bool
    let currency: String
    let label: String
    let accessibility: String
    let rtl: Bool
    let dark: Bool

    static let placeholder = TodayEntry(
        date: Date(), amount: "44.250", isZero: false, currency: "د.ت",
        label: "اليوم", accessibility: "مصاريف اليوم: 44.250 د.ت", rtl: true, dark: true
    )

    /// Reads what the app saved; shows 0 once the stored day is over.
    static func load(at date: Date) -> TodayEntry {
        let d = UserDefaults(suiteName: appGroupId)
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd"
        let stale = d?.string(forKey: "today_date") != fmt.string(from: date)

        let zero = d?.string(forKey: "today_zero") ?? "0.000"
        let amount = stale ? zero : (d?.string(forKey: "today_amount") ?? zero)
        let label = d?.string(forKey: "today_label") ?? "اليوم"
        let currency = d?.string(forKey: "today_currency") ?? "د.ت"
        let a11y = stale ? "\(label): \(zero) \(currency)"
            : (d?.string(forKey: "today_a11y") ?? "\(label): \(amount) \(currency)")
        return TodayEntry(
            date: date,
            amount: amount,
            isZero: stale || (d?.object(forKey: "today_is_zero") as? Bool ?? true),
            currency: currency,
            label: label,
            accessibility: a11y,
            rtl: d?.object(forKey: "today_rtl") as? Bool ?? true,
            dark: d?.object(forKey: "today_dark") as? Bool ?? true
        )
    }
}

struct TodayProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayEntry { .placeholder }

    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> Void) {
        completion(context.isPreview ? .placeholder : .load(at: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayEntry>) -> Void) {
        let now = Date()
        let midnight = Calendar.current.startOfDay(for: now.addingTimeInterval(24 * 60 * 60))
        // Now, then reset to 0 at midnight; the app pushes fresh data whenever it changes.
        let entries = [TodayEntry.load(at: now), TodayEntry.load(at: midnight)]
        completion(Timeline(entries: entries, policy: .after(midnight)))
    }
}

private extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

/// Two Cashflow waves on a 58-pt grid.
private struct Waves: Shape {
    let dy: CGFloat

    func path(in rect: CGRect) -> Path {
        let s = rect.width / 58
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * s, y: (y + dy) * s) }
        var path = Path()
        path.move(to: p(8, 22))
        path.addCurve(to: p(25, 13), control1: p(15, 22), control2: p(17, 13))
        path.addCurve(to: p(42, 22), control1: p(33, 13), control2: p(35, 22))
        path.addCurve(to: p(50, 16), control1: p(49, 22), control2: p(49, 18))
        return path
    }
}

private struct LogoBadge: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color(hex: 0x4263EB))
            Waves(dy: 0).stroke(.white, style: StrokeStyle(lineWidth: 1.65, lineCap: .round))
                .frame(width: 16, height: 16)
            Waves(dy: 16).stroke(.white.opacity(0.6), style: StrokeStyle(lineWidth: 1.65, lineCap: .round))
                .frame(width: 16, height: 16)
        }
        .frame(width: 26, height: 26)
        .accessibilityHidden(true)
    }
}

struct TodayWidgetView: View {
    let entry: TodayEntry

    private var background: Color { entry.dark ? Color(hex: 0x262629) : .white }
    private var text: Color { entry.dark ? Color(hex: 0xF2F2F4) : Color(hex: 0x111114) }
    private var muted: Color { entry.dark ? Color(hex: 0x8E8E93) : Color(hex: 0x62626B) }
    private var zero: Color { entry.dark ? Color(hex: 0x6B6B72) : Color(hex: 0xA1A1AA) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Text(entry.label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(muted)
                    .lineLimit(1)
                Spacer(minLength: 0)
                LogoBadge()
            }
            Spacer(minLength: 0)
            VStack(alignment: .leading, spacing: 2) {
                // Digits never mirror.
                Text(entry.amount)
                    .font(.system(size: 40, weight: .heavy).monospacedDigit())
                    .kerning(-1.2)
                    .foregroundColor(entry.isZero ? zero : text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .environment(\.layoutDirection, .leftToRight)
                Text(entry.currency)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(muted)
            }
        }
        .environment(\.layoutDirection, entry.rtl ? .rightToLeft : .leftToRight)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(entry.accessibility)
        .widgetURL(URL(string: "cashflow://add?homeWidget"))
        .modifier(WidgetBackground(color: background))
    }
}

private struct WidgetBackground: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            content.padding(2).containerBackground(color, for: .widget)
        } else {
            content.padding(18).background(color)
        }
    }
}

@main
struct TodayWidget: Widget {
    let kind = "TodayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayProvider()) { entry in
            TodayWidgetView(entry: entry)
        }
        .configurationDisplayName("Cashflow")
        .description("What you spent today")
        .supportedFamilies([.systemSmall])
    }
}
