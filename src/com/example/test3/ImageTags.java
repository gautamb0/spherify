package com.example.test3;

import java.util.Collections;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;
import com.googlecode.objectify.Key;

import java.lang.String;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Collection;

@Entity(name = "ImageTags")
public class ImageTags {
 
  @Id Long id;
  @Parent Key<ImageRecord> imageRecord;
  List<String> tags = new ArrayList<String>();
 
  private ImageTags() {
    super();
  }
 
  public ImageTags (Key<ImageRecord> parent) {
    this(parent, Collections.<String>emptyList());
  }
 
  public ImageTags (Key<ImageRecord> parent, Collection<String> tags) {
    super();
 
    this.imageRecord = parent;
    this.tags.addAll(tags);
  }
 
  // add single keyword
  public boolean add(String tag) {
    return tags.add(tag);
  }
 
  // add collection of keywords
  public boolean add(Collection<String> tags) {
    return this.tags.addAll(tags);
  }
}