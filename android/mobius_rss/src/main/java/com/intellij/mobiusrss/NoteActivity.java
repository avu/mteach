package com.intellij.mobiusrss;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.webkit.WebView;

import nl.matshofman.saxrssreader.RssItem;

public class NoteActivity extends Activity {

  private static final String RSS_ITEM_KEY = "rss_item";

  public static Intent createIntent(Context context, RssItem item) {
    final Intent intent = new Intent(context, NoteActivity.class);
    intent.putExtra(RSS_ITEM_KEY, item);
    return intent;
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_note);

    final RssItem rssItem = getIntent().getParcelableExtra(RSS_ITEM_KEY);
    assert rssItem != null;
    setTitle(rssItem.getTitle());
    final WebView webView = (WebView) findViewById(R.id.webView);

    String content = rssItem.getContent();
    content = content != null ? content.trim() : "";

    if (content.isEmpty()) {
      content = rssItem.getDescription();
    }
    webView.loadDataWithBaseURL(null, "<html><body>" + content + "</body></html>",
        "text/html", "utf-8", null);
  }
}
