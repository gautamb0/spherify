/**
 * Copyright 2014-2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.test3;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;
import com.googlecode.objectify.Key;

import java.lang.String;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;

/**
 * The @Entity tells Objectify about our entity.  We also register it in OfyHelper.java -- very
 * important. Our primary key @Id is set automatically by the Google Datastore for us.
 *
 * We add a @Parent to tell the object about its ancestor. We are doing this to support many
 * guestbooks.  Objectify, unlike the AppEngine library requires that you specify the fields you
 * want to index using @Index.  This `is often a huge win in performance -- though if you don't Index
 * your data from the start, you'll have to go back and index it later.
 *
 * NOTE - all the properties are PUBLIC so that can keep this simple, otherwise,
 * Jackson, wants us to write a BeanSerializaer for cloud endpoints.s
 **/
@Entity
public class ImageRecord implements Comparable<ImageRecord> {
  @Parent Key<Gallery> theBook;
  @Id public Long id;

  @Index public String author_nickname;
  public String author_email;
  public String author_id;
  public String blob_key;
  public String perma_url;
  public String desc;
  public int likes;
  public int views;
  public List<String> likedUsers;
  @Index public List<String> tags;
  
  @Index public String isPrivate;
  public String isUnlisted;
  @Index public Date date;

  /**
   * Simple constructor just sets the date
   **/
  public ImageRecord() {
	desc = "";
	likedUsers = new Vector<String>();
	tags = new ArrayList<String>();
	isPrivate = "yes";
	isUnlisted = "yes";
    date = new Date();
    likes = 0;
    views = 0;
  }

  /**
   * A connivence constructor
   **/
  public ImageRecord(String book, String blob_key) {
    this();
    if( book != null ) {
      theBook = Key.create(Gallery.class, book);  // Creating the Ancestor key
    } else {
      theBook = Key.create(Gallery.class, "default");
    }
    this.blob_key = blob_key;
  }
  
  public ImageRecord(String book, String blob_key, String url) {
	    this(book, blob_key);
	    perma_url = url;
	  }

  /**
   * Takes all important fields
   **/
  public ImageRecord(String book, String blob_key, String url, String id, String nickname, String email) {
    this(book, blob_key, url);
    author_nickname = nickname;
    author_id = id;
    author_email = email;
  }
  
  public void setDesc(String description)
  {
	  desc = description;
  }
  
  public int compareTo(ImageRecord imageRecord)
  {
	  
	  return ((ImageRecord)imageRecord).likes - this.likes;
  }
  
  
  
}
