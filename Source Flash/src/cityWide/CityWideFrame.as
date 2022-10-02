package cityWide
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.character.RoomCharacter;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class CityWideFrame extends BaseAlerFrame
   {
       
      
      private var _alertInfo:AlertInfo;
      
      private var _vipName:GradientText;
      
      private var _nickNameText:FilterFrameText;
      
      private var _vipNamePoint:Point;
      
      private var _playerView:ICharacter;
      
      private var _cityWideBg:Bitmap;
      
      private var _cityWideTextBg:Bitmap;
      
      private var _addFriend:BaseButton;
      
      private var _addFriendEff:Bitmap;
      
      private var _addFriendSpeed:int;
      
      private var _playerViewPoint:Point;
      
      private var _playerInfo:PlayerInfo;
      
      public function CityWideFrame()
      {
         super();
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         this._playerInfo = param1;
      }
      
      private function setView() : void
      {
         this._addFriendSpeed = -1;
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("cityWideFrame.ONSTitle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._vipNamePoint = ComponentFactory.Instance.creatCustomObject("VipNamePoint");
         if(this._playerInfo.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(138,this._playerInfo.typeVIP);
            this._vipName.textSize = 18;
            this._vipName.x = this._vipNamePoint.x;
            this._vipName.y = this._vipNamePoint.y;
            this._vipName.text = this._playerInfo.NickName as String;
            addToContent(this._vipName);
            DisplayUtils.removeDisplay(this._nickNameText);
         }
         else
         {
            this._nickNameText = ComponentFactory.Instance.creatComponentByStylename("cityWide.CityWideFrame.nickNameText");
            this._nickNameText.text = this._playerInfo.NickName as String;
            addChild(this._nickNameText);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._cityWideBg = ComponentFactory.Instance.creatBitmap("cityWide.cityWideBg");
         addToContent(this._cityWideBg);
         this._playerView = CharactoryFactory.createCharacter(this._playerInfo,"room");
         RoomCharacter(this._playerView).showGun = false;
         this._playerView.show();
         this._playerView.setShowLight(true);
         this._playerViewPoint = ComponentFactory.Instance.creatCustomObject("playerViewPoint");
         this._playerView.x = this._playerViewPoint.x;
         this._playerView.y = this._playerViewPoint.y;
         this._playerView.scaleX = -1;
         addToContent(this._playerView as DisplayObject);
         this._cityWideTextBg = ComponentFactory.Instance.creatBitmap("cityWide.cityWideTextBg");
         addToContent(this._cityWideTextBg);
         this._addFriend = ComponentFactory.Instance.creatComponentByStylename("cityWide.CityWideFrame.addFriendBt");
         addToContent(this._addFriend);
         this._addFriendEff = ComponentFactory.Instance.creatBitmap("cityWide.addFriendBtEff");
         addToContent(this._addFriendEff);
      }
      
      public function show() : void
      {
         this.setView();
         this.setEvent();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function setList(param1:Array) : void
      {
      }
      
      private function _thisInFrame(param1:Event) : void
      {
         if(this._addFriendEff.alpha >= 1)
         {
            this._addFriendSpeed = -1;
            this._addFriendEff.alpha = 0.9;
         }
         else if(this._addFriendEff.alpha <= 0)
         {
            this._addFriendSpeed = 1;
            this._addFriendEff.alpha = 0.1;
         }
         else
         {
            this._addFriendEff.alpha += this._addFriendSpeed * 0.1;
         }
      }
      
      private function _clickaddFriend(param1:MouseEvent) : void
      {
         this.dispose();
         SoundManager.instance.play("008");
         dispatchEvent(new Event("submit"));
      }
      
      private function removeView() : void
      {
         this._alertInfo = null;
         this._vipNamePoint = null;
         this._playerInfo = null;
         if(this._nickNameText)
         {
            ObjectUtils.disposeObject(this._nickNameText);
         }
         this._nickNameText = null;
         if(this._playerView)
         {
            ObjectUtils.disposeObject(this._playerView);
         }
         this._playerView = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this._cityWideBg)
         {
            ObjectUtils.disposeObject(this._cityWideBg);
         }
         this._cityWideBg = null;
         if(this._cityWideTextBg)
         {
            ObjectUtils.disposeObject(this._cityWideTextBg);
         }
         this._cityWideTextBg = null;
         if(this._addFriend)
         {
            ObjectUtils.disposeObject(this._addFriend);
         }
         this._addFriend = null;
         if(this._addFriendEff)
         {
            ObjectUtils.disposeObject(this._addFriendEff);
         }
         this._addFriendEff = null;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         addEventListener(Event.ENTER_FRAME,this._thisInFrame);
         this._addFriend.addEventListener(MouseEvent.CLICK,this._clickaddFriend);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         removeEventListener(Event.ENTER_FRAME,this._thisInFrame);
         this._addFriend.removeEventListener(MouseEvent.CLICK,this._clickaddFriend);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               dispatchEvent(new Event("close"));
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.dispose();
               dispatchEvent(new Event("submit"));
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
         super.dispose();
      }
   }
}
