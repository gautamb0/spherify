<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- //[START imports]--%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
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
<head>
<title>Spherify | Photosphere Viewer</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <link type="text/css" rel="stylesheet" href="/stylesheets/render.css"/>
</head>

<%
    String galleryName = request.getParameter("gallery");
    String ancestor = "default";
    if (galleryName == null) {
        galleryName = "home";
    }
    pageContext.setAttribute("galleryName", galleryName);

    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();


%>

<body>
  	<div id="iden" style="display: none;">1</div>
  
    <div id="examplee"></div>
  <script src="js/third-party/jquery-1.11.3.min.js"></script>
  <script src="js/third-party/threejs/three.js"></script>
  <script src="js/third-party/threejs/StereoEffect.js"></script>
  <script src="js/third-party/threejs/DeviceOrientationControls.js"></script>
  <script src="js/third-party/threejs/OrbitControls.js"></script>
  <script src="js/renderlocal.js"></script>

<script src="fonts/gentilis_bold.typeface.js"></script>
<script src="fonts/gentilis_regular.typeface.js"></script>
<script src="fonts/optimer_bold.typeface.js"></script>
<script src="fonts/optimer_regular.typeface.js"></script>
<script src="fonts/helvetiker_bold.typeface.js"></script>
<script src="fonts/helvetiker_regular.typeface.js"></script>
<script src="fonts/droid_sans_regular.typeface.js"></script>
<script src="fonts/droid_sans_bold.typeface.js"></script>
<script src="fonts/droid_serif_regular.typeface.js"></script>
<script src="fonts/droid_serif_bold.typeface.js"></script>


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
</script>
 
<%-- //[START datastore]--%>
<%
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

    if (imageRecords.isEmpty()) {
%>
<p>No pictures in '${fn:escapeXml(galleryName)}'. Upload a sphere now!</p>
<%
    } else {
    	Collections.sort(imageRecords);
		for (ImageRecord imageRecord : imageRecords) {
			pageContext.setAttribute("blob_key", imageRecord.blob_key);		
			if(imageRecord.isUnlisted.equals("yes")&&(user==null||!user.getNickname().equals(galleryName)))
           	{
           		//System.out.print(user.getNickname()+" "+galleryName);
         		//System.out.println("unlisted");
         		continue;
           	}
%>
<script>
	blob_keys.push("${fn:escapeXml(blob_key)}");
</script>
<%		} 
 
	} %>
<script>
initlocal();
animate();
</script>
</body>
</html>