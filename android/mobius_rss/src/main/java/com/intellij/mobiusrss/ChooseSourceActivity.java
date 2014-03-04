package com.intellij.mobiusrss;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.text.Editable;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

import nl.matshofman.saxrssreader.RssFeed;

public class ChooseSourceActivity extends Activity {
  private static final String ADD_SOURCE_DIALOG_TAG = "add_source";

  private ArrayList<RssFeedInfo> mySources = new ArrayList<RssFeedInfo>();
  private SourcesListAdapter myListViewAdapter;
  private final Set<RssFeedInfo> mySelection = new HashSet<RssFeedInfo>();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_choose_source);

    final ListView listView = (ListView) findViewById(R.id.sourcesListView);

    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        final RssFeedInfo info = mySources.get(position);
        startActivity(FeedActivity.createIntent(ChooseSourceActivity.this, info.getUrl()));
      }
    });
    listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
      @Override
      public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
        final boolean selected = !view.isSelected();
        view.setSelected(selected);
        final RssFeedInfo info = mySources.get(position);

        if (selected) {
          mySelection.add(info);
        } else {
          mySelection.remove(info);
        }
        return true;
      }
    });
    mySources = new ArrayList<RssFeedInfo>(PreferenceUtil.doLoadSources(this));
    myListViewAdapter = new SourcesListAdapter(this, mySources);
    listView.setAdapter(myListViewAdapter);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.choose_source, menu);
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.add_source:
        addSourceActionSelected();
        return true;
      case R.id.remove_source:
        doRemoveSelectedSources();
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }

  private void addSourceActionSelected() {
    new AddSourceDialogFragment().show(getFragmentManager(), ADD_SOURCE_DIALOG_TAG);
  }

  private void doAddSource(String url) {
    new MyRssFeedLoadingTask(url).execute();
  }

  public Set<RssFeedInfo> getSelectedSources() {
    return mySelection;
  }

  public void doAddSource(String url, RssFeed rssFeed) {
    mySources.add(new RssFeedInfo(url, rssFeed.getTitle(), rssFeed.getDescription()));
    myListViewAdapter.notifyDataSetChanged();
    PreferenceUtil.doSaveSources(this, mySources);
  }

  public void doRemoveSelectedSources() {
    mySources.removeAll(getSelectedSources());
    myListViewAdapter.notifyDataSetChanged();
    PreferenceUtil.doSaveSources(this, mySources);
  }

  public static class AddSourceDialogFragment extends DialogFragment {
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
      final Activity activity = getActivity();
      @SuppressWarnings("ConstantConditions")
      final EditText input = new EditText(activity);
      input.setInputType(EditorInfo.TYPE_TEXT_VARIATION_URI);

      return new AlertDialog.Builder(activity).setMessage(R.string.input_url)
          .setView(input)
          .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
              final Editable text = input.getText();

              if (text != null) {
                final String url = text.toString();

                if (!url.isEmpty()) {
                  ((ChooseSourceActivity) activity).doAddSource(url);
                }
              }
            }
          })
          .setNegativeButton(R.string.cancel, null)
          .create();
    }
  }

  public class MyRssFeedLoadingTask extends RssFeedLoadingTask {

    private ProgressDialog myProgressDialog;

    MyRssFeedLoadingTask(String url) {
      super(url);
    }

    @Override
    protected void onProgressUpdate(Void... values) {
      super.onProgressUpdate(values);
      myProgressDialog = ProgressDialog.show(ChooseSourceActivity.this, "", getString(
          R.string.loading_rss_feed_progress), true, false);
    }

    @Override
    protected void onPostExecute(RssFeed rssFeed) {
      super.onPostExecute(rssFeed);

      if (myProgressDialog != null) {
        myProgressDialog.dismiss();
      }
      if (rssFeed != null) {
        doAddSource(myUrl, rssFeed);
      } else {
        new AlertDialog.Builder(ChooseSourceActivity.this)
            .setMessage(R.string.cannot_load_rss_feed_error)
            .setNeutralButton(R.string.ok, null).create().show();
      }
    }
  }
}
