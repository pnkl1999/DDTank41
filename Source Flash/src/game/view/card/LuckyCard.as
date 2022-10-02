package game.view.card
{
   import bagAndInfo.cell.BagCell;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quint;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import game.GameManager;
   import game.model.Player;
   import room.RoomManager;
   import room.model.RoomInfo;
   import vip.VipController;
   
   public class LuckyCard extends Sprite implements Disposeable
   {
      
      public static const AFTER_GAME_CARD:int = 0;
      
      public static const WITHIN_GAME_CARD:int = 1;
       
      
      public var allowClick:Boolean;
      
      public var msg:String;
      
      public var isPayed:Boolean;
      
      private var _idx:int;
      
      private var _cardType:int;
      
      private var _luckyCardMc:MovieClip;
      
      private var _info:Player;
      
      private var _templateID:int;
      
      private var _count:int;
      
      private var _isVip:Boolean;
      
      private var _nickName:FilterFrameText;
      
      private var _itemName:FilterFrameText;
      
      private var _vipNameTxt:GradientText;
      
      private var _itemCell:BagCell;
      
      private var _itemGoldTxt:Bitmap;
      
      private var _itemBitmap:Bitmap;
      
      private var _goldTxt:FilterFrameText;
      
      private var _overShape:Sprite;
      
      private var _overEffect:GlowFilter;
      
      private var _overEffectPoint:Point;
      
      private var _payAlert:BaseAlerFrame;
      
      public function LuckyCard(param1:int, param2:int)
      {
         super();
         this._idx = param1;
         this._cardType = param2;
         this.init();
      }
      
      private function init() : void
      {
         buttonMode = true;
         this._overShape = new Sprite();
         this._overShape.graphics.lineStyle(1.8,16777215);
         this._overShape.graphics.drawRoundRect(4,2,100,148,15,15);
         this._overEffect = ComponentFactory.Instance.model.getSet("takeoutCard.LuckyCardOverFilter");
         this._overShape.filters = [this._overEffect];
         this._luckyCardMc = ComponentFactory.Instance.creat("asset.takeoutCard.LuckyCard");
         this._luckyCardMc.addEventListener(Event.ENTER_FRAME,this.__checkMovie);
         addChild(this._luckyCardMc);
      }
      
      private function __checkMovie(param1:Event) : void
      {
         if(this._luckyCardMc.numChildren == 5)
         {
            if(this._luckyCardMc.cardMc.totalFrames == 5)
            {
               this._luckyCardMc.removeEventListener(Event.ENTER_FRAME,this.__checkMovie);
               this._luckyCardMc.cardMc.addFrameScript(this._luckyCardMc.cardMc.totalFrames - 1,this.showResult);
            }
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         buttonMode = param1;
         if(param1)
         {
            this._overEffectPoint = new Point(y,y - 14);
            addEventListener(MouseEvent.CLICK,this.__onClick);
            addEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
            addEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.__onClick);
            removeEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
            removeEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
            this.__onRollOut();
         }
      }
      
      private function __onRollOver(param1:MouseEvent = null) : void
      {
         if(!this._overEffectPoint)
         {
            return;
         }
         addChild(this._overShape);
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.3,{
            "y":this._overEffectPoint.y,
            "ease":Quint.easeOut
         });
      }
      
      private function __onRollOut(param1:MouseEvent = null) : void
      {
         if(!this._overEffectPoint)
         {
            return;
         }
         if(contains(this._overShape))
         {
            removeChild(this._overShape);
         }
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.3,{
            "y":this._overEffectPoint.x,
            "ease":Quint.easeOut
         });
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
         if(this.allowClick)
         {
            SoundManager.instance.play("008");
            if(this.isPayed)
            {
               if(GameManager.Instance.Current.selfGamePlayer.hasGardGet)
               {
                  GameInSocketOut.sendPaymentTakeCard(this._idx);
                  GameManager.Instance.Current.selfGamePlayer.hasGardGet = false;
                  this.enabled = false;
               }
               else
               {
                  this.payAlert();
               }
            }
            else
            {
               if(RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
               {
                  GameInSocketOut.sendBossTakeOut(this._idx);
               }
               else if(this._cardType == WITHIN_GAME_CARD)
               {
                  GameInSocketOut.sendBossTakeOut(this._idx);
               }
               else
               {
                  GameInSocketOut.sendGameTakeOut(this._idx);
               }
               this.enabled = false;
            }
         }
         else
         {
            MessageTipManager.getInstance().show(this.msg);
         }
      }
      
      private function payAlert() : void
      {
         var _loc1_:String = null;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.gameover.payConfirm.contentVip");
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.gameover.payConfirm.contentCommon");
         }
         this._payAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.gameover.payConfirm.title"),_loc1_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         if(this._payAlert.parent)
         {
            this._payAlert.parent.removeChild(this._payAlert);
         }
         LayerManager.Instance.addToLayer(this._payAlert,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this._payAlert.addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this.__onRollOut();
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         this._payAlert.removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            GameInSocketOut.sendPaymentTakeCard(this._idx);
            this.enabled = false;
         }
         ObjectUtils.disposeObject(this._payAlert);
         this._payAlert = null;
      }
      
      public function play(param1:Player, param2:int, param3:int, param4:Boolean) : void
      {
         this._info = param1;
         this._templateID = param2;
         this._count = param3;
         this._isVip = param4;
         if(!param1 || !this._info.isSelf)
         {
            this._luckyCardMc.lightFrame.visible = false;
            this._luckyCardMc.vipLightFrame.visible = false;
            this._luckyCardMc.starMc.visible = false;
         }
         SoundManager.instance.play("048");
         if(param4)
         {
            this.openVipCard();
         }
         else
         {
            this.openNormalCard();
         }
         this.enabled = false;
      }
      
      private function openNormalCard() : void
      {
         this._luckyCardMc["lightFrame"].gotoAndPlay(2);
         this._luckyCardMc["cardMc"].gotoAndPlay(2);
         this._luckyCardMc["vipLightFrame"].gotoAndStop(1);
         this._luckyCardMc["vipCardMc"].gotoAndStop(1);
         this._luckyCardMc["starMc"].gotoAndPlay(2);
      }
      
      private function openVipCard() : void
      {
         this._luckyCardMc["lightFrame"].gotoAndStop(1);
         this._luckyCardMc["cardMc"].gotoAndPlay(2);
         this._luckyCardMc["vipLightFrame"].gotoAndPlay(2);
         this._luckyCardMc["vipCardMc"].gotoAndPlay(2);
         this._luckyCardMc["starMc"].gotoAndPlay(2);
      }
      
      private function showResult() : void
      {
         var textFormat:TextFormat = null;
         var tempInfo:ItemTemplateInfo = null;
         try
         {
            this._luckyCardMc["cardMc"].stop();
            return;
         }
         catch(e:Error)
         {
            return;
         }
         finally
         {
            if(this._info)
            {
               this._nickName = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.PlayerItemNameTxt");
               this._nickName.text = !!Boolean(this._info.playerInfo) ? this._info.playerInfo.NickName : "";
               if(this._info.playerInfo && this._info.playerInfo.IsVIP)
               {
                  this._vipNameTxt = VipController.instance.getVipNameTxt(90,this._info.playerInfo.typeVIP);
                  this._vipNameTxt.x = this._nickName.x;
                  this._vipNameTxt.y = this._nickName.y + 1;
                  textFormat = new TextFormat();
                  textFormat.align = "center";
                  textFormat.bold = true;
                  this._vipNameTxt.textField.defaultTextFormat = textFormat;
                  this._vipNameTxt.text = this._nickName.text;
                  addChild(this._vipNameTxt);
               }
               else
               {
                  addChild(this._nickName);
               }
            }
            if(this._templateID > 0)
            {
               this._itemCell = new BagCell(0);
               this._itemCell.BGVisible = false;
               this._itemName = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.CardItemNameTxt");
               tempInfo = ItemManager.Instance.getTemplateById(this._templateID);
               if(tempInfo && this._itemCell)
               {
                  this._itemCell.info = tempInfo;
                  this._itemName.text = tempInfo.Name;
                  this._itemCell.x = 32;
                  this._itemCell.y = 57;
                  this._itemCell.mouseChildren = false;
                  this._itemCell.mouseEnabled = false;
                  if(this._itemName.numLines > 1)
                  {
                     this._itemName.y -= 9;
                  }
                  addChild(this._itemCell);
                  addChild(this._itemName);
               }
            }
            else if(this._templateID == -100)
            {
               this._itemGoldTxt = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.GoldTxt");
               this._itemBitmap = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.GoldBitmap");
               this._goldTxt = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.GoldTxt");
               this._goldTxt.text = this._count.toString();
               addChild(this._itemGoldTxt);
               addChild(this._itemBitmap);
               addChild(this._goldTxt);
               if(this._info && this._info.isSelf)
               {
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.gameover.takecard.getgold",this._count));
               }
            }
            else if(this._templateID != -200)
            {
               if(this._templateID == -300)
               {
               }
            }
         }
      }
      
      public function dispose() : void
      {
         if(this._payAlert)
         {
            this._payAlert.removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         }
         removeEventListener(MouseEvent.CLICK,this.__onClick);
         removeEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
         ObjectUtils.disposeObject(this._luckyCardMc);
         this._luckyCardMc = null;
         ObjectUtils.disposeObject(this._nickName);
         this._nickName = null;
         ObjectUtils.disposeObject(this._itemName);
         this._itemName = null;
         ObjectUtils.disposeObject(this._vipNameTxt);
         this._vipNameTxt = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeObject(this._itemGoldTxt);
         this._itemGoldTxt = null;
         ObjectUtils.disposeObject(this._itemBitmap);
         this._itemBitmap = null;
         ObjectUtils.disposeObject(this._goldTxt);
         this._goldTxt = null;
         ObjectUtils.disposeObject(this._payAlert);
         this._payAlert = null;
         if(this._overShape && this._overShape.parent)
         {
            this._overShape.parent.removeChild(this._overShape);
         }
         this._overShape = null;
         this._overEffect = null;
         this._overEffectPoint = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
