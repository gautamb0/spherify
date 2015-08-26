package com.example.test3;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class View extends HttpServlet {
	  
	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		  ImageRecord imageRecord; 	

		  String ancestor = "default";
		  
		  String sid = req.getParameter("sid");
		  String user_nickname = req.getParameter("user");

		  
		  //System.out.println("sid: "+ sid);
		  //System.out.println("user_nickname: "+ user_nickname);
		  Long id = Long.parseLong(sid);
		  Key<Gallery> theBook = Key.create(Gallery.class, ancestor);
		  imageRecord = ObjectifyService.ofy().load().type(ImageRecord.class).parent(theBook).id(id).now();
		  
 		  imageRecord.views++;
		  
 		  //System.out.println("views "+ imageRecord.views);
		  ObjectifyService.ofy().save().entity(imageRecord).now();		  
		  
	  }
}