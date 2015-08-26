var camera, scene, renderer;
    var effect, controls;
    var element, container;
    var arrow=null;
    var arrow2=null;
    var prevMesh = null;
    var nextMesh = null;
    var loadingMesh = null;
    var loadMesh2 = null;
    var clock = new THREE.Clock();
    var iden = document.getElementById('iden').innerHTML;
    var mesh = null;
    var index = getUrlParameter('index');
    var nextTick = 0;
    var prevTick = 0;
    var sbs = false;
    if(index==null)
    {
    	index = 0;
    }
    var drag = false;
    function initlocal() {
      
    	console.log(navigator.userAgent);
      //$("#examplee").on("tap",myFunction);
      renderer = new THREE.WebGLRenderer();
      element = renderer.domElement;
      container = document.getElementById('examplee');
      container.appendChild(element);
      
      effect = new THREE.StereoEffect(renderer);
      effect.separation = 0;
	  effect.setSize(window.innerWidth/2,window.innerHeight);


      scene = new THREE.Scene();
      
      var light = new THREE.PointLight(0xffffff);
  	light.position.set(0,50,0);
  	scene.add(light);
  	
  	
  	
    var arrowPoints = [];
	
	arrowPoints.push( new THREE.Vector2 (  4,  0 ) );

	arrowPoints.push( new THREE.Vector2 ( -1, 2 ) );
	arrowPoints.push( new THREE.Vector2 ( -1, 1 ) );
	arrowPoints.push( new THREE.Vector2 ( -5, 1 ) );

	arrowPoints.push( new THREE.Vector2 ( -5, -1 ) );
	arrowPoints.push( new THREE.Vector2 ( -1, -1 ) );
	arrowPoints.push( new THREE.Vector2 ( -1, -2 ) );

	
	var arrowShape = new THREE.Shape( arrowPoints );

	var extrusionSettings = {
		size: 1, height: 1, curveSegments: 3,
		bevelThickness: 1, bevelSize: 1, bevelEnabled: false,
		material: 0, extrudeMaterial: 1, amount: 2
	};
	
	var arrowGeometry = new THREE.ExtrudeGeometry( arrowShape, extrusionSettings );
	
	var materialFront = new THREE.MeshBasicMaterial( { color: 0xFFFFCC , transparent: true, opacity: 0.6 } );
	var materialSide = new THREE.MeshBasicMaterial( { color: 0xFFFFCC , transparent: true, opacity: 0.6 } );
	var materialArray = [ materialFront, materialSide ];
	var arrowMaterial = new THREE.MeshFaceMaterial(materialArray);
	
	var textGeom = new THREE.TextGeometry( "Prev", 
			{
				size: 4, height: 1, curveSegments: 3,
				font: "helvetiker", weight: "normal", style: "normal",
				bevelThickness: 1, bevelSize: 1, bevelEnabled: false,
				material: 0, extrudeMaterial: 1
			});
	
			// font: helvetiker, gentilis, droid sans, droid serif, optimer
			// weight: normal, bold
			
	var textMaterial = new THREE.MeshFaceMaterial(materialArray);
	prevMesh = new THREE.Mesh(textGeom, textMaterial );
	
	textGeom.computeBoundingBox();
	var textWidth = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x;
	prevMesh.position.set(-55,20,50);
	prevMesh.rotation.y = -1.25*Math.PI;		
	//scene.add(prevMesh);
	textGeom = new THREE.TextGeometry( "Next", 
			{
				size: 4, height: 1, curveSegments: 3,
				font: "helvetiker", weight: "normal", style: "normal",
				bevelThickness: 1, bevelSize: 1, bevelEnabled: false,
				material: 0, extrudeMaterial: 1
			});
	nextMesh = new THREE.Mesh(textGeom, textMaterial );
	textGeom.computeBoundingBox();
	textWidth = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x;
	nextMesh.position.set(-66,20,-50);
	nextMesh.rotation.y = -1.75*Math.PI;	
	
	
	arrow = new THREE.Mesh( arrowGeometry, arrowMaterial );
	arrow2 = new THREE.Mesh( arrowGeometry, arrowMaterial );
	arrow.position.set(-60,14,50);  	  		
	//scene.add(arrow);
  	
  	arrow2.position.set(-60,14,-50);
  	
  	

	textGeom = new THREE.TextGeometry( "Loading", 
			{
				size: 8, height: 1, curveSegments: 3,
				font: "helvetiker", weight: "normal", style: "normal",
				bevelThickness: 1, bevelSize: 1, bevelEnabled: false,
				material: 0, extrudeMaterial: 1
			});
	materialFront = new THREE.MeshBasicMaterial( { color: 0xFF0000 } );
	materialSide = new THREE.MeshBasicMaterial( { color: 0xFF0000 } );
	materialArray = [ materialFront, materialSide ];
	textMaterial = new THREE.MeshFaceMaterial(materialArray);
	loadingMesh = new THREE.Mesh(textGeom, textMaterial );
	textGeom.computeBoundingBox();
	textWidth = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x;
	loadingMesh.position.set(-70,13,20);
	loadingMesh.rotation.y = -1.5*Math.PI;	
	//scene.add(loadingMesh);
	loadingMesh2 = new THREE.Mesh(textGeom, textMaterial );
	loadingMesh2.rotation.y = 1.5*Math.PI;
	loadingMesh2.position.set(70,-22,0);
	
  	//scene.add(arrow2);
  	
  	
  	
      //scene.add(sphere);
      
      
      
      camera = new THREE.PerspectiveCamera(90, (window.innerWidth/2)/window.innerHeight, 0.001, 700);
      

      
      
      camera.position.set(0, 10, 0);
      scene.add(camera);

      controls = new THREE.OrbitControls(camera, element);
      controls.rotateUp(Math.PI / 4);
      controls.target.set(
        camera.position.x + 0.1,
        camera.position.y,
        camera.position.z
      );
      controls.noZoom = true;
      controls.noPan = true;
      
      window.addEventListener('deviceorientation', setOrientationControls, true);
      
      document.getElementById("examplee").addEventListener("mousedown", function(){drag=false;});
      document.getElementById("examplee").addEventListener("mouseup", myFunction);
      document.getElementById("examplee").addEventListener("mousemove", function(){drag=true;});
      //console.log("("+camera.rotation._x+","+camera.rotation._y+","+camera.rotation._z+")");
    
      function setOrientationControls(e) {
        if (!e.alpha) {
          return;
        }
        sbs = true;
     
        controls = new THREE.DeviceOrientationControls(camera, true);
        controls.connect();
        controls.update();

        //container.addEventListener('click', console.log("clicj"), false);

        window.removeEventListener('deviceorientation', setOrientationControls, true);
      }
      if(!(/CriOS|Android/i.test(navigator.userAgent)))
      {
    	  window.addEventListener('resize', resize, false);
      }
      
      setTimeout(resize, 1);
      changeSphere();
    }	
    
    function resize() {
      var width;
      
      var height;

      if(/CriOS|Android/i.test(navigator.userAgent))
      {
          width = screen.height;
          height = screen.width+150;
      }
      else
      {
          width = container.offsetWidth;
          height = container.offsetHeight;
      }
      
      camera.aspect = width / height;
      camera.updateProjectionMatrix();

      renderer.setSize(width, height);
      effect.setSize(width, height);
    }

    function update(dt) {
    if(!(/CriOS|Android/i.test(navigator.userAgent)))
    {
    	resize();

      camera.updateProjectionMatrix();
    }
      var vector = new THREE.Vector3( 0, 0, -1 );
      vector.applyQuaternion( camera.quaternion );
      if(arrow)
      {
    	  anglePrev = vector.angleTo( arrow.position );
      }
      if(arrow2)
    {
    	  angleNext = vector.angleTo( arrow2.position );
    }
      
      //console.log(anglePrev);
      
      
      controls.update(dt);
    	if(angleNext<.29)//(camera.rotation._x>0&&camera.rotation._x<.2&&camera.rotation._y>.75&&camera.rotation._y<.95&&camera.rotation._z>-.15&&camera.rotation._z<.05)
      	{

    		nextTick++;
    		arrow2.rotation.x -= 0.05;
      		if(nextTick>250)
      		{
      			//console.log("next");
      			nextTick = 0;
      			nextSphere();
      		}
      	} else if(anglePrev<.29)//(camera.rotation._x>3&&camera.rotation._x<3.2&&camera.rotation._y>.75&&camera.rotation._y<.95&&camera.rotation._z>-3.2&&camera.rotation._z<-3)
      	{
      		prevTick++;
      	 	arrow.rotation.x -= 0.05;
      		if(prevTick>250)
      		{
      	//		console.log("prev");
      			prevTick = 0;
      			prevSphere();
      		}
      	}
      	else
      	{
      		arrow.rotation.x = 0;
      		arrow2.rotation.x = 0;
      		nextTick = 0;
      		prevTick = 0;
      	}
    	
    	 
    }

    function render(dt) {
    	if(sbs)
    	{
    		effect.render(scene, camera);
    	}
    	else
    	{	
    		renderer.render(scene, camera);
    	}
    }

    function animate(t) {
      requestAnimationFrame(animate);

      update(clock.getDelta());
      render(clock.getDelta());
    }

    function fullscreen() {
      if (container.requestFullscreen) {
        container.requestFullscreen();
      } else if (container.msRequestFullscreen) {
        container.msRequestFullscreen();
      } else if (container.mozRequestFullScreen) {
        container.mozRequestFullScreen();
      } else if (container.webkitRequestFullscreen) {
        container.webkitRequestFullscreen();
      }
    }
    
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
    
    function nextSphere()
    {
    	if(index<blob_keys.length-1)
    	{
    		index++;
    		changeSphere();
    	}  
    }
    
    function prevSphere()
    {
    	if(index>0)
    	{
    		index--;
    		changeSphere();
    	}  
    }
    
    
    function changeSphere(){
     	if(mesh)
    	{
    		console.log("remove mesh");
     		scene.remove(mesh);
    		
    	}
     	var materialBlank = new THREE.MeshBasicMaterial( { color: 0x00000});
     	var geometryBlank = new THREE.SphereGeometry(100, 32, 32);
        var mesh2 = new THREE.Mesh(geometryBlank, materialBlank);
        scene.add(mesh2);
        scene.add(loadingMesh);
        scene.add(loadingMesh2);
     	if(arrow)
    	{
    		scene.remove(arrow);
    	}
     	if(arrow2)
    	{
    		scene.remove(arrow2);
    	}
     	if(prevMesh)
    	{
    		scene.remove(prevMesh);
    	}
     	if(nextMesh)
    	{
    		scene.remove(nextMesh);
    	}
     	
    	var loader = new THREE.ImageLoader();
    	
    	
    	var imagePath = "/serve?blob-key="+blob_keys[index];
    	
    	var textur = THREE.ImageUtils.loadTexture(imagePath);
    	console.log(textur);
    	console.log(imagePath);
    	// load a image resource
    	loader.load(
    		// resource URL
    		imagePath,
    		// Function when resource is loaded
    		function ( image ) {
    			xmlhttp=new XMLHttpRequest();
    			xmlhttp.open("POST","/view",true);
    			xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    			xmlhttp.send("sid="+sids[index]);
    			// do something with it
    			scene.remove(mesh2);
    			var texture = new THREE.Texture();
    			texture.image = image;
    			console.log(texture);
    			console.log("load complete");
              	var material = new THREE.MeshBasicMaterial({
                    map: textur
                  });
              	console.log("material");
                  //controls.rotateUp(Math.PI / 4);
                  //controls.target.set(
                  //  camera.position.x + 0.1,
                  //  camera.position.y,
                  //  camera.position.z
                  //);
                  var geometry = new THREE.SphereGeometry(100, 32, 32);
                  mesh = new THREE.Mesh(geometry, material);
                  mesh.scale.x = -1;
                  
                  scene.add(mesh);
                  if(sbs)
                  {
                	  scene.add(arrow);
                      scene.add(arrow2);
                  	scene.add(prevMesh);
                	scene.add(nextMesh);
                  }
                  scene.remove(loadingMesh);
                  scene.remove(loadingMesh2);
    		},
    		// Function called when download progresses
    		function ( xhr ) {
    			console.log( (xhr.loaded / xhr.total * 100) + '% loaded' );
    		},
    		// Function called when download errors
    		function ( xhr ) {
    			console.log( 'An error happened' );
    		}
    	);
    	
   
    	
      	
    	//var texture = THREE.ImageUtils.loadTexture(imagePath,{},function(){
    //	}
    	//while (texture.image.width == 0);


    }
    
    document.addEventListener("keydown", keyboardResponse, false);
    
    function keyboardResponse(e) {

        switch(e.keyCode) {
            case 37:
                // left key pressed
            	prevSphere()
                break;
            case 38:
                // up key pressed
                break;
            case 39:
            	nextSphere();
                // right key pressed
                break;
            case 40:
                // down key pressed
                break;  
        }   
    }
    
    function myFunction() {
    	if(!drag)
    	{
    	nextSphere();
        //console.log("click");
    	}
    }