package character
{
   import character.action.ActionSet;
   import character.action.BaseAction;
   import character.action.MovieClipAction;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import mx.events.PropertyChangeEvent;
   
   public class MovieClipCharacter extends Sprite implements ICharacter
   {
       
      
      private var _assets:Dictionary;
      
      private var _actionSet:ActionSet;
      
      private var _currentAction:MovieClipAction;
      
      private var _label:String = "";
      
      private var _autoStop:Boolean;
      
      private var _isPlaying:Boolean = true;
      
      private var _type:int;
      
      private var _registerPoint:Point;
      
      private var _rect:Rectangle;
      
      private var _realRender:Boolean;
      
      protected var _soundEnabled:Boolean = false;
      
      public function MovieClipCharacter(assets:Dictionary, $description:XML = null, label:String = "", autoStop:Boolean = false)
      {
         this._registerPoint = new Point(0,0);
         super();
         this._type = CharacterType.MOVIECLIP_TYPE;
         this._actionSet = new ActionSet();
         this._assets = assets;
         this._autoStop = autoStop;
         if($description)
         {
            this.description = $description;
         }
         this._label = label;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function get soundEnabled() : Boolean
      {
         return this._soundEnabled;
      }
      
      private function set _164832462soundEnabled(value:Boolean) : void
      {
         if(this._soundEnabled == value)
         {
            return;
         }
         this._soundEnabled = value;
      }
      
      public function getActionFrames(action:String) : int
      {
         var act:BaseAction = this._actionSet.getAction(action);
         if(act)
         {
            return act.len;
         }
         return 0;
      }
      
      private function onEnterFrame(event:Event) : void
      {
         if(this._isPlaying)
         {
            if(this._currentAction)
            {
               if(this._currentAction.isEnd)
               {
                  if(this._autoStop)
                  {
                     MovieClip(this._currentAction.asset).stop();
                  }
                  else
                  {
                     this.doAction(this._currentAction.nextAction);
                  }
               }
            }
         }
         else if(this._currentAction)
         {
            MovieClip(this._currentAction.asset).stop();
         }
      }
      
      public function get actions() : Array
      {
         return this._actionSet.actions;
      }
      
      public function set description(des:XML) : void
      {
         var action:XML = null;
         var r:String = null;
         var ar:Array = null;
         var resource:MovieClip = null;
         var a:MovieClipAction = null;
         var cls:Class = null;
         this._actionSet = new ActionSet();
         var actions:XMLList = des..action;
         this._label = des.@label;
         if(des.hasOwnProperty("@registerX"))
         {
            this._registerPoint.x = des.@registerX;
         }
         if(des.hasOwnProperty("@registerY"))
         {
            this._registerPoint.y = des.@registerY;
         }
         if(des.hasOwnProperty("@rect"))
         {
            r = String(des.@rect);
            this._rect = new Rectangle();
            ar = r.split("|");
            this._rect.x = ar[0];
            this._rect.y = ar[1];
            this._rect.width = ar[2];
            this._rect.height = ar[3];
         }
         for each(action in actions)
         {
            if(this._assets && this._assets[String(action.@asset)])
            {
               resource = this._assets[String(action.@asset)];
            }
            else
            {
               try
               {
                  cls = getDefinitionByName(String(action.@asset)) as Class;
                  resource = new cls() as MovieClip;
                  if(this._assets == null)
                  {
                     this._assets = new Dictionary();
                  }
                  this._assets[String(action.@resource)] = resource;
               }
               catch(e:Error)
               {
                  trace("not found resource when creat movieClipCharacter");
               }
            }
            a = new MovieClipAction(resource,action.@name,action.@next,action.@priority);
            a.endStop = String(action.@endStop) == "true";
            a.sound = action.@sound;
            this._actionSet.addAction(a);
         }
         this.currentAction = this._actionSet.currentAction as MovieClipAction;
      }
      
      private function set currentAction(action:MovieClipAction) : void
      {
         if(action == null)
         {
            return;
         }
         this._currentAction = action;
         this._autoStop = this._currentAction.endStop;
         var movie:MovieClip = this._currentAction.asset as MovieClip;
         movie.gotoAndPlay(1);
         addChild(movie);
         if(this._currentAction.sound != "" && this._soundEnabled)
         {
            CharacterSoundManager.instance.play(this._currentAction.sound);
         }
      }
      
      public function get itemWidth() : Number
      {
         return width;
      }
      
      public function get itemHeight() : Number
      {
         return height;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      private function set _102727412label(value:String) : void
      {
         this._label = value;
      }
      
      public function hasAction(action:String) : Boolean
      {
         return this._actionSet.getAction(action) != null;
      }
      
      public function doAction(action:String) : void
      {
         var movie:MovieClip = null;
         var a:MovieClipAction = this._actionSet.getAction(action) as MovieClipAction;
         if(a)
         {
            if(this._currentAction != null)
            {
               if(a.priority >= this._currentAction.priority)
               {
                  movie = this._currentAction.asset as MovieClip;
                  movie.gotoAndStop(1);
                  if(contains(movie))
                  {
                     removeChild(movie);
                  }
                  this._currentAction.reset();
                  this.currentAction = a;
               }
            }
            else
            {
               this.currentAction = a;
            }
         }
      }
      
      public function addAction(action:BaseAction) : void
      {
         this._actionSet.addAction(action);
         dispatchEvent(new CharacterEvent(CharacterEvent.ADD_ACTION,action));
      }
      
      public function toXml() : XML
      {
         var result:XML = <character></character>;
         result.@type = this._type;
         result.@label = this._label;
         result.@registerX = this._registerPoint.x;
         result.@registerY = this._registerPoint.y;
         result.@rect = [this.rect.x,this.rect.y,this.rect.width,this.rect.height].join("|");
         result.appendChild(this._actionSet.toXml());
         return result;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function removeAction(action:String) : void
      {
         var movie:MovieClip = null;
         var act:BaseAction = this._actionSet.getAction(action);
         if(this._currentAction == act)
         {
            movie = this._currentAction.asset as MovieClip;
            movie.gotoAndStop(1);
            if(contains(movie))
            {
               removeChild(movie);
            }
            this._currentAction = null;
         }
         this._actionSet.removeAction(action);
         dispatchEvent(new CharacterEvent(CharacterEvent.REMOVE_ACTION));
      }
      
      public function get registerPoint() : Point
      {
         return this._registerPoint;
      }
      
      public function get rect() : Rectangle
      {
         if(this._rect == null)
         {
            this._rect = new Rectangle(0,0,this.itemWidth,this.itemHeight);
         }
         return this._rect;
      }
      
      public function dispose() : void
      {
         var mc:MovieClip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         for each(mc in this._assets)
         {
            if(mc.parent)
            {
               mc.parent.removeChild(mc);
            }
            mc.stop();
         }
         this._actionSet.dispose();
         this._actionSet = null;
         this._currentAction = null;
      }
      
      public function get assets() : Dictionary
      {
         return this._assets;
      }
      
      public function get realRender() : Boolean
      {
         return this._realRender;
      }
      
      private function set _2032707372realRender(value:Boolean) : void
      {
         if(this._realRender == value)
         {
            return;
         }
         this._realRender = value;
         if(this._realRender)
         {
            if(this._currentAction && this._currentAction.asset)
            {
               addChild(this._currentAction.asset);
            }
         }
         else if(this._currentAction && this._currentAction.asset && contains(this._currentAction.asset))
         {
            removeChild(this._currentAction.asset);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set soundEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.soundEnabled;
         if(_loc2_ !== param1)
         {
            this._164832462soundEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"soundEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set label(param1:String) : void
      {
         var _loc2_:Object = this.label;
         if(_loc2_ !== param1)
         {
            this._102727412label = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set realRender(param1:Boolean) : void
      {
         var _loc2_:Object = this.realRender;
         if(_loc2_ !== param1)
         {
            this._2032707372realRender = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"realRender",_loc2_,param1));
            }
         }
      }
   }
}
