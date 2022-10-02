package firstRecharge
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class FirstRechargeFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _bottom:ScaleBitmapImage;
      
      private var _getAwardBtn:SimpleBitmapButton;
      
      private var _contentTxt:FilterFrameText;
      
      private var _anyMoneyTxt:FilterFrameText;
      
      private var _scaleTxt:FilterFrameText;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _getTxt:FilterFrameText;
      
      private var _valueTxt:FilterFrameText;
      
      public function FirstRechargeFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Array = null;
         _loc1_ = ServerConfigManager.instance.getFirstRechargeRebateAndValue();
         titleText = LanguageMgr.GetTranslation("firstrecharge.mainframe.title");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.firstrecharge.frame.bg");
         addToContent(this._bg);
         this._bottom = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.mainframe.bottom");
         addToContent(this._bottom);
         this._getAwardBtn = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.mainframe.getAwardBtn");
         addToContent(this._getAwardBtn);
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.mainframe.contentText");
         addToContent(this._contentTxt);
         this._contentTxt.htmlText = LanguageMgr.GetTranslation("firstrecharge.mainframe.contentTxt",_loc1_[0],_loc1_[1]);
         this._anyMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.mainframe.contentDetailText");
         PositionUtils.setPos(this._anyMoneyTxt,"firstrecharge.mainframe.anymoney.pos");
         this._anyMoneyTxt.text = LanguageMgr.GetTranslation("firstrecharge.mainframe.contentTxtAnymoney");
         this._scaleTxt = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.mainframe.contentDetailText");
         PositionUtils.setPos(this._scaleTxt,"firstrecharge.mainframe.scale.pos");
         this._scaleTxt.text = LanguageMgr.GetTranslation("firstrecharge.mainframe.contentTxtScale",_loc1_[0]);
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.mainframe.contentDetailText");
         PositionUtils.setPos(this._moneyTxt,"firstrecharge.mainframe.money.pos");
         this._moneyTxt.text = LanguageMgr.GetTranslation("firstrecharge.mainframe.contentTxtMoney");
         this._getTxt = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.mainframe.contentDetailText");
         PositionUtils.setPos(this._getTxt,"firstrecharge.mainframe.get.pos");
         this._getTxt.text = LanguageMgr.GetTranslation("firstrecharge.mainframe.contentTxtGet");
         this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.mainframe.contentDetailText");
         PositionUtils.setPos(this._valueTxt,"firstrecharge.mainframe.value.pos");
         this._valueTxt.text = LanguageMgr.GetTranslation("firstrecharge.mainframe.contentTxtValue",_loc1_[1]);
         this._getAwardBtn.enable = FirstRechargeManager.instance.isRecharged;
         this.setInfo();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._getAwardBtn.addEventListener(MouseEvent.CLICK,this.__getAward);
         FirstRechargeManager.instance.addEventListener(FirstRechargeManager.update_event,this.__updateView);
      }
      
      private function __updateView(param1:Event) : void
      {
         this._getAwardBtn.enable = FirstRechargeManager.instance.isRecharged == true && FirstRechargeManager.instance.isGetAward == false;
      }
      
      private function setInfo() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         _loc1_ = null;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = 0;
         _loc5_ = null;
         var _loc6_:InventoryItemInfo = null;
         var _loc7_:BagCell = null;
         _loc1_ = FirstRechargeManager.instance.awardList;
         _loc2_ = PositionUtils.creatPoint("firstrecharge.mainframe.cell.pos");
         _loc3_ = PositionUtils.creatPoint("firstrecharge.mainframe.cellshine.pos");
         _loc4_ = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc5_ = ClassUtils.CreatInstance("asset.firstcharge.frame.awardcell.shine");
            _loc5_.x = _loc3_.x + _loc4_ * 72;
            _loc5_.y = _loc3_.y;
            addToContent(_loc5_);
            _loc6_ = new InventoryItemInfo();
            _loc6_.TemplateID = _loc1_[_loc4_].TemplateID;
            _loc6_.Count = _loc1_[_loc4_].Count;
            _loc6_.StrengthenLevel = _loc1_[_loc4_].StrengthLevel;
            _loc6_.AttackCompose = _loc1_[_loc4_].AttackCompose;
            _loc6_.DefendCompose = _loc1_[_loc4_].DefendCompose;
            _loc6_.LuckCompose = _loc1_[_loc4_].LuckCompose;
            _loc6_.AgilityCompose = _loc1_[_loc4_].AgilityCompose;
            _loc6_.IsBinds = _loc1_[_loc4_].IsBind;
            _loc6_.ValidDate = _loc1_[_loc4_].ValidDate;
            ItemManager.fill(_loc6_);
            _loc7_ = new BagCell(0,_loc6_,true,ComponentFactory.Instance.creatBitmap("asset.firstcharge.frame.awardcell.bg"),false);
            _loc7_.setCount(_loc1_[_loc4_].Count);
            _loc7_.x = _loc2_.x + _loc4_ * 72;
            _loc7_.y = _loc2_.y;
            addToContent(_loc7_);
            _loc4_++;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            if(FirstRechargeManager.instance.isGetAward)
            {
               FirstRechargeManager.instance.removeIcon();
            }
            this.dispose();
         }
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(FirstRechargeManager.instance.isRecharged)
         {
            GameInSocketOut.sendFirstRechargeGetAward(FirstRechargeManager.instance.FIRSTRECHARGE_TYPE);
         }
         else
         {
            LeavePageManager.showFirstFillFrame();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._getAwardBtn.removeEventListener(MouseEvent.CLICK,this.__getAward);
         FirstRechargeManager.instance.removeEventListener(FirstRechargeManager.update_event,this.__updateView);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._bottom)
         {
            ObjectUtils.disposeObject(this._bottom);
         }
         this._bottom = null;
         if(this._getAwardBtn)
         {
            ObjectUtils.disposeObject(this._getAwardBtn);
         }
         this._getAwardBtn = null;
         if(this._contentTxt)
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
