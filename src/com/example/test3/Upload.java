package com.example.test3;

// file Upload.java

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.images.Image;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.ServingUrlOptions;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyFactory;
import com.googlecode.objectify.ObjectifyService;

import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;

public class Upload extends HttpServlet {
    private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {

        Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
        List<BlobKey> blobKeys = blobs.get("myFile");
        
        ImagesService imagesService = ImagesServiceFactory.getImagesService();


        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
      	String guestbookName = "default";
      	
      	ImageRecord imageRecord = null;
      	for(int i = 0; i < blobKeys.size(); i++)
      	{	
      		BlobKey blobKey = (BlobKey) blobKeys.get(i);
      		String blobString = blobKeys.get(i).getKeyString();
            
            ServingUrlOptions servingUrlOptions = ServingUrlOptions.Builder.withBlobKey(blobKey);
            String imageUrl = imagesService.getServingUrl(servingUrlOptions);
            
            java.lang.System.out.println("image url: "+imageUrl);
            java.lang.System.out.println("blob-key: "+ blobString);
            
        	if (user != null) {
        	imageRecord = new ImageRecord(guestbookName, blobString, imageUrl, user.getUserId(), user.getNickname(), user.getEmail());
        	} else {	
        	imageRecord = new ImageRecord(guestbookName, blobString, imageUrl);
        	}
        	java.lang.System.out.println("id: "+imageRecord.id);
        	// Use Objectify to save the greeting and now() is used to make the call synchronously as we
        	// will immediately get a new page using redirect and we want the data to be present.
        	ObjectifyService.ofy().save().entity(imageRecord).now();
    	}
      	if(user!=null&&blobKeys.size() > 1)
      	{
      		res.sendRedirect("/gallery.jsp?gallery="+user.getNickname());
      	}
      	else
      	{
      		res.sendRedirect("/update.jsp?id="+imageRecord.id+"&firsttime=true");
      	}
      	
    }
}
