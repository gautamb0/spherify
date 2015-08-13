var camera, scene, renderer;
    var effect, controls;
    var element, container;
    
    var clock = new THREE.Clock();
    var iden = document.getElementById('iden').innerHTML;
    var mesh = null;
    var index = getUrlParameter('index');
    if(index==null)
    {
    	index = 0;
    }
    var drag = false;
    function initlocal() {
      
      document.getElementById("examplee").addEventListener("mousedown", function(){drag=false;});
      document.getElementById("examplee").addEventListener("mouseup", myFunction);
      document.getElementById("examplee").addEventListener("mousemove", function(){drag=true;});
      //$("#examplee").on("tap",myFunction);
      renderer = new THREE.WebGLRenderer();
      element = renderer.domElement;
      container = document.getElementById('examplee');
      container.appendChild(element);
      
      effect = new THREE.StereoEffect(renderer);
	  effect.setSize(window.innerWidth/2,window.innerHeight);

      scene = new THREE.Scene();

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
    
    function changeSphere(){
    	if(mesh)
    	{
    		scene.remove(mesh);
    	}
    	var imagePath = "/serve?blob-key="+blob_keys[index];
      	var texture = THREE.ImageUtils.loadTexture(imagePath);
      	var material = new THREE.MeshBasicMaterial({
          map: texture
        });

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