package farm.view.compose
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.control.FarmComposeHouseController;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class ConfirmComposeFoodAlertFrame extends Frame
   {
       
      
      private var _bg3:Scale9CornerImage;
      
      private var _promptTxt:FilterFrameText;
      
      private var _showTxtBG:Image;
      
      private var _preBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _hBox:HBox;
      
      private var _cells:Vector.<ShopItemCell>;
      
      private var _cellInfos:Array;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _currentImg:Bitmap;
      
      public function ConfirmComposeFoodAlertFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         var _loc4_:ShopItemCell = null;
         var _loc2_:BaseButton = null;
         var _loc3_:Sprite = null;
         _loc4_ = null;
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeFoodAlertFrame.bg3");
         addToContent(this._bg3);
         this._showTxtBG = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeFoodAlertFrame.showTxtBG");
         addToContent(this._showTxtBG);
         this._promptTxt = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.promptTxt");
         this._promptTxt.text = LanguageMgr.GetTranslation("ddt.farms.confirmComposeFoodAlertFrame.promptText");
         addToContent(this._promptTxt);
         escEnable = true;
         this._preBtn = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.btnPrePage1");
         addToContent(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.btnNextPage1");
         addToContent(this._nextBtn);
         this._cells = new Vector.<ShopItemCell>();
         this._hBox = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.cropBox");
         addToContent(this._hBox);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("farmHouse.btnSelectHouseCompose3");
            _loc3_ = new Sprite();
            _loc3_.graphics.beginFill(16777215,0);
            _loc3_.graphics.drawRect(0,0,50,50);
            _loc3_.graphics.endFill();
            _loc4_ = new ShopItemCell(_loc3_);
            _loc4_.cellSize = 50;
            _loc2_.addEventListener(MouseEvent.CLICK,this.__selectValue);
            _loc2_.mouseChildren = true;
            _loc2_.addChild(_loc4_);
            PositionUtils.setPos(_loc4_,"farm.confirmComposeFoodAlertFrame.cellPos");
            this._hBox.addChild(_loc2_);
            this._cells.push(_loc4_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
      }
      
      private function __onPageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._preBtn:
               this._currentPage = this._currentPage - 1 < 0 ? int(int(0)) : int(int(this._currentPage - 1));
               break;
            case this._nextBtn:
               this._currentPage = this._currentPage + 1 > this._totlePage ? int(int(this._totlePage)) : int(int(this._currentPage + 1));
         }
         this.upCells(this._currentPage);
      }
      
      private function initData() : void
      {
         var _loc1_:Vector.<FoodComposeListTemplateInfo> = null;
         var _loc2_:int = 0;
         var _loc3_:ItemTemplateInfo = null;
         this._cellInfos = [];
         for each(_loc1_ in FarmComposeHouseController.instance().composeHouseModel.foodComposeList)
         {
            _loc2_ = _loc1_[0].FoodID;
            _loc3_ = ItemManager.Instance.getTemplateById(_loc2_);
            this._cellInfos.push(_loc3_);
         }
         this._totlePage = this._cellInfos.length % 3 == 0 ? int(int(this._cellInfos.length / 3 - 1)) : int(int(this._cellInfos.length / 3));
         this.upCells(0);
      }
      
      private function upCells(param1:int = 0) : void
      {
         this._currentPage = param1;
         var _loc2_:int = param1 * 3;
         var _loc3_:int = 0;
         while(_loc3_ < this._cells.length)
         {
            if(this._cellInfos[_loc3_ + _loc2_])
            {
               this._cells[_loc3_].info = this._cellInfos[_loc3_ + _loc2_];
            }
            _loc3_++;
         }
      }
      
      private function __selectValue(param1:MouseEvent) : void
      {
         var _loc3_:ItemTemplateInfo = null;
         var _loc5_:Object = null;
         SoundManager.instance.play("008");
         var _loc2_:BaseButton = param1.currentTarget as BaseButton;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.numChildren)
         {
            _loc5_ = _loc2_.getChildAt(_loc4_);
            if(_loc5_ is ShopItemCell)
            {
               _loc3_ = _loc5_.info;
               break;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.SELECT_FOOD,_loc3_));
         }
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         this.removeEvent();
         if(this._hBox)
         {
            _loc1_ = 0;
            while(_loc1_ < this._hBox.numChildren)
            {
               _loc2_ = this._hBox.getChildAt(_loc1_);
               if(_loc2_ is BaseButton)
               {
                  _loc2_.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
               }
               _loc1_++;
            }
            this._hBox.disposeAllChildren();
            this._hBox.dispose();
            this._hBox = null;
         }
         if(this._promptTxt)
         {
            ObjectUtils.disposeObject(this._promptTxt);
         }
         this._promptTxt = null;
         if(this._bg3)
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         if(this._showTxtBG)
         {
            ObjectUtils.disposeObject(this._showTxtBG);
         }
         this._showTxtBG = null;
         super.dispose();
      }
   }
}
