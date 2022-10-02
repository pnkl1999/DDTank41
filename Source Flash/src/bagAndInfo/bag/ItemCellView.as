package bagAndInfo.bag
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.ItemEvent;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import game.GameManager;
   
   [Event(name="itemClick",type="tank.view.items.ItemEvent")]
   [Event(name="itemOver",type="tank.view.items.ItemEvent")]
   [Event(name="itemOut",type="tank.view.items.ItemEvent")]
   [Event(name="itemMove",type="tank.view.items.ItemEvent")]
   public class ItemCellView extends Sprite implements Disposeable
   {
      
      public static const RIGHT_PROP:String = "rightPropView";
      
      public static const PROP_SHORT:String = "propShortCutView";
       
      
      private var _item:DisplayObject;
      
      private var _asset:Bitmap;
      
      private var _index:uint;
      
      private var _clickAble:Boolean;
      
      private var _isDisable:Boolean;
      
      private var _isGray:Boolean;
      
      private var _container:Sprite;
      
      private var _letterTip:Bitmap;
      
      private var _effectType:String;
      
      public function ItemCellView(param1:uint = 0, param2:DisplayObject = null, param3:Boolean = false, param4:String = "")
      {
         super();
         this._effectType = param4;
         this._container = new Sprite();
         addChild(this._container);
         this._index = param1;
         this._asset = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.propItemBgAssetAsset");
         this._container.addChild(this._asset);
         this._asset.x = -this._asset.width / 2;
         this._asset.y = -this._asset.height / 2;
         this._container.x = this._asset.width / 2;
         this._container.y = this._asset.height / 2;
         this.setItem(param2,false);
         this.setEffectType(param4);
      }
      
      public function setClick(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this._clickAble = param1;
         this.setGrayII(param2,param3);
      }
      
      private function setEffectType(param1:String) : void
      {
         switch(param1)
         {
            case RIGHT_PROP:
               this._letterTip = ComponentFactory.Instance.creatBitmap("asset.game.itemCell.tip" + (this.index + 1));
               break;
            case PROP_SHORT:
               this._letterTip = ComponentFactory.Instance.creatBitmap("asset.game.itemCell.letter" + (this.index + 1));
         }
         if(this._letterTip)
         {
            this._container.addChild(this._letterTip);
            this._letterTip.x = this._asset.x + this._asset.width - this._letterTip.width;
            this._letterTip.y = this._asset.y;
         }
      }
      
      override public function get height() : Number
      {
         return this._asset.height;
      }
      
      private function __click(param1:MouseEvent) : void
      {
         stage.focus = this;
         if(this._clickAble && this._item)
         {
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,this.item,this._index));
         }
      }
      
      public function mouseClick() : void
      {
         if(this._isDisable || !visible)
         {
            return;
         }
         this.__click(null);
      }
      
      private function __over(param1:Event) : void
      {
         if(!this._isGray && this._item && this._effectType != "")
         {
            this.showEffect();
         }
         if(!this._isGray && this._item)
         {
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_OVER,this.item,this._index));
         }
      }
      
      private function __out(param1:Event) : void
      {
         this.hideEffect();
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_OUT,this.item,this._index));
      }
      
      private function showEffect() : void
      {
         TweenMax.to(this,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3
            }
         });
         TweenMax.to(this._container,0.1,{
            "scaleX":1.2,
            "scaleY":1.2
         });
      }
      
      private function hideEffect() : void
      {
         TweenMax.killChildTweensOf(this.parent);
         this.filters = null;
         this._container.scaleX = 1;
         this._container.scaleY = 1;
      }
      
      private function __effectEnd() : void
      {
      }
      
      private function __move(param1:MouseEvent) : void
      {
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_MOVE,this.item,this._index));
      }
      
      public function get item() : DisplayObject
      {
         return this._item;
      }
      
      public function setItem(param1:DisplayObject, param2:Boolean) : void
      {
         var _loc3_:Sprite = null;
         _loc3_ = null;
         if(this._item)
         {
            this.removeEvent();
            ObjectUtils.disposeObject(this._item);
         }
         this._item = param1;
         if(this._item)
         {
            mouseEnabled = true;
            buttonMode = true;
            this.addEvent();
            _loc3_ = new Sprite();
            this._container.addChild(_loc3_);
            _loc3_.addChild(this._item);
            if(this._letterTip)
            {
               this._container.swapChildren(_loc3_,this._letterTip);
            }
            _loc3_.x = -20;
            _loc3_.y = -20;
            if(this._item is PropItemView)
            {
               this.setGrayII(param2,PropItemView(this._item).isExist);
            }
            else
            {
               this.setGrayII(param2,true);
            }
         }
         else
         {
            buttonMode = false;
            mouseEnabled = false;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
         this.item.addEventListener(PropItemView.OVER,this.__over);
         this.item.addEventListener(PropItemView.OUT,this.__out);
         addEventListener(MouseEvent.MOUSE_MOVE,this.__move);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__click);
         if(this.item)
         {
            this.item.removeEventListener(PropItemView.OVER,this.__over);
            this.item.removeEventListener(PropItemView.OUT,this.__out);
         }
         removeEventListener(MouseEvent.MOUSE_MOVE,this.__move);
      }
      
      public function seleted(param1:Boolean) : void
      {
      }
      
      public function disable() : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isAttacking)
         {
            this.removeEvent();
            this._isDisable = true;
            this.setGrayII(false,false);
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function setBackgroundVisible(param1:Boolean) : void
      {
         this._asset.alpha = !!param1 ? Number(Number(1)) : Number(Number(0));
      }
      
      public function setGrayII(param1:Boolean, param2:Boolean) : void
      {
         if(this.item)
         {
            this._isGray = param1;
            if(!param1 && param2)
            {
               if(this._isDisable)
               {
                  this.addEvent();
                  this._isDisable = false;
               }
               this.item.filters = null;
            }
            else
            {
               this.hideEffect();
               this.item.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._asset)
         {
            if(this._asset.parent)
            {
               this._asset.parent.removeChild(this._asset);
            }
            if(this._asset.bitmapData)
            {
               this._asset.bitmapData.dispose();
            }
         }
         if(this._letterTip)
         {
            ObjectUtils.disposeObject(this._letterTip);
         }
         this._letterTip = null;
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         this._asset = null;
         ObjectUtils.disposeObject(this._item);
         this._item = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
