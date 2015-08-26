<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- //[START imports]--%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>


<%@ page import="com.example.test3.ImageRecord" %>
<%@ page import="com.example.test3.Gallery" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.example.test3.Userbase" %>
<%@ page import="com.example.test3.UserRecord" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>



<html>
<title>Spherify | Photosphere Viewer</title>
<head>
	<link href='http://fonts.googleapis.com/css?family=Pontano+Sans' rel='stylesheet' type='text/css'>
    <link href="bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet"/>

	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<%-- //[START datastore]--%>
<%
String galleryName = request.getParameter("gallery");
String index = request.getParameter("index");
String ancestor = "default";
if (galleryName == null) {
    galleryName = "home";
}
pageContext.setAttribute("galleryName", galleryName);

BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
    
// Create the correct Ancestor key
      Key<Gallery> theBook = Key.create(Gallery.class, ancestor);
	  List<ImageRecord> imageRecords;
	  UserService userService = UserServiceFactory.getUserService();
	  User user = userService.getCurrentUser();
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
      Collections.sort(imageRecords);
      for (Iterator<ImageRecord> iter = imageRecords.listIterator(); iter.hasNext(); ) {
    	    ImageRecord a = iter.next();
    	    if(a.isUnlisted.equals("yes")&&(user==null||!user.getNickname().equals(galleryName)))
    	    {
    	        iter.remove();
    	    }
    	}
	  ImageRecord a = imageRecords.get(Integer.parseInt(index));
      String thumbnail = a.perma_url+"=s590-c";
      String description;
      pageContext.setAttribute("thumbnail", thumbnail);

      
      if (a.desc == null) {
          description = "spherify";
      } else {
          description = a.desc;
      }
      pageContext.setAttribute("description", description);
%>
    <meta name="description" content="Spherify - An easy-to-use Photosphere viewer and sharing service for Google Cardboard that works with any phone in the browser.">
	<meta property="og:description" content="Spherify - An easy-to-use Photosphere viewer and sharing service for Google Cardboard.">
    <meta property="og:image"
    content="${fn:escapeXml(thumbnail)}" />
    <meta property="og:title"
    content="${fn:escapeXml(description)}" />
    <!--<link type="text/css" rel="stylesheet" href="/stylesheets/render.css"/>-->
</head>
<style>
.class_checkbox {
display:none;
    
}

.class_checkbox + label{
   content: url('images/cardboard_logo.png');
   opacity: 0.7;	
    //background-color: blue;
    height: 30px;
    width: 30px;
    display:inline-block;
    padding: 0 0 0 0px;
 
}

.class_checkbox:checked + label {
   content: url('images/aspect_ratio.png');
   opacity: 0.4;	
    //background-color: blue;
    height: 30px;
    width: 30px;
    display:inline-block;
    padding: 0 0 0 0px;
 
	}
</style>
<body onload="show()">
  	<div id="iden" style="display: none;">1</div>
  	   
  <h3 class="panel panel-default list-group-item-info" id="info" style="display:none"><span class="glyphicon glyphicon-remove pull-right"></span><span class="glyphicon glyphicon-info-sign"></span><span id="infotext"></span></h3>	
    <div id="examplee"></div>
    <div style="position: fixed; bottom:0px; left:48%;" id="sbscontainer" ><input id="sbs" type="checkbox" class="class_checkbox"><label for="sbs" id="sbslabel" style="display:none"></label></div>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script src="js/third-party/threejs/three.js"></script>
  <script src="js/third-party/threejs/StereoEffect.js"></script>
  <script src="js/third-party/threejs/DeviceOrientationControls.js"></script>
  <script src="js/third-party/threejs/OrbitControls.js"></script>
  <script src="js/renderlocal.js"></script>
<script src="fonts/helvetiker_regular.typeface.js"></script>
<script>
if(!(/CriOS|Android/i.test(navigator.userAgent)))
{
var ex = document.getElementById("examplee");
var body = document.getElementsByTagName("BODY")[0];
ex.style.position ="absolute";
ex.style.top ="0";
ex.style.left ="0";
ex.style.right ="0";
ex.style.bottom ="0";
body.style.margin="0px";
body.overflow="hidden";	

}

function show(){
	if(/CriOS|Android/i.test(navigator.userAgent))
	{ 
	$('#infotext').html("Drag this text and scroll down swiftly to hide the address bar.");
	$('#info').show();
	}
	document.getElementById("sbs").checked = sbs;

	
	$('#sbslabel').show();
	
	
	$('#sbs').change(function(){
		sbs = !sbs;
	
		resize();
		});
}
</script>
  <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-64190024-2', 'auto');
  ga('send', 'pageview');

</script>

<script>
var blob_keys = [];
var sids = [];
</script>
 

<%    	
		for (ImageRecord imageRecord : imageRecords) {
			pageContext.setAttribute("blob_key", imageRecord.blob_key);
			pageContext.setAttribute("sid", Long.toString(imageRecord.id));		
			//if(imageRecord.isUnlisted.equals("yes")&&(user==null||!user.getNickname().equals(galleryName)))
           	//{
           		//System.out.print(user.getNickname()+" "+galleryName);
         		//System.out.println("unlisted");
         		//continue;
           	
%>
<script>
	blob_keys.push("${fn:escapeXml(blob_key)}");
	sids.push("${fn:escapeXml(sid)}");
</script>
<% } %>

<script>
initlocal();
animate();
</script>
</body>
</html>