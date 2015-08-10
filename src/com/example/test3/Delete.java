package com.example.test3;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

public class Delete extends HttpServlet {
	  
	  private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		  ImageRecord imageRecord; 	

		  String ancestor = "default";
		  String gallery = req.getParameter("sid");
		  String sid = req.getParameter("sid");
		  
		  if(gallery==null)
		  {
			  gallery = "home";
		  }
		  
		  
		  System.out.println("sid: "+ sid);
		  
		  Long id = Long.parseLong(sid);
		  Key<Gallery> theBook = Key.create(Gallery.class, ancestor);
		  imageRecord = ObjectifyService.ofy().load().type(ImageRecord.class).parent(theBook).id(id).now();
		  BlobKey blobKey = new BlobKey(imageRecord.blob_key);
		  blobstoreService.delete(blobKey);
		  
		  ObjectifyService.ofy().delete().type(ImageRecord.class).parent(theBook).id(id).now();
		  
		  resp.sendRedirect("/gallery.jsp?gallery="+gallery);
	  }
}