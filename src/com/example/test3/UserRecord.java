package com.example.test3;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;
import com.googlecode.objectify.Key;

import java.lang.String;
import java.util.Date;
import java.util.List;

@Entity
public class UserRecord {
  @Parent Key<Userbase> theBase;
  @Id public String author_nickname;
  public String bio;
  public Date date;
  
  public UserRecord()
  {
	  theBase = Key.create(Userbase.class, "default");
	  bio = author_nickname+" has not entered a bio yet.";
	  date = new Date();
  }
  
  public UserRecord(String nickname)
  {
	  this();
	  author_nickname = nickname;

  }
  
  public UserRecord(String nickname, String bioString)
  {
	  this(nickname);
	  bio = bioString;
  }
  
  
}