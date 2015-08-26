<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
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
    <meta name="description" content="Spherify - An easy-to-use Photosphere viewer and sharing service for Google Cardboard that works with any phone in the browser.">
	<style>.col-centered{
float: none;
margin: 0 auto;
}
.ui-selectmenu-button {
    width: auto !important;
}



</style>
</head>

<%
    String galleryName = request.getParameter("gallery");
	String tag = request.getParameter("tag");
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
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.4";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
 	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
    <script src="js/third-party/imagesloaded.pkgd.min.js"></script>
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

function toggleSearch(state)
{
	console.log(state);
	if(state=="1")
	{
		$('#navbarDefault').hide();
		$('#navbarSearch').show();
	}
	else
	{
		$('#navbarDefault').show();
		$('#navbarSearch').hide();
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
	numCols = 1;//Math.floor(screen.width/$('.cells').width());
	numRows = Math.ceil(screen.height/$('.cells').height());
	//console.log($('.cells').height());
	//console.log(screen.height);
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
		appendImg(images[index].author, images[index].nickname, images[index].description, images[index].perma_url, images[index].blob_key, images[index].index, images[index].sid,images[index].you,images[index].likes,images[index].liked,images[index].views);
		index++;
	}

}

$(window).scroll(function () {
	
	if($(window).scrollTop() + screen.height >= $(document).height() - 100) {
	
		nextPage();
	}
});

</script>
<nav class="navbar navbar-default" id="navbarDefault" style="margin-bottom: 0;">
  <div class="container-fluid">
  
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header pull-left">
      <a class="navbar-brand" href="/"><img src="/images/logo.jpg" alt="spherify" style="object-fit: contain;height: 40px;"></img></a>
      
    </div>

    <!-- 'Sticky' (non-collapsing) right-side menu item(s) -->
    <div class="navbar-header pull-right">
      <ul class="nav pull-left">
		<li class="pull-right">
          <a onclick="toggleSearch('1')" style="color:#fff; margin-top: 15px; border:5px; padding:5px"><span class="glyphicon glyphicon-search"></span></a>
        </li>
        <li class="pull-right">
    
<%
    if (user != null) {
      pageContext.setAttribute("user", user);
      pageContext.setAttribute("user_id", user.getUserId());
%>
          <a href="/gallery.jsp?gallery=${fn:escapeXml(user.nickname)}" style="color:#fff; margin-top: 15px; border:5px; padding:5px">
<%
	} else {
%>          
          <a href="<%= userService.createLoginURL(request.getRequestURI()) %>" style="color:#fff; margin-top: 15px; border:5px; padding:5px">
<%
	}
%>          
          <span class="glyphicon glyphicon-user"></span></a>
        </li>
        <li class="pull-right">
          <a href="/upload.jsp" style="color:#fff; margin-top: 15px; border:5px; padding:5px"><span class="glyphicon glyphicon-upload"></span></a>
        </li>

      </ul>
	  </div>
     </div>
</nav>
<nav class="navbar navbar-default" id="navbarSearch" style="margin-bottom: 0; display:none;">
<div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    	<form class="navbar-form navbar-left" style="margin:0px;border:0px;padding:8px;"role="search">
          <div class="input-group">
          <input type="text" class="form-control" name="tag" placeholder="Search tags">
    		<span class="input-group-btn">
          	<a onclick="toggleSearch('0')" class="btn btn-default">Cancel</a>
          	</span>
          </div>          
        </form>

 </div>
 
</nav>

<script>

function likeImg(sid, index)
{
	//console.log("${fn:escapeXml(user.nickname)}");
	xmlhttp=new XMLHttpRequest();
	xmlhttp.open("POST","/like",true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("sid="+sid+"&user="+"${fn:escapeXml(user.nickname)}");
	var textEl = document.getElementById("likes_"+index);
	
	var iconEl = document.getElementById("likeIcon_"+index);
	iconEl.setAttribute("onclick","");
	
	iconEl.className="glyphicon glyphicon-heart";
	
	oldLikes = parseInt(textEl.innerHTML);
	
	if(textEl.innerHTML=="")
	{
		textEl.innerHTML = "1 like";
	}
	else
	{
		oldLikes++;
		textEl.innerHTML = oldLikes+" likes";
	}
}


function appendImg(author, nickname, description, perma_url, blob_key, index, sid, you, likes, liked, views, callback)
{
	//console.log(callback);
	var imgEl = "";
	
	var regexp = new RegExp('#([A-Za-z]+)','g');
	var pureDesc = description.replace(regexp, '');
	var tags =[];
	tags = description.match(regexp);
	var taglinks = "";
	if(tags!=null){
		for(var i=0;i<tags.length;i++)
		{
			taglinks += "<b><a href='/gallery.jsp?tag="+tags[i].substr(1)+"'>&nbsp;"+tags[i]+"</a></b>";
		}
	}
	
	imgEl+="<div class=\"row\">";
	imgEl+="<div class=\"cells col-centered\" style=\"max-width:600px\">";
	
	imgEl+="<div class=\"thumbnail\" style=\"white-space: nowrap;overflow:hidden;text-overflow: ellipsis;\">";
	imgEl+="<div class=\"caption\">";
	if ("${fn:escapeXml(galleryName)}"=="home"&&nickname =="")
	{
		imgEl+=author;
	}
	else if("${fn:escapeXml(galleryName)}"=="home")
	{
		imgEl+="<b><a href='/gallery.jsp?gallery="+nickname+"'>"+author+"</a></b>"

	}
	imgEl+="</div>"

	imgEl+="<a target='_blank' href='/slideshow.jsp?gallery=${fn:escapeXml(galleryName)}&index="+index+"'>";
	imgEl+="<img style=\"width:100%;\" src=\""+perma_url+"\" alt=\""+blob_key+"\"></a>";
	imgEl+="<div class=\"caption\" style=\"font-weight: bold;color:#212e49;\">";
	if(views!="")
	{
		imgEl+="<span>"+views+"</span>";
	}
	console.log(views);
	imgEl+="<span id=\"likes_"+index+"\">"+likes+"</span>";
	imgEl+="</div>"
	if(pureDesc!=""||taglinks!="")
	{
		imgEl+="<div class=\"caption\">"+pureDesc+taglinks+"</div>";
	}
	
	
	//imgEl+="<div class=\"input-group\">";
	//imgEl+="<span class=\"input-group-addon\" id=\"basic-addon1\"><span class=\"glyphicon glyphicon-link\"></span></span>";
	//imgEl+="<input type=\"text\" class=\"form-control\" value=\"http://www.spherify.co/render.html?blob-key="+blob_key+"\" aria-describedby=\"basic-addon1\">";
	imgEl+="<div class=\"caption\">";	
	if (you=="1")
	{
		//imgEl+= "<span class=\"input-group-btn\">";
		imgEl+= "<a href=\"/update.jsp?id="+sid+"\"><span class=\"glyphicon glyphicon-edit\" style=\"color:#2e6da4;\"></span></a>";
		imgEl+= "&nbsp;&nbsp;<span onclick=\"deleteImg("+sid+")\" class=\"glyphicon glyphicon-trash\" style=\"color:#2e6da4;\"></span>";
		
		//imgEl+= "<button class=\"btn btn-default\" type=\"button\">&nbsp;<span class=\"glyphicon glyphicon-edit\"></span>&nbsp;</button></a></span>"
	}
	
	
	else if("${fn:escapeXml(user.nickname)}"!="")
	{
		
		if(liked=="1")
		{
			imgEl+="<span class=\"glyphicon glyphicon-heart\" style=\"color:#2e6da4;\"></span>"			
		}
		else
		{
			
			imgEl+= "<span onclick=\"likeImg("+sid+","+index+")\" class=\"glyphicon glyphicon-heart-empty\" style=\"color:#2e6da4;\" id=\"likeIcon_"+index+"\"></span>";
		}
	}
	else
	{
		imgEl+="<span class=\"glyphicon glyphicon-heart-empty\" style=\"color:gray;\"></span>";	
	}
	//imgEl+="<a target='_blank' href='https://www.facebook.com/sharer/sharer.php?u=www.spherify.co/render.jsp?sid="+sid+"'<span class=\"glyphicon glyphicon-share pull-right\" style=\"color:#2e6da4;\"></span></a>";
	//imgEl+="<a target='_blank' href='https://www.reddit.com/submit?title="+description+"&url=www.spherify.co/render.jsp?sid="+sid+"'<span class=\"glyphicon glyphicon-share pull-right\" style=\"color:#2e6da4;\"></span></a>";
	//imgEl+="<select id=\"selectId\">";
	//imgEl+="<option>The 1st Option</option>";
	//imgEl+="<option>The 2nd Option</option>";
	//imgEl+="</select>";
	imgEl+="<span class=\"glyphicon glyphicon-link pull-right\" style=\"color:#2e6da4; margin:2px;\" data-toggle=\"modal\" data-target=\"#myModal\" onclick=\"$('#share_modal').val('www.spherify.co/render.jsp?sid="+sid+"');\"></span>"
	imgEl+="<div class=\"pull-right\"><a target='_blank' href='//www.reddit.com/submit?title="+pureDesc+"&url=www.spherify.co/render.jsp?sid="+sid+"'> <img src=\"//www.redditstatic.com/spreddit4.gif\" width=\"14\" height=\"14\" alt=\"submit to reddit\" style=\"margin:2px;\" /> </a></div>"
	imgEl+="<div class=\"pull-right\"><a target='_blank' href='https://www.facebook.com/sharer/sharer.php?u=/render.jsp?sid="+sid+"'><img class=\"img\" src=\"https://static.xx.fbcdn.net/rsrc.php/v2/yQ/r/7GFXgco-uzw.png\" alt=\"fb\" width=\"14\" height=\"14\" style=\"margin:2px;\"></a></div>"
	imgEl+="</div></div></div></div>";

	$("#imgGrid").append(imgEl);
	
    if (callback && typeof(callback) === "function") {
        callback();
    }
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
      if(!(tag==null)){
         imageRecords = ObjectifyService.ofy()
          .load()
          .type(ImageRecord.class) // We want only ImageRecords
          .ancestor(theBook)    // Anyone in this book
          .order("-date")       // Most recent first - date is indexed.
          .filter("isPrivate", "no")
          .filter("tags", tag.toLowerCase())
          .list();
      }
      else if(galleryName.equals("home")){
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
<p>No results found.</p>
<%
    } else {
    	Collections.sort(imageRecords);
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
<div class="panel panel-default list-group-item-info" id="info"><span class="glyphicon glyphicon-remove pull-right" onclick="$('#info').hide()"></span><span class="glyphicon glyphicon-info-sign"></span><span id="infotext"></span>


</div>
<script>

if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
	 $('#infotext').html(" Tap an image and place your phone in your cardboard to get started. Tap the screen, or look at the arrows to navigate through photospheres in the gallery.");
	}
else{
	//console.log("desktop");
	
	$('#infotext').html(" Click an image to get started. Use the left and right keys to navigate through photospheres in the gallery. For more fun, use a Google Cardboard!");
}
</script>
<% } %>

 <%
      // Look at all of our imageRecords
      int index = 0;
        for (ImageRecord imageRecord : imageRecords) {
        	
        	
        	

            String author="";
            String author_id="";
            String nickname ="";
            pageContext.setAttribute("you", "0");
            
            if (imageRecord.author_nickname == null) {
                author = "an anonymous person";
                
            } else {
                author = imageRecord.author_nickname;
                author_id = imageRecord.author_id;
                nickname = imageRecord.author_nickname;
                if (user != null && (user.getUserId().equals(author_id))) {
                    author += " (You)";
                    pageContext.setAttribute("you", "1");
                }
            }
           // System.out.print(index);
            //System.out.println(imageRecord.isUnlisted);
         	if(imageRecord.isUnlisted.equals("yes")&&(user==null||!user.getNickname().equals(galleryName)))
           	{
           		//System.out.print(user.getNickname()+" "+galleryName);
         		//System.out.println("unlisted");
         		continue;
           	}
         	
          	pageContext.setAttribute("index", index);
            pageContext.setAttribute("perma_url", imageRecord.perma_url);
            pageContext.setAttribute("blob_key", imageRecord.blob_key);

            pageContext.setAttribute("liked", "0");
            pageContext.setAttribute("imageRecord_user", author);
         	//System.out.println("");
  
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
            
            if(imageRecord.likes==1)
            {
            	pageContext.setAttribute("likes",Integer.toString(imageRecord.likes)+" like");
            }
            else if(imageRecord.likes>0)
            {
            	pageContext.setAttribute("likes",Integer.toString(imageRecord.likes)+" likes");
            }
            else
            {
            	pageContext.setAttribute("likes","");
            }
            
            if(user != null && imageRecord.likedUsers.contains(user.getNickname()))
            {
            	//System.out.println("liked");
            	pageContext.setAttribute("liked", "1");
            }
            
            if(imageRecord.views>49)
            {
            	pageContext.setAttribute("views",Integer.toString(imageRecord.views)+" views ");
            }
            else
            {
            	pageContext.setAttribute("views","");
            }
            
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
			image.perma_url = "${fn:escapeXml(perma_url)}"+"=s590-c";
			image.likes = "${fn:escapeXml(likes)}";
			image.views = "${fn:escapeXml(views)}";
			image.liked = "${fn:escapeXml(liked)}";
			//console.log(image.likes);
			images.push(image);
			</script>

<%
        }
    }
%>



<div id="imgGrid">
</div>

  <div class="modal" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Share Permalink</h4>
        </div>
        <div class="modal-body">
          <input type="text" class="form-control" id="share_modal" value="" aria-describedby="basic-addon1">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>
<script>
var index = 0;

function init(){
	
	imagesLoaded( $('.cells'), function( instance ) {

			index++;
			nextPage();
		});

}

appendImg(images[index].author, images[index].nickname, images[index].description, images[index].perma_url, images[index].blob_key, images[index].index, images[index].sid,images[index].you,images[index].likes,images[index].liked,images[index].views,init);


</script>
</div>
</body>
</html>
<%-- //[END all]--%>



