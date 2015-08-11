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
<title>Spherify | Upload</title>
<head>
    <link href='http://fonts.googleapis.com/css?family=Pontano+Sans' rel='stylesheet' type='text/css'>
    <link href="bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<%

    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
    if (user != null) {
        pageContext.setAttribute("user", user);
        pageContext.setAttribute("nickname", user.getNickname());
        }
    else
    {
    	pageContext.setAttribute("nickname", "an anonymous person");
    }
        
%>

<body style="background-color:#f9f9f9;">
 	<script src="js/third-party/jquery-1.11.3.min.js"></script>
    <script src="bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
 	<div id="iden" style="display: none;">1</div>
    <div id="example"></div>

  <script src="js/third-party/threejs/three.js"></script>
  <script src="js/third-party/threejs/StereoEffect.js"></script>
  <script src="js/third-party/threejs/DeviceOrientationControls.js"></script>
  <script src="js/third-party/threejs/OrbitControls.js"></script>
  <script src="js/renderlocal.js"></script>
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
          <span class="glyphicon glyphicon-user"></span></a>
        </li>
      </ul>
	  </div>
   </div>
</nav>


<div class = "subnav" style="background-color:#b0bed9;width: 100%;margin:auto;padding:5px;color:#212e49;">
Uploading as: ${fn:escapeXml(nickname)}</div>

<form class="input-group" action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data">
<% if(user!=null){ %>
         <input class="form-control" accept="image/*" type="file" name="myFile" aria-label="file-field" multiple />
<% } else { %>
		 <input class="form-control" accept="image/*" type="file" name="myFile" aria-label="file-field"/>
<% } %>
         <input class="form-control" type="submit" value="Upload" aria-label="submit-button" />
</form>
<div class="row">
 <output id="list"></output>
</div>     
<script>

 $(function () {
    $(":file").change(function () {
		var parent = document.getElementById('list');
		while (parent.firstChild) {
    		parent.removeChild(parent.firstChild);
		}
        for (var i = 0, f; f = this.files[i]; i++) {
        	if (this.files && this.files[i]) {
            	var reader = new FileReader();
                reader.onload = imageIsLoaded;
                reader.readAsDataURL(this.files[i]);
            }
        }
    });
});

function imageIsLoaded(e) {
    //$('#myImg').attr('src', e.target.result);
    //initlocal(e.target.result);
    //animate();
    //$('#imgContainer').show();
    
    var span = document.createElement('span');
    span.innerHTML = ['<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3"><div class="thumbnail"><img id="myImg" src="',e.target.result,'" alt="your image" /></img></div></div>'].join('');
	document.getElementById('list').insertBefore(span, list.childNodes[0]);
};


</script>
 </body>
</html>
<%-- //[END all]--%>