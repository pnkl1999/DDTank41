package auctionHouse.view
{
   import auctionHouse.AuctionState;
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AuctionRightView extends Sprite implements Disposeable
   {
       
      
      private var _prePage_btn:BaseButton;
      
      private var _nextPage_btn:BaseButton;
      
      public var page_txt:FilterFrameText;
      
      private var _sortBtItems:Vector.<BaseButton>;
      
      private var _sortArrowItems:Vector.<ScaleFrameImage>;
      
      private var _stripList:ListPanel;
      
      private var _state:String;
      
      private var _currentButtonIndex:uint = 0;
      
      private var _currentIsdown:Boolean = true;
      
      private var _selectStrip:StripView;
      
      private var _selectInfo:AuctionGoodsInfo;
      
      private var help_mc:Bitmap;
      
      private var _startNum:int = 0;
      
      private var _endNum:int = 0;
      
      private var _totalCount:int = 0;
      
      public function AuctionRightView()
      {
         super();
      }
      
      public function setup(param1:String = "") : void
      {
         this._state = param1;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc13_:ScaleFrameImage = null;
         this._sortBtItems = new Vector.<BaseButton>(6);
         this._sortArrowItems = new Vector.<ScaleFrameImage>(4);
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightBG1");
         addChild(_loc1_);
         var _loc2_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightBG2");
         addChild(_loc2_);
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topLeft");
         addChild(_loc3_);
         _loc3_.x = 10;
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.topRight");
         addChild(_loc4_);
         _loc4_.x = 677;
         var _loc5_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.Browse.PageCountBg");
         addChild(_loc5_);
         this.help_mc = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.Help");
         addChild(this.help_mc);
         this._prePage_btn = ComponentFactory.Instance.creat("auctionHouse.Prev_btn");
         addChild(this._prePage_btn);
         this._nextPage_btn = ComponentFactory.Instance.creat("auctionHouse.Next_btn");
         addChild(this._nextPage_btn);
         this.page_txt = ComponentFactory.Instance.creat("auctionHouse.RightPageText");
         addChild(this.page_txt);
         var _loc6_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.BidNumber");
         addChild(_loc6_);
         var _loc7_:BaseButton = ComponentFactory.Instance.creat("auctionHouse.GoodsName_btn");
         var _loc8_:BaseButton = ComponentFactory.Instance.creat("auctionHouse.RemainingTime_btn");
         var _loc9_:BaseButton = ComponentFactory.Instance.creat("auctionHouse.BidPerson_btn");
         var _loc10_:BaseButton = ComponentFactory.Instance.creat("auctionHouse.SellPerson_btn");
         var _loc11_:BaseButton = ComponentFactory.Instance.creat("auctionHouse.BidPrice_btn");
         this._sortBtItems[0] = _loc7_;
         this._sortBtItems[2] = _loc8_;
         this._sortBtItems[3] = _loc10_;
         this._sortBtItems[4] = _loc11_;
         this._sortBtItems[5] = _loc9_;
         var _loc12_:int = 0;
         while(_loc12_ < this._sortBtItems.length)
         {
            if(_loc12_ != 1)
            {
               if(_loc12_ == 3)
               {
                  if(this._state == AuctionState.BROWSE)
                  {
                     addChild(this._sortBtItems[_loc12_]);
                  }
               }
               else if(_loc12_ == 5)
               {
                  if(this._state == AuctionState.SELL)
                  {
                     addChild(this._sortBtItems[_loc12_]);
                  }
               }
               else
               {
                  addChild(this._sortBtItems[_loc12_]);
               }
            }
            _loc12_++;
         }
         this._sortArrowItems[0] = ComponentFactory.Instance.creat("auctionHouse.ArrowI");
         this._sortArrowItems[1] = ComponentFactory.Instance.creat("auctionHouse.ArrowII");
         this._sortArrowItems[2] = ComponentFactory.Instance.creat("auctionHouse.ArrowIII");
         this._sortArrowItems[3] = ComponentFactory.Instance.creat("auctionHouse.ArrowV");
         for each(_loc13_ in this._sortArrowItems)
         {
            addChild(_loc13_);
            _loc13_.visible = false;
         }
         this._stripList = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.rightListII");
         addChild(this._stripList);
         this._stripList.list.updateListView();
         this._stripList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         if(this._state == AuctionState.SELL)
         {
            this.help_mc.visible = false;
         }
         this.addStageInit();
         this._nextPage_btn.enable = false;
         this._prePage_btn.enable = false;
      }
      
      private function addEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._sortBtItems.length)
         {
            if(_loc1_ != 1)
            {
               this._sortBtItems[_loc1_].addEventListener(MouseEvent.CLICK,this.sortHandler);
            }
            _loc1_++;
         }
      }
      
      public function addStageInit() : void
      {
      }
      
      public function hideReady() : void
      {
         this._hideArrow();
      }
      
      public function addAuction(param1:AuctionGoodsInfo) : void
      {
         this._stripList.vectorListModel.append(param1);
         this._stripList.list.updateListView();
         this.help_mc.visible = false;
      }
      
      public function updateAuction(param1:AuctionGoodsInfo) : void
      {
         var _loc2_:AuctionGoodsInfo = null;
         var _loc3_:AuctionGoodsInfo = null;
         for each(_loc3_ in this._stripList.vectorListModel.elements)
         {
            if(_loc3_.AuctionID == param1.AuctionID)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(_loc2_ != null)
         {
            param1.BagItemInfo = _loc2_.BagItemInfo;
         }
         if(this._stripList.vectorListModel.indexOf(_loc2_) != -1)
         {
            this._stripList.vectorListModel.replaceAt(this._stripList.vectorListModel.indexOf(_loc2_),param1);
         }
         else
         {
            this._stripList.vectorListModel.append(param1);
         }
         this._stripList.list.updateListView();
      }
      
	  internal function getStripCount() : int
      {
         return this._stripList.vectorListModel.size();
      }
      
	  internal function setPage(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         param1 = 1 + AuctionHouseModel.SINGLE_PAGE_NUM * (param1 - 1);
         if(param1 + AuctionHouseModel.SINGLE_PAGE_NUM - 1 < param2)
         {
            _loc3_ = param1 + AuctionHouseModel.SINGLE_PAGE_NUM - 1;
         }
         else
         {
            _loc3_ = param2;
         }
         this._startNum = param1;
         this._endNum = _loc3_;
         this._totalCount = param2;
         if(param2 == 0)
         {
            if(this._stripList.vectorListModel.elements.length == 0)
            {
               this.page_txt.text = "";
            }
         }
         else
         {
            this.page_txt.text = (int(this._startNum / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString() + "/" + (int((this._totalCount - 1) / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString();
         }
         this.buttonStatus(param1,_loc3_,param2);
      }
      
      private function upPageTxt() : void
      {
         if(this._endNum < this._startNum)
         {
            this.page_txt.text = "";
         }
         else
         {
            this.page_txt.text = (int(this._startNum / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString() + "/" + (int((this._totalCount - 1) / AuctionHouseModel.SINGLE_PAGE_NUM) + 1).toString();
         }
         if(this._stripList.vectorListModel.elements.length == 0)
         {
            this.page_txt.text = "";
         }
         if(this._endNum < this._totalCount)
         {
            this._nextPage_btn.enable = true;
         }
         else
         {
            this._nextPage_btn.enable = false;
         }
      }
      
      private function buttonStatus(param1:int, param2:int, param3:int) : void
      {
         if(param1 <= 1)
         {
            this._prePage_btn.enable = false;
         }
         else
         {
            this._prePage_btn.enable = true;
         }
         if(param2 < param3)
         {
            this._nextPage_btn.enable = true;
         }
         else
         {
            this._nextPage_btn.enable = false;
         }
         this._nextPage_btn.alpha = 1;
         this._prePage_btn.alpha = 1;
      }
      
	  internal function clearList() : void
      {
         this._clearItems();
         this._selectInfo = null;
         this.page_txt.text = "";
         if(this._state == AuctionState.BROWSE)
         {
            this.help_mc.visible = true;
         }
         if(this._stripList.vectorListModel.elements.length == 0)
         {
            this.help_mc.visible = true;
         }
         else
         {
            this.help_mc.visible = false;
         }
         if(this._state == AuctionState.SELL)
         {
            this.help_mc.visible = false;
         }
      }
      
      private function _clearItems() : void
      {
         this._stripList.vectorListModel.clear();
         this._stripList.list.updateListView();
      }
      
      private function invalidatePanel() : void
      {
      }
      
	  internal function getSelectInfo() : AuctionGoodsInfo
      {
         if(this._selectInfo)
         {
            return this._selectInfo;
         }
         return null;
      }
      
	  internal function deleteItem() : void
      {
         var _loc1_:AuctionGoodsInfo = null;
         for each(_loc1_ in this._stripList.vectorListModel.elements)
         {
            if(_loc1_.AuctioneerID == this._selectInfo.AuctioneerID)
            {
               this._stripList.vectorListModel.remove(_loc1_);
               this._selectInfo = null;
               this.upPageTxt();
               break;
            }
         }
         this._stripList.list.updateListView();
      }
      
	  internal function clearSelectStrip() : void
      {
         this._stripList.vectorListModel.remove(this._selectInfo);
         this._selectInfo = null;
         this.upPageTxt();
         this._stripList.list.unSelectedAll();
         this._stripList.list.updateListView();
      }
      
	  internal function setSelectEmpty() : void
      {
         this._selectStrip.isSelect = false;
         this._selectStrip = null;
         this._selectInfo = null;
      }
      
	  internal function get sortCondition() : int
      {
         return this._currentButtonIndex;
      }
      
	  internal function get sortBy() : Boolean
      {
         return this._currentIsdown;
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         var _loc2_:StripView = param1.cell as StripView;
         this._selectStrip = _loc2_;
         this._selectInfo = _loc2_.info;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._sortBtItems.length)
         {
            if(_loc1_ != 1)
            {
               this._sortBtItems[_loc1_].removeEventListener(MouseEvent.CLICK,this.sortHandler);
               ObjectUtils.disposeObject(this._sortBtItems[_loc1_]);
            }
            _loc1_++;
         }
         this._sortBtItems = null;
      }
      
      private function sortHandler(param1:MouseEvent) : void
      {
         AuctionHouseModel._dimBooble = false;
         SoundManager.instance.play("047");
         var _loc2_:uint = this._sortBtItems.indexOf(param1.target as BaseButton);
         if(this._currentButtonIndex == _loc2_)
         {
            this.changeArrow(_loc2_,!this._currentIsdown);
         }
         else
         {
            this.changeArrow(_loc2_,true);
         }
      }
      
      private function _showOneArrow(param1:uint) : void
      {
         this._hideArrow();
         this._sortArrowItems[param1].visible = true;
      }
      
      private function _hideArrow() : void
      {
         var _loc1_:ScaleFrameImage = null;
         for each(_loc1_ in this._sortArrowItems)
         {
            _loc1_.visible = false;
         }
      }
      
      private function changeArrow(param1:uint, param2:Boolean) : void
      {
         var _loc3_:uint = param1;
         if(param1 == 5)
         {
            param1 = 3;
         }
         param1 = param1 == 0 ? uint(uint(0)) : uint(uint(param1 - 1));
         this._showOneArrow(param1);
         if(param2)
         {
            this._sortArrowItems[param1].setFrame(2);
         }
         else
         {
            this._sortArrowItems[param1].setFrame(1);
         }
         this._currentIsdown = param2;
         this._currentButtonIndex = _loc3_;
         AuctionHouseModel.searchType = 3;
         if(this._stripList.vectorListModel.elements.length < 1)
         {
            return;
         }
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SORT_CHANGE));
      }
      
      public function get prePage_btn() : BaseButton
      {
         return this._prePage_btn;
      }
      
      public function get nextPage_btn() : BaseButton
      {
         return this._nextPage_btn;
      }
      
      public function dispose() : void
      {
         var _loc1_:ScaleFrameImage = null;
         this.removeEvent();
         this._selectInfo = null;
         if(this._prePage_btn)
         {
            ObjectUtils.disposeObject(this._prePage_btn);
         }
         this._prePage_btn = null;
         if(this._nextPage_btn)
         {
            ObjectUtils.disposeObject(this._nextPage_btn);
         }
         this._nextPage_btn = null;
         if(this.page_txt)
         {
            ObjectUtils.disposeObject(this.page_txt);
         }
         this.page_txt = null;
         for each(_loc1_ in this._sortArrowItems)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._sortArrowItems = null;
         if(this._selectStrip)
         {
            ObjectUtils.disposeObject(this._selectStrip);
         }
         this._selectStrip = null;
         this._stripList.vectorListModel.clear();
         if(this._stripList)
         {
            this._stripList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
            ObjectUtils.disposeObject(this._stripList);
         }
         this._stripList = null;
         if(this.help_mc)
         {
            ObjectUtils.disposeObject(this.help_mc);
         }
         this.help_mc = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
