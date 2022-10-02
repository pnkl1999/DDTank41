package com.pickgliss.ui.controls.container
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   
   public class BoxContainer extends Component
   {
      
      public static const P_childRefresh:String = "childRefresh";
      
      public static const P_childResize:String = "childResize";
      
      public static const P_isReverAdd:String = "isReverAdd";
      
      public static const P_spacing:String = "spacing";
      
      public static const P_strictSize:String = "strictSize";
      
      public static const P_autoSize:String = "autoSize";
      
      public static const LEFT_OR_TOP:int = 0;
      
      public static const RIGHT_OR_BOTTOM:int = 1;
      
      public static const CENTER:int = 2;
       
      
      protected var _childrenList:Vector.<DisplayObject>;
      
      protected var _isReverAdd:Boolean;
      
      protected var _spacing:Number = 0;
      
      protected var _strictSize:Number = -1;
      
      protected var _autoSize:int = 0;
      
      public function BoxContainer()
      {
         this._childrenList = new Vector.<DisplayObject>();
         super();
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         if(this._childrenList.indexOf(param1) > -1)
         {
            return param1;
         }
         if(!this._isReverAdd)
         {
            this._childrenList.push(super.addChild(param1));
         }
         else
         {
            this._childrenList.push(super.addChildAt(param1,0));
         }
         param1.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onResize);
         onPropertiesChanged(P_childRefresh);
         return param1;
      }
      
      override public function dispose() : void
      {
         this.disposeAllChildren();
         this._childrenList = null;
         super.dispose();
      }
      
      public function disposeAllChildren() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            _loc2_.removeEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onResize);
            _loc1_++;
         }
         ObjectUtils.disposeAllChildren(this);
      }
      
      public function set isReverAdd(param1:Boolean) : void
      {
         if(this._isReverAdd == param1)
         {
            return;
         }
         this._isReverAdd = param1;
         onPropertiesChanged(P_isReverAdd);
      }
      
      public function refreshChildPos() : void
      {
         onPropertiesChanged(P_childResize);
      }
      
      public function removeAllChild() : void
      {
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         this._childrenList.length = 0;
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         param1.removeEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onResize);
         this._childrenList.splice(this._childrenList.indexOf(param1),1);
         super.removeChild(param1);
         onPropertiesChanged(P_childRefresh);
         return param1;
      }
      
      public function reverChildren() : void
      {
         var _loc1_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         while(numChildren > 0)
         {
            _loc1_.push(removeChildAt(0));
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.addChild(_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function set autoSize(param1:int) : void
      {
         if(this._autoSize == param1)
         {
            return;
         }
         this._autoSize = param1;
         onPropertiesChanged(P_autoSize);
      }
      
      public function get spacing() : Number
      {
         return this._spacing;
      }
      
      public function set spacing(param1:Number) : void
      {
         if(this._spacing == param1)
         {
            return;
         }
         this._spacing = param1;
         onPropertiesChanged(P_spacing);
      }
      
      public function set strictSize(param1:Number) : void
      {
         if(this._strictSize == param1)
         {
            return;
         }
         this._strictSize = param1;
         onPropertiesChanged(P_strictSize);
      }
      
      public function arrange() : void
      {
      }
      
      protected function get isStrictSize() : Boolean
      {
         return this._strictSize > 0;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         this.arrange();
      }
      
      private function __onResize(param1:ComponentEvent) : void
      {
         if(param1.changedProperties[Component.P_height] || param1.changedProperties[Component.P_width])
         {
            onPropertiesChanged(P_childRefresh);
         }
      }
   }
}
