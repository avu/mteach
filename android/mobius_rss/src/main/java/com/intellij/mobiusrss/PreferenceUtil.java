package com.intellij.mobiusrss;

import android.app.Activity;
import android.content.Context;

import java.util.Arrays;
import java.util.List;

/**
 * @author Eugene.Kudelevsky
 */
public class PreferenceUtil {
  static final String SOURCES_PREFERENCE_KEY = "sources";

  public static List<RssFeedInfo> doLoadSources(Activity activity) {
    final String sourcesStr = activity.getPreferences(Context.MODE_PRIVATE).getString(SOURCES_PREFERENCE_KEY, "");
    List<RssFeedInfo> infos;

    if (!sourcesStr.isEmpty()) {
      infos = RssFeedInfo.readListFrom(sourcesStr);
    }
    else {
      infos = Arrays.asList(
          new RssFeedInfo("http://news.google.ru/news?pz=1&cf=all&ned=ru_ru&hl=ru&output=rss",
              "Google News", "news.google.com"),
          new RssFeedInfo("https://developer.apple.com/news/rss/news.rss",
              "Apple Dev News", "News for developers"));
    }
    return infos;
  }

  public static void doSaveSources(Activity activity, List<RssFeedInfo> sources) {
    final String s = RssFeedInfo.writeListTo(sources);
    activity.getPreferences(Context.MODE_PRIVATE).edit().putString(SOURCES_PREFERENCE_KEY, s).commit();
  }
}
