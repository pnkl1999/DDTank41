package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SelfConsortiaView extends Sprite implements Disposeable
   {
       
      
      private var _BG:MovieClip;
      
      private var _BG2:Bitmap;
      
      private var _infoView:ConsortionInfoView;
      
      private var _memberList:MemberList;
      
      private var _placardAndEvent:PlacardAndEvent;
      
      private var _buildingManager:BuildingManager;
      
      private var _DissolveConsortia:TextButton;
      
      public function SelfConsortiaView()
      {
         super();
      }
      
      public function enterSelfConsortion() : void
      {
         ConsortionModelControl.Instance.getConsortionMember(ConsortionModelControl.Instance.memberListComplete);
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete,1,6,"",-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._DissolveConsortia = ComponentFactory.Instance.creat("DissolveConsortia");
         this._DissolveConsortia.text = "赶紧解散";
         this._BG = ClassUtils.CreatInstance("asset.consortion.BG") as MovieClip;
         PositionUtils.setPos(this._BG,"consortionClub.BG.pos");
         this._BG2 = ComponentFactory.Instance.creatBitmap("asset.consortion.BG2");
         this._infoView = ComponentFactory.Instance.creatCustomObject("consortionInfoView");
         this._memberList = ComponentFactory.Instance.creatCustomObject("memberList");
         this._placardAndEvent = ComponentFactory.Instance.creatCustomObject("placardAndEvent");
         this._buildingManager = ComponentFactory.Instance.creatCustomObject("buildingManager");
         addChild(this._BG);
         addChild(this._BG2);
         addChild(this._infoView);
         addChild(this._memberList);
         addChild(this._placardAndEvent);
         addChild(this._buildingManager);
      }
      
      private function initEvent() : void
      {
      }
      
      private function __dissolve(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.sendConsortiaDismiss();
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._BG = null;
         this._BG2 = null;
         this._infoView = null;
         this._memberList = null;
         this._placardAndEvent = null;
         this._buildingManager = null;
         this._DissolveConsortia = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
