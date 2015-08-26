package com.example.test3;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;


public class Update extends HttpServlet {
  

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    ImageRecord imageRecord;

    String ancestor = "default";
    String gallery = "home";
    String description = req.getParameter("description");
    String sid = req.getParameter("sid");
    String isPrivate = "no";
    String isUnlisted = "no";
    String notPrivate = req.getParameter("notPrivate");
    String notUnlisted = req.getParameter("notUnlisted");
    Pattern p = Pattern.compile("#([A-Za-z]+)");
    Matcher m = p.matcher(description);
    int count = 0;
    List<String> tags = new ArrayList<String>();
    while(m.find()) {
        count++;
        /*System.out.println("Match number "
                           + count);
        System.out.println("start(): "
                           + m.start());
        System.out.println("end(): "
                           + m.end());
        System.out.println(description.substring(m.start()+1, m.end()));*/
        tags.add(description.substring(m.start()+1, m.end()).toLowerCase());
   }
    
    if(notPrivate==null)
    {
    	isPrivate = "yes";
    }
    if(notUnlisted==null)
    {
    	isUnlisted = "yes";
    }
    
    
    //System.out.println("sid: "+ sid);
    //System.out.println("description: "+description);
    
    Long id = Long.parseLong(sid);
	Key<Gallery> theBook = Key.create(Gallery.class, ancestor);
	imageRecord = ObjectifyService.ofy().load().type(ImageRecord.class).parent(theBook).id(id).now();
	imageRecord.desc = description;
	imageRecord.tags = tags;
	imageRecord.isPrivate = isPrivate;
	imageRecord.isUnlisted = isUnlisted;
	//System.out.println("is private: "+isPrivate);
	//System.out.println("is private: "+imageRecord.isUnlisted);
	if(isPrivate.equals("yes"))
	{
		gallery=imageRecord.author_nickname;
	}
	
	// Use Objectify to save the greeting and now() is used to make the call synchronously as we
    // will immediately get a new page using redirect and we want the data to be present.
		ObjectifyService.ofy().save().entity(imageRecord).now();

    
    resp.sendRedirect("/gallery.jsp?gallery=" + gallery);
  }
}