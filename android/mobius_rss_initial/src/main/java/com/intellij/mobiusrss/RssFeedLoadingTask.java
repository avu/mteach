package com.intellij.mobiusrss;

import android.os.AsyncTask;
import android.util.Log;

import org.xml.sax.SAXException;

import java.io.IOException;
import java.net.URL;

import nl.matshofman.saxrssreader.RssFeed;
import nl.matshofman.saxrssreader.RssReader;

/**
* @author Eugene.Kudelevsky
*/
public class RssFeedLoadingTask extends AsyncTask<Void, Void, RssFeed> {
  private static final String LOG_TAG = RssFeedLoadingTask.class.getName();

  protected final String myUrl;

  RssFeedLoadingTask(String url) {
    myUrl = url;
  }

  @Override
  protected RssFeed doInBackground(Void... params) {
    publishProgress();
    try {
      return RssReader.read(new URL(myUrl));
    }
    catch (SAXException e) {
      Log.e(LOG_TAG, "", e);
    } catch (IOException e) {
      Log.e(LOG_TAG, "", e);
    }
    return null;
  }
}
