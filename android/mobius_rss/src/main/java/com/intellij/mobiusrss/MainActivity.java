package com.intellij.mobiusrss;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class MainActivity extends Activity {
  public static final String URL_EXTRA = "URL";
  private MainFragment myFragment;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    if (savedInstanceState == null) {
      myFragment = new MainFragment();
      getFragmentManager().beginTransaction()
          .add(R.id.container, myFragment)
          .commit();
    }
    else {
      myFragment = (MainFragment) getFragmentManager().findFragmentById(R.id.container);
    }
    final String url = getIntent().getStringExtra(URL_EXTRA);
    myFragment.loadRss(url);
  }

  public static Intent createIntent(Context context, String url) {
    final Intent intent = new Intent(context, MainActivity.class);
    intent.putExtra(URL_EXTRA, url);
    return intent;
  }

}
