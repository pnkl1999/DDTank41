// JavaScript Document
jQuery(document).ready(function(){
	jQuery('.dangky').bind('mouseover',function(){
		jQuery(this).removeClass('dangky');
		jQuery(this).addClass('dangky-o');
	})
	jQuery('.dangky').bind('mouseout',function(){
		jQuery(this).removeClass('dangky-o');
		jQuery(this).addClass('dangky');
	})
})