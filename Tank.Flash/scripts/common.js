// JavaScript Document
jQuery(document).ready(function(){
	jQuery('.Dangky').bind('mouseover',function(){
		jQuery(this).removeClass('Dangky');
		jQuery(this).addClass('Dangky-o');
	})
	jQuery('.Dangky').bind('mouseout',function(){
		jQuery(this).removeClass('Dangky-o');
		jQuery(this).addClass('Dangky');
	})
	if(jQuery("#img").length > 0){
		new FadeGallery(jQuery("#img"),{
			control_event: "mouseover",
			auto_play: true,
			control: jQuery("ul#imgControl"),
			delay: 2
		});
	}
})