package com.cashflow.cashflow

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Typeface
import android.net.Uri
import android.os.Bundle
import android.util.TypedValue
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.math.ceil
import kotlin.math.max

/**
 * "Today" home-screen widget (2×2): what you spent today. Tapping it opens
 * the app's Add sheet (cashflow://add).
 *
 * The Flutter app writes the values (already formatted and localized) via
 * home_widget; this class only draws them. The amount is drawn with the
 * app's bundled Inter ExtraBold and shrinks to fit long numbers.
 */
class TodayWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            appWidgetManager.updateAppWidget(id, buildViews(context, appWidgetManager, id, widgetData))
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        val data = HomeWidgetPlugin.getData(context)
        appWidgetManager.updateAppWidget(appWidgetId, buildViews(context, appWidgetManager, appWidgetId, data))
    }

    private fun buildViews(
        context: Context,
        manager: AppWidgetManager,
        widgetId: Int,
        data: SharedPreferences,
    ): RemoteViews {
        val rtl = data.getBoolean("today_rtl", true) // Arabic is the default
        val dark = data.getBoolean("today_dark", true) // dark is the default
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        val stale = data.getString("today_date", null) != today

        val zero = data.getString("today_zero", null) ?: "0.000"
        val amount = if (stale) zero else (data.getString("today_amount", null) ?: zero)
        val isZero = stale || data.getBoolean("today_is_zero", true)
        val label = data.getString("today_label", null) ?: context.getString(R.string.today_widget_label)
        val currency = data.getString("today_currency", null) ?: "TND"
        val a11y = if (stale) "$label: $zero $currency" else (data.getString("today_a11y", null) ?: "$label: $amount $currency")

        val palette = if (dark) Palette.DARK else Palette.LIGHT
        val views = RemoteViews(
            context.packageName,
            if (rtl) R.layout.today_widget_rtl else R.layout.today_widget,
        )

        views.setInt(R.id.today_root, "setBackgroundResource", palette.background)
        views.setTextViewText(R.id.today_label, label)
        views.setTextColor(R.id.today_label, palette.muted)
        views.setTextViewText(R.id.today_currency, currency)
        views.setTextColor(R.id.today_currency, palette.muted)

        val density = context.resources.displayMetrics.density
        val widthDp = manager.getAppWidgetOptions(widgetId)
            .getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0)
            .takeIf { it > 0 } ?: 150
        val availablePx = max(60f, (widthDp - 2 * PADDING_DP) * density)
        views.setImageViewBitmap(
            R.id.today_amount,
            renderAmount(context, amount, if (isZero) palette.zero else palette.text, availablePx),
        )

        views.setContentDescription(R.id.today_root, a11y)
        views.setOnClickPendingIntent(
            R.id.today_root,
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("cashflow://add")),
        )
        return views
    }

    /** Draws the amount (40sp, ExtraBold, −3% tracking, tabular digits), shrunk to fit [maxWidthPx]. */
    private fun renderAmount(context: Context, text: String, color: Int, maxWidthPx: Float): Bitmap {
        val metrics = context.resources.displayMetrics
        val paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.SUBPIXEL_TEXT_FLAG).apply {
            typeface = interExtraBold(context)
            this.color = color
            letterSpacing = -0.03f
            fontFeatureSettings = "tnum"
            textSize = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, AMOUNT_SP, metrics)
        }
        val natural = paint.measureText(text)
        if (natural > maxWidthPx) paint.textSize *= maxWidthPx / natural

        val fm = paint.fontMetrics
        val width = ceil(paint.measureText(text)).toInt().coerceAtLeast(1)
        val height = ceil(fm.descent - fm.ascent).toInt().coerceAtLeast(1)
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        bitmap.density = metrics.densityDpi
        Canvas(bitmap).drawText(text, 0f, -fm.ascent, paint)
        return bitmap
    }

    private fun interExtraBold(context: Context): Typeface {
        cachedTypeface?.let { return it }
        val tf = try {
            Typeface.createFromAsset(context.assets, "flutter_assets/assets/fonts/Inter-ExtraBold.ttf")
        } catch (e: RuntimeException) {
            Typeface.create("sans-serif-black", Typeface.NORMAL)
        }
        cachedTypeface = tf
        return tf
    }

    private enum class Palette(val background: Int, val text: Int, val muted: Int, val zero: Int) {
        DARK(R.drawable.today_widget_bg_dark, 0xFFF2F2F4.toInt(), 0xFF8E8E93.toInt(), 0xFF6B6B72.toInt()),
        LIGHT(R.drawable.today_widget_bg_light, 0xFF111114.toInt(), 0xFF62626B.toInt(), 0xFFA1A1AA.toInt()),
    }

    companion object {
        private const val AMOUNT_SP = 40f
        private const val PADDING_DP = 18
        private var cachedTypeface: Typeface? = null
    }
}
