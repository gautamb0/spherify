package com.example.test3;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class UpdateProfile extends HttpServlet 
{
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String galleryName = req.getParameter("gallery");
		String bio = req.getParameter("bio");
		System.out.println("gallery "+galleryName);
		System.out.println("bio "+bio);
		Key<Userbase> theBase = Key.create(Userbase.class, "default"); 
		UserRecord userRecord = ObjectifyService.ofy().load().type(UserRecord.class).parent(theBase).id(galleryName).now();
		if(userRecord==null)
		{
			userRecord = new UserRecord(galleryName);
		}
		userRecord.bio = bio;
		ObjectifyService.ofy().save().entity(userRecord).now();
	}
}
