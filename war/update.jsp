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
<title>Spherify | Edit</title>
<head>
    <link href="bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body style="background-color:#f9f9f9;">
 	<script src="js/third-party/jquery-1.11.3.min.js"></script>
    <script src="bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>

<nav class="navbar navbar-default" style="margin-bottom: 0;">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header pull-left">
      <a class="navbar-brand" href="/gallery.jsp"><img src="/images/logo.jpg" alt="spherify" style="object-fit: contain;height: 40px;"></img></a>
    </div>
    <!-- 'Sticky' (non-collapsing) right-side menu item(s) -->
    <div class="navbar-header pull-right">
      <ul class="nav pull-left">
        <li class="pull-right">
          <a href="/gallery.jsp" style="color:#fff; margin-top: 5px;"><span class="glyphicon glyphicon-home"></span></a>
        </li>
      </ul>
	  </div>
     </div>
  </div>
</nav>
<%
    String sid = request.getParameter("id");
    Long id = Long.parseLong(sid);
    pageContext.setAttribute("sid", sid);
	String ancestor = "default";
    
	Key<Gallery> theBook = Key.create(Gallery.class, ancestor);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
    if (user != null) {
        pageContext.setAttribute("user", user);
        }
  
      ImageRecord imageRecord = ObjectifyService.ofy().load().type(ImageRecord.class).parent(theBook).id(id).now();
            pageContext.setAttribute("perma_url", imageRecord.perma_url);
            pageContext.setAttribute("blob_key", imageRecord.blob_key);
            pageContext.setAttribute("desc", imageRecord.desc);               
%>

<div class = "subnav" style="background-color:#b0bed9;width: 100%;margin:auto;padding:5px;color:#212e49;">
Uploading as: ${fn:escapeXml(user.nickname)}</div>


<form action="/update" method="post">
  <div class="input-group">
  <span class="input-group-addon" id="basic-addon1">Edit description:</span>
  <input type="text" class="form-control" aria-describedby="basic-addon1" name="description" value="${fn:escapeXml(desc)}"></div>
  <input type="hidden" class="form-control" name="sid" aria-label="sid-field" value="${fn:escapeXml(sid)}"/>
<input type="submit" class="form-control" aria-label="submit-button" value="Submit">
</form>

<div class="update">Link to share: <input type="text" name="link" value="http://www.spherify.co/render.html?blob-key=${fn:escapeXml(blob_key)}" />
</div>

<div class="row" id="imgContainer">
	<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
    	<div class="thumbnail">
     		<img id="myImg" src="${fn:escapeXml(perma_url)}" alt="your image" /></img>
     	</div>
     </div>
</div>


 </body>
</html>
<%-- //[END all]--%>