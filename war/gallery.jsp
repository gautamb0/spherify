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
<%@ page import="com.example.test3.UserRecord" %>
<%@ page import="com.example.test3.Gallery" %>
<%@ page import="com.example.test3.Userbase" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<title>Spherify | View and Share Photospheres on Cardboard</title>
<head>
	<link href='http://fonts.googleapis.com/css?family=Pontano+Sans' rel='stylesheet' type='text/css'>
    <link href="bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Spherify - An easy-to-use Photosphere viewer and sharing service for Cardboard that works with any phone in the browser.">
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
    <script src="js/third-party/equalize.min.js"></script>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-64190024-2', 'auto');
  ga('send', 'pageview');

</script>
	
	<script>
	var images = [];
	
	    function getUrlParameter(sParam)
    {
        var sPageURL = window.location.search.substring(1);
        var sURLVariables = sPageURL.split('&');
        for (var i = 0; i < sURLVariables.length; i++) 
        {
            var sParameterName = sURLVariables[i].split('=');
            if (sParameterName[0] == sParam) 
            {
                return sParameterName[1];
            }
        }
    } 
	
function deleteImg(sid) {
    var r = confirm("Are you sure you want to delete this photosphere?");
    if(r == true)
    {
    	xmlhttp=new XMLHttpRequest();
    	xmlhttp.open("POST","/delete",true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send("sid="+sid+"&gallery="+getUrlParameter('gallery'));
		location.reload();
    }
}

function showEdit() {
	$('#bio').hide();
	$('#bioedit').show();
}

function hideEdit() {
	$('#bio').show();
	$('#bioedit').hide();
}

function saveBio()
{
	hideEdit();
	var newBio = $('#bioTextarea').val();
	$('#bioStatic').html(newBio);
	xmlhttp=new XMLHttpRequest();
    xmlhttp.open("POST","/updateprofile",true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("bio="+newBio+"&gallery="+getUrlParameter('gallery'));
}

function nextPage()
{
	numCols = Math.floor(screen.width/$('.cells').width());
	numRows = Math.ceil(screen.height/$('.cells').height());
	picsPerPage = numCols * numRows;
	//console.log(numCols);
	//console.log(numRows);
	//console.log(picsPerPage);
	for(x=0;x<picsPerPage;x++)
	{
		if(index>=images.length)
		{
			break;
		}
		appendImg(images[index].author, images[index].nickname, images[index].description, images[index].perma_url, images[index].blob_key, images[index].index, images[index].sid,images[index].you);
		index++;
	}

}

$(window).scroll(function () {
	console.log($(window).scrollTop());
	console.log($(window).height());
	console.log($(document).height());
	console.log(screen.height);
	console.log(screen.width);
	//console.log($('.cells').height());
	//console.log($('.cells').width());
	if($(window).scrollTop() + screen.height >= $(document).height() - 100) {
		
		console.log("next page");
		nextPage();
	}
});

</script>
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
      pageContext.setAttribute("user_id", user.getUserId());
%>
          <a href="/gallery.jsp?gallery=${fn:escapeXml(user.nickname)}" style="color:#fff; margin-top: 5px;"></a>
<%
	} else {
%>          
          <a href="<%= userService.createLoginURL(request.getRequestURI()) %>" style="color:#fff; margin-top: 5px;"></a>
<%
	}
%>          
          <span class="glyphicon glyphicon-user"></span></a>
        </li>
        <li class="pull-right">
          <a href="/upload.jsp" style="color:#fff; margin-top: 5px;"><span class="glyphicon glyphicon-upload"></span></a>
        </li>
      </ul>
	  </div>
     </div>
</nav>
<script>
function appendImg(author, nickname, description, perma_url, blob_key, index, sid, you)
{
	var imgEl = "";
	imgEl+="<div class=\"cells col-xs-12 col-sm-6 col-md-4 col-lg-3\">";
	imgEl+="<div class=\"thumbnail\" style=\"white-space: nowrap;overflow:hidden;text-overflow: ellipsis;\">";
	
	if ("${fn:escapeXml(galleryName)}"=="home"&&nickname =="")
	{
		imgEl+="Spherified by "+author;
	}
	else if("${fn:escapeXml(galleryName)}"=="home")
	{
		imgEl+="Spherified by <b><a href='/gallery.jsp?gallery="+nickname+"'>"+author+"</a></b>";
	}
	
	imgEl+="<a target='_blank' href='/slideshow.jsp?gallery=${fn:escapeXml(galleryName)}&index="+index+"'>";
	imgEl+="<img style=\"height:180px;\" src=\""+perma_url+"\" alt=\""+blob_key+"\"></a>";
	imgEl+="<div class=\"caption\">"+description+"</div>";
	imgEl+="<div class=\"input-group\"><span class=\"input-group-addon\" id=\"basic-addon1\"><span class=\"glyphicon glyphicon-link\"></span></span>";
	imgEl+="<input type=\"text\" class=\"form-control\" value=\"http://www.spherify.co/render.html?blob-key="+blob_key+"\" aria-describedby=\"basic-addon1\">";
		
	if (you=="1")
	{
		imgEl+= "<span class=\"input-group-btn\">";
		imgEl+= "<button class=\"btn btn-default type=\"button\" onclick=\"deleteImg("+sid+")\">&nbsp;<span class=\"glyphicon glyphicon-trash\"></span>&nbsp;</button></span>";
		imgEl+= "<span class=\"input-group-btn\"><a href=\"/update.jsp?id="+sid+"\">";
		imgEl+= "<button class=\"btn btn-default\" type=\"button\">&nbsp;<span class=\"glyphicon glyphicon-edit\"></span>&nbsp;</button></a></span>"
	}
	
	imgEl+="</div></div></div>";
	
	$("#imgGrid").append(imgEl);
}
</script>
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

<% 
if(!galleryName.equals("home")) { 

		Key<Userbase> theBase = Key.create(Userbase.class, "default"); 
		UserRecord userRecord = ObjectifyService.ofy().load().type(UserRecord.class).parent(theBase).id(galleryName).now();
		if(userRecord == null)
		{
			
			pageContext.setAttribute("bio", galleryName+" has not entered a bio yet.");
		}
		else
		{
			pageContext.setAttribute("bio", userRecord.bio);
		}

%>
  <div class="panel panel-default">
  <div class="panel-heading">
  <h3 class="panel-title">${fn:escapeXml(galleryName)}'s Gallery</h3>
  </div>
<% 
	if(user != null && galleryName.equals(user.getNickname())) {

%>  
  <div id="bio">
  	<button class="btn btn-default pull-right" type="button" onclick="showEdit()"><span class="glyphicon glyphicon-edit"></span></button>
  	<div class="panel-body" id="bioStatic">${fn:escapeXml(bio)}</div>
  </div>
  <div id="bioedit" style="display:none">
  	<textarea style="width:100%" id="bioTextarea">${fn:escapeXml(bio)}</textarea><button class="btn btn-default pull-right" type="button" onclick="saveBio()"><span class="glyphicon glyphicon-ok"></span></button><button class="btn btn-default pull-right" type="button" onclick="hideEdit()"><span class="glyphicon glyphicon-remove"></span></button></span>
  </div>
<% } else { %>

  <div id="bio">
  	<div class="panel-body">${fn:escapeXml(bio)}</div>
  </div>
<% 	 } %>  
</div>
 
<% } else { %>
<div class="panel panel-default list-group-item-info" id="info"><span class="glyphicon glyphicon-remove pull-right" onclick="$('#info').hide()"></span><span class="glyphicon glyphicon-info-sign"></span>Tap an image and place your phone in your cardboard to get started. Tap the screen to go to the next image in the gallery, or use left/right keys on PC.
</div>

<% } %>

 <%
      // Look at all of our imageRecords
      int index = 0;
        for (ImageRecord imageRecord : imageRecords) {
        	
        	pageContext.setAttribute("index", index);
            pageContext.setAttribute("perma_url", imageRecord.perma_url);
            pageContext.setAttribute("blob_key", imageRecord.blob_key);
            pageContext.setAttribute("you", "0");
            String author="";
            String author_id="";
            String nickname ="";
            if (imageRecord.author_nickname == null) {
                author = "an anonymous person";
                
            } else {
                author = imageRecord.author_nickname;
                author_id = imageRecord.author_id;
                nickname = imageRecord.author_nickname;
                if (user != null && user.getUserId().equals(author_id)) {
                    author += " (You)";
                    pageContext.setAttribute("you", "1");
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
            pageContext.setAttribute("author", author);
            pageContext.setAttribute("author_id", author_id);
            pageContext.setAttribute("nickname", imageRecord.author_nickname);
            index++;
%>
			<script>
			var image={};
			image.description = "${fn:escapeXml(description)}";
			image.sid = "${fn:escapeXml(sid)}";
			image.author = "${fn:escapeXml(author)}";
			image.nickname = "${fn:escapeXml(nickname)}";
			image.you = "${fn:escapeXml(you)}";
			image.blob_key = "${fn:escapeXml(blob_key)}";
			image.index = "${fn:escapeXml(index)}";
			image.perma_url = "${fn:escapeXml(perma_url)}";
			images.sid = "${fn:escapeXml(sid)}";
			images.push(image);
			</script>

<%
        }
    }
%>



<div class="row" id="imgGrid">
</div>

<script>
var index = 0;
appendImg(images[index].author, images[index].nickname, images[index].description, images[index].perma_url, images[index].blob_key, images[index].index, images[index].sid,images[index].you);
index++;
nextPage();
</script>
</div>
</body>
</html>
<%-- //[END all]--%>



