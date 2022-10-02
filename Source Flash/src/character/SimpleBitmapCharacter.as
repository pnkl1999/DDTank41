package character
{
   import character.action.ActionSet;
   import character.action.BaseAction;
   import character.action.SimpleFrameAction;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   
   public class SimpleBitmapCharacter extends CrossFrameItem implements ICharacter
   {
       
      
      private var _actionSet:ActionSet;
      
      private var _currentAction:SimpleFrameAction;
      
      private var _label:String = "";
      
      private var _registerPoint:Point;
      
      private var _rect:Rectangle;
      
      protected var _soundEnabled:Boolean = false;
      
      public function SimpleBitmapCharacter(source:BitmapData, $description:XML = null, label:String = "", $width:Number = 0, $height:Number = 0, $rendmode:String = "original", autoStop:Boolean = false)
      {
         this._registerPoint = new Point(0,0);
         this._actionSet = new ActionSet();
         if($description)
         {
            this.description = $description;
         }
         this._label = label;
         super($width,$height,source,null,$rendmode,autoStop);
         _type = CharacterType.SIMPLE_BITMAP_TYPE;
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
      
      public function set description(des:XML) : void
      {
         var action:XML = null;
         var r:String = null;
         var ar:Array = null;
         var a:SimpleFrameAction = null;
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
         var actions:XMLList = des..action;
         for each(action in actions)
         {
            a = new SimpleFrameAction(CharacterUtils.creatFrames(action.@frames),action.@name,action.@next,action.@priority);
            this._actionSet.addAction(a);
            a.endStop = String(action.@endStop) == "true";
            a.sound = action.@sound;
         }
         this._currentAction = this._actionSet.currentAction as SimpleFrameAction;
      }
      
      private function set _102727412label(value:String) : void
      {
         this._label = value;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function hasAction(action:String) : Boolean
      {
         return this._actionSet.getAction(action) != null;
      }
      
      public function addAction(action:BaseAction) : void
      {
         if(action is SimpleFrameAction)
         {
            this._actionSet.addAction(action);
            if(this._currentAction == null)
            {
               this._currentAction = action as SimpleFrameAction;
               this.doAction(this._currentAction.name);
            }
            return;
         }
         throw new Error("SimpleBitmapCharacter\'s action must be SimpleFrameAction");
      }
      
      public function get actions() : Array
      {
         return this._actionSet.actions;
      }
      
      public function removeAction(action:String) : void
      {
         this._actionSet.removeAction(action);
         dispatchEvent(new CharacterEvent(CharacterEvent.REMOVE_ACTION));
      }
      
      public function doAction(action:String) : void
      {
         play();
         var a:SimpleFrameAction = this._actionSet.getAction(action) as SimpleFrameAction;
         if(a == null)
         {
            return;
         }
         if(this._currentAction)
         {
            if(a.priority >= this._currentAction.priority)
            {
               this._currentAction = a;
               _frames = a.frames;
               _len = _frames.length;
               _index = 0;
               _autoStop = this._currentAction.endStop;
               if(this._currentAction.sound != "" && this._soundEnabled)
               {
                  CharacterSoundManager.instance.play(this._currentAction.sound);
               }
            }
         }
         else
         {
            this._currentAction = a;
            _frames = a.frames;
            _len = _frames.length;
            _index = 0;
            _autoStop = this._currentAction.endStop;
            if(this._currentAction.sound != "" && this._soundEnabled)
            {
               CharacterSoundManager.instance.play(this._currentAction.sound);
            }
         }
      }
      
      override protected function update() : void
      {
         if(_index >= _len - 1 && !_autoStop)
         {
            if(this._currentAction)
            {
               this.doAction(this._currentAction.nextAction);
            }
         }
         super.update();
      }
      
      public function get registerPoint() : Point
      {
         return this._registerPoint;
      }
      
      public function get rect() : Rectangle
      {
         if(this._rect == null)
         {
            this._rect = new Rectangle(0,0,_itemWidth,_itemHeight);
         }
         return this._rect;
      }
      
      override public function toXml() : XML
      {
         var result:XML = <character></character>;
         result.@type = _type;
         result.@resource = _sourceName;
         result.@width = _itemWidth;
         result.@height = _itemHeight;
         result.@label = this._label;
         result.@registerX = this._registerPoint.x;
         result.@registerY = this._registerPoint.y;
         result.@rect = [this.rect.x,this.rect.y,this.rect.width,this.rect.height].join("|");
         result.appendChild(this._actionSet.toXml());
         return result;
      }
      
      override public function dispose() : void
      {
         this._actionSet.dispose();
         this._actionSet = null;
         this._currentAction = null;
         super.dispose();
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
   }
}
