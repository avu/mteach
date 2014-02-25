package com.intellij.mobiusrss;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.Fragment;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.text.Editable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import nl.matshofman.saxrssreader.RssFeed;

public class ChooseSourceActivity extends Activity {
  private static final String LOG_TAG = ChooseSourceActivity.class.getName();
  private static final String SOURCES_PREFERENCE_KEY = "sources";
  private static final String ADD_SOURCE_DIALOG_TAG = "add_source";

  private PlaceholderFragment myFragment;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_choose_source);

    if (savedInstanceState == null) {
      myFragment = new PlaceholderFragment();
      getFragmentManager().beginTransaction()
          .add(R.id.container, myFragment)
          .commit();
    }
    else {
      myFragment = (PlaceholderFragment) getFragmentManager().findFragmentById(R.id.container);
    }
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
        myFragment.doRemoveSelectedSources();
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

  @SuppressWarnings("ConstantConditions")
  public static class PlaceholderFragment extends Fragment {

    private ListView myListView;
    private ArrayList<RssFeedInfo> mySources = new ArrayList<RssFeedInfo>();
    private SourcesListAdapter myListViewAdapter;

    public PlaceholderFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
      final View view = inflater.inflate(R.layout.fragment_choose_source, container, false);
      myListView = (ListView) view.findViewById(R.id.listView);

      myListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
          final RssFeedInfo info = mySources.get(position);
          startActivity(MainActivity.createIntent(getActivity(), info.getUrl()));
        }
      });

      myListView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
        @Override
        public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
          final boolean selected = !view.isSelected();
          view.setSelected(selected);
          final RssFeedInfo info = mySources.get(position);

          if (selected) {
            myListViewAdapter.getSelection().add(info);
          }
          else {
            myListViewAdapter.getSelection().remove(info);
          }
          return true;
        }
      });
      return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
      super.onActivityCreated(savedInstanceState);
      loadSources();
    }

    private void saveSources() {
      final SharedPreferences prefs = getActivity().getPreferences(MODE_PRIVATE);
      try {
        final String s = writeSources(mySources);
        prefs.edit().putString(SOURCES_PREFERENCE_KEY, s).commit();
      } catch (JSONException e) {
        Log.e(LOG_TAG, "", e);
      }
    }

    private void loadSources() {
      final SharedPreferences prefs = getActivity().getPreferences(MODE_PRIVATE);
      final String sourcesStr = prefs.getString(SOURCES_PREFERENCE_KEY, "");
      List<RssFeedInfo> infos = Collections.emptyList();

      if (!sourcesStr.isEmpty()) {
        try {
          infos = readSources(sourcesStr);
        } catch (JSONException e) {
          Log.e(LOG_TAG, "", e);
        }
      }
      mySources = new ArrayList<RssFeedInfo>(infos);
      myListViewAdapter = new SourcesListAdapter(getActivity(), mySources);
      myListView.setAdapter(myListViewAdapter);
    }

    public Set<RssFeedInfo> getSelectedSources() {
      return myListViewAdapter.getSelection();
    }

    private static String writeSources(List<RssFeedInfo> sources) throws JSONException {
      final List<JSONObject> objects = new ArrayList<JSONObject>();

      for (RssFeedInfo source : sources) {
        objects.add(source.toJsonObject());
      }
      return new JSONArray(objects).toString();
    }

    private static List<RssFeedInfo> readSources(String s) throws JSONException {
      final JSONArray jsonArray = new JSONArray(s);
      final int count = jsonArray.length();
      final List<RssFeedInfo> result = new ArrayList<RssFeedInfo>(count);

      for (int i = 0; i < count; i++) {
        result.add(new RssFeedInfo(jsonArray.getJSONObject(i)));
      }
      return result;
    }

    public void doAddSource(String url, RssFeed rssFeed) {
      mySources.add(new RssFeedInfo(url, rssFeed.getTitle(), rssFeed.getDescription()));
      myListViewAdapter.notifyDataSetChanged();
      saveSources();
    }

    public void doRemoveSelectedSources() {
      mySources.removeAll(getSelectedSources());
      myListViewAdapter.notifyDataSetChanged();
      saveSources();
    }
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
                  ((ChooseSourceActivity)activity).doAddSource(url);
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
        myFragment.doAddSource(myUrl, rssFeed);
      }
      else {
        new AlertDialog.Builder(ChooseSourceActivity.this)
            .setMessage(R.string.cannot_load_rss_feed_error)
            .setNeutralButton(R.string.ok, null).create().show();
      }
    }
  }
}
