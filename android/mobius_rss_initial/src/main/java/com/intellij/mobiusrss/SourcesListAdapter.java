package com.intellij.mobiusrss;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.List;

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
    return null;
  }
}
