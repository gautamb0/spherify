package com.example.test3;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;


public class Update extends HttpServlet {
  @Override
  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Greeting greeting;

    String gallery = req.getParameter("gallery");
    String description = req.getParameter("description");
    String sid = req.getParameter("sid");
    Long id = Long.parseLong(sid);
	Key<Guestbook> theBook = Key.create(Guestbook.class, gallery);
	greeting = ObjectifyService.ofy().load().type(Greeting.class).parent(theBook).id(id).now();
	greeting.desc = description;

    // Use Objectify to save the greeting and now() is used to make the call synchronously as we
    // will immediately get a new page using redirect and we want the data to be present.
    ObjectifyService.ofy().save().entity(greeting).now();

    resp.sendRedirect("/gallery.jsp?gallery=" + gallery);
  }
}