package com.intellij.mobiusrss;

import android.app.ActionBar;
import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import nl.matshofman.saxrssreader.RssFeed;
import nl.matshofman.saxrssreader.RssItem;

/**
 * A placeholder fragment containing a simple view.
 */
public class MainFragment extends Fragment {
  private ProgressBar myProgressBar;
  private ListView myListView;
  private List<RssItem> myItems;

  public MainFragment() {
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
                           Bundle savedInstanceState) {
    final View view = inflater.inflate(R.layout.fragment_main, container, false);
    //noinspection ConstantConditions
    myProgressBar = (ProgressBar) view.findViewById(R.id.progressBar);
    myListView = (ListView) view.findViewById(R.id.listView);

    myListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        startActivity(RssItemActivity.createIntent(getActivity(), myItems.get(position)));
      }
    });
    return view;
  }

  public void loadRss(String url) {
    new MyRssFeedLoadingTask(url).execute();
  }

  @SuppressWarnings("ConstantConditions")
  private void showRssFeed(RssFeed rssFeed) {
    final String title = rssFeed.getTitle();

    if (title != null && !title.isEmpty()) {
      getActivity().setTitle(title);
    }
    myItems = rssFeed.getRssItems();
    myListView.setAdapter(new MyListAdapter(myItems));
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

    private MyListAdapter(List<RssItem> items) {
      myItems = items;
    }

    @Override
    public int getCount() {
      return myItems.size();
    }

    @Override
    public Object getItem(int position) {
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
      final View view = LayoutInflater.from(getActivity()).inflate(
          R.layout.rss_item, parent, false);
      final TextView descriptionView = (TextView) view.findViewById(R.id.descriptionView);
      descriptionView.setText(rssItem.getTitle());
      return view;
    }
  }
}
