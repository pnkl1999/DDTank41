package ddt.view.caddyII.reader
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatNamePanel;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import im.IMController;
   import im.IMView;
   
   public class AwardsItem extends Sprite implements Disposeable
   {
      
      public static const GOODSCLICK:String = "goods_click_awardsItem";
       
      
      private var _contentField:TextField;
      
      private var _info:AwardsInfo;
      
      private var _nameTip:ChatNamePanel;
      
      public function AwardsItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._contentField = ComponentFactory.Instance.creatCustomObject("caddy.readAward.ContentField");
         this._contentField.defaultTextFormat = ComponentFactory.Instance.model.getSet("caddy.readAward.ContentFieldTF");
         this._contentField.styleSheet = ChatFormats.styleSheet;
         addChild(this._contentField);
      }
      
      private function initEvents() : void
      {
         this._contentField.addEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function removeEvents() : void
      {
         this._contentField.removeEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function createMessage() : void
      {
         var _loc6_:String = null;
         var _loc1_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._info.TemplateId);
         var _loc2_:ChatData = new ChatData();
         var _loc3_:String = LanguageMgr.GetTranslation("tank.view.caddy.awardsPoint");
         var _loc4_:String = LanguageMgr.GetTranslation("tank.view.caddy.awardsGong");
         var _loc5_:String = "<font color=\'#c64100\'>" + ChatFormats.creatBracketsTag("[" + this._info.name + "] ",ChatFormats.CLICK_USERNAME) + "</font>";
         if(CaddyModel.instance.type == CaddyModel.BEAD_TYPE)
         {
            if(int(_loc1_.Property2) == 1)
            {
               _loc6_ = LanguageMgr.GetTranslation("tank.view.award.Attack");
            }
            else if(int(_loc1_.Property2) == 2)
            {
               _loc6_ = LanguageMgr.GetTranslation("tank.view.award.Defense");
            }
            else
            {
               _loc6_ = LanguageMgr.GetTranslation("tank.view.award.Attribute");
            }
         }
         else
         {
            _loc6_ = CaddyModel.instance.AwardsBuff;
         }
         var _loc7_:String = ChatFormats.creatGoodTag("[" + _loc1_.Name + "]",ChatFormats.CLICK_GOODS,_loc1_.TemplateID,_loc1_.Quality,true,_loc2_);
         if(this._info.isLong)
         {
            _loc2_.htmlMessage = _loc3_ + _loc4_ + LanguageMgr.GetTranslation("tank.view.award.Player") + _loc5_ + _loc6_ + _loc7_ + "(" + this._info.zone + ")";
         }
         else
         {
            _loc2_.htmlMessage = _loc3_ + _loc4_ + _loc5_ + _loc6_ + _loc7_;
         }
         this.setChats(_loc2_);
      }
      
      private function setChats(param1:ChatData) : void
      {
         var _loc2_:String = "";
         _loc2_ += Helpers.deCodeString(param1.htmlMessage);
         this._contentField.htmlText = "<a>" + _loc2_ + "</a>";
      }
      
      private function __onTextClicked(param1:TextEvent) : void
      {
         var _loc4_:Point = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:RegExp = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Point = null;
         var _loc15_:int = 0;
         var _loc16_:Rectangle = null;
         var _loc17_:Point = null;
         var _loc18_:ItemTemplateInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:Object = {};
         var _loc3_:Array = param1.text.split("|");
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_].indexOf(":"))
            {
               _loc6_ = _loc3_[_loc5_].split(":");
               _loc2_[_loc6_[0]] = _loc6_[1];
            }
            _loc5_++;
         }
         if(int(_loc2_.clicktype) == ChatFormats.CLICK_USERNAME)
         {
            _loc7_ = PlayerManager.Instance.Self.ZoneID;
            _loc8_ = this._info.zoneID;
            if(_loc8_ > 0 && _loc8_ != _loc7_)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
               return;
            }
            if(IMView.IS_SHOW_SUB)
            {
               dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,_loc2_.tagname));
            }
            else if(IMController.Instance.isFriend(String(_loc2_.tagname)))
            {
               IMEManager.enable();
               ChatManager.Instance.output.functionEnabled = true;
               ChatManager.Instance.privateChatTo(_loc2_.tagname);
            }
            else
            {
               if(this._nameTip == null)
               {
                  this._nameTip = ComponentFactory.Instance.creatCustomObject("chat.NamePanel");
               }
               _loc9_ = new RegExp(String(_loc2_.tagname),"g");
               _loc10_ = this._contentField.text;
               _loc11_ = _loc9_.exec(_loc10_);
               while(_loc11_ != null)
               {
                  _loc12_ = _loc11_.index;
                  _loc13_ = _loc12_ + String(_loc2_.tagname).length;
                  _loc14_ = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
                  _loc15_ = this._contentField.getCharIndexAtPoint(_loc14_.x,_loc14_.y);
                  if(_loc15_ >= _loc12_ && _loc15_ <= _loc13_)
                  {
                     this._contentField.setSelection(_loc12_,_loc13_);
                     _loc16_ = this._contentField.getCharBoundaries(_loc13_);
                     _loc17_ = this._contentField.localToGlobal(new Point(_loc16_.x,_loc16_.y));
                     this._nameTip.x = _loc17_.x + _loc16_.width;
                     this._nameTip.y = _loc17_.y - this._nameTip.getHeight;
                     break;
                  }
                  _loc11_ = _loc9_.exec(_loc10_);
               }
               ChatManager.Instance.privateChatTo(_loc2_.tagname);
               this._nameTip.playerName = String(_loc2_.tagname);
               this._nameTip.setVisible = true;
            }
         }
         else if(int(_loc2_.clicktype) == ChatFormats.CLICK_GOODS)
         {
            _loc4_ = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            _loc18_ = ItemManager.Instance.getTemplateById(_loc2_.templeteIDorItemID);
            _loc18_.BindType = _loc2_.isBind == "true" ? int(int(0)) : int(int(1));
            this._showLinkGoodsInfo(_loc18_);
         }
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      private function _showLinkGoodsInfo(param1:ItemTemplateInfo) : void
      {
         var _loc2_:Point = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
         var _loc3_:CaddyEvent = new CaddyEvent(AwardsItem.GOODSCLICK);
         _loc3_.itemTemplateInfo = param1;
         _loc3_.point = _loc2_;
         dispatchEvent(_loc3_);
      }
      
      public function set info(param1:AwardsInfo) : void
      {
         this._info = param1;
         this.createMessage();
      }
      
      public function get info() : AwardsInfo
      {
         return this._info;
      }
      
      override public function get height() : Number
      {
         return this._contentField.textHeight + 5;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._info = null;
         if(this._contentField)
         {
            ObjectUtils.disposeObject(this._contentField);
         }
         this._contentField = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
