package bagAndInfo.bag
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class KeyDefaultSetPanel extends Sprite
   {
       
      
      private var _bg:Bitmap;
      
      private var alphaClickArea:Sprite;
      
      private var _icon:Array;
      
      public var selectedItemID:int = 0;
      
      public function KeyDefaultSetPanel()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:KeySetItem = null;
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.KeySet.KeyTL");
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.KeySet.KeyRect");
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeToStage);
         this.alphaClickArea = new Sprite();
         this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.keySetBGAsset");
         addChild(this._bg);
         this._icon = [];
         var _loc3_:Array = SharedManager.KEY_SET_ABLE;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = ItemManager.Instance.getTemplateById(_loc3_[_loc4_]);
            if(_loc5_)
            {
               _loc6_ = new KeySetItem(_loc3_[_loc4_],0,_loc3_[_loc4_],PropItemView.createView(_loc5_.Pic,40,40));
               _loc6_.addEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               _loc6_.x = _loc1_.x + (_loc4_ < 4 ? _loc4_ * _loc2_.x : (_loc4_ - 4) * _loc2_.x);
               _loc6_.y = _loc1_.y + (_loc4_ < 4 ? 0 : Math.floor(_loc4_ / 4) * _loc2_.y);
               _loc6_.setClick(true,false,true);
               _loc6_.width = 40;
               _loc6_.height = 40;
               _loc6_.setBackgroundVisible(false);
               addChild(_loc6_);
               this._icon.push(_loc6_);
            }
            _loc4_++;
         }
      }
      
      private function __addToStage(param1:Event) : void
      {
         this.alphaClickArea.graphics.beginFill(16711935,0);
         this.alphaClickArea.graphics.drawRect(-3000,-3000,6000,6000);
         addChildAt(this.alphaClickArea,0);
         this.alphaClickArea.addEventListener(MouseEvent.CLICK,this.clickHide);
      }
      
      private function __removeToStage(param1:Event) : void
      {
         this.alphaClickArea.graphics.clear();
         this.alphaClickArea.removeEventListener(MouseEvent.CLICK,this.clickHide);
      }
      
      private function clickHide(param1:MouseEvent) : void
      {
         this.hide();
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:KeySetItem = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.__removeToStage);
         while(this._icon.length > 0)
         {
            _loc1_ = this._icon.shift() as KeySetItem;
            if(_loc1_)
            {
               _loc1_.removeEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               _loc1_.dispose();
            }
            _loc1_ = null;
         }
         this._icon = null;
         if(this.alphaClickArea)
         {
            this.alphaClickArea.removeEventListener(MouseEvent.CLICK,this.clickHide);
            this.alphaClickArea.graphics.clear();
            if(this.alphaClickArea.parent)
            {
               this.alphaClickArea.parent.removeChild(this.alphaClickArea);
            }
         }
         this.alphaClickArea = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function onItemClick(param1:ItemEvent) : void
      {
         SoundManager.instance.play("008");
         this.selectedItemID = param1.index;
         this.hide();
         dispatchEvent(new Event(Event.SELECT));
      }
   }
}
