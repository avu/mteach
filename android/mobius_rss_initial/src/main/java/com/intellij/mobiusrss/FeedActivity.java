package com.intellij.mobiusrss;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import java.util.List;

import nl.matshofman.saxrssreader.RssFeed;
import nl.matshofman.saxrssreader.RssItem;

public class FeedActivity extends Activity {
  public static final String URL_EXTRA = "URL";

  private ListView myListView;
  private MyListAdapter myListAdapter;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_feed);

    myListView = (ListView) findViewById(R.id.feedListView);

    myListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @SuppressWarnings("ConstantConditions")
      @Override
      public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        final RssItem item = myListAdapter.getItem(position);
        startActivity(NoteActivity.createIntent(FeedActivity.this, item));
      }
    });
    loadRss(getIntent().getStringExtra(URL_EXTRA));
  }

  public static Intent createIntent(Context context, String url) {
    final Intent intent = new Intent(context, FeedActivity.class);
    intent.putExtra(URL_EXTRA, url);
    return intent;
  }

  @SuppressWarnings("ConstantConditions")
  public void loadRss(String url) {
    new MyRssFeedLoadingTask(url).execute();
  }

  @SuppressWarnings("ConstantConditions")
  private void showRssFeed(RssFeed rssFeed) {
    final String title = rssFeed.getTitle();

    if (title != null && !title.isEmpty()) {
      setTitle(title);
    }
    myListAdapter = new MyListAdapter(rssFeed.getRssItems());
    myListView.setAdapter(myListAdapter);
  }

  public class MyRssFeedLoadingTask extends RssFeedLoadingTask {

    private MyRssFeedLoadingTask(String url) {
      super(url);
    }

    @Override
    protected void onPostExecute(RssFeed rssFeed) {
      super.onPostExecute(rssFeed);
      showRssFeed(rssFeed);
    }
  }

  private class MyListAdapter extends BaseAdapter {
    private final List<RssItem> myItems;

    private MyListAdapter(List<RssItem> items) {
      myItems = items;
    }

    @Override
    public int getCount() {
      return myItems.size();
    }

    @Override
    public RssItem getItem(int position) {
      return myItems.get(position);
    }

    @Override
    public long getItemId(int position) {
      return position;
    }

    @SuppressWarnings("ConstantConditions")
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
      final RssItem rssItem = myItems.get(position);
      final View view = LayoutInflater.from(FeedActivity.this).inflate(
          R.layout.rss_item, parent, false);
      final TextView titleView = (TextView) view.findViewById(R.id.rssItemTitleView);
      titleView.setText(rssItem.getTitle());
      return view;
    }
  }
}
