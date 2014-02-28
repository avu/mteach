package com.intellij.mobiusrss;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import nl.matshofman.saxrssreader.RssFeed;
import nl.matshofman.saxrssreader.RssItem;

public class FeedActivity extends Activity {
  private static final String READ_NEWS_KEY = "read_news";
  private static final String LOG_TAG = FeedActivity.class.getName();

  public static final String URL_EXTRA = "URL";

  private ProgressBar myProgressBar;
  private ListView myListView;
  private MyListAdapter myListAdapter;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_feed);

    myProgressBar = (ProgressBar) findViewById(R.id.progressBar);
    myListView = (ListView) findViewById(R.id.listView);

    myListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @SuppressWarnings("ConstantConditions")
      @Override
      public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        final RssItem item = myListAdapter.getItem(position);
        myListAdapter.myReadSet.add(item.getPubDate());
        myListAdapter.notifyDataSetChanged();
        try {
          final String s = saveReadNewsSet(myListAdapter.myReadSet);
          final SharedPreferences prefs = getPreferences(Context.MODE_PRIVATE);
          prefs.edit().putString(READ_NEWS_KEY, s).commit();
        } catch (JSONException e) {
          Log.e(LOG_TAG, "", e);
        }
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

  private static Set<Date> loadReadNewsSet(String s) throws JSONException {
    final JSONArray jsonArray = new JSONArray(s);
    final int size = jsonArray.length();
    final Set<Date> result = new HashSet<Date>(size);

    for (int i = 0; i < size; i++) {
      result.add(new Date(jsonArray.getLong(i)));
    }
    return result;
  }

  private static String saveReadNewsSet(Set<Date> set) throws JSONException {
    final List<Long> longs = new ArrayList<Long>(set.size());

    for (Date date : set) {
      longs.add(date.getTime());
    }
    return new JSONArray(longs).toString();
  }

  @SuppressWarnings("ConstantConditions")
  private void showRssFeed(RssFeed rssFeed) {
    final String title = rssFeed.getTitle();

    if (title != null && !title.isEmpty()) {
      setTitle(title);
    }
    final SharedPreferences prefs = getPreferences(Context.MODE_PRIVATE);
    final String readNewsStr = prefs.getString(READ_NEWS_KEY, "");
    Set<Date> readSet = Collections.emptySet();

    if (!readNewsStr.isEmpty()) {
      try {
        readSet = loadReadNewsSet(readNewsStr);
      } catch (JSONException e) {
        Log.e(LOG_TAG, "", e);
      }
    }
    myListAdapter = new MyListAdapter(rssFeed.getRssItems(), readSet);
    myListView.setAdapter(myListAdapter);
  }

  public class MyRssFeedLoadingTask extends RssFeedLoadingTask {

    private MyRssFeedLoadingTask(String url) {
      super(url);
    }

    @Override
    protected void onProgressUpdate(Void... values) {
      super.onProgressUpdate(values);
      myProgressBar.setVisibility(View.VISIBLE);
    }

    @Override
    protected void onPostExecute(RssFeed rssFeed) {
      super.onPostExecute(rssFeed);
      myProgressBar.setVisibility(View.GONE);
      showRssFeed(rssFeed);
    }
  }

  private class MyListAdapter extends BaseAdapter {
    private final List<RssItem> myItems;
    private final Set<Date> myReadSet;

    private MyListAdapter(List<RssItem> items, Set<Date> readSet) {
      myItems = items;
      myReadSet = new HashSet<Date>(readSet);
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
      titleView.setTypeface(myReadSet.contains(rssItem.getPubDate()) ? Typeface.DEFAULT : Typeface.DEFAULT_BOLD);
      return view;
    }
  }
}
