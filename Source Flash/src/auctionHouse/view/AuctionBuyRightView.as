package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class AuctionBuyRightView extends Sprite implements Disposeable
   {
       
      
      private var panel:ScrollPanel;
      
      private var _strips:Vector.<AuctionBuyStripView>;
      
      private var _selectStrip:AuctionBuyStripView;
      
      private var _list:VBox;
      
      public function AuctionBuyRightView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.buyBG1");
         addChild(_loc1_);
         var _loc2_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.buyBG2");
         addChild(_loc2_);
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topLeft");
         addChild(_loc3_);
         _loc3_.x = 10;
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topRight");
         addChild(_loc4_);
         _loc4_.x = 935;
         var _loc5_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topLb1");
         addChild(_loc5_);
         _loc5_.x = 69;
         var _loc6_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topLb2");
         addChild(_loc6_);
         _loc6_.x = 289;
         var _loc7_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topLb3");
         addChild(_loc7_);
         _loc7_.x = 362;
         var _loc8_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topLb4");
         addChild(_loc8_);
         _loc8_.x = 451;
         var _loc9_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topLb5");
         addChild(_loc9_);
         _loc9_.x = 600;
         var _loc10_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topLb6");
         addChild(_loc10_);
         _loc10_.x = 757;
         this._list = new VBox();
         this._strips = new Vector.<AuctionBuyStripView>();
         this.panel = ComponentFactory.Instance.creat("auctionHouse.BrowseBuyScrollpanel");
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.setView(this._list);
         addChild(this.panel);
         this.invalidatePanel();
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
	  internal function addAuction(param1:AuctionGoodsInfo) : void
      {
         var _loc2_:AuctionBuyStripView = new AuctionBuyStripView();
         _loc2_.info = param1;
         _loc2_.addEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
         this._strips.push(_loc2_);
         this._list.addChild(_loc2_);
         this.invalidatePanel();
      }
      
      private function invalidatePanel() : void
      {
         this.panel.vScrollProxy = this._list.height > this.panel.height ? int(int(ScrollPanel.ON)) : int(int(ScrollPanel.OFF));
         this.panel.invalidateViewport();
      }
      
	  internal function clearList() : void
      {
         this._clearItems();
         this._selectStrip = null;
         this._strips = new Vector.<AuctionBuyStripView>();
      }
      
      private function _clearItems() : void
      {
         this._strips.splice(0,this._strips.length);
         this._list.disposeAllChildren();
         this._list.height = 0;
         this.invalidatePanel();
      }
      
	  internal function getSelectInfo() : AuctionGoodsInfo
      {
         if(this._selectStrip)
         {
            return this._selectStrip.info;
         }
         return null;
      }
      
	  internal function deleteItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._strips.length)
         {
            if(this._selectStrip == this._strips[_loc1_])
            {
               this._selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
               this._selectStrip.dispose();
               this._strips.splice(_loc1_,1);
               this._selectStrip = null;
               break;
            }
            _loc1_++;
         }
      }
      
	  internal function clearSelectStrip() : void
      {
         var _loc1_:AuctionBuyStripView = null;
         for each(_loc1_ in this._strips)
         {
            if(this._selectStrip == _loc1_)
            {
               this._selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,this.__selectStrip);
               this._selectStrip.clearSelectStrip();
               this._selectStrip = null;
               break;
            }
         }
      }
      
	  internal function updateAuction(param1:AuctionGoodsInfo) : void
      {
         var _loc2_:AuctionBuyStripView = null;
         for each(_loc2_ in this._strips)
         {
            if(_loc2_.info.AuctionID == param1.AuctionID)
            {
               param1.BagItemInfo = _loc2_.info.BagItemInfo;
               _loc2_.info = param1;
               break;
            }
         }
      }
      
      private function __selectStrip(param1:AuctionHouseEvent) : void
      {
         if(this._selectStrip)
         {
            this._selectStrip.isSelect = false;
         }
         var _loc2_:AuctionBuyStripView = param1.target as AuctionBuyStripView;
         _loc2_.isSelect = true;
         this._selectStrip = _loc2_;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      public function dispose() : void
      {
         var _loc1_:AuctionBuyStripView = null;
         this.removeEvent();
         if(this.panel)
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(this._selectStrip)
         {
            ObjectUtils.disposeObject(this._selectStrip);
         }
         this._selectStrip = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         for each(_loc1_ in this._strips)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
            _loc1_ = null;
         }
         this._strips = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
