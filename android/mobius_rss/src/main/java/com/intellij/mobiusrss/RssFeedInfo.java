package com.intellij.mobiusrss;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * @author Eugene.Kudelevsky
 */
public class RssFeedInfo {
  private static final String DESCRIPTION = "description";
  private static final String URL = "url";
  private static final String TITLE = "title";

  private final String myUrl;
  private final String myTitle;
  private final String myDescription;

  public RssFeedInfo(String url, String title, String description) {
    myUrl = url;
    myTitle = title;
    myDescription = description;
  }

  public RssFeedInfo(JSONObject jsonObject) throws JSONException {
    myTitle = jsonObject.optString(TITLE);
    myUrl = jsonObject.optString(URL);
    myDescription = jsonObject.optString(DESCRIPTION);
  }

  public String getTitle() {
    return myTitle;
  }

  public String getUrl() {
    return myUrl;
  }

  public JSONObject toJsonObject() throws JSONException {
    final JSONObject result = new JSONObject();
    result.put(TITLE, myTitle);
    result.put(URL, myUrl);
    result.put(DESCRIPTION, myDescription);
    return result;
  }

  public String getDescription() {
    return myDescription;
  }
}
