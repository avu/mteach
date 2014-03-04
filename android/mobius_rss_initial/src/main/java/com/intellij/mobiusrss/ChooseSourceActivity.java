package com.intellij.mobiusrss;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.Arrays;
import java.util.List;

public class ChooseSourceActivity extends Activity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_choose_source);

    final ListView listView = (ListView) findViewById(R.id.sourcesListView);
    final List<String> sources = Arrays.asList(
        "http://news.google.ru/news?pz=1&cf=all&ned=ru_ru&hl=ru&output=rss",
        "https://developer.apple.com/news/rss/news.rss");
    listView.setAdapter(new ArrayAdapter<String>(
        this, android.R.layout.simple_list_item_1, sources));
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        final String url = sources.get(position);
        startActivity(FeedActivity.createIntent(ChooseSourceActivity.this, url));
      }
    });
  }
}
