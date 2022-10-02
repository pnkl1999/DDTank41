package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CheckWeaponManager
   {
      
      private static var _instance:CheckWeaponManager;
       
      
      private var _alert:BaseAlerFrame;
      
      private var _skipCheck:Boolean;
      
      private var _funcObject:Object;
      
      private var _func:Function;
      
      private var _funcArgs:Array;
      
      public function CheckWeaponManager()
      {
         super();
      }
      
      public static function get instance() : CheckWeaponManager
      {
         if(!_instance)
         {
            _instance = new CheckWeaponManager();
         }
         return _instance;
      }
      
      public function setFunction(param1:Object, param2:Function = null, param3:Array = null) : void
      {
         _funcObject = param1;
         _func = param2;
         _funcArgs = param3;
      }
      
      public function isNoWeapon() : Boolean
      {
         if(!_skipCheck && PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            return true;
         }
         return false;
      }
      
      public function isNoWeaponFragment() : Boolean
      {
         if(!_skipCheck && PlayerManager.Instance.Self.Bag.getItemAt(20) == null)
         {
            return true;
         }
         return false;
      }
      
      public function showFragmentAlert() : void
      {
         ObjectUtils.disposeObject(_alert);
         _alert = null;
         _alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.battleRoom.noWeaponFragment"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",50,true);
         _alert.addEventListener("response",onWeaponFragmentResponse);
      }
      
      private function onWeaponFragmentResponse(param1:FrameEvent) : void
      {
         _alert.removeEventListener("response",onWeaponFragmentResponse);
         ObjectUtils.disposeObject(_alert);
         _alert = null;
         SoundManager.instance.play("008");
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            _funcArgs.push(true);
         }
         else
         {
            _funcArgs.push(false);
         }
         callBack();
      }
      
      public function showGoShopAlert() : void
      {
         ObjectUtils.disposeObject(_alert);
         _alert = null;
         _alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.ToShopConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2);
         _alert.addEventListener("response",__confirmToShopResponse);
      }
      
      private function __confirmToShopResponse(param1:FrameEvent) : void
      {
         _alert.removeEventListener("response",__confirmToShopResponse);
         ObjectUtils.disposeObject(_alert);
         _alert = null;
         SoundManager.instance.play("008");
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            StateManager.setState("shop");
         }
      }
      
      public function showAlert() : void
      {
         ObjectUtils.disposeObject(_alert);
         _alert = null;
         _alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",50,true);
         _alert.addEventListener("response",onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            _skipCheck = true;
            callBack();
         }
         _alert.removeEventListener("response",onFrameResponse);
         ObjectUtils.disposeObject(_alert);
         _alert = null;
      }
      
      private function callBack() : void
      {
         if(_funcObject != null && _func != null)
         {
            _func.apply(_funcObject,_funcArgs);
         }
         _funcObject = null;
         _func = null;
         _funcArgs = null;
         _skipCheck = false;
      }
   }
}
