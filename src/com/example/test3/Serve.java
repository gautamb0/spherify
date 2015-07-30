package com.example.test3;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.images.Image;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.Transform;

public class Serve extends HttpServlet {
    private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws IOException {
            BlobKey blobKey = new BlobKey(req.getParameter("blob-key"));
            ImagesService imagesService = ImagesServiceFactory.getImagesService();

            Image oldImage = ImagesServiceFactory.makeImageFromBlob(blobKey);
            Transform resize = ImagesServiceFactory.makeResize(3200,1600);
            Image newImage = imagesService.applyTransform(resize, oldImage);
            byte[] newImageData = newImage.getImageData();
            
            res.setContentType("image/jpeg");
            OutputStream o = res.getOutputStream();
            o.write(newImageData); 
            o.flush(); 
            o.close(); 
            //blobstoreService.serve(blobKey, res);
        }
}