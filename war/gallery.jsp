<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>

<%-- //[START imports]--%>
<%@ page import="com.example.test3.ImageRecord" %>
<%@ page import="com.example.test3.Gallery" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<title>Spherify your world | VR for everyone</title>
<head>
	<link href='http://fonts.googleapis.com/css?family=Pontano+Sans' rel='stylesheet' type='text/css'>
    <link href="bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<%
    String galleryName = request.getParameter("gallery");
    String ancestor = "default";
    if (galleryName == null) {
        galleryName = "home";
    }
    pageContext.setAttribute("galleryName", galleryName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>


<body style="background-color:#f9f9f9;">
 	<script src="js/third-party/jquery-1.11.3.min.js"></script>
    <script src="bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>

<nav class="navbar navbar-default" style="margin-bottom: 0;">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header pull-left">
      <a class="navbar-brand" href="/"><img src="/images/logo.jpg" alt="spherify" style="object-fit: contain;height: 40px;"></img></a>
    </div>
    <!-- 'Sticky' (non-collapsing) right-side menu item(s) -->
    <div class="navbar-header pull-right">
      <ul class="nav pull-left">
        <li class="pull-right">
          <a href="/upload.jsp" style="color:#fff; margin-top: 5px;"><span class="glyphicon glyphicon-user"></span></a>
        </li>
        <li class="pull-right">
<%
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
          <a href="/gallery.jsp?gallery=${fn:escapeXml(user.nickname)}" style="color:#fff; margin-top: 5px;">
<%
	} else {
%>          
          <a href="<%= userService.createLoginURL(request.getRequestURI()) %>" style="color:#fff; margin-top: 5px;">
<%
	}
%>          
          <span class="glyphicon glyphicon-cloud-upload"></span></a>
        </li>
      </ul>
	  </div>
     </div>
</nav>

<div class = "subnav" style="background-color:#b0bed9;width: 100%;margin:auto;padding:5px;color:#212e49;">

<%
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
Welcome, ${fn:escapeXml(user.nickname)}! Not you?
    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a>.
<%
    } else {
%>

Welcome!
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> to manage your images
<%
    }
%>
</div>


<%-- //[START datastore]--%>
<%
    // Create the correct Ancestor key
      Key<Gallery> theBook = Key.create(Gallery.class, ancestor);
	  List<ImageRecord> imageRecords;
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the ImageRecords belonging to the selected Gallery.
      if(galleryName.equals("home")){
         imageRecords = ObjectifyService.ofy()
          .load()
          .type(ImageRecord.class) // We want only ImageRecords
          .ancestor(theBook)    // Anyone in this book
          .order("-date")       // Most recent first - date is indexed.
          .filter("isPrivate", "no")
          .list();
      }
      else
      {
		  imageRecords = ObjectifyService.ofy()
          .load()
          .type(ImageRecord.class) // We want only ImageRecords
          .ancestor(theBook)    // Anyone in this book
          .filter("author_nickname", galleryName)
          .order("-date")       // Most recent first - date is indexed.
          .list();
      }

    if (imageRecords.isEmpty()) {
%>
<p>No pictures in '${fn:escapeXml(galleryName)}'. Upload a sphere now!</p>
<%
    } else {
%>
 <div class="container-fluid">
<div class="row">
  
 
 <%
      // Look at all of our imageRecords
        for (ImageRecord imageRecord : imageRecords) {
            pageContext.setAttribute("imageRecord_content", imageRecord.perma_url);
            pageContext.setAttribute("blob_key", imageRecord.blob_key);
            String author;
            String author_id="";
            if (imageRecord.author_nickname == null) {
                author = "An anonymous person";
            } else {
                author = imageRecord.author_nickname;
                author_id = imageRecord.author_id;
                
                if (user != null && user.getUserId().equals(author_id)) {
                    author += " (You)";
                }
            }
            pageContext.setAttribute("imageRecord_user", author);
            String description;
            if (imageRecord.desc == null) {
                description = "No description.";
            } else {
                description = imageRecord.desc;
            }
            pageContext.setAttribute("description", description);
            pageContext.setAttribute("sid", imageRecord.id);
            System.out.println("author "+ imageRecord.author_nickname);
%>

   <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
    <div class="thumbnail">
      <a target='_blank' href='/render.html?blob-key=${fn:escapeXml(blob_key)}'>
     <img src="${fn:escapeXml(imageRecord_content)}" alt="${fn:escapeXml(blob_key)}"></a>
      <div class="caption">
        ${fn:escapeXml(description)}
      </div>
      <div class="input-group">
  		<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-link"></span></span>
  		<input type="text" class="form-control" value="http://www.spherify.co/render.html?blob-key=${fn:escapeXml(blob_key)}" aria-describedby="basic-addon1">

<%
  if (user != null && user.getUserId().equals(author_id)) {
%>     

  		<span class="input-group-btn">
  		 <a href="/update.jsp?id=${fn:escapeXml(sid)}">
	   	 <button class="btn btn-default type="button"><span class="glyphicon glyphicon-edit"></span></button>
	   	 </a>
	    </span>
<%
  } else {
%>

       	         
<%
  }
%>
    </div>
   </div>
  </div>

<%
        }
    }
%>

</div>
</div>
</body>
</html>
<%-- //[END all]--%>
