var camera, scene, renderer;
    var effect, controls;
    var element, container;
    var star=null;
    var star2=null;
    var clock = new THREE.Clock();
    var iden = document.getElementById('iden').innerHTML;
    var mesh = null;
    var index = getUrlParameter('index');
    var nextTick = 0;
    var prevTick = 0;
    if(index==null)
    {
    	index = 0;
    }
    var drag = false;
    function initlocal() {
      

      //$("#examplee").on("tap",myFunction);
      renderer = new THREE.WebGLRenderer();
      element = renderer.domElement;
      container = document.getElementById('examplee');
      container.appendChild(element);
      
      effect = new THREE.StereoEffect(renderer);
	  effect.setSize(window.innerWidth/2,window.innerHeight);
	// Sphere parameters: radius, segments along width, segments along height
		var sphereGeometry = new THREE.SphereGeometry( 2, 32, 32 );
		var tetrahedronGeometry = new THREE.TetrahedronGeometry( 4, 1 );
		tetrahedronGeometry.applyMatrix( new THREE.Matrix4().makeRotationAxis( new THREE.Vector3( 1, 0, -1 ).normalize(), Math.atan( Math.sqrt(2)) ) );
		// use a "lambert" material rather than "basic" for realistic lighting.
		//   (don't forget to add (at least one) light!)
		var multiMaterial = new THREE.MeshLambertMaterial( {color: 0x8888ff} ); 
		var sphere = new THREE.Mesh(tetrahedronGeometry, multiMaterial);
		sphere.position.set(-60, 15, 60);

      scene = new THREE.Scene();
      
      var light = new THREE.PointLight(0xffffff);
  	light.position.set(0,50,0);
  	scene.add(light);
  	
  	
  	
var starPoints = [];
	
	starPoints.push( new THREE.Vector2 (  4,  0 ) );

	starPoints.push( new THREE.Vector2 ( -1, 2 ) );
	starPoints.push( new THREE.Vector2 ( -1, 1 ) );
	starPoints.push( new THREE.Vector2 ( -5, 1 ) );

	starPoints.push( new THREE.Vector2 ( -5, -1 ) );
	starPoints.push( new THREE.Vector2 ( -1, -1 ) );
	starPoints.push( new THREE.Vector2 ( -1, -2 ) );

	
	var starShape = new THREE.Shape( starPoints );

	var extrusionSettings = {
		size: 1, height: 1, curveSegments: 3,
		bevelThickness: 1, bevelSize: 1, bevelEnabled: false,
		material: 0, extrudeMaterial: 1, amount: 2
	};
	
	var starGeometry = new THREE.ExtrudeGeometry( starShape, extrusionSettings );
	
	var materialFront = new THREE.MeshBasicMaterial( { color: 0xffff00 } );
	var materialSide = new THREE.MeshBasicMaterial( { color: 0xff8800 } );
	var materialArray = [ materialFront, materialSide ];
	var starMaterial = new THREE.MeshFaceMaterial(materialArray);
	
	star = new THREE.Mesh( starGeometry, starMaterial );
	star2 = new THREE.Mesh( starGeometry, starMaterial );
	star.position.set(-60,14,50);  	  		
	scene.add(star);
  	
  	star2.position.set(-60,14,-50);
  	scene.add(star2);
  	
  	
  	
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
      document.getElementById("examplee").addEventListener("mousemove", function(){drag=true;
      //console.log("("+camera.rotation._x+","+camera.rotation._y+","+camera.rotation._z+")");


      });
      function setOrientationControls(e) {
        if (!e.alpha) {
          return;
        }
        
        controls = new THREE.DeviceOrientationControls(camera, true);
        controls.connect();
        controls.update();

        container.addEventListener('click', console.log("clicj"), false);

        window.removeEventListener('deviceorientation', setOrientationControls, true);
      }
     
      window.addEventListener('resize', resize, false);
      setTimeout(resize, 1);
      changeSphere();
    }	
    
    function resize() {
      var width = container.offsetWidth;
      var height = container.offsetHeight;

      camera.aspect = width / height;
      camera.updateProjectionMatrix();

      renderer.setSize(width, height);
      effect.setSize(width, height);
    }

    function update(dt) {
      resize();

      camera.updateProjectionMatrix();

      controls.update(dt);
    	if(camera.rotation._x>0&&camera.rotation._x<.2&&camera.rotation._y>.75&&camera.rotation._y<.95&&camera.rotation._z>-.15&&camera.rotation._z<.05)
      	{

    		nextTick++;
    		star2.rotation.x -= 0.05;
      		if(nextTick>250)
      		{
      			console.log("next");
      			nextTick = 0;
      			nextSphere();
      		}
      	} else if(camera.rotation._x>3&&camera.rotation._x<3.2&&camera.rotation._y>.75&&camera.rotation._y<.95&&camera.rotation._z>-3.2&&camera.rotation._z<-3)
      	{
      	 	prevTick++;
      	 	star.rotation.x -= 0.05;
      		if(prevTick>250)
      		{
      			console.log("prev");
      			prevTick = 0;
      			prevSphere();
      		}
      	}
      	else
      	{
      		star.rotation.x = 0;
      		star2.rotation.x = 0;
      		nextTick = 0;
      		prevTick = 0;
      	}
    	
    	 
    }

    function render(dt) {
      effect.render(scene, camera);
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
    		scene.remove(mesh);
    	}
    	var imagePath = "/serve?blob-key="+blob_keys[index];
      	console.log(imagePath);
    	var texture = THREE.ImageUtils.loadTexture(imagePath);
      	var material = new THREE.MeshBasicMaterial({
          map: texture
        });
        controls.rotateUp(Math.PI / 4);
        controls.target.set(
          camera.position.x + 0.1,
          camera.position.y,
          camera.position.z
        );
        var geometry = new THREE.SphereGeometry(100, 32, 32);
        mesh = new THREE.Mesh(geometry, material);
        mesh.scale.x = -1;
        
        scene.add(mesh);
      }
    
    document.addEventListener("keydown", keyboardResponse, false);
    
    function keyboardResponse(e) {

        switch(e.keyCode) {
            case 37:
                // left key pressed
            	if(index>0)
            	{
            		index--;
            		changeSphere();
            	}
                break;
            case 38:
                // up key pressed
                break;
            case 39:
            	if(index<blob_keys.length-1)
            	{
            		index++;
            		changeSphere();
            	}
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
        console.log("click");
    	}
    }