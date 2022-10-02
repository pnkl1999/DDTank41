package ddt.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.filters.ColorMatrixFilter;
   
   public class Helpers
   {
      
      private static var _stage:Stage;
      
      public static const STAGE_UP_EVENT:String = "STAGE_UP_EVENT";
      
      public static const MOUSE_DOWN_AND_DRAGING_EVENT:String = "MOUSE_DOWN_AND_DRAGING_EVENT";
      
      private static var enterFrameDispatcher:Sprite = new Sprite();
      
      private static const encode_arr:Array = [["%","%01"],["]","%02"],["\\[","%03"]];
      
      private static const decode_arr:Array = [["%","%01"],["]","%02"],["[","%03"]];
       
      
      public function Helpers()
      {
         super();
      }
      
      public static function setTextfieldFormat(param1:TextField, param2:Object, param3:Boolean = false) : void
      {
         var _loc5_:* = null;
         var _loc4_:TextFormat = param1.getTextFormat();
         for(_loc5_ in param2)
         {
            _loc4_[_loc5_] = param2[_loc5_] || _loc4_[_loc5_];
         }
         if(param3)
         {
            param1.setTextFormat(_loc4_);
         }
         param1.defaultTextFormat = _loc4_;
      }
      
      public static function hidePosMc(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:RegExp = /_pos$/;
         var _loc4_:int = 0;
         while(_loc4_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc4_);
            if(_loc2_.test(_loc3_.name))
            {
               _loc3_.visible = false;
            }
            _loc4_++;
         }
      }
      
      public static function registExtendMouseEvent(param1:InteractiveObject) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_DOWN,__dobjDown);
      }
      
      private static function __dobjDown(param1:MouseEvent) : void
      {
         var dobj:InteractiveObject = null;
         var fun_up:Function = null;
         var fun_move:Function = null;
         dobj = null;
         fun_up = null;
         fun_move = null;
         var e:MouseEvent = param1;
         dobj = e.currentTarget as InteractiveObject;
         fun_up = function(param1:MouseEvent):void
         {
            dobj.dispatchEvent(new Event(STAGE_UP_EVENT));
            dobj.stage.removeEventListener(MouseEvent.MOUSE_UP,fun_up);
            dobj.stage.removeEventListener(MouseEvent.MOUSE_MOVE,fun_move);
         };
         fun_move = function(param1:MouseEvent):void
         {
            dobj.dispatchEvent(new Event(MOUSE_DOWN_AND_DRAGING_EVENT));
         };
         dobj.stage.addEventListener(MouseEvent.MOUSE_UP,fun_up);
         dobj.stage.addEventListener(MouseEvent.MOUSE_MOVE,fun_move);
      }
      
      public static function delayCall(param1:Function, param2:int = 1) : void
      {
         var fun_new:Function = null;
         fun_new = null;
         var fun:Function = param1;
         var delay_frame:int = param2;
         fun_new = function(param1:Event):void
         {
            if(--delay_frame <= 0)
            {
               fun();
               enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME,fun_new);
            }
         };
         enterFrameDispatcher.addEventListener(Event.ENTER_FRAME,fun_new);
      }
      
      public static function copyProperty(param1:Object, param2:Object, param3:Array = null) : void
      {
         var _loc4_:String = null;
         for each(_loc4_ in param3)
         {
            param2[_loc4_] = param1[_loc4_];
         }
      }
      
      public static function enCodeString(param1:String) : String
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < encode_arr.length)
         {
            param1 = param1.replace(new RegExp(encode_arr[_loc2_][0],"g"),encode_arr[_loc2_][1]);
            _loc2_++;
         }
         return param1;
      }
      
      public static function deCodeString(param1:String) : String
      {
         var _loc2_:int = 0;
         _loc2_ = decode_arr.length - 1;
         while(_loc2_ >= 0)
         {
            param1 = param1.replace(new RegExp(decode_arr[_loc2_][1],"g"),decode_arr[_loc2_][0]);
            _loc2_--;
         }
         return param1;
      }
      
      public static function setup(param1:Stage) : void
      {
         _stage = param1;
      }
      
      public static function randomPick(param1:Array) : *
      {
         var _loc2_:int = param1.length;
         var _loc3_:int = Math.floor(_loc2_ * Math.random());
         return param1[_loc3_];
      }
	  
	  public static function colorful(param1:DisplayObject) : void
	  {
		  param1.filters = [];
	  }
	  
	  public static function grey(param1:DisplayObject) : void
	  {
		  var _loc2_:Array = [];
		  _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
		  _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
		  _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
		  _loc2_ = _loc2_.concat([0,0,0,1,0]);
		  var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
		  var _loc4_:Array = [];
		  _loc4_.push(_loc3_);
		  param1.filters = _loc4_;
	  }
	  
	  public static function spaceString(param1:Number, param2:Number = 8) : String
	  {
		  var _loc3_:String = "";
		  var _loc4_:int = param1 / param2;
		  var _loc5_:int = 0;
		  while(_loc5_ < _loc4_)
		  {
			  _loc3_ += " ";
			  _loc5_++;
		  }
		  return _loc3_;
	  }
   }
}
