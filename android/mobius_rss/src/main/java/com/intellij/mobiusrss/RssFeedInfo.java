package com.intellij.mobiusrss;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

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

  public static List<RssFeedInfo> readListFrom(String s) throws JSONException {
    final JSONArray jsonArray = new JSONArray(s);
    final int count = jsonArray.length();
    final List<RssFeedInfo> result = new ArrayList<RssFeedInfo>(count);

    for (int i = 0; i < count; i++) {
      result.add(new RssFeedInfo(jsonArray.getJSONObject(i)));
    }
    return result;
  }

  public static String writeListTo(List<RssFeedInfo> sources) throws JSONException {
    final List<JSONObject> objects = new ArrayList<JSONObject>();

    for (RssFeedInfo source : sources) {
      objects.add(source.toJsonObject());
    }
    return new JSONArray(objects).toString();
  }
}
