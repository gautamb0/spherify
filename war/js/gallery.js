(function() {
console.log("hellO");
	var data ="";
	var xmlHttp = new XMLHttpRequest();
	var theUrl = "http://test3-djyeuxhczc.elasticbeanstalk.com/GetGalleryInfo";
	var imgHost = "http://elasticbeanstalk-us-east-1-990888494507.s3-website-us-east-1.amazonaws.com/";
	xmlHttp.open( "GET", theUrl+"?user=0", true );
	xmlHttp.send();
	
	
	xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState < 4)
            document.getElementById('container').innerHTML = "Loading...";
        else if (xmlHttp.readyState === 4) {
            if (xmlHttp.status == 200 && xmlHttp.status < 300) { 
                var amountStr = xmlHttp.responseText;
                console.log(amountStr)
                var amount = parseInt(amountStr);
                document.getElementById('container').innerHTML = "";
                for(i=0;i<amount;i++)
                {
                	data = "<div class='img'>  <a target='_blank' href='"+imgHost+i+".html'><img src='"+imgHost+"images/"+i+".jpg' alt='1' width='110' height='90'></a><div class='desc'>Add a description of the image here</div></div>"
                	document.getElementById("container").innerHTML += data;
                		console.log(i);
                }
            }
        }
    }
	



}());
