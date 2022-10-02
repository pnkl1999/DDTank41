package com.pickgliss.ui.core
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.DisplayUtils;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SpriteLayer extends Sprite
   {
       
      
      private var _blackGoundList:Vector.<DisplayObject>;
      
      private var _alphaGoundList:Vector.<DisplayObject>;
      
      private var _blackGound:Sprite;
      
      private var _alphaGound:Sprite;
      
      private var _autoClickTotop:Boolean;
      
      public function SpriteLayer(param1:Boolean = false)
      {
         this.init();
         super();
         mouseEnabled = param1;
      }
      
      private function init() : void
      {
         this._blackGoundList = new Vector.<DisplayObject>();
         this._alphaGoundList = new Vector.<DisplayObject>();
      }
      
      public function addTolayer(param1:DisplayObject, param2:int, param3:Boolean) : void
      {
         if(param2 == LayerManager.BLCAK_BLOCKGOUND)
         {
            if(this._blackGoundList.indexOf(param1) != -1)
            {
               this._blackGoundList.splice(this._blackGoundList.indexOf(param1),1);
            }
            this._blackGoundList.push(param1);
         }
         else if(param2 == LayerManager.ALPHA_BLOCKGOUND)
         {
            if(this._alphaGoundList.indexOf(param1) != -1)
            {
               this._alphaGoundList.splice(this._alphaGoundList.indexOf(param1),1);
            }
            this._alphaGoundList.push(param1);
         }
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.__onChildRemoveFromStage);
         if(param3)
         {
            param1.addEventListener(Event.REMOVED_FROM_STAGE,this.__onFocusChange);
         }
         if(this._autoClickTotop)
         {
            param1.addEventListener(MouseEvent.MOUSE_DOWN,this.__onClickToTop);
         }
         addChild(param1);
         this.arrangeBlockGound();
         if(param3)
         {
            this.focusTopLayerDisplay();
         }
      }
      
      private function __onClickToTop(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         addChild(_loc2_);
         this.focusTopLayerDisplay();
      }
      
      private function __onFocusChange(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,this.__onFocusChange);
         this.focusTopLayerDisplay(_loc2_);
      }
      
      private function __onChildRemoveFromStage(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,this.__onChildRemoveFromStage);
         _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onClickToTop);
         if(this._blackGoundList.indexOf(_loc2_) != -1)
         {
            this._blackGoundList.splice(this._blackGoundList.indexOf(_loc2_),1);
         }
         if(this._alphaGoundList.indexOf(_loc2_) != -1)
         {
            this._alphaGoundList.splice(this._alphaGoundList.indexOf(_loc2_),1);
         }
         this.arrangeBlockGound();
      }
      
      private function arrangeBlockGound() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         if(this.blackGound.parent)
         {
            this.blackGound.parent.removeChild(this.blackGound);
         }
         if(this.alphaGound.parent)
         {
            this.alphaGound.parent.removeChild(this.alphaGound);
         }
         if(this._blackGoundList.length > 0)
         {
            _loc1_ = this._blackGoundList[this._blackGoundList.length - 1];
            _loc2_ = getChildIndex(_loc1_);
            addChildAt(this.blackGound,_loc2_);
         }
         if(this._alphaGoundList.length > 0)
         {
            _loc1_ = this._alphaGoundList[this._alphaGoundList.length - 1];
            _loc2_ = getChildIndex(_loc1_);
            addChildAt(this.alphaGound,_loc2_);
         }
      }
      
      private function focusTopLayerDisplay(param1:DisplayObject = null) : void
      {
         var _loc2_:InteractiveObject = null;
         var _loc4_:DisplayObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_);
            if(_loc4_ != param1)
            {
               _loc2_ = _loc4_ as InteractiveObject;
            }
            _loc3_++;
         }
         if(!DisplayUtils.isTargetOrContain(StageReferance.stage.focus,_loc2_))
         {
            StageReferance.stage.focus = _loc2_;
         }
      }
      
      public function get backGroundInParent() : Boolean
      {
         if(this._blackGoundList.length > 0 || this._alphaGoundList.length > 0)
         {
            return true;
         }
         return false;
      }
      
      private function get blackGound() : Sprite
      {
         if(this._blackGound == null)
         {
            this._blackGound = new Sprite();
            this._blackGound.graphics.beginFill(0,0.4);
            this._blackGound.graphics.drawRect(-500,-200,2000,1000);
            this._blackGound.graphics.endFill();
            this._blackGound.addEventListener(MouseEvent.MOUSE_DOWN,this.__onBlackGoundMouseDown);
         }
         return this._blackGound;
      }
      
      private function __onBlackGoundMouseDown(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         StageReferance.stage.focus = this._blackGoundList[this._blackGoundList.length - 1] as InteractiveObject;
      }
      
      private function get alphaGound() : Sprite
      {
         if(this._alphaGound == null)
         {
            this._alphaGound = new Sprite();
            this._alphaGound.graphics.beginFill(0,0.001);
            this._alphaGound.graphics.drawRect(-500,-200,2000,1000);
            this._alphaGound.graphics.endFill();
            this._alphaGound.addEventListener(MouseEvent.MOUSE_DOWN,this.__onAlphaGoundDownClicked);
            this._alphaGound.addEventListener(MouseEvent.MOUSE_UP,this.__onAlphaGoundUpClicked);
         }
         return this._alphaGound;
      }
      
      private function __onAlphaGoundDownClicked(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = null;
         _loc2_ = null;
         _loc2_ = this._alphaGoundList[this._alphaGoundList.length - 1];
         _loc2_.filters = ComponentFactory.Instance.creatFilters(ComponentSetting.ALPHA_LAYER_FILTER);
         StageReferance.stage.focus = _loc2_ as InteractiveObject;
      }
      
      private function __onAlphaGoundUpClicked(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = this._alphaGoundList[this._alphaGoundList.length - 1];
         _loc2_.filters = null;
      }
      
      public function set autoClickTotop(param1:Boolean) : void
      {
         if(this._autoClickTotop == param1)
         {
            return;
         }
         this._autoClickTotop = param1;
      }
   }
}
