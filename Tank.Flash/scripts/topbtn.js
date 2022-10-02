$(document).ready(function(){	
		if ( jQuery(".CapCha").length > 0 ) { 
			
			jQuery(".FormLogin .frm_button").css ("top", "205px");			
		}
		else {
			jQuery(".FormLogin .frm_button").css ("top", "168px");	
		}
		
		if($('p.TextWarning').length>0){
			var color = ['black','red'];
			var i=0;
			
			var change_c = setInterval(function(){
				if(i==color.length){
					i=0;	
				}
				$('p.TextWarning > a').css('color',color[i])
				i=i+1;
				
			},500);
		}
	});