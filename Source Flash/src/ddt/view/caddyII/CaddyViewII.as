package ddt.view.caddyII
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.BuffTipInfo;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import shop.view.SetsShopView;
   
   public class CaddyViewII extends RightView
   {
      
      public static const NEED_KEY:int = 4;
      
      public static const START_TURN:String = "caddy_start_turn";
      
      public static const START_MOVE_AFTER_TURN:String = "start_move_after_turn";
      
      public static const GOODSNUMBER:int = 30;
       
      
      private var _bg:Scale9CornerImage;
      
      private var _gridBGI:ScaleBitmapImage;
      
      private var _gridBGII:ScaleBitmapImage;
      
      private var _lookBtn:BaseButton;
      
      private var _openBtn:BaseButton;
      
      private var _keyBtn:BaseButton;
      
      private var _boxBtn:BaseButton;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _keyNumberTxt:FilterFrameText;
      
      private var _boxNumberTxt:FilterFrameText;
      
      private var _lookTrophy:LookTrophy;
      
      private var _keyNumber:int;
      
      private var _boxNumber:int;
      
      private var _selectedCount:int;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _templateIDList:Vector.<int>;
      
      private var _turn:CaddyTurn;
      
      private var _buff:SimpleBitmapButton;
      
      private var _buffData:DictionaryData;
      
      private var _tipData:BuffTipInfo;
      
      private var _buffs:Vector.<BuffInfo>;
      
      private var isActive:Boolean = false;
      
      public function CaddyViewII()
      {
         this._tipData = new BuffTipInfo();
         super();
         this.initView();
         this.initEvents();
      }
      
      override public function set item(param1:ItemTemplateInfo) : void
      {
         if(_item != param1)
         {
            _item = param1;
            if(_item.TemplateID == EquipType.Gold_Caddy)
            {
               if(this._turn)
               {
                  this._turn.setCaddyType(CaddyModel.Gold_Caddy);
               }
               this._boxBtn.tipData = _item.Name;
            }
            else if(_item.TemplateID == EquipType.Silver_Caddy)
            {
               if(this._turn)
               {
                  this._turn.setCaddyType(CaddyModel.Silver_Caddy);
               }
               this._boxBtn.tipData = _item.Name;
            }
            else
            {
               if(this._turn)
               {
                  this._turn.setCaddyType(CaddyModel.CADDY_TYPE);
               }
               this._boxBtn.tipData = _item.Name;
            }
            this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_item.TemplateID);
         }
      }
      
      private function initView() : void
      {
         var _loc1_:Bitmap = null;
         _loc1_ = ComponentFactory.Instance.creatBitmap("asset.caddy.NodeAsset");
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.caddy.GoodsNameBG");
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.caddy.CaddyViewBG");
         var _loc4_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("caddy.numberBG");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGridBGI");
         this._gridBGII = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGridBGII");
         this._lookBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.LookBtn");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         this._keyBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.KeyBtn");
         this._keyBtn.addChild(this.creatShape());
         this._boxBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.BoxBtn");
         this._boxBtn.addChild(this.creatShape());
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.goodsNameTxt");
         this._keyNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.keyNumberTxt");
         this._boxNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.boxNumberTxt");
         this._turn = ComponentFactory.Instance.creatCustomObject("caddy.CaddyTurn",[this._goodsNameTxt]);
         this._lookTrophy = ComponentFactory.Instance.creatCustomObject("caddyII.LookTrophy");
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         _autoCheck.selected = SharedManager.Instance.autoCaddy;
         this._buff = ComponentFactory.Instance.creatComponentByStylename("buybuffBtnI");
         this._buffData = PlayerManager.Instance.Self.buffInfo;
         this._buff.tipData = this.upBuff();
         addChild(this._bg);
         addChild(this._gridBGI);
         addChild(this._gridBGII);
         addChild(_loc1_);
         addChild(_loc3_);
         addChild(_loc2_);
         addChild(_loc4_);
         addChild(this._lookBtn);
         addChild(this._openBtn);
         addChild(this._keyBtn);
         addChild(this._boxBtn);
         addChild(this._goodsNameTxt);
         addChild(this._keyNumberTxt);
         addChild(this._boxNumberTxt);
         addChild(this._turn);
         addChild(_autoCheck);
         addChild(this._buff);
         this._keyBtn.tipData = LanguageMgr.GetTranslation("tank.view.caddy.quickBuyKey");
         this._boxBtn.tipData = LanguageMgr.GetTranslation("tank.view.caddy.quickBoxKey");
         this.keyNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CADDY_KEY);
         this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CADDY);
      }
      
      private function __addBuff(param1:DictionaryEvent) : void
      {
         this.isActive = false;
         this._buff.tipData = this.upBuff();
      }
      
      private function upBuff() : BuffTipInfo
      {
         var _loc1_:BuffInfo = null;
         this._buffs = new Vector.<BuffInfo>();
         for each(_loc1_ in PlayerManager.Instance.Self.buffInfo)
         {
            switch(_loc1_.Type)
            {
               case BuffInfo.Caddy_Good:
               case BuffInfo.Save_Life:
               case BuffInfo.Agility:
               case BuffInfo.ReHealth:
               case BuffInfo.Train_Good:
               case BuffInfo.Level_Try:
               case BuffInfo.Card_Get:
                  this._buffs.push(_loc1_);
                  this.isActive = true;
                  break;
            }
         }
         this._tipData.isActive = this.isActive;
         this._tipData.describe = !!this.isActive ? "" : LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Note");
         this._tipData.name = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Name");
         this._tipData.isFree = false;
         this._tipData.linkBuffs = this._buffs;
         return this._tipData;
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._lookBtn.addEventListener(MouseEvent.CLICK,this._look);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__openClick);
         this._keyBtn.addEventListener(MouseEvent.CLICK,this._buyKey);
         this._keyBtn.addEventListener(MouseEvent.MOUSE_MOVE,this.__quickBuyMouseOver);
         this._keyBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__quickBuyMouseOut);
         this._boxBtn.addEventListener(MouseEvent.CLICK,this._buyBox);
         this._boxBtn.addEventListener(MouseEvent.MOUSE_MOVE,this.__quickBuyMouseOver);
         this._boxBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__quickBuyMouseOut);
         this._turn.addEventListener(CaddyTurn.TURN_COMPLETE,this._turnComplete);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
         this._buff.addEventListener(MouseEvent.CLICK,this.__buyBuff);
         this._buffData.addEventListener(DictionaryEvent.ADD,this.__addBuff);
         this._buffData.addEventListener(DictionaryEvent.REMOVE,this.__addBuff);
         this._buffData.addEventListener(DictionaryEvent.UPDATE,this.__addBuff);
      }
      
      private function __selectedChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.autoCaddy = _autoCheck.selected;
      }
      
      private function __quickBuyMouseOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget != this._keyBtn)
         {
            if(param1.currentTarget == this._boxBtn)
            {
            }
         }
      }
      
      private function __quickBuyMouseOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget != this._keyBtn)
         {
            if(param1.currentTarget == this._boxBtn)
            {
            }
         }
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._lookBtn.removeEventListener(MouseEvent.CLICK,this._look);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__openClick);
         this._keyBtn.removeEventListener(MouseEvent.CLICK,this._buyKey);
         this._keyBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.__quickBuyMouseOver);
         this._keyBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__quickBuyMouseOut);
         this._boxBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.__quickBuyMouseOver);
         this._boxBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__quickBuyMouseOut);
         this._turn.removeEventListener(CaddyTurn.TURN_COMPLETE,this._turnComplete);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
         this._buff.removeEventListener(MouseEvent.CLICK,this.__buyBuff);
         if(this._buffData)
         {
            this._buffData.removeEventListener(DictionaryEvent.ADD,this.__addBuff);
            this._buffData.removeEventListener(DictionaryEvent.REMOVE,this.__addBuff);
            this._buffData.removeEventListener(DictionaryEvent.UPDATE,this.__addBuff);
         }
      }
      
      private function __buyBuff(param1:MouseEvent) : void
      {
         var _loc3_:ShopItemInfo = null;
         var _loc4_:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:Array = [];
         _loc3_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Caddy_Good);
         _loc4_ = new ShopCarItemInfo(_loc3_.ShopID,_loc3_.TemplateID);
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         _loc2_.push(_loc4_);
         _loc3_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Save_Life);
         _loc4_ = new ShopCarItemInfo(_loc3_.ShopID,_loc3_.TemplateID);
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         _loc2_.push(_loc4_);
         _loc3_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Agility_Get);
         _loc4_ = new ShopCarItemInfo(_loc3_.ShopID,_loc3_.TemplateID);
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         _loc2_.push(_loc4_);
         _loc3_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.ReHealth);
         _loc4_ = new ShopCarItemInfo(_loc3_.ShopID,_loc3_.TemplateID);
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         _loc2_.push(_loc4_);
         _loc3_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Train_Good);
         _loc4_ = new ShopCarItemInfo(_loc3_.ShopID,_loc3_.TemplateID);
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         _loc2_.push(_loc4_);
         _loc3_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Level_Try);
         _loc4_ = new ShopCarItemInfo(_loc3_.ShopID,_loc3_.TemplateID);
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         _loc2_.push(_loc4_);
         _loc3_ = ShopManager.Instance.getGoodsByTemplateID(EquipType.Card_Get);
         _loc4_ = new ShopCarItemInfo(_loc3_.ShopID,_loc3_.TemplateID);
         ObjectUtils.copyProperties(_loc4_,_loc3_);
         _loc2_.push(_loc4_);
         var _loc5_:SetsShopView = new SetsShopView();
         _loc5_.initialize(_loc2_);
         LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function creatShape(param1:Number = 100, param2:Number = 25) : Shape
      {
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("caddy.QuickBuyBtn.ButtonSize");
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,_loc3_.x,_loc3_.y);
         _loc4_.graphics.endFill();
         return _loc4_;
      }
      
      private function _bagUpdate(param1:BagEvent) : void
      {
         this.keyNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CADDY_KEY);
         this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_item.TemplateID);
      }
      
      private function _look(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(EquipType.isCaddy(_item))
         {
            this._lookTrophy.show(CaddyModel.instance.getCaddyTrophy(_item.TemplateID));
         }
         else if(!EquipType.isBead(_item))
         {
            if(EquipType.isOfferPackage(_item))
            {
            }
         }
      }
      
      private function __openClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openBoxImp();
      }
      
      private function hasKey() : Boolean
      {
         var _loc1_:BuffInfo = PlayerManager.Instance.Self.getBuff(BuffInfo.Caddy_Good);
         if(_loc1_ != null && _loc1_.ValidCount > 0)
         {
            return this.keyNumber + 1 >= NEED_KEY;
         }
         return this.keyNumber >= NEED_KEY;
      }
      
      private function openBoxImp() : void
      {
         var _loc1_:Boolean = this.hasKey();
         if(this.boxNumber >= 1 && _loc1_)
         {
            if(CaddyModel.instance.bagInfo.itemNumber < CaddyBagView.SUM_NUMBER)
            {
               this._openBtn.enable = false;
            }
            this.getRandomTempId();
            SocketManager.Instance.out.sendRouletteBox(BagInfo.CADDYBAG,-1,_item.TemplateID);
         }
         else if(!_loc1_)
         {
            this._quickBuy();
         }
         else if(this.boxNumber < 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.EmptyBox",_item.Name));
         }
      }
      
      private function _quickBuy() : void
      {
         this._buyKey(null);
      }
      
      private function _buyKey(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._showQuickBuy(QuickBuyCaddy.CADDYKEY_NUMBER);
      }
      
      private function _buyBox(param1:MouseEvent) : void
      {
         if(EquipType.isCaddyCanBay(_item))
         {
            SoundManager.instance.play("008");
            this._showQuickBuy(QuickBuyCaddy.CADDY_NUMBER);
         }
      }
      
      private function _showQuickBuy(param1:int) : void
      {
         var _loc2_:QuickBuyCaddy = ComponentFactory.Instance.creatCustomObject("caddy.QuickBuyCaddy");
         _loc2_.show(param1);
      }
      
      private function _turnComplete(param1:Event) : void
      {
         dispatchEvent(new Event(START_MOVE_AFTER_TURN));
      }
      
      private function againImp() : void
      {
         ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.caddy.showChat",this._selectedGoodsInfo.Name + "x" + this._selectedGoodsInfo.Count));
      }
      
      override public function again() : void
      {
         this._openBtn.enable = true;
         this._turn.again();
         ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.caddy.showChat",this._selectedGoodsInfo.Name + "x" + this._selectedGoodsInfo.Count));
         if(SharedManager.Instance.autoCaddy)
         {
            if(CaddyModel.instance.bagInfo.itemNumber >= CaddyBagView.SUM_NUMBER)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
            }
            else if(this.keyNumber < NEED_KEY)
            {
               this._quickBuy();
            }
            else if(this.boxNumber < 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.EmptyBox",_item.Name));
            }
            else
            {
               this.openBoxImp();
            }
         }
      }
      
      public function set keyNumber(param1:int) : void
      {
         this._keyNumber = param1;
         this._keyNumberTxt.text = String(this._keyNumber);
      }
      
      public function get keyNumber() : int
      {
         return this._keyNumber;
      }
      
      public function set boxNumber(param1:int) : void
      {
         this._boxNumber = param1;
         this._boxNumberTxt.text = String(this._boxNumber);
      }
      
      public function get boxNumber() : int
      {
         return this._boxNumber;
      }
      
      override public function setSelectGoodsInfo(param1:InventoryItemInfo) : void
      {
         this._openBtn.enable = false;
         this._selectedGoodsInfo = param1;
         this._startTurn();
         this._turn.setTurnInfo(this._selectedGoodsInfo,this._templateIDList);
         this._turn.start(_item);
      }
      
      private function _startTurn() : void
      {
         var _loc1_:CaddyEvent = new CaddyEvent(START_TURN);
         _loc1_.info = this._selectedGoodsInfo;
         dispatchEvent(_loc1_);
      }
      
      private function getRandomTempId() : void
      {
         var _loc8_:int = 0;
         var _loc1_:Vector.<BoxGoodsTempInfo> = BossBoxManager.instance.caddyBoxGoodsInfo;
         this._templateIDList = new Vector.<int>();
         var _loc3_:int = Math.floor(_loc1_.length / GOODSNUMBER);
         var _loc4_:int = Math.floor(Math.random() * _loc3_);
         _loc4_ = _loc4_ == 0 ? int(int(1)) : int(int(_loc4_));
         var _loc5_:int = 1;
         while(_loc5_ <= GOODSNUMBER)
         {
            if(_loc4_ * _loc5_ < _loc1_.length)
            {
               this._templateIDList.push(_loc1_[_loc4_ * _loc5_].TemplateId);
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < this._templateIDList.length)
         {
            _loc8_ = Math.floor(Math.random() * this._templateIDList.length);
            _loc6_ = this._templateIDList[_loc7_];
            this._templateIDList[_loc7_] = this._templateIDList[_loc8_];
            this._templateIDList[_loc8_] = _loc6_;
            _loc7_++;
         }
      }
      
      override public function get openBtnEnable() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._gridBGI)
         {
            ObjectUtils.disposeObject(this._gridBGI);
         }
         this._gridBGI = null;
         if(this._gridBGII)
         {
            ObjectUtils.disposeObject(this._gridBGII);
         }
         this._gridBGII = null;
         if(this._lookBtn)
         {
            ObjectUtils.disposeObject(this._lookBtn);
         }
         this._lookBtn = null;
         if(this._openBtn)
         {
            ObjectUtils.disposeObject(this._openBtn);
         }
         this._openBtn = null;
         if(this._goodsNameTxt)
         {
            ObjectUtils.disposeObject(this._goodsNameTxt);
         }
         this._goodsNameTxt = null;
         if(this._keyNumberTxt)
         {
            ObjectUtils.disposeObject(this._keyNumberTxt);
         }
         this._keyNumberTxt = null;
         if(this._boxNumberTxt)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._boxNumberTxt = null;
         if(this._lookTrophy)
         {
            ObjectUtils.disposeObject(this._lookTrophy);
         }
         this._lookTrophy = null;
         if(this._turn)
         {
            ObjectUtils.disposeObject(this._turn);
         }
         this._turn = null;
         if(this._keyBtn)
         {
            ObjectUtils.disposeObject(this._keyBtn);
         }
         this._keyBtn = null;
         if(this._boxBtn)
         {
            ObjectUtils.disposeObject(this._boxBtn);
         }
         this._boxBtn = null;
         if(this._buff)
         {
            ObjectUtils.disposeObject(this._buff);
         }
         this._buff = null;
         ObjectUtils.disposeObject(_autoCheck);
         _autoCheck = null;
         _item = null;
         this._selectedGoodsInfo = null;
         this._templateIDList = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
