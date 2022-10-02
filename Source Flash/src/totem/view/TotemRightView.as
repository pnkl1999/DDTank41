package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemRightView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _lvTxt:FilterFrameText;
      
      private var _titleTxt1:FilterFrameText;
      
      private var _honorTxt1:TotemRightViewIconTxtCell;
      
      private var _expTxt1:TotemRightViewIconTxtCell;
      
      private var _titleTxt2:FilterFrameText;
      
      private var _honorTxt2:TotemRightViewIconTxtCell;
      
      private var _expTxt2:TotemRightViewIconTxtCell;
      
      private var _titleTxt3:FilterFrameText;
      
      private var _propertyList:Vector.<TotemRightViewTxtTxtCell>;
      
      private var _tipTxt:FilterFrameText;
      
      private var _honorUpIcon:HonorUpIcon;
      
      private var _nextInfo:TotemDataVo;
      
      private var _totemRightViewIconTxtDragonBoatCell:TotemRightViewIconTxtDragonBoatCell;
      
      private var _totemSignTxt:FilterFrameText;
      
      private var _totemSignTxtCell:TotemSignTxtCell;
      
      public function TotemRightView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:TotemRightViewTxtTxtCell = null;
         var _loc2_:int = 0;
         _loc1_ = null;
         _loc2_ = 0;
         _loc1_ = null;
         _loc2_ = 0;
         _loc1_ = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.rightView.bg");
         this._lvTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.lvTxt");
         this._titleTxt1 = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.titleTxt1");
         this._titleTxt1.text = LanguageMgr.GetTranslation("ddt.totem.rightView.titleTxt1");
         this._honorTxt1 = ComponentFactory.Instance.creatCustomObject("TotemRightViewIconTxtCell.honor1");
         this._expTxt1 = ComponentFactory.Instance.creatCustomObject("TotemRightViewIconTxtCell.exp1");
         this._titleTxt2 = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.titleTxt2");
         this._titleTxt2.text = LanguageMgr.GetTranslation("ddt.totem.rightView.titleTxt2");
         this._honorTxt2 = ComponentFactory.Instance.creatCustomObject("TotemRightViewIconTxtCell.honor2");
         this._expTxt2 = ComponentFactory.Instance.creatCustomObject("TotemRightViewIconTxtCell.exp2");
         this._titleTxt3 = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.titleTxt3");
         this._titleTxt3.text = LanguageMgr.GetTranslation("ddt.totem.rightView.titleTxt3");
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.tipTxt");
         this._tipTxt.text = LanguageMgr.GetTranslation("ddt.totem.rightView.tipTxt");
         this._honorUpIcon = ComponentFactory.Instance.creatCustomObject("totem.honorUpIcon");
         this._totemSignTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.totemSignTxt");
         this._totemSignTxtCell = ComponentFactory.Instance.creatCustomObject("totem.totemSignTxtCell");
         addChild(this._bg);
         addChild(this._lvTxt);
         addChild(this._titleTxt1);
         addChild(this._honorTxt1);
         addChild(this._expTxt1);
         addChild(this._titleTxt2);
         addChild(this._honorTxt2);
         addChild(this._expTxt2);
         addChild(this._titleTxt3);
         addChild(this._tipTxt);
         this._propertyList = new Vector.<TotemRightViewTxtTxtCell>();
         _loc2_ = 1;
         while(_loc2_ <= 7)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("TotemRightViewTxtTxtCell" + _loc2_);
            _loc1_.show(_loc2_);
            _loc1_.x = 44 + (_loc2_ - 1) % 2 * 110;
            _loc1_.y = 328 + int((_loc2_ - 1) / 2) * 21;
            addChild(_loc1_);
            this._propertyList.push(_loc1_);
            _loc2_++;
         }
         addChild(this._honorUpIcon);
         addChild(this._totemSignTxt);
         addChild(this._totemSignTxtCell);
         this._honorTxt1.show(2);
         this._expTxt1.show(1);
         this._honorTxt2.show(2);
         this._expTxt2.show(1);
         this.refreshView();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.propertyChangeHandler);
      }
      
      public function refreshView() : void
      {
         var _loc1_:Number = NaN;
         this._totemSignTxtCell.updateData();
         var _loc2_:int = TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId);
         this._lvTxt.text = LanguageMgr.GetTranslation("ddt.totem.rightView.lvTxt",TotemManager.instance.getCurrentLv(_loc2_));
         this._nextInfo = TotemManager.instance.getNextInfoByLevel(_loc2_);
         if(this._nextInfo)
         {
            this._honorTxt1.refresh(this._nextInfo.ConsumeHonor);
            this._expTxt1.refresh(this._nextInfo.ConsumeExp);
            _loc1_ = Math.round(this._nextInfo.ConsumeExp * (ServerConfigManager.instance.totemSignDiscount / 100));
            this._expTxt1.clearTextLine();
            this._totemSignTxt.htmlText = LanguageMgr.GetTranslation("ddt.totem.rightViewTotemSignTxt",_loc1_,_loc1_);
         }
         else
         {
            this._honorTxt1.refresh(0);
            this._expTxt1.refresh(0);
         }
         this.refreshHonorTxt();
         this.refreshGPTxt();
         var _loc3_:int = 0;
         while(_loc3_ < 7)
         {
            this._propertyList[_loc3_].refresh();
            _loc3_++;
         }
      }
      
      private function refreshHonorTxt() : void
      {
         var _loc1_:Boolean = false;
         if(this._nextInfo && PlayerManager.Instance.Self.myHonor < this._nextInfo.ConsumeHonor)
         {
            _loc1_ = true;
         }
         var _loc2_:int = PlayerManager.Instance.Self.myHonor;
         this._honorTxt2.refresh(PlayerManager.Instance.Self.myHonor,_loc1_);
      }
      
      private function refreshGPTxt() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this._nextInfo)
         {
            _loc1_ = false;
            _loc2_ = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(TotemSignTxtCell.TOTEM_SIGN,true);
            if(_loc2_ > (_loc4_ = Number(Math.round(this._nextInfo.ConsumeExp * (ServerConfigManager.instance.totemSignDiscount / 100)))))
            {
               _loc2_ = _loc4_;
            }
            if(this._nextInfo && PlayerManager.Instance.Self.Money + _loc2_ < this._nextInfo.ConsumeExp)
            {
               _loc1_ = true;
            }
            this._expTxt2.refresh(PlayerManager.Instance.Self.Money,_loc1_);
         }
         else
         {
            this._expTxt2.refresh(PlayerManager.Instance.Self.Money,false);
         }
      }
      
      private function propertyChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["myHonor"])
         {
            this.refreshHonorTxt();
         }
         if(param1.changedProperties["GP"])
         {
            this.refreshGPTxt();
         }
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.propertyChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._totemSignTxt);
         this._totemSignTxt = null;
         ObjectUtils.disposeAllChildren(this._totemSignTxtCell);
         ObjectUtils.disposeObject(this._totemSignTxtCell);
         this._totemSignTxtCell = null;
         ObjectUtils.disposeAllChildren(this);
         this._nextInfo = null;
         this._bg = null;
         this._lvTxt = null;
         this._titleTxt1 = null;
         this._honorTxt1 = null;
         this._expTxt1 = null;
         this._titleTxt2 = null;
         this._honorTxt2 = null;
         this._expTxt2 = null;
         this._titleTxt3 = null;
         this._tipTxt = null;
         this._propertyList = null;
         this._honorUpIcon = null;
         this._totemRightViewIconTxtDragonBoatCell = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
