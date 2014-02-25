package com.intellij.mobiusrss;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * @author Eugene.Kudelevsky
 */
public class RssFeedInfo {
  private final String myUrl;
  private final String myTitle;
  private final String myDescription;

  public RssFeedInfo(String url, String title, String description) {
    myUrl = url;
    myTitle = title;
    myDescription = description;
  }

  public RssFeedInfo(DataInput input) throws IOException {
    myTitle = input.readUTF();
    myUrl = input.readUTF();
    myDescription = input.readUTF();
  }

  public String getTitle() {
    return myTitle;
  }

  public String getUrl() {
    return myUrl;
  }

  public void write(DataOutput output) throws IOException {
    output.writeUTF(myTitle != null ? myTitle : "");
    output.writeUTF(myUrl != null ? myUrl : "");
    output.writeUTF(myDescription != null ? myDescription : "");
  }

  public String getDescription() {
    return myDescription;
  }
}
