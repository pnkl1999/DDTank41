package character
{
   import character.action.ActionSet;
   import character.action.BaseAction;
   import character.action.ComplexBitmapAction;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   
   public class ComplexBitmapCharacter extends ComplexItem implements ICharacter
   {
       
      
      protected var _assets:Dictionary;
      
      protected var _actionSet:ActionSet;
      
      protected var _currentAction:ComplexBitmapAction;
      
      protected var _label:String = "";
      
      protected var _autoStop:Boolean;
      
      protected var _bitmapRendItems:Vector.<FrameByFrameItem>;
      
      private var _registerPoint:Point;
      
      private var _rect:Rectangle;
      
      protected var _soundEnabled:Boolean = false;
      
      public function ComplexBitmapCharacter(assets:Dictionary, $description:XML = null, label:String = "", $width:Number = 0, $height:Number = 0, $rendmode:String = "original", autoStop:Boolean = false)
      {
         this._registerPoint = new Point(0,0);
         this._bitmapRendItems = new Vector.<FrameByFrameItem>();
         this._assets = assets;
         this._actionSet = new ActionSet();
         if($description)
         {
            $width = int($description.@width);
            $height = int($description.@height);
         }
         this._autoStop = autoStop;
         super($width,$height,$rendmode,"auto",true);
         _type = CharacterType.COMPLEX_BITMAP_TYPE;
         if($description)
         {
            this.description = $description;
         }
         this._label = label;
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
      
      public function set description(des:XML) : void
      {
         var action:XML = null;
         var r:String = null;
         var ar:Array = null;
         var s:XMLList = null;
         var st:Vector.<FrameByFrameItem> = null;
         var i:int = 0;
         var a:ComplexBitmapAction = null;
         var t:XML = null;
         var asset:BitmapRendItem = null;
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
            s = action.asset;
            st = new Vector.<FrameByFrameItem>();
            for(i = 0; i < s.length(); i++)
            {
               t = s[i];
               asset = t.@frames == "" ? new FrameByFrameItem(t.@width,t.@height,this._assets[String(t.@resource)]) : new CrossFrameItem(t.@width,t.@height,this._assets[String(t.@resource)],CharacterUtils.creatFrames(t.@frames));
               FrameByFrameItem(asset).sourceName = String(t.@resource);
               asset.name = t.@name;
               if(t.hasOwnProperty("@x"))
               {
                  asset.x = t.@x;
               }
               if(t.hasOwnProperty("@y"))
               {
                  asset.y = t.@y;
               }
               if(t.hasOwnProperty("@points"))
               {
                  FrameByFrameItem(asset).moveInfo = CharacterUtils.creatPoints(t.@points);
               }
               st.push(asset);
               this._bitmapRendItems.push(asset);
            }
            a = new ComplexBitmapAction(st,action.@name,action.@next,int(action.@priority));
            a.sound = action.@sound;
            a.endStop = String(action.@endStop) == "true";
            a.sound = String(action.@sound);
            this._actionSet.addAction(a);
         }
         if(this._actionSet.actions.length > 0)
         {
            this.currentAction = this._actionSet.currentAction as ComplexBitmapAction;
         }
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
      
      private function set _1408207997assets(value:Dictionary) : void
      {
         this._assets = value;
      }
      
      public function get assets() : Dictionary
      {
         return this._assets;
      }
      
      public function get actions() : Array
      {
         return this._actionSet.actions;
      }
      
      public function addAction(action:BaseAction) : void
      {
         if(action is ComplexBitmapAction)
         {
            this._actionSet.addAction(action);
            if(this._currentAction == null)
            {
               this.currentAction = action as ComplexBitmapAction;
            }
            dispatchEvent(new CharacterEvent(CharacterEvent.ADD_ACTION,action));
            return;
         }
         throw new Error("ComplexBitmapCharacter\'s action must be ComplexBitmapAction");
      }
      
      public function doAction(action:String) : void
      {
         var item:FrameByFrameItem = null;
         play();
         var a:ComplexBitmapAction = this._actionSet.getAction(action) as ComplexBitmapAction;
         if(a)
         {
            if(this._currentAction == null)
            {
               this.currentAction = a;
            }
            else if(a.priority >= this._currentAction.priority)
            {
               for each(item in this._currentAction.assets)
               {
                  item.stop();
                  removeItem(item);
               }
               this._currentAction.reset();
               this.currentAction = a;
            }
         }
      }
      
      protected function set currentAction(action:ComplexBitmapAction) : void
      {
         var item1:FrameByFrameItem = null;
         action.reset();
         this._currentAction = action;
         this._autoStop = this._currentAction.endStop;
         for each(item1 in this._currentAction.assets)
         {
            item1.reset();
            item1.play();
            addItem(item1);
         }
         if(this._currentAction.sound != "" && this._soundEnabled)
         {
            CharacterSoundManager.instance.play(this._currentAction.sound);
         }
      }
      
      override protected function update() : void
      {
         super.update();
         if(this._currentAction == null)
         {
            return;
         }
         this._currentAction.update();
         if(this._currentAction.isEnd)
         {
            if(this._autoStop)
            {
               stop();
            }
            else
            {
               this.doAction(this._currentAction.nextAction);
            }
         }
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
         result.@width = _itemWidth;
         result.@height = _itemHeight;
         result.@label = this._label;
         result.@registerX = this._registerPoint.x;
         result.@registerY = this._registerPoint.y;
         result.@rect = [this.rect.x,this.rect.y,this.rect.width,this.rect.height].join("|");
         result.appendChild(this._actionSet.toXml());
         return result;
      }
      
      public function removeAction(action:String) : void
      {
         var item:FrameByFrameItem = null;
         var act:BaseAction = this._actionSet.getAction(action);
         if(act && this._currentAction == act)
         {
            for each(item in this._currentAction.assets)
            {
               item.stop();
               removeItem(item);
            }
            this._currentAction = null;
         }
         this._actionSet.removeAction(action);
         dispatchEvent(new CharacterEvent(CharacterEvent.REMOVE_ACTION));
      }
      
      override public function dispose() : void
      {
         var item:FrameByFrameItem = null;
         super.dispose();
         for each(item in this._bitmapRendItems)
         {
            item.dispose();
         }
         this._bitmapRendItems = null;
         this._assets = null;
         this._actionSet.dispose();
         this._actionSet = null;
         this._currentAction = null;
      }
      
      [Bindable(event="propertyChange")]
      public function set assets(param1:Dictionary) : void
      {
         var _loc2_:Object = this.assets;
         if(_loc2_ !== param1)
         {
            this._1408207997assets = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"assets",_loc2_,param1));
            }
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
   }
}
