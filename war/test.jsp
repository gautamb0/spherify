<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- //[START imports]--%>

<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>


<%@ page import="com.example.test3.ImageRecord" %>
<%@ page import="com.example.test3.Gallery" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
<title>Spherify your world | VR for everyone</title>
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

<p>This example uses the addEventListener() method to execute a function when a user clicks on a button.</p>

<div id="myBtn">Try it</div>

<p id="demo">

    


<script>
document.getElementById("myBtn").addEventListener("click", myFunction);

function myFunction() {
    document.getElementById("demo").innerHTML = "Hello orld";
    console.log("click");
}
</script>
<div id="examplee"></div>
</body>
</html>
