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
        BlobKey blobKey = (BlobKey) blobKeys.get(0);
        ImagesService imagesService = ImagesServiceFactory.getImagesService();
        ServingUrlOptions servingUrlOptions = ServingUrlOptions.Builder.withBlobKey(blobKey);
        String imageUrl = imagesService.getServingUrl(servingUrlOptions);
        String blobString = blobKeys.get(0).getKeyString();
        java.lang.System.out.println("image url: "+imageUrl);
        java.lang.System.out.println("blob-key: "+ blobString);
        
        Greeting greeting;

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String guestbookName = "default";//req.getParameter("guestbookName");
        //String content = req.getParameter("content");
        if (user != null) {
          greeting = new Greeting(guestbookName, blobString, imageUrl, user.getUserId(), user.getNickname());
        } else {
          greeting = new Greeting(guestbookName, blobString, imageUrl);
        }
        java.lang.System.out.println("id: "+greeting.id);
        // Use Objectify to save the greeting and now() is used to make the call synchronously as we
        // will immediately get a new page using redirect and we want the data to be present.
        ObjectifyService.ofy().save().entity(greeting).now();
        //if (blobKeys == null || blobKeys.isEmpty()) {
        res.sendRedirect("/update.jsp?id="+greeting.id+"&guestbookName=default");
       // } else {
         //   res.sendRedirect("/serve?blob-key=" + blobKeys.get(0).getKeyString());
        //}
    }
}
