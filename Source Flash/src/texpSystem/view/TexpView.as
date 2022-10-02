package texpSystem.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.buff.buffButton.PayBuffButton;
   import ddt.view.tips.BuffTipInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import shop.view.SetsShopView;
   import shop.view.ShopBugleView;
   import texpSystem.TexpEvent;
   import texpSystem.controller.TexpManager;
   import texpSystem.data.TexpInfo;
   import texpSystem.data.TexpType;
   
   public class TexpView extends Sprite implements Disposeable
   {
       
      
      private var _bg1:Scale9CornerImage;
      
      private var _bg2:Scale9CornerImage;
      
      private var _bg3:Scale9CornerImage;
      
      private var _bg4:Bitmap;
      
      private var _txtBg1:Bitmap;
      
      private var _txtBg2:Bitmap;
      
      private var _bmpLine:Bitmap;
      
      private var _texpCell:TexpCell;
      
      private var _lblTexpName:FilterFrameText;
      
      private var _lblTexpExp:FilterFrameText;
      
      private var _lblCurrLv:FilterFrameText;
      
      private var _lblCurrEffect:FilterFrameText;
      
      private var _lblUpEffect:FilterFrameText;
      
      private var _lblCurrExp:FilterFrameText;
      
      private var _lblUpExp:FilterFrameText;
      
      private var _txtCurrLv:FilterFrameText;
      
      private var _txtCurrEffect:FilterFrameText;
      
      private var _txtUpEffect:FilterFrameText;
      
      private var _txtCurrExp:FilterFrameText;
      
      private var _txtUpExp:FilterFrameText;
      
      private var _sbtnGroup:SelectedButtonGroup;
      
      private var _sbtnAtt:SelectedButton;
      
      private var _sbtnHp:SelectedButton;
      
      private var _sbtnLuk:SelectedButton;
      
      private var _sbtnDef:SelectedButton;
      
      private var _sbtnSpd:SelectedButton;
      
      private var _btnTexp:SimpleBitmapButton;
      
      private var _btnHelp:BaseButton;
      
      private var _btnBuy:TexpBuyButton;
      
      private var _helpFrame:Frame;
      
      private var _buff:SimpleBitmapButton;
      
      private var _buffData:DictionaryData;
      
      private var _tipData:BuffTipInfo;
      
      private var _buffs:Vector.<BuffInfo>;
      
      private var isActive:Boolean = false;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      public function TexpView()
      {
         this._tipData = new BuffTipInfo();
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._buffData = PlayerManager.Instance.Self.buffInfo;
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg1");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg2");
         addChild(this._bg2);
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg3");
         addChild(this._bg3);
         this._bg4 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.bg4");
         addChild(this._bg4);
         this._txtBg1 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.txtBg");
         PositionUtils.setPos(this._txtBg1,"texpSystem.posTxtBg1");
         addChild(this._txtBg1);
         this._txtBg2 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.txtBg");
         PositionUtils.setPos(this._txtBg2,"texpSystem.posTxtBg2");
         addChild(this._txtBg2);
         this._bmpLine = ComponentFactory.Instance.creatBitmap("asset.texpSystem.line");
         addChild(this._bmpLine);
         this._texpCell = ComponentFactory.Instance.creatCustomObject("texpSystem.texpCell");
         addChild(this._texpCell);
         this._lblTexpName = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblTexpName");
         addChild(this._lblTexpName);
         this._lblTexpExp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblTexpExp");
         this._lblTexpExp.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpExp");
         addChild(this._lblTexpExp);
         this._lblCurrLv = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblCurrentLv");
         this._lblCurrLv.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.currLv");
         addChild(this._lblCurrLv);
         this._lblCurrEffect = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblCurrentEffect");
         this._lblCurrEffect.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.currEffect");
         addChild(this._lblCurrEffect);
         this._lblUpEffect = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblUpEffect");
         this._lblUpEffect.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.upEffect");
         addChild(this._lblUpEffect);
         this._lblCurrExp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblCurrentExp");
         this._lblCurrExp.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.currExp");
         addChild(this._lblCurrExp);
         this._lblUpExp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblUpExp");
         this._lblUpExp.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.upExp");
         addChild(this._lblUpExp);
         this._txtCurrLv = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtCurrLv");
         addChild(this._txtCurrLv);
         this._txtCurrEffect = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtCurrEffect");
         addChild(this._txtCurrEffect);
         this._txtUpEffect = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtUpEffect");
         addChild(this._txtUpEffect);
         this._txtCurrExp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtCurrExp");
         addChild(this._txtCurrExp);
         this._txtUpExp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtUpExp");
         addChild(this._txtUpExp);
         this._sbtnGroup = new SelectedButtonGroup();
         this._sbtnHp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.hp");
         this._sbtnHp.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.HP));
         this._sbtnGroup.addSelectItem(this._sbtnHp);
         addChild(this._sbtnHp);
         this._sbtnAtt = ComponentFactory.Instance.creatComponentByStylename("texpSystem.att");
         this._sbtnAtt.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.ATT));
         this._sbtnGroup.addSelectItem(this._sbtnAtt);
         addChild(this._sbtnAtt);
         this._sbtnDef = ComponentFactory.Instance.creatComponentByStylename("texpSystem.def");
         this._sbtnDef.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.DEF));
         this._sbtnGroup.addSelectItem(this._sbtnDef);
         addChild(this._sbtnDef);
         this._sbtnSpd = ComponentFactory.Instance.creatComponentByStylename("texpSystem.spd");
         this._sbtnSpd.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.SPD));
         this._sbtnGroup.addSelectItem(this._sbtnSpd);
         addChild(this._sbtnSpd);
         this._sbtnLuk = ComponentFactory.Instance.creatComponentByStylename("texpSystem.luk");
         this._sbtnLuk.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.LUK));
         this._sbtnGroup.addSelectItem(this._sbtnLuk);
         addChild(this._sbtnLuk);
         this._btnTexp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.btnTexp");
         addChild(this._btnTexp);
         this._btnBuy = ComponentFactory.Instance.creat("texpSystem.btnBuy");
         this._btnBuy.setup(EquipType.TEXP_LV_II);
         addChild(this._btnBuy);
         this._btnHelp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.btnHelp");
         addChild(this._btnHelp);
         this._buff = ComponentFactory.Instance.creatComponentByStylename("buybuffBtnI");
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("buybuffBtnPos");
         addChild(this._buff);
         this._buff.x = _loc1_.x;
         this._buff.y = _loc1_.y;
         this._sbtnGroup.selectIndex = -1;
      }
      
      private function refresh() : void
      {
         var _loc1_:BuffInfo = null;
         this.upBuff();
         for each(_loc1_ in this._buffs)
         {
            PayBuffButton(this._buff).addBuff(_loc1_);
         }
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
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this._sbtnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._sbtnAtt.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnHp.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnLuk.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnDef.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnSpd.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._btnTexp.addEventListener(MouseEvent.CLICK,this.__texpClick);
         this._btnBuy.addEventListener(MouseEvent.CLICK,this.__buyClick);
         this._btnHelp.addEventListener(MouseEvent.CLICK,this.__helpClick);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_HP,this.__onChange);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_ATT,this.__onChange);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_DEF,this.__onChange);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_SPD,this.__onChange);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_LUK,this.__onChange);
         this._buff.addEventListener(MouseEvent.CLICK,this.__buyBuff);
         this._buffData.addEventListener(DictionaryEvent.ADD,this.__addBuff);
         this._buffData.addEventListener(DictionaryEvent.REMOVE,this.__addBuff);
         this._buffData.addEventListener(DictionaryEvent.UPDATE,this.__addBuff);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         this._sbtnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._sbtnAtt.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnHp.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnLuk.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnDef.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnSpd.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._btnTexp.removeEventListener(MouseEvent.CLICK,this.__texpClick);
         this._btnBuy.removeEventListener(MouseEvent.CLICK,this.__buyClick);
         this._btnHelp.removeEventListener(MouseEvent.CLICK,this.__helpClick);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_HP,this.__onChange);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_ATT,this.__onChange);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_DEF,this.__onChange);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_SPD,this.__onChange);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_LUK,this.__onChange);
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
      
      public function clearInfo() : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         this._texpCell.info = null;
      }
      
      public function startShine() : void
      {
         this._texpCell.startShine();
      }
      
      public function stopShine() : void
      {
         this._texpCell.stopShine();
      }
      
      private function __updateStoreBag(param1:BagEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1.changedSlots)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ == 0)
            {
               this._texpCell.info = PlayerManager.Instance.Self.StoreBag.items[0];
            }
         }
      }
      
      private function __onChange(param1:TexpEvent) : void
      {
         switch(param1.type)
         {
            case TexpEvent.TEXP_HP:
               if(this._sbtnGroup.selectIndex == TexpType.HP)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
               break;
            case TexpEvent.TEXP_ATT:
               if(this._sbtnGroup.selectIndex == TexpType.ATT)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
               break;
            case TexpEvent.TEXP_DEF:
               if(this._sbtnGroup.selectIndex == TexpType.DEF)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
               break;
            case TexpEvent.TEXP_SPD:
               if(this._sbtnGroup.selectIndex == TexpType.SPD)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
               break;
            case TexpEvent.TEXP_LUK:
               if(this._sbtnGroup.selectIndex == TexpType.LUK)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
         }
      }
      
      private function __changeHandler(param1:Event) : void
      {
         this.setTexpInfo(this._sbtnGroup.selectIndex);
      }
      
      private function __texpTypeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
      }
      
      private function __texpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:InventoryItemInfo = this._texpCell.info as InventoryItemInfo;
         if(_loc2_)
         {
            if(_loc2_.CategoryID != EquipType.TEXP)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.typeError"));
               return;
            }
            if(this._sbtnGroup.selectIndex == -1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.selectType"));
               return;
            }
            if(TexpManager.Instance.getLv(TexpManager.Instance.getExp(this._sbtnGroup.selectIndex)) >= PlayerManager.Instance.Self.Grade + 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.lvToplimit"));
               return;
            }
            SocketManager.Instance.out.sendTexp(this._sbtnGroup.selectIndex,_loc2_.TemplateID,_loc2_.Place);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.empty"));
         }
      }
      
      private function __buyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         KeyboardShortcutsManager.Instance.prohibitNewHandBag(false);
         var _loc2_:ShopBugleView = new ShopBugleView(EquipType.TEXP_LV_II);
      }
      
      private function __helpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("texpSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("texpSystem.view.TexpView.helpTitle");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("texpSystem.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("texpSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      private function setTexpInfo(param1:int) : void
      {
         var _loc2_:TexpInfo = TexpManager.Instance.getInfo(param1,TexpManager.Instance.getExp(param1));
         this._lblTexpName.text = TexpManager.Instance.getName(param1) + LanguageMgr.GetTranslation("texpSystem.view.TexpView.texp");
         this._txtCurrLv.text = _loc2_.lv.toString();
         this._txtCurrEffect.text = _loc2_.currEffect.toString();
         this._txtUpEffect.text = _loc2_.upEffect.toString();
         this._txtCurrExp.text = _loc2_.currExp.toString();
         this._txtUpExp.text = _loc2_.upExp.toString();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearInfo();
         ObjectUtils.disposeAllChildren(this);
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._bg4 = null;
         this._txtBg1 = null;
         this._txtBg2 = null;
         this._bmpLine = null;
         this._texpCell = null;
         this._lblTexpName = null;
         this._lblTexpExp = null;
         this._lblCurrLv = null;
         this._lblCurrEffect = null;
         this._lblUpEffect = null;
         this._lblCurrExp = null;
         this._lblUpExp = null;
         this._txtCurrLv = null;
         this._txtCurrEffect = null;
         this._txtUpEffect = null;
         this._txtCurrExp = null;
         this._txtUpExp = null;
         this._sbtnGroup = null;
         this._sbtnAtt = null;
         this._sbtnHp = null;
         this._sbtnLuk = null;
         this._sbtnDef = null;
         this._sbtnSpd = null;
         this._btnTexp = null;
         this._btnBuy = null;
         this._btnHelp = null;
         this._buff = null;
         if(this._helpFrame)
         {
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._btnOk.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            ObjectUtils.disposeObject(this._bgHelp);
            ObjectUtils.disposeObject(this._content);
            ObjectUtils.disposeObject(this._btnOk);
            this._bgHelp = null;
            this._content = null;
            this._btnOk = null;
            this._helpFrame.dispose();
            this._helpFrame = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
