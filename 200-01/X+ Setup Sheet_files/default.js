	// call init when loading the html page
	window.onload=init;
	
	//---------------------------------------
	//eventhandler
	//show toolholderbitmap in full size
	function MoveIt(e)
	{
		e=e || window.event;
		var mydiv=document.getElementById("THBMP");
		mydiv.style.left=e.clientX + 20 + "px";
		mydiv.style.marginTop = - e.target.naturalHeight/2 + window.scrollY + "px";
		mydiv.style.top="50%";
		mydiv.style.display="block";
		mydiv.firstChild.src=e.target.src;
	}
	
	//---------------------------------------
	//eventhandler
	//hide toolholderbitmap
	function HideIt()
	{
		var mydiv=document.getElementById("THBMP");
		mydiv.style.display="none";
	}
	
	
// screenshot zooming -------
function ZoomBackground(e){
  var container = e.currentTarget;
  var img = container.firstElementChild;  
  if (img.width<img.naturalWidth || img.height<img.naturalHeight){
  	container.style.cursor= "zoom-in";
	  container.style.backgroundSize="auto";
	  e.offsetX ? offsetX = e.offsetX : offsetX = e.touches[0].pageX
	  e.offsetY ? offsetY = e.offsetY : offsetX = e.touches[0].pageX
	  x = offsetX/container.offsetWidth*100
	  y = offsetY/container.offsetHeight*100
	  container.style.backgroundPosition = x + '% ' + y + '%';
	}
}

function ResetBackground(e)
{
	var container = e.currentTarget;
	container.style.cursor= "auto";
	container.style.backgroundPosition="center center"; 
	container.style.backgroundSize="contain"; 
}
//-----------------------------

	//-------------------------------------------------------
	//initialisation
	//create new DIV tag and IMG tag for toolholderbitmap
	//assign eventhandlers to the IMG tags
	function init()
	{
		document.title = "X+ Setup Sheet";
		// initialize zoomer
		var container = document.getElementsByClassName("HEADSCREENSHOT")[0];
		var img = container.firstElementChild;
		container.style.backgroundImage = "url('" + img.src + "')";
		container.onmousemove=ZoomBackground;
		container.onmouseout=ResetBackground;
		
		//create a new DIV with IMG tag
		var newdiv=document.createElement("div");
		newdiv.style.position="absolute";
		newdiv.style.border="solid 1px";
		newdiv.id="THBMP";
		newdiv.style.backgroundColor="rgba( 240, 255, 240, 0.9)";
		newdiv.style.boxShadow="10px 10px 5px #888888";
		newdiv.style.display="none";
		var img=document.createElement('img');
		img.src="";
		newdiv.appendChild(img);
		document.body.appendChild(newdiv);
		
		// create event handler for IMG tag (<div class=td_100> <img...>)
		var tds=document.getElementsByClassName("td_100");
		for (var i=0;i<tds.length;i++)
		{
			if(tds[i].hasChildNodes())
			{
				tds[i].firstChild.onmousemove=MoveIt;
				tds[i].firstChild.onmouseleave=HideIt;
			}
		}
		
	}
	