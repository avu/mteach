package com.intellij.mobiusrss;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class FeedActivity extends Activity {
  public static final String URL_EXTRA = "URL";
  private FeedFragment myFragment;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    if (savedInstanceState == null) {
      myFragment = new FeedFragment();
      getFragmentManager().beginTransaction()
          .add(R.id.container, myFragment)
          .commit();
    }
    else {
      myFragment = (FeedFragment) getFragmentManager().findFragmentById(R.id.container);
    }
    myFragment.loadRss(getIntent().getStringExtra(URL_EXTRA));
  }

  public static Intent createIntent(Context context, String url) {
    final Intent intent = new Intent(context, FeedActivity.class);
    intent.putExtra(URL_EXTRA, url);
    return intent;
  }

}
