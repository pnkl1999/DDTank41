package com.greensock
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   public dynamic class TweenProxy extends Proxy
   {
      
      public static const VERSION:Number = 0.94;
      
      private static const _DEG2RAD:Number = Math.PI / 180;
      
      private static const _RAD2DEG:Number = 180 / Math.PI;
      
      private static var _dict:Dictionary = new Dictionary(false);
      
      private static var _addedProps:String = " tint tintPercent scale skewX skewY skewX2 skewY2 target registration registrationX registrationY localRegistration localRegistrationX localRegistrationY ";
       
      
      private var _target:DisplayObject;
      
      private var _angle:Number;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _proxies:Array;
      
      private var _localRegistration:Point;
      
      private var _registration:Point;
      
      private var _regAt0:Boolean;
      
      public var ignoreSiblingUpdates:Boolean = false;
      
      public var isTweenProxy:Boolean = true;
      
      public function TweenProxy(param1:DisplayObject, param2:Boolean = false)
      {
         super();
         this._target = param1;
         if(_dict[this._target] == undefined)
         {
            _dict[this._target] = [];
         }
         this._proxies = _dict[this._target];
         this._proxies.push(this);
         this._localRegistration = new Point(0,0);
         this.ignoreSiblingUpdates = param2;
         this.calibrate();
      }
      
      public static function create(param1:DisplayObject, param2:Boolean = true) : TweenProxy
      {
         if(_dict[param1] != null && param2)
         {
            return _dict[param1][0];
         }
         return new TweenProxy(param1);
      }
      
      public function getCenter() : Point
      {
         var _loc4_:Sprite = null;
         var _loc1_:Boolean = false;
         if(this._target.parent == null)
         {
            _loc1_ = true;
            _loc4_ = new Sprite();
            _loc4_.addChild(this._target);
         }
         var _loc2_:Rectangle = this._target.getBounds(this._target.parent);
         var _loc3_:Point = new Point(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height / 2);
         if(_loc1_)
         {
            this._target.parent.removeChild(this._target);
         }
         return _loc3_;
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function calibrate() : void
      {
         this._scaleX = this._target.scaleX;
         this._scaleY = this._target.scaleY;
         this._angle = this._target.rotation * _DEG2RAD;
         this.calibrateRegistration();
      }
      
      public function destroy() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Array = _dict[this._target];
         _loc2_ = _loc1_.length - 1;
         while(_loc2_ > -1)
         {
            if(_loc1_[_loc2_] == this)
            {
               _loc1_.splice(_loc2_,1);
            }
            _loc2_--;
         }
         if(_loc1_.length == 0)
         {
            delete _dict[this._target];
         }
         this._target = null;
         this._localRegistration = null;
         this._registration = null;
         this._proxies = null;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return this._target[param1].apply(null,rest);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this._target[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this._target[param1] = param2;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         if(this._target.hasOwnProperty(param1))
         {
            return true;
         }
         if(_addedProps.indexOf(" " + param1 + " ") != -1)
         {
            return true;
         }
         return false;
      }
      
      public function moveRegX(param1:Number) : void
      {
         this._registration.x += param1;
      }
      
      public function moveRegY(param1:Number) : void
      {
         this._registration.y += param1;
      }
      
      private function reposition() : void
      {
         var _loc1_:Point = null;
         _loc1_ = this._target.parent.globalToLocal(this._target.localToGlobal(this._localRegistration));
         this._target.x += this._registration.x - _loc1_.x;
         this._target.y += this._registration.y - _loc1_.y;
      }
      
      private function updateSiblingProxies() : void
      {
         var _loc1_:int = this._proxies.length - 1;
         while(_loc1_ > -1)
         {
            if(this._proxies[_loc1_] != this)
            {
               this._proxies[_loc1_].onSiblingUpdate(this._scaleX,this._scaleY,this._angle);
            }
            _loc1_--;
         }
      }
      
      private function calibrateLocal() : void
      {
         this._localRegistration = this._target.globalToLocal(this._target.parent.localToGlobal(this._registration));
         this._regAt0 = this._localRegistration.x == 0 && this._localRegistration.y == 0;
      }
      
      private function calibrateRegistration() : void
      {
         this._registration = this._target.parent.globalToLocal(this._target.localToGlobal(this._localRegistration));
         this._regAt0 = this._localRegistration.x == 0 && this._localRegistration.y == 0;
      }
      
      public function onSiblingUpdate(param1:Number, param2:Number, param3:Number) : void
      {
         this._scaleX = param1;
         this._scaleY = param2;
         this._angle = param3;
         if(this.ignoreSiblingUpdates)
         {
            this.calibrateLocal();
         }
         else
         {
            this.calibrateRegistration();
         }
      }
      
      public function get localRegistration() : Point
      {
         return this._localRegistration;
      }
      
      public function set localRegistration(param1:Point) : void
      {
         this._localRegistration = param1;
         this.calibrateRegistration();
      }
      
      public function get localRegistrationX() : Number
      {
         return this._localRegistration.x;
      }
      
      public function set localRegistrationX(param1:Number) : void
      {
         this._localRegistration.x = param1;
         this.calibrateRegistration();
      }
      
      public function get localRegistrationY() : Number
      {
         return this._localRegistration.y;
      }
      
      public function set localRegistrationY(param1:Number) : void
      {
         this._localRegistration.y = param1;
         this.calibrateRegistration();
      }
      
      public function get registration() : Point
      {
         return this._registration;
      }
      
      public function set registration(param1:Point) : void
      {
         this._registration = param1;
         this.calibrateLocal();
      }
      
      public function get registrationX() : Number
      {
         return this._registration.x;
      }
      
      public function set registrationX(param1:Number) : void
      {
         this._registration.x = param1;
         this.calibrateLocal();
      }
      
      public function get registrationY() : Number
      {
         return this._registration.y;
      }
      
      public function set registrationY(param1:Number) : void
      {
         this._registration.y = param1;
         this.calibrateLocal();
      }
      
      public function get x() : Number
      {
         return this._registration.x;
      }
      
      public function set x(param1:Number) : void
      {
         var _loc2_:Number = param1 - this._registration.x;
         this._target.x += _loc2_;
         var _loc3_:int = this._proxies.length - 1;
         while(_loc3_ > -1)
         {
            if(this._proxies[_loc3_] == this || !this._proxies[_loc3_].ignoreSiblingUpdates)
            {
               this._proxies[_loc3_].moveRegX(_loc2_);
            }
            _loc3_--;
         }
      }
      
      public function get y() : Number
      {
         return this._registration.y;
      }
      
      public function set y(param1:Number) : void
      {
         var _loc2_:Number = param1 - this._registration.y;
         this._target.y += _loc2_;
         var _loc3_:int = this._proxies.length - 1;
         while(_loc3_ > -1)
         {
            if(this._proxies[_loc3_] == this || !this._proxies[_loc3_].ignoreSiblingUpdates)
            {
               this._proxies[_loc3_].moveRegY(_loc2_);
            }
            _loc3_--;
         }
      }
      
      public function get rotation() : Number
      {
         return this._angle * _RAD2DEG;
      }
      
      public function set rotation(param1:Number) : void
      {
         var _loc2_:Number = param1 * _DEG2RAD;
         var _loc3_:Matrix = this._target.transform.matrix;
         _loc3_.rotate(_loc2_ - this._angle);
         this._target.transform.matrix = _loc3_;
         this._angle = _loc2_;
         this.reposition();
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get skewX() : Number
      {
         var _loc1_:Matrix = this._target.transform.matrix;
         return (Math.atan2(-_loc1_.c,_loc1_.d) - this._angle) * _RAD2DEG;
      }
      
      public function set skewX(param1:Number) : void
      {
         var _loc2_:Number = param1 * _DEG2RAD;
         var _loc3_:Matrix = this._target.transform.matrix;
         var _loc4_:Number = this._scaleY < 0 ? Number(Number(-this._scaleY)) : Number(Number(this._scaleY));
         _loc3_.c = -_loc4_ * Math.sin(_loc2_ + this._angle);
         _loc3_.d = _loc4_ * Math.cos(_loc2_ + this._angle);
         this._target.transform.matrix = _loc3_;
         if(!this._regAt0)
         {
            this.reposition();
         }
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get skewY() : Number
      {
         var _loc1_:Matrix = this._target.transform.matrix;
         return (Math.atan2(_loc1_.b,_loc1_.a) - this._angle) * _RAD2DEG;
      }
      
      public function set skewY(param1:Number) : void
      {
         var _loc2_:Number = param1 * _DEG2RAD;
         var _loc3_:Matrix = this._target.transform.matrix;
         var _loc4_:Number = this._scaleX < 0 ? Number(Number(-this._scaleX)) : Number(Number(this._scaleX));
         _loc3_.a = _loc4_ * Math.cos(_loc2_ + this._angle);
         _loc3_.b = _loc4_ * Math.sin(_loc2_ + this._angle);
         this._target.transform.matrix = _loc3_;
         if(!this._regAt0)
         {
            this.reposition();
         }
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get skewX2() : Number
      {
         return this.skewX2Radians * _RAD2DEG;
      }
      
      public function set skewX2(param1:Number) : void
      {
         this.skewX2Radians = param1 * _DEG2RAD;
      }
      
      public function get skewY2() : Number
      {
         return this.skewY2Radians * _RAD2DEG;
      }
      
      public function set skewY2(param1:Number) : void
      {
         this.skewY2Radians = param1 * _DEG2RAD;
      }
      
      public function get skewX2Radians() : Number
      {
         return -Math.atan(this._target.transform.matrix.c);
      }
      
      public function set skewX2Radians(param1:Number) : void
      {
         var _loc2_:Matrix = this._target.transform.matrix;
         _loc2_.c = Math.tan(-param1);
         this._target.transform.matrix = _loc2_;
         if(!this._regAt0)
         {
            this.reposition();
         }
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get skewY2Radians() : Number
      {
         return Math.atan(this._target.transform.matrix.b);
      }
      
      public function set skewY2Radians(param1:Number) : void
      {
         var _loc2_:Matrix = this._target.transform.matrix;
         _loc2_.b = Math.tan(param1);
         this._target.transform.matrix = _loc2_;
         if(!this._regAt0)
         {
            this.reposition();
         }
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get scaleX() : Number
      {
         return this._scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(param1 == 0)
         {
            param1 = 0.0001;
         }
         var _loc2_:Matrix = this._target.transform.matrix;
         _loc2_.rotate(-this._angle);
         _loc2_.scale(param1 / this._scaleX,1);
         _loc2_.rotate(this._angle);
         this._target.transform.matrix = _loc2_;
         this._scaleX = param1;
         this.reposition();
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get scaleY() : Number
      {
         return this._scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(param1 == 0)
         {
            param1 = 0.0001;
         }
         var _loc2_:Matrix = this._target.transform.matrix;
         _loc2_.rotate(-this._angle);
         _loc2_.scale(1,param1 / this._scaleY);
         _loc2_.rotate(this._angle);
         this._target.transform.matrix = _loc2_;
         this._scaleY = param1;
         this.reposition();
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get scale() : Number
      {
         return (this._scaleX + this._scaleY) / 2;
      }
      
      public function set scale(param1:Number) : void
      {
         if(param1 == 0)
         {
            param1 = 0.0001;
         }
         var _loc2_:Matrix = this._target.transform.matrix;
         _loc2_.rotate(-this._angle);
         _loc2_.scale(param1 / this._scaleX,param1 / this._scaleY);
         _loc2_.rotate(this._angle);
         this._target.transform.matrix = _loc2_;
         this._scaleX = this._scaleY = param1;
         this.reposition();
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get alpha() : Number
      {
         return this._target.alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._target.alpha = param1;
      }
      
      public function get width() : Number
      {
         return this._target.width;
      }
      
      public function set width(param1:Number) : void
      {
         this._target.width = param1;
         if(!this._regAt0)
         {
            this.reposition();
         }
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
      
      public function get height() : Number
      {
         return this._target.height;
      }
      
      public function set height(param1:Number) : void
      {
         this._target.height = param1;
         if(!this._regAt0)
         {
            this.reposition();
         }
         if(this._proxies.length > 1)
         {
            this.updateSiblingProxies();
         }
      }
   }
}
