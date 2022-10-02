package calendar.view.goodsExchange
{
   import activeEvents.data.ActiveEventsInfo;
   import calendar.view.ICalendar;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GoodsExchangeView extends Sprite implements Disposeable, ICalendar
   {
       
      
      private var _titleText:FilterFrameText;
      
      private var _explainText:FilterFrameText;
      
      private var _openBagBtn:SimpleBitmapButton;
      
      private var _deliverGoodsBtn:SimpleBitmapButton;
      
      private var _cellList:SimpleTileList;
      
      private var _info:ActiveEventsInfo;
      
      private var _cells:Vector.<GoodsExchangeCell>;
      
      private var _bag:BagCalendarFrame;
      
      public function GoodsExchangeView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._titleText = UICreatShortcut.creatTextAndAdd("CalendarGrid.GoodsExchangeView.TitleFFT",LanguageMgr.GetTranslation("calendar.view.GoodsExchangeView.title"),this);
         this._explainText = UICreatShortcut.creatTextAndAdd("CalendarGrid.GoodsExchangeView.explainFFT",LanguageMgr.GetTranslation("calendar.view.GoodsExchangeView.explain"),this);
         this._openBagBtn = UICreatShortcut.creatAndAdd("Calendar.GoodsExchangeView.openBagButton",this);
         this._cellList = ComponentFactory.Instance.creat("Calendar.GoodsExchangeView.CellList",[2]);
         addChild(this._cellList);
         this._bag = ComponentFactory.Instance.creat("CalendarGrid.GoodsExchangeView.GoodsBagFrame");
         this._bag.titleText = LanguageMgr.GetTranslation("calendar.view.goodsExchange.BagFrame.Choose");
         this._bag.moveEnable = true;
         this._bag.bagView.isNeedCard(false);
         this._bag.bagView.cellDoubleClickEnable = false;
         this._bag.graySortBtn();
         this._bag.bagView.trieveBtnEnable = false;
         this._cells = new Vector.<GoodsExchangeCell>();
      }
      
      private function initEvent() : void
      {
         this._openBagBtn.addEventListener(MouseEvent.CLICK,this.__onOpenBagClick);
         this._cellList.addEventListener(MouseEvent.CLICK,this.__onCellListClick);
      }
      
      private function removeEvent() : void
      {
         if(this._openBagBtn)
         {
            this._openBagBtn.removeEventListener(MouseEvent.CLICK,this.__onOpenBagClick);
         }
         if(this._cellList)
         {
            this._cellList.removeEventListener(MouseEvent.CLICK,this.__onCellListClick);
         }
      }
      
      private function __onCellListClick(param1:MouseEvent) : void
      {
         if(!this._bag.isShow)
         {
            SoundManager.instance.play("008");
            this._bag.show();
         }
      }
      
      private function __onOpenBagClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._bag.isShow)
         {
            this._bag.show();
         }
         else
         {
            this._bag.hide();
         }
      }
      
      private function createCell() : void
      {
         var _loc2_:GoodsExchangeCell = null;
         this.cleanCell();
         var _loc1_:int = 0;
         while(_loc1_ < this._info.goodsExchangeInfos.length)
         {
            _loc2_ = new GoodsExchangeCell();
            _loc2_.goodsExchangeInfo = this._info.goodsExchangeInfos[_loc1_];
            this._cellList.addChild(_loc2_);
            this._cells.push(_loc2_);
            _loc1_++;
         }
         this.updatePos();
      }
      
      private function updatePos() : void
      {
         this._openBagBtn.x = this._cellList.x + this._cellList.width + PositionUtils.creatPoint("CalendarGrid.GoodsExchangeView.Pos").x;
         this._openBagBtn.y = this._cellList.y + this._cellList.height - this._openBagBtn.height + PositionUtils.creatPoint("CalendarGrid.GoodsExchangeView.Pos").y;
         this._explainText.y = this._cellList.y + this._cellList.height + PositionUtils.creatPoint("CalendarGrid.GoodsExchangeView.Pos").y;
      }
      
      private function __cellInfoChange(param1:Event) : void
      {
      }
      
      public function setData(param1:* = null) : void
      {
         this._info = param1 as ActiveEventsInfo;
         this.update();
      }
      
      private function update() : void
      {
         this.createCell();
      }
      
      private function cleanCell() : void
      {
         var _loc1_:GoodsExchangeCell = null;
         for each(_loc1_ in this._cells)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._cells = new Vector.<GoodsExchangeCell>();
      }
      
      public function sendGoods() : void
      {
         var _loc3_:SendGoodsExchangeInfo = null;
         var _loc1_:Vector.<SendGoodsExchangeInfo> = new Vector.<SendGoodsExchangeInfo>();
         var _loc2_:int = 0;
         while(_loc2_ < this._cells.length)
         {
            _loc3_ = new SendGoodsExchangeInfo();
            if(!this._cells[_loc2_].info)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.goodsExchange.warningIII"));
               return;
            }
            _loc3_.id = this._cells[_loc2_].info.TemplateID;
            _loc3_.place = this._cells[_loc2_].place;
            _loc3_.bagType = this._cells[_loc2_].itemInfo.BagType;
			if(this._cells[_loc2_].itemInfo.BagType > 51)
			{
				SocketManager.Instance.out.sendErrorMsg("BagType sendGoods: " + this._cells[_loc2_].itemInfo.BagType);
			}
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         SocketManager.Instance.out.sendGoodsExchange(_loc1_,this._info.ActiveID);
      }
      
      public function dispose() : void
      {
         this.cleanCell();
         this.removeEvent();
         ObjectUtils.disposeObject(this._titleText);
         this._titleText = null;
         ObjectUtils.disposeObject(this._explainText);
         this._explainText = null;
         ObjectUtils.disposeObject(this._openBagBtn);
         this._openBagBtn = null;
         ObjectUtils.disposeObject(this._cellList);
         this._cellList = null;
         ObjectUtils.disposeObject(this._bag);
         this._bag = null;
      }
   }
}
