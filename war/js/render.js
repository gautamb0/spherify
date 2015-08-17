var camera, scene, renderer;
    var effect, controls;
    var element, container;
    
    var clock = new THREE.Clock();
    var iden = document.getElementById('iden').innerHTML;
    var blobKey = getUrlParameter('blob-key');
    var localPath = getUrlParameter('local-path');
    var imagePath;
    var sbs = false;
    if(blobKey!=null)
    {
    	 imagePath = "/serve?blob-key="+blobKey;
    }
    else
    {
    	imagePath = localPath;
    }
    console.log(blobKey);
    console.log(imagePath);
    init();
    animate();

    function init() {
      renderer = new THREE.WebGLRenderer();
      element = renderer.domElement;
      container = document.getElementById('example');
      container.appendChild(element);
      
      effect = new THREE.StereoEffect(renderer);
      effect.separation = 0;
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
      
      var texture = THREE.ImageUtils.loadTexture(imagePath);
      var material = new THREE.MeshBasicMaterial({
          map: texture
        });

        var geometry = new THREE.SphereGeometry(100, 32, 32);
        var mesh = new THREE.Mesh(geometry, material);
        mesh.scale.x = -1;
        
        scene.add(mesh);
        
      function setOrientationControls(e) {
        if (!e.alpha) {
          return;
        }
        sbs = true;
        controls = new THREE.DeviceOrientationControls(camera, true);
        controls.connect();
        controls.update();

        element.addEventListener('click', fullscreen, false);

        window.removeEventListener('deviceorientation', setOrientationControls, true);
      }
     
      window.addEventListener('resize', resize, false);
      setTimeout(resize, 1);
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