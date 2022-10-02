package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.BuffTipInfo;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import shop.view.SetsShopView;
   
   public class PayBuffButton extends BuffButton
   {
       
      
      private var _buffs:Vector.<BuffInfo>;
      
      private var _isActived:Boolean = false;
      
      private var _timer:Timer;
      
      private var _str:String;
      
      private var _isMouseOver:Boolean = false;
      
      public function PayBuffButton(param1:String = "")
      {
         this._buffs = new Vector.<BuffInfo>();
         if(param1 == "")
         {
            this._str = "asset.core.payBuffAsset";
         }
         else
         {
            this._str = param1;
         }
         super(this._str);
         _tipStyle = "core.PayBuffTip";
         info = new BuffInfo(BuffInfo.Pay_Buff);
         this._timer = new Timer(10000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerTick);
         this._timer.start();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timerTick);
         this._timer.stop();
         this._timer = null;
      }
      
      private function __timerTick(param1:TimerEvent) : void
      {
         this.validBuff();
         if(this._isMouseOver)
         {
            ShowTipManager.Instance.showTip(this);
         }
      }
      
      private function validBuff() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BuffInfo = null;
         if(this._isActived)
         {
            _loc1_ = 0;
            for each(_loc2_ in this._buffs)
            {
               _loc2_.calculatePayBuffValidDay();
               if(!_loc2_.valided)
               {
                  _loc1_++;
               }
            }
            if(_loc1_ >= this._buffs.length)
            {
               this.setAcived(false);
            }
         }
      }
      
      override protected function __onclick(param1:MouseEvent) : void
      {
         this.shop();
      }
      
      private function shop() : void
      {
         var _loc2_:ShopItemInfo = null;
         var _loc3_:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         var _loc1_:Array = [];
         _loc2_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Caddy_Good);
         _loc3_ = new ShopCarItemInfo(_loc2_.ShopID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc1_.push(_loc3_);
         _loc2_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Save_Life);
         _loc3_ = new ShopCarItemInfo(_loc2_.ShopID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc1_.push(_loc3_);
         _loc2_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Agility_Get);
         _loc3_ = new ShopCarItemInfo(_loc2_.ShopID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc1_.push(_loc3_);
         _loc2_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.ReHealth);
         _loc3_ = new ShopCarItemInfo(_loc2_.ShopID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc1_.push(_loc3_);
         _loc2_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Train_Good);
         _loc3_ = new ShopCarItemInfo(_loc2_.ShopID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc1_.push(_loc3_);
         _loc2_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Level_Try);
         _loc3_ = new ShopCarItemInfo(_loc2_.ShopID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc1_.push(_loc3_);
         _loc2_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Card_Get);
         _loc3_ = new ShopCarItemInfo(_loc2_.ShopID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc1_.push(_loc3_);
         var _loc4_:SetsShopView = new SetsShopView();
         _loc4_.initialize(_loc1_);
         LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         ShowTipManager.Instance.hideTip(this);
      }
      
      public function addBuff(param1:BuffInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._buffs.length)
         {
            if(this._buffs[_loc2_].Type == param1.Type)
            {
               this._buffs[_loc2_] = param1;
               this.setAcived(true);
               return;
            }
            _loc2_++;
         }
         this._buffs.push(param1);
         this.setAcived(true);
      }
      
      public function setAcived(param1:Boolean) : void
      {
         if(this._isActived == param1)
         {
            return;
         }
         this._isActived = param1;
         if(this._isActived)
         {
            filters = null;
         }
         else
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      override protected function __onMouseOver(param1:MouseEvent) : void
      {
         if(this._isActived)
         {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
         this._isMouseOver = true;
      }
      
      override protected function __onMouseOut(param1:MouseEvent) : void
      {
         if(this._isActived)
         {
            filters = null;
         }
         this._isMouseOver = false;
      }
      
      override public function get tipData() : Object
      {
         _tipData = new BuffTipInfo();
         this.validBuff();
         if(_info)
         {
            _tipData.isActive = this._isActived;
            _tipData.describe = !!this._isActived ? "" : LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Note");
            _tipData.name = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Name");
            _tipData.isFree = false;
            _tipData.linkBuffs = this._buffs;
         }
         return _tipData;
      }
   }
}
