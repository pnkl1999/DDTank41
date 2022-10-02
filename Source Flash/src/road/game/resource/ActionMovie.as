package road.game.resource
{
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class ActionMovie extends MovieClip
   {
      
      public static var LEFT:String = "left";
      
      public static var RIGHT:String = "right";
      
      public static var DEFAULT_ACTION:String = "stand";
      
      public static var STAND_ACTION:String = "stand";
       
      
      private var _labelLastFrames:Array;
      
      private var _soundControl:SoundTransform;
      
      private var _labelLastFrame:Dictionary;
      
      private var _currentAction:String;
      
      private var lastAction:String = "";
      
      private var _callBacks:Dictionary;
      
      private var _argsDic:Dictionary;
      
      private var _actionEnded:Boolean = true;
      
      protected var _actionRelative:Object;
      
      public var labelMapping:Dictionary;
      
      private var _soundEffectInstance:*;
      
      private var _isMute:Boolean = false;
      
      public function ActionMovie()
      {
         var _local_1:* = undefined;
         this._labelLastFrames = [];
         this._labelLastFrame = new Dictionary();
         this._argsDic = new Dictionary();
         this.labelMapping = new Dictionary();
         super();
         try
         {
            _local_1 = getDefinitionByName("ddt.manager.SoundEffectManager");
            if(_local_1)
            {
               this._soundEffectInstance = _local_1.Instance;
            }
         }
         catch(e:Error)
         {
         }
         this._callBacks = new Dictionary();
         mouseEnabled = false;
         mouseChildren = false;
         scrollRect = null;
         this._soundControl = new SoundTransform();
         soundTransform = this._soundControl;
         this.initMovie();
         this.addEvent();
      }
      
      private function initMovie() : void
      {
         var _local_2:int = 0;
         var _local_1:Array = currentLabels;
         while(_local_2 < _local_1.length)
         {
            if(_local_2 != 0)
            {
               this._labelLastFrame[_local_1[_local_2 - 1].name] = int(_local_1[_local_2].frame - 1);
            }
            _local_2++;
         }
         this._labelLastFrame[_local_1[_local_1.length - 1].name] = int(totalFrames);
      }
      
      private function addEvent() : void
      {
         addEventListener(ActionMovieEvent.ACTION_END,this.__onActionEnd);
      }
      
      public function doAction(_arg_1:String, _arg_2:Function = null, _arg_3:Array = null) : void
      {
         var _local_4:String = null;
         if(this.labelMapping[_arg_1])
         {
            _local_4 = this.labelMapping[_arg_1];
         }
         else
         {
            _local_4 = _arg_1;
         }
         if(!this.hasThisAction(_local_4))
         {
            if(_arg_2 != null)
            {
               this.callFun(_arg_2,_arg_3);
            }
            return;
         }
         if(!this._actionEnded)
         {
            if(this._callBacks && this._callBacks[this.currentAction] != null)
            {
               this.callCallBack(this.currentAction);
            }
            this._actionEnded = true;
            dispatchEvent(new ActionMovieEvent(ActionMovieEvent.ACTION_END));
         }
         this._actionEnded = false;
         if(_arg_2 != null && this._callBacks != null && this._callBacks[_local_4] != _arg_2)
         {
            this._callBacks[_local_4] = _arg_2;
            this._argsDic[_local_4] = _arg_3;
         }
         this.lastAction = this.currentAction;
         this._currentAction = _local_4;
         if(this._soundControl)
         {
            this._soundControl.volume = !!this._isMute ? Number(0) : Number(1);
         }
         if(soundTransform && this._soundControl)
         {
            soundTransform = this._soundControl;
         }
         addEventListener(Event.ENTER_FRAME,this.loop);
         this.MCGotoAndPlay(this.currentAction);
         dispatchEvent(new ActionMovieEvent(ActionMovieEvent.ACTION_START));
      }
      
      private function hasThisAction(_arg_1:String) : Boolean
      {
         var _local_3:FrameLabel = null;
         var _local_2:Boolean = false;
         for each(_local_3 in currentLabels)
         {
            if(_local_3.name == _arg_1)
            {
               _local_2 = true;
               break;
            }
         }
         return _local_2;
      }
      
      private function loop(_arg_1:Event) : void
      {
         if(currentFrame == this._labelLastFrame[this.currentAction] || currentLabel != this.currentAction)
         {
            removeEventListener(Event.ENTER_FRAME,this.loop);
            this._actionEnded = true;
            if(this._callBacks && this._callBacks[this.currentAction] != null)
            {
               this.callCallBack(this.currentAction);
            }
            dispatchEvent(new ActionMovieEvent(ActionMovieEvent.ACTION_END));
         }
      }
      
      private function callCallBack(_arg_1:String) : void
      {
         var _local_2:Array = this._argsDic[_arg_1];
         if(this._callBacks[_arg_1] == null)
         {
            return;
         }
         this.callFun(this._callBacks[_arg_1],_local_2);
         this.deleteFun(_arg_1);
      }
      
      private function deleteFun(_arg_1:String) : void
      {
         if(this._callBacks)
         {
            this._callBacks[_arg_1] = null;
            delete this._callBacks[_arg_1];
         }
         if(this._argsDic)
         {
            this._argsDic[_arg_1] = null;
            delete this._argsDic[_arg_1];
         }
      }
      
      private function callFun(_arg_1:Function, _arg_2:Array) : void
      {
         if(_arg_2 == null || _arg_2.length == 0)
         {
            _arg_1();
         }
         else if(_arg_2.length == 1)
         {
            _arg_1(_arg_2[0]);
         }
         else if(_arg_2.length == 2)
         {
            _arg_1(_arg_2[0],_arg_2[1]);
         }
         else if(_arg_2.length == 3)
         {
            _arg_1(_arg_2[0],_arg_2[1],_arg_2[2]);
         }
         else if(_arg_2.length == 4)
         {
            _arg_1(_arg_2[0],_arg_2[1],_arg_2[2],_arg_2[3]);
         }
      }
      
      public function get currentAction() : String
      {
         return this._currentAction;
      }
      
      public function setActionRelative(_arg_1:Object) : void
      {
         this._actionRelative = _arg_1;
      }
      
      public function get popupPos() : Point
      {
         if(this["_popPos"])
         {
            return new Point(this["_popPos"].x * scaleX,this["_popPos"].y);
         }
         return null;
      }
      
      public function get popupDir() : Point
      {
         if(this["_popDir"])
         {
            return new Point(this["_popDir"].x,this["_popDir"].y);
         }
         return null;
      }
      
      public function set direction(_arg_1:String) : void
      {
         if(ActionMovie.LEFT == _arg_1)
         {
            scaleX = 1;
         }
         else if(ActionMovie.RIGHT == _arg_1)
         {
            scaleX = -1;
         }
      }
      
      public function get direction() : String
      {
         if(scaleX > 0)
         {
            return ActionMovie.LEFT;
         }
         return ActionMovie.RIGHT;
      }
      
      public function setActionMapping(_arg_1:String, _arg_2:String) : void
      {
         if(_arg_1.length <= 0)
         {
            return;
         }
         this.labelMapping[_arg_1] = _arg_2;
      }
      
      private function stopMovieClip(_arg_1:MovieClip) : void
      {
         var _local_2:int = 0;
         if(_arg_1)
         {
            _arg_1.gotoAndStop(1);
            if(_arg_1.numChildren > 0)
            {
               _local_2 = 0;
               while(_local_2 < _arg_1.numChildren)
               {
                  this.stopMovieClip(_arg_1.getChildAt(_local_2) as MovieClip);
                  _local_2++;
               }
            }
         }
      }
      
      override public function gotoAndStop(_arg_1:Object, _arg_2:String = null) : void
      {
         var _local_3:FrameLabel = null;
         if(_arg_1 is String)
         {
            for each(_local_3 in currentLabels)
            {
               if(_local_3.name == _arg_1)
               {
                  super.gotoAndStop(_arg_1);
                  return;
               }
            }
         }
         else
         {
            super.gotoAndStop(_arg_1);
         }
      }
      
      protected function endAction() : void
      {
         dispatchEvent(new ActionMovieEvent("end"));
      }
      
      protected function startAction() : void
      {
         dispatchEvent(new ActionMovieEvent("start"));
      }
      
      protected function send(_arg_1:String) : void
      {
         dispatchEvent(new ActionMovieEvent(_arg_1));
      }
      
      protected function sendCommand(_arg_1:String, _arg_2:Object = null) : void
      {
         dispatchEvent(new ActionMovieEvent(_arg_1,_arg_2));
      }
      
      override public function gotoAndPlay(_arg_1:Object, _arg_2:String = null) : void
      {
         this.doAction(String(_arg_1));
      }
      
      public function MCGotoAndPlay(_arg_1:Object) : void
      {
         super.gotoAndPlay(_arg_1);
      }
      
      private function __onActionEnd(_arg_1:ActionMovieEvent) : void
      {
         var _local_2:* = undefined;
         if(!this._actionRelative)
         {
            return;
         }
         if(!this._actionRelative[this._currentAction])
         {
            this.doAction(DEFAULT_ACTION);
            return;
         }
         if(this._actionRelative[this._currentAction] is Function)
         {
            _local_2 = this._actionRelative;
            _local_2[this._currentAction]();
         }
         else
         {
            this.doAction(this._actionRelative[this._currentAction]);
         }
      }
      
      public function get versionTag() : String
      {
         return "road.game.resource.ActionMovie version:1.02";
      }
      
      public function doSomethingSpecial() : void
      {
      }
      
      public function dispose() : void
      {
         this._soundControl.volume = 0;
         removeEventListener(Event.ENTER_FRAME,this.loop);
         this.stopMovieClip(this);
         stop();
         this._soundControl = null;
         this._labelLastFrames = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         this._callBacks = null;
      }
      
      public function mute() : void
      {
         this._soundControl.volume = 0;
         this._isMute = true;
      }
   }
}
