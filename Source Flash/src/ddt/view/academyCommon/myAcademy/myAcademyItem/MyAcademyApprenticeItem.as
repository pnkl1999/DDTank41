package ddt.view.academyCommon.myAcademy.myAcademyItem
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class MyAcademyApprenticeItem extends MyAcademyMasterItem implements Disposeable
   {
       
      
      public function MyAcademyApprenticeItem()
      {
         super();
      }
      
      override protected function initComponent() : void
      {
         _removeGold = 20000;
         _sexIcon.visible = true;
         PositionUtils.setPos(_stateTxt,"academyCommon.myAcademy.MyAcademyApprenticeItem.stateTxt");
         PositionUtils.setPos(_removeBtn,"academyCommon.myAcademy.MyAcademyApprenticeItem.removeBtn");
         PositionUtils.setPos(_levelIcon,"academyCommon.myAcademy.MyAcademyApprenticeItem.levelIcon");
         PositionUtils.setPos(_sexIcon,"academyCommon.myAcademy.MyAcademyApprenticeItem.sexIcon");
         PositionUtils.setPos(_emailBtn,"academyCommon.myAcademy.MyAcademyApprenticeItem.emailBtn");
      }
      
      override protected function __removeClick(param1:MouseEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         var _loc4_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
         if(!getTimerOvertop())
         {
            _loc2_.data = LanguageMgr.GetTranslation("ddt.view.academyCommon.myAcademy.MyAcademyMasterItem.remove",_info.NickName);
            _loc3_ = AlertManager.Instance.alert("academySimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         }
         else
         {
            _loc2_.data = LanguageMgr.GetTranslation("ddt.view.academyCommon.myAcademy.MyAcademyApprenticeItem.removeIII",_info.NickName);
            _loc4_ = AlertManager.Instance.alert("academySimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
            _loc4_.addEventListener(FrameEvent.RESPONSE,__alerFrameEvent);
         }
      }
      
      override protected function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (param1.currentTarget as BaseAlerFrame).dispose();
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Gold >= 20000)
               {
                  this.submit();
                  break;
               }
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,__quickBuyResponse);
               break;
         }
      }
      
      override protected function submit() : void
      {
         SocketManager.Instance.out.sendAcademyFireApprentice(_info.ID);
      }
   }
}
