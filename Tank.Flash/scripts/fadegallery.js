FadeGallery = function (jEl, options) {
    var ACTIVE_CLASS = "ActiveBanner";
	var self= this; //self references

	/* public methods */

		/*
		*  name : setup
		*  arguments: 
		*  return: void
		*  description: autoplay
		*/
		this.setup = function () {
			this.options = {
				control_event: options != undefined && options.control_event!= undefined ? options.control_event : "click",
                auto_play: options != undefined && options.auto_play != undefined ? options.auto_play : false,
				delay: options != undefined && options.delay != undefined ? options.delay*1000 : 2*1000, //by default : each image can be viewed in 2 second
				control: options != undefined && options.control != undefined ? options.control : undefined,
				next_btn: options != undefined && options.next_btn != undefined ? options.next_btn : undefined,
				prev_btn: options != undefined && options.prev_btn != undefined ? options.prev_btn : undefined,
				play_backward: options != undefined && options.play_backward != undefined ? options.play_backward : false
			}
			this.list = jEl;
			this.list_items = this.list.find("> li");

			this.control_items = this.options.control.find("li");

			this.current_active_index;

			this.onAnimate = false;
			this.onHover = false;	

			this.list_items.each(function (index) { //init state
				var item = jQuery(this);

				if ( item.hasClass(ACTIVE_CLASS) ) {
					self.current_active_index = index;
				}
			});

			self.control_items.eq(self.current_active_index).addClass(ACTIVE_CLASS);
									
			//binding event
			if ( this.options.control != undefined ) {
				this.list_items.hover(function(){
					self.clearTimer();
				},function(){					
					if ( self.options.auto_play ) { self.autoPlay(); }
				});
				this.control_items.each(function (index) {
					var item = jQuery(this);
					
					item.bind(self.options.control_event, function () {
						
						if ( !item.hasClass(ACTIVE_CLASS) ) {
							self.clearTimer();
							self.onAnimate = true;
							self.gotoSlide(index);
						}
						self.clearTimer();
						return false;
					});
					item.bind("mouseout", function () {
						if ( self.options.auto_play ) { self.autoPlay(); }
					});
				});
				
			}

			if ( this.options.next_btn != undefined ) { //next
				this.options.next_btn.bind("click", function () {
					if ( !self.onAnimate ) {
						self.clearTimer();
						self.onAnimate = true;
						self.next();
					}

					return false;
				});
			}

			if ( this.options.prev_btn != undefined ) { //prev
				this.options.prev_btn.bind("click", function () {
					if ( !self.onAnimate ) {
						self.clearTimer();
						self.onAnimate = true;
						self.prev();
					}

					return false;
				});
			}

			if ( this.options.auto_play ) { self.autoPlay(); }//enable autoplay
			
			return self;
		}

		/*
		*  name : clear
		*  arguments: 
		*  return: void
		*  description: clear current active and return to no 'active' state
		*/
        this.clear = function () {
            this.list_items.eq(this.current_active_index).removeClass(ACTIVE_CLASS);
			this.control_items.eq(this.current_active_index).removeClass(ACTIVE_CLASS);
            this.current_active_index = undefined;
        }

		/*
		*  name : autoPlay
		*  arguments: 
		*  return: void
		*  description: autoplay
		*/
		this.autoPlay = function () {
			this.timer = setInterval(function () {
				self.onAnimate = true;
				if ( !self.options.play_backward ) {
					if ( self.current_active_index == self.list_items.length-1 ) { //current at the end of list
						self.gotoSlide(0);
					}
					else {
						self.gotoSlide(self.current_active_index+1);
					}
				}
				else {
					if ( self.current_active_index == 0 ) { //current at the begin of list
						self.gotoSlide(self.list_items.length-1);
					}
					else {
						self.gotoSlide(self.current_active_index-1);
					}
				}
			}, this.options.delay);
		}

		/*
		*  name : next
		*  arguments: 
		*  return: void
		*  description: slide to next image
		*/
		this.next = function () {
			if ( this.current_active_index == this.list_items.length-1 ) { //current at the end of list
				this.gotoSlide(0);
			}
			else {
				this.gotoSlide(this.current_active_index+1);
			}
		}

		/*
		*  name : prev
		*  arguments: 

		*  return: void
		*  description: slide to prev image
		*/
		this.prev = function () {
			if ( this.current_active_index == 0 ) { //current at the begin of list
				this.gotoSlide(this.list_items.length-1);
			}
			else {
				this.gotoSlide(this.current_active_index-1);
			}
		}

		/*
		*  name : gotoSlide
		*  arguments: Integer index
		*  return: void if index in range, false if out of range
		*  description: go to specific slide
		*/
		this.gotoSlide = function (index) {
			this.swapSlides(this.current_active_index, index, function () {
				self.current_active_index = index;
			});
		}

		/*
		*  name : swapSlides
		*  arguments: Integer old_index, Integer new_index, Function callback
		*  return: void
		*  description: swap 2 slides (change visible state)
		*/
		this.swapSlides = function (old_index, new_index, callback) {
			if ( old_index != undefined ) { self.control_items.eq(old_index).removeClass(ACTIVE_CLASS); } //control_items 
			
			if ( (/MSIE 6\.0/).test(navigator.userAgent) ) {
				try {
                    DD_belatedPNG.applyVML(self.control_items.eq(old_index).find("a").get(0));
                } catch (exp) {}
			}
			
			self.control_items.eq(new_index).addClass(ACTIVE_CLASS); //control_items
			
			if ( (/MSIE 6\.0/).test(navigator.userAgent) ) {
				try {
                    DD_belatedPNG.applyVML(self.control_items.eq(new_index).find("a").get(0));
                } catch (exp) {}
			}

			this.list_items.eq(new_index).stop().animate({
				opacity: 1
			});
            if ( old_index != undefined ) {
                this.list_items.eq(old_index).stop().animate({
                    opacity: 0
                }, "normal", "swing", function () {
                   
                    
                    
                });
				self.list_items.eq(old_index).removeClass(ACTIVE_CLASS);
                 self.list_items.eq(new_index).addClass(ACTIVE_CLASS);
				self.internal_callback();
				if ( callback != undefined ) {
                        callback(self);
                    }
				 
            }
            else {
                self.list_items.eq(new_index).addClass(ACTIVE_CLASS);
                self.internal_callback();
                if ( callback != undefined ) {
                    callback(self);
                }
            }
		}

		/*
		*  name : internal_callback
		*  arguments: no
		*  return: void
		*  description: callback
		*/
		this.internal_callback = function () {
			this.onAnimate = false;
			if ( this.timer == null ) {
				if ( this.options.auto_play ) { this.autoPlay(); } 
			}
		}

		/*
		*  name : clearTimer
		*  arguments: no
		*  return: void
		*  description: callback
		*/
		this.clearTimer = function () {
			clearInterval(this.timer);
			this.timer = null;
		}

	/* END. public methods */

	/* public members + constructor */

		//setup
		this.setup();

	/* END. public members + constructor */
}