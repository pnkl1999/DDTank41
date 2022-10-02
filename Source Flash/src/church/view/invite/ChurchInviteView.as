package church.view.invite
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import invite.data.InvitePlayerInfo;
   
   public class ChurchInviteView extends BaseAlerFrame
   {
       
      
      private var _bg:Bitmap;
      
      private var _controller:ChurchInviteController;
      
      private var _model:ChurchInviteModel;
      
      private var _alertInfo:AlertInfo;
      
      private var _currentTab:int;
      
      private var _refleshCount:int;
      
      private var _listPanel:ListPanel;
      
      private var _inviteFriendBtn:ScaleFrameImage;
      
      private var _inviteConsortiaBtn:ScaleFrameImage;
      
      private var _currentList:Array;
      
      public function ChurchInviteView()
      {
         super();
         this.setView();
      }
      
      private function setView() : void
      {
         this._refleshCount = 0;
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("tank.invite.InviteView.list");
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.room.guestInviteBgAsset");
         addToContent(this._bg);
         this._inviteFriendBtn = ComponentFactory.Instance.creat("church.room.inviteFriendBtnAsset");
         this._inviteFriendBtn.setFrame(1);
         this._inviteFriendBtn.buttonMode = true;
         addToContent(this._inviteFriendBtn);
         this._inviteConsortiaBtn = ComponentFactory.Instance.creat("church.room.inviteConsortiaBtnAsset");
         this._inviteConsortiaBtn.setFrame(2);
         this._inviteConsortiaBtn.buttonMode = true;
         addToContent(this._inviteConsortiaBtn);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("church.room.invitePlayerListAsset");
         addToContent(this._listPanel);
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._model.addEventListener(ChurchInviteModel.LIST_UPDATE,this.listUpdate);
         this._inviteFriendBtn.addEventListener(MouseEvent.CLICK,this.onTabClick);
         this._inviteConsortiaBtn.addEventListener(MouseEvent.CLICK,this.onTabClick);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.hide();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.sumbitConfirm();
         }
      }
      
      private function sumbitConfirm(param1:MouseEvent = null) : void
      {
         SoundManager.instance.play("008");
         this._controller.refleshList(this._currentTab);
      }
      
      private function onTabClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._inviteFriendBtn:
               if(this._currentTab == 0)
               {
                  return;
               }
               this._currentTab = 0;
               this._inviteFriendBtn.setFrame(1);
               this._inviteConsortiaBtn.setFrame(2);
               break;
            case this._inviteConsortiaBtn:
               if(this._currentTab == 1)
               {
                  return;
               }
               this._currentTab = 1;
               this._inviteFriendBtn.setFrame(2);
               this._inviteConsortiaBtn.setFrame(1);
               break;
         }
         this._controller.refleshList(this._currentTab);
      }
      
      private function listUpdate(param1:Event = null) : void
      {
         var _loc4_:InvitePlayerInfo = null;
         var _loc5_:PlayerInfo = null;
         var _loc6_:InvitePlayerInfo = null;
         var _loc7_:ConsortiaPlayerInfo = null;
         this._currentList = [];
         var _loc2_:int = 0;
         while(_loc2_ < this._model.currentList.length)
         {
            if(this._model.currentList[_loc2_] is PlayerInfo)
            {
               _loc4_ = new InvitePlayerInfo();
               _loc5_ = this._model.currentList[_loc2_] as PlayerInfo;
               _loc4_.NickName = _loc5_.NickName;
               _loc4_.Sex = _loc5_.Sex;
               _loc4_.Grade = _loc5_.Grade;
               _loc4_.Repute = _loc5_.Repute;
               _loc4_.WinCount = _loc5_.WinCount;
               _loc4_.TotalCount = _loc5_.TotalCount;
               _loc4_.FightPower = _loc5_.FightPower;
               _loc4_.ID = _loc5_.ID;
               _loc4_.Offer = _loc5_.Offer;
               _loc4_.typeVIP = _loc5_.typeVIP;
               _loc4_.invited = false;
               this._currentList.push(_loc4_);
            }
            else if(this._model.currentList[_loc2_] is ConsortiaPlayerInfo)
            {
               _loc6_ = new InvitePlayerInfo();
               _loc7_ = this._model.currentList[_loc2_] as ConsortiaPlayerInfo;
               _loc6_.NickName = _loc7_.NickName;
               _loc6_.Sex = _loc7_.Sex;
               _loc6_.Grade = _loc7_.Grade;
               _loc6_.Repute = _loc7_.Repute;
               _loc6_.WinCount = _loc7_.WinCount;
               _loc6_.TotalCount = _loc7_.TotalCount;
               _loc6_.FightPower = _loc7_.FightPower;
               _loc6_.ID = _loc7_.ID;
               _loc6_.Offer = _loc7_.Offer;
               _loc6_.typeVIP = _loc7_.typeVIP;
               _loc6_.invited = false;
               this._currentList.push(_loc6_);
            }
            _loc2_++;
         }
         this._listPanel.vectorListModel.clear();
         var _loc3_:int = 0;
         while(_loc3_ < this._model.currentList.length)
         {
            this._listPanel.vectorListModel.insertElementAt(this._currentList[_loc3_],_loc3_);
            _loc3_++;
         }
         this._listPanel.list.updateListView();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true);
         this.setEvent();
         this.listUpdate();
         this._controller.refleshList(this._currentTab);
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get model() : ChurchInviteModel
      {
         return this._model;
      }
      
      public function set model(param1:ChurchInviteModel) : void
      {
         this._model = param1;
      }
      
      public function get controller() : ChurchInviteController
      {
         return this._controller;
      }
      
      public function set controller(param1:ChurchInviteController) : void
      {
         this._controller = param1;
      }
      
      private function removeEvent() : void
      {
         if(this._model)
         {
            this._model.removeEventListener(ChurchInviteModel.LIST_UPDATE,this.listUpdate);
         }
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(this._inviteFriendBtn)
         {
            this._inviteFriendBtn.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         }
         if(this._inviteConsortiaBtn)
         {
            this._inviteConsortiaBtn.removeEventListener(MouseEvent.CLICK,this.onTabClick);
         }
      }
      
      private function removeView() : void
      {
         this._controller = null;
         this._model = null;
         this._alertInfo = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._listPanel);
         this._listPanel = null;
         ObjectUtils.disposeObject(this._inviteFriendBtn);
         this._inviteFriendBtn = null;
         ObjectUtils.disposeObject(this._inviteConsortiaBtn);
         this._inviteConsortiaBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}
