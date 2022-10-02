package cardSystem.view
{
   import cardSystem.data.CardInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryEvent;
   
   public class PropResetFrame extends BaseAlerFrame
   {
       
      
      private var _cardInfo:CardInfo;
      
      private var _cardCell:ResetCardCell;
      
      private var _count:FilterFrameText;
      
      private var _basicPropVec1:Vector.<FilterFrameText>;
      
      private var _basicPropVec2:Vector.<FilterFrameText>;
      
      private var _oldPropVec:Vector.<FilterFrameText>;
      
      private var _newPropVec:Vector.<FilterFrameText>;
      
      private var _basePropContainer1:VBox;
      
      private var _basePropContainer2:VBox;
      
      private var _oldPropContainer:VBox;
      
      private var _newPropContainer:VBox;
      
      private var _canReplace:Boolean;
      
      private var _isFirst:Boolean = true;
      
      private var _bg1:Scale9CornerImage;
      
      private var _bg2:Scale9CornerImage;
      
      private var _bg3:Scale9CornerImage;
      
      private var _back:MovieClip;
      
      private var _alertInfo:AlertInfo;
      
      private var _helpButton:BaseButton;
      
      private var _propertyPool:Object;
      
      private var _propertys:Vector.<PropertyEmu>;
      
      private var _sendReplace:Boolean = false;
      
      public function PropResetFrame()
      {
         this._propertyPool = new Object();
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc2_:FilterFrameText = null;
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG1");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG2");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.BG3");
         addToContent(this._bg1);
         addToContent(this._bg2);
         addToContent(this._bg3);
         this._back = ClassUtils.CreatInstance("asset.cardSystem.reset.Back") as MovieClip;
         PositionUtils.setPos(this._back,"resetFrame.bgPos");
         addToContent(this._back);
         this._helpButton = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.Help");
         addToContent(this._helpButton);
         escEnable = true;
         this._basicPropVec1 = new Vector.<FilterFrameText>(4);
         this._basicPropVec2 = new Vector.<FilterFrameText>(4);
         this._oldPropVec = new Vector.<FilterFrameText>(4);
         this._newPropVec = new Vector.<FilterFrameText>(4);
         this._cardCell = ComponentFactory.Instance.creatCustomObject("PropResetCell");
         this._count = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.count");
         PositionUtils.setPos(this._count,"PropResetFrame.countPos");
         this._basePropContainer1 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.basePropContainer1");
         this._basePropContainer2 = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.basePropContainer2");
         this._oldPropContainer = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.oldPropContainer");
         this._newPropContainer = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.newPropContainer");
         var _loc1_:int = 0;
         while(_loc1_ < 16)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.PropText");
            if(_loc1_ < 4)
            {
               this._basicPropVec1[_loc1_] = _loc2_;
               this._basePropContainer1.addChild(this._basicPropVec1[_loc1_]);
            }
            else if(_loc1_ < 8)
            {
               this._basicPropVec2[_loc1_ % 4] = _loc2_;
               this._basePropContainer2.addChild(this._basicPropVec2[_loc1_ % 4]);
            }
            else if(_loc1_ < 12)
            {
               this._oldPropVec[_loc1_ % 4] = _loc2_;
               this._oldPropContainer.addChild(this._oldPropVec[_loc1_ % 4]);
            }
            else
            {
               this._newPropVec[_loc1_ % 4] = _loc2_;
               this._newPropContainer.addChild(this._newPropVec[_loc1_ % 4]);
            }
            _loc1_++;
         }
         addToContent(this._cardCell);
         addToContent(this._count);
         addToContent(this._basePropContainer1);
         addToContent(this._basePropContainer2);
         addToContent(this._oldPropContainer);
         addToContent(this._newPropContainer);
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.title");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.reset");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.replace");
         this._alertInfo.moveEnable = false;
         this._alertInfo.enterEnable = false;
         this._alertInfo.cancelEnabled = false;
         info = this._alertInfo;
      }
      
      private function newPropZero() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._newPropVec[_loc1_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop","0");
            _loc1_++;
         }
      }
      
      public function show(param1:CardInfo) : void
      {
         var _loc3_:int = 0;
         this._cardInfo = param1;
         this._cardCell.cardInfo = this._cardInfo;
         this._propertys = new Vector.<PropertyEmu>();
         if(this._cardInfo.realAttack > 0)
         {
            this._propertys.push(new PropertyEmu("Attack",0));
         }
         if(this._cardInfo.realDefence > 0)
         {
            this._propertys.push(new PropertyEmu("Defence",1));
         }
         if(this._cardInfo.realAgility > 0)
         {
            this._propertys.push(new PropertyEmu("Agility",2));
         }
         if(this._cardInfo.realLuck > 0)
         {
            this._propertys.push(new PropertyEmu("Luck",3));
         }
         if(this._cardInfo.realGuard > 0)
         {
            this._propertys.push(new PropertyEmu("Guard",4));
         }
         if(this._cardInfo.realDamage > 0)
         {
            this._propertys.push(new PropertyEmu("Damage",5));
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._propertys.length)
         {
            this._basicPropVec1[_loc2_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame." + this._propertys[_loc2_].key,this._cardInfo["real" + this._propertys[_loc2_].key]);
            _loc2_++;
         }
         this._count.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.count",this._cardInfo.Count);
         if(this._cardInfo.Attack != 0 || this._cardInfo.Defence != 0 || this._cardInfo.Agility != 0 || this._cardInfo.Luck || this._cardInfo.Guard != 0 || this._cardInfo.Damage != 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this._propertys.length)
            {
               this._oldPropVec[_loc3_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop",this._cardInfo[this._propertys[_loc3_].key] > 0 ? "+" + this._cardInfo[this._propertys[_loc3_].key] : this._cardInfo[this._propertys[_loc3_].key]);
               _loc3_++;
            }
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function set cardInfo(param1:CardInfo) : void
      {
         this._cardInfo = param1;
         this._propertys = new Vector.<PropertyEmu>();
         if(this._cardInfo.realAttack > 0)
         {
            this._propertys.push(new PropertyEmu("Attack",0));
         }
         if(this._cardInfo.realDefence > 0)
         {
            this._propertys.push(new PropertyEmu("Defence",1));
         }
         if(this._cardInfo.realAgility > 0)
         {
            this._propertys.push(new PropertyEmu("Agility",2));
         }
         if(this._cardInfo.realLuck > 0)
         {
            this._propertys.push(new PropertyEmu("Luck",3));
         }
         if(this._cardInfo.realGuard > 0)
         {
            this._propertys.push(new PropertyEmu("Guard",4));
         }
         if(this._cardInfo.realDamage > 0)
         {
            this._propertys.push(new PropertyEmu("Damage",5));
         }
      }
      
      private function upView() : void
      {
         this._cardCell.cardInfo = this._cardInfo;
         this._count.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.count",this._cardInfo.Count);
         var _loc1_:int = 0;
         while(_loc1_ < this._propertys.length)
         {
            this._basicPropVec1[_loc1_].text = this._basicPropVec2[_loc1_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame." + this._propertys[_loc1_].key,this._cardInfo["real" + this._propertys[_loc1_].key]);
            _loc1_++;
         }
      }
      
      private function upOldProp(param1:CardInfo) : void
      {
         var _loc3_:* = null;
         var _loc2_:int = 0;
         for(_loc3_ in this._propertyPool)
         {
            this._oldPropVec[_loc2_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop",param1[_loc3_] > 0 ? "+" + param1[_loc3_] : param1[_loc3_]);
            _loc2_++;
         }
      }
      
      private function upNewProp(param1:CardInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._propertys.length)
         {
            this._basicPropVec1[_loc2_].text = this._basicPropVec2[_loc2_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame." + this._propertys[_loc2_].key,this._cardInfo["real" + this._propertys[_loc2_].key]);
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARD_RESET,this.__reset);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this.__upDate);
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._helpButton.addEventListener(MouseEvent.CLICK,this.__helpOpen);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               this.__resethandler(null);
               break;
            case FrameEvent.CANCEL_CLICK:
               this.__replaceHandler(null);
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CARD_RESET,this.__reset);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this.__upDate);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._helpButton.removeEventListener(MouseEvent.CLICK,this.__helpOpen);
      }
      
      protected function __upDate(param1:DictionaryEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:CardInfo = param1.data as CardInfo;
         this.cardInfo = _loc2_;
         if(this._sendReplace)
         {
            this.upView();
            _loc3_ = 0;
            while(_loc3_ < this._newPropVec.length)
            {
               this._newPropVec[_loc3_].text = "";
               this._basicPropVec2[_loc3_].text = "";
               _loc3_++;
            }
            if(this._cardInfo.Attack != 0 || this._cardInfo.Defence != 0 || this._cardInfo.Agility != 0 || this._cardInfo.Luck || this._cardInfo.Guard != 0 || this._cardInfo.Damage != 0)
            {
               _loc4_ = 0;
               while(_loc4_ < this._propertys.length)
               {
                  this._oldPropVec[_loc4_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop",this._cardInfo[this._propertys[_loc4_].key] > 0 ? "+" + this._cardInfo[this._propertys[_loc4_].key] : this._cardInfo[this._propertys[_loc4_].key]);
                  _loc4_++;
               }
            }
            this._sendReplace = false;
         }
         this._count.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.count",this._cardInfo.Count);
      }
      
      protected function __replaceHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._canReplace)
         {
            SocketManager.Instance.out.sendReplaceCardProp(this._cardInfo.Place);
            this.setReplaceAbled(false);
            this._alertInfo.cancelEnabled = false;
            this._sendReplace = true;
         }
      }
      
      protected function __resethandler(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._cardInfo.Count < 3)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.EmptyCard"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__emptyCardResponse);
         }
         else
         {
            SocketManager.Instance.out.sendCardReset(this._cardInfo.Place);
            this._alertInfo.submitEnabled = false;
            this.setReplaceAbled(true);
         }
      }
      
      private function __emptyCardResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__emptyCardResponse);
         _loc2_.dispose();
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Money >= 300)
               {
                  SocketManager.Instance.out.sendCardReset(this._cardInfo.Place);
                  this.setReplaceAbled(true);
               }
               else
               {
                  LeavePageManager.showFillFrame();
               }
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               StageReferance.stage.focus = this;
         }
      }
      
      private function setReplaceAbled(param1:Boolean) : void
      {
         this._alertInfo.cancelEnabled = this._canReplace = param1;
      }
      
      protected function __noReplaceHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.newPropZero();
      }
      
      private function __reset(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_.push(_loc2_.readInt());
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < this._propertys.length)
         {
            this._newPropVec[_loc6_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.prop",_loc4_[this._propertys[_loc6_].idx] > 0 ? "+" + _loc4_[this._propertys[_loc6_].idx] : _loc4_[this._propertys[_loc6_].idx]);
            this._basicPropVec2[_loc6_].text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame." + this._propertys[_loc6_].key,this._cardInfo["real" + this._propertys[_loc6_].key]);
            _loc6_++;
         }
         this._alertInfo.submitEnabled = true;
         this._alertInfo.cancelEnabled = true;
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         if(this._cardCell)
         {
            this._cardCell.dispose();
         }
         this._cardCell = null;
         super.dispose();
         this.removeEvent();
         this._count = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._basicPropVec1[_loc1_] = null;
            this._basicPropVec2[_loc1_] = null;
            this._oldPropVec[_loc1_] = null;
            this._newPropVec[_loc1_] = null;
            _loc1_++;
         }
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._basePropContainer1 = null;
         this._basePropContainer2 = null;
         this._oldPropContainer = null;
         this._newPropContainer = null;
         this._back = null;
         this._helpButton = null;
         this._propertyPool = null;
         this._propertys = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      private function __helpOpen(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:DisplayObject = ComponentFactory.Instance.creatComponentByStylename("Scale9CornerImage17");
         var _loc3_:DisplayObject = ComponentFactory.Instance.creat("asset.cardSystem.reset.help.content");
         PositionUtils.setPos(_loc3_,"resetFrame.help.contentPos");
         var _loc4_:AlertInfo = new AlertInfo();
         _loc4_.title = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.help.title");
         _loc4_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc4_.showCancel = false;
         _loc4_.moveEnable = false;
         var _loc5_:BaseAlerFrame = ComponentFactory.Instance.creatComponentByStylename("PropResetFrame.HelpFrame");
         _loc5_.info = _loc4_;
         _loc5_.addToContent(_loc2_);
         _loc5_.addToContent(_loc3_);
         _loc5_.addEventListener(FrameEvent.RESPONSE,this.__helpResponse);
         LayerManager.Instance.addToLayer(_loc5_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __helpResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__helpResponse);
         _loc2_.dispose();
         SoundManager.instance.play("008");
         StageReferance.stage.focus = this;
      }
   }
}

class PropertyEmu
{
    
   
   public var key:String;
   
   public var idx:int;
   
   function PropertyEmu(param1:String, param2:int)
   {
      super();
      this.key = param1;
      this.idx = param2;
   }
}
