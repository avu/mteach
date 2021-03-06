package com.intellij.mobiusrss;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListAdapter;
import android.widget.TextView;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import nl.matshofman.saxrssreader.RssFeed;

/**
 * @author Eugene.Kudelevsky
 */
public class SourcesListAdapter extends BaseAdapter {
  private final Context myContext;
  private final List<RssFeedInfo> myInfos;

  public SourcesListAdapter(Context context, List<RssFeedInfo> infos) {
    myContext = context;
    myInfos = infos;
  }

  @Override
  public int getCount() {
    return myInfos.size();
  }

  @Override
  public Object getItem(int position) {
    return myInfos.get(position);
  }

  @Override
  public long getItemId(int position) {
    return position;
  }

  @Override
  public View getView(int position, View convertView, ViewGroup parent) {
    final View view = LayoutInflater.from(myContext).inflate(
        R.layout.sources_list_item, parent, false);

    if (view != null) {
      final RssFeedInfo info = myInfos.get(position);
      final TextView titleView = (TextView) view.findViewById(R.id.titleView);
      titleView.setText(info.getTitle());
      final TextView descriptionView = (TextView) view.findViewById(R.id.descriptionView);
      descriptionView.setText(info.getDescription());
    }
    return view;
  }
}
