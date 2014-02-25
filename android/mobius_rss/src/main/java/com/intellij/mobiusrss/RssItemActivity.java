package com.intellij.mobiusrss;

import android.app.ActionBar;
import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;

import nl.matshofman.saxrssreader.RssItem;

public class RssItemActivity extends Activity {

  private static final String RSS_ITEM_KEY = "rss_item";

  public static Intent createIntent(Context context, RssItem item) {
    final Intent intent = new Intent(context, RssItemActivity.class);
    intent.putExtra(RSS_ITEM_KEY, item);
    return intent;
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_rss_item);

    final RssItem rssItem = getIntent().getParcelableExtra(RSS_ITEM_KEY);
    assert rssItem != null;
    setTitle(rssItem.getTitle());

    if (savedInstanceState == null) {
      final PlaceholderFragment fragment = new PlaceholderFragment();
      final Bundle args = new Bundle();
      args.putParcelable(RSS_ITEM_KEY, rssItem);
      fragment.setArguments(args);
      getFragmentManager().beginTransaction()
          .add(R.id.container, fragment)
          .commit();
    }
  }

  /**
   * A placeholder fragment containing a simple view.
   */
  public static class PlaceholderFragment extends Fragment {

    public PlaceholderFragment() {
    }

    @SuppressWarnings("ConstantConditions")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
      final RssItem rssItem = getArguments().getParcelable(RSS_ITEM_KEY);
      View view = inflater.inflate(R.layout.fragment_rss_item, container, false);
      final WebView webView = (WebView) view.findViewById(R.id.webView);

      String content = rssItem.getContent();
      content = content != null ? content.trim() : "";

      if (content.isEmpty()) {
        content = rssItem.getDescription();
      }
      webView.loadDataWithBaseURL(null, "<html><body>" + content + "</body></html>",
          "text/html", "utf-8", null);
      return view;
    }
  }

}
