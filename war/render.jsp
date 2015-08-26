<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- //[START imports]--%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>


<%@ page import="com.example.test3.ImageRecord" %>
<%@ page import="com.example.test3.Gallery" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%-- //[END imports]--%>



<html>
<head>
<title>Spherify | Photosphere Viewer</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    	<link href='http://fonts.googleapis.com/css?family=Pontano+Sans' rel='stylesheet' type='text/css'>
    <link href="bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet"/>
<%-- //[START datastore]--%>
<%
	  String sid = request.getParameter("sid");
      String ancestor = "default";
	  Long id = Long.parseLong(sid);
	  Key<Gallery> theBook = Key.create(Gallery.class, ancestor);

	  ImageRecord a = ObjectifyService.ofy().load().type(ImageRecord.class).parent(theBook).id(id).now();
      String thumbnail = a.perma_url+"=s590-c";
      String description;
      pageContext.setAttribute("thumbnail", thumbnail);
      pageContext.setAttribute("blob_key", a.blob_key);
      
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
  	<h3 class="panel panel-default list-group-item-info" id="info" style="display:none"><span class="glyphicon glyphicon-remove pull-right"></span><span class="glyphicon glyphicon-info-sign"></span><span id="infotext"></span></h3>	
  	<div id="iden" style="display: none;">1</div>
  
    <div id="example"><div style="position: fixed; bottom:0px; left:48%;"><input id="sbs" type="checkbox" class="class_checkbox"><label for="sbs" id="sbslabel" style="display:none"></label></div></div>
    
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script src="js/third-party/threejs/three.js"></script>
  <script src="js/third-party/threejs/StereoEffect.js"></script>
  <script src="js/third-party/threejs/DeviceOrientationControls.js"></script>
  <script src="js/third-party/threejs/OrbitControls.js"></script>
  <script src="js/render.js"></script>
<script src="fonts/helvetiker_regular.typeface.js"></script>
<script>
if(!(/CriOS|Android/i.test(navigator.userAgent)))
{
var ex = document.getElementById("example");
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
	$('#infotext').html("Drag this text and scroll down to hide the address bar.");
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

init("/serve?blob-key=${fn:escapeXml(blob_key)}");
animate();
</script>
</body>
</html>