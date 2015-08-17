package com.example.test3;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;
import com.example.test3.ImageRecord;
import com.example.test3.Gallery;
public class UpdateDB extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	 String ancestor = "default";
	 Key<Gallery> theBook = Key.create(Gallery.class, ancestor);
	 List<ImageRecord> imageRecords;
	 
	 imageRecords = ObjectifyService.ofy().load().type(ImageRecord.class).ancestor(theBook).list();
	 
	 for (ImageRecord imageRecord : imageRecords) {
		 System.out.println(imageRecord.isPrivate);
		 imageRecord.isPrivate = "no";
		 imageRecord.isUnlisted = "no";
		 ObjectifyService.ofy().save().entity(imageRecord).now();
	 }
	}
}
