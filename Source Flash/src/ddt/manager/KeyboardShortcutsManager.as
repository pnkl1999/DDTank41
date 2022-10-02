package ddt.manager
{
   import bagAndInfo.BagAndInfoManager;
   import calendar.CalendarManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.LayerManager;
   import ddt.states.StateType;
   import email.manager.MailManager;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import gotopage.view.GotoPageController;
   import im.IMController;
   import org.aswing.KeyStroke;
   import setting.controll.SettingController;
   
   public class KeyboardShortcutsManager
   {
      
      public static const GAME_PREPARE:int = 1;
      
      public static const GAME:int = 2;
      
      public static const BAG:int = 3;
      
      public static const FRIEND:int = 4;
      
      public static const GAME_WAIT:int = 5;
      
      private static var _instance:KeyboardShortcutsManager;
       
      
      private var isProhibit_B:Boolean;
      
      private var isProhibit_Q:Boolean;
      
      private var isProhibit_F:Boolean;
      
      private var isProhibit_G:Boolean;
      
      private var isProhibit_H:Boolean;
      
      private var isProhibit_T:Boolean;
      
      private var isProhibit_R:Boolean;
      
      private var isProhibit_S:Boolean;
      
      private var isFullForbid:Boolean;
      
      private var isProhibit_P:Boolean;
      
      private var isAddEvent:Boolean = true;
      
      private var isForbiddenSection:Boolean = true;
      
      private var isProhibitNewHand_B:Boolean = true;
      
      private var isProhibitNewHand_F:Boolean = true;
      
      private var isProhibitNewHand_T:Boolean = true;
      
      private var isProhibitNewHand_R:Boolean = true;
      
      private var isProhibitNewHand_S:Boolean = true;
      
      private var isProhibitNewHand_H:Boolean = true;
      
      private var isProhibitNewHand_P:Boolean = true;
      
      public function KeyboardShortcutsManager()
      {
         super();
      }
      
      public static function get Instance() : KeyboardShortcutsManager
      {
         if(_instance == null)
         {
            _instance = new KeyboardShortcutsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         if(this.isAddEvent)
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_UP,this.__onKeyDown);
            this.isAddEvent = false;
         }
      }
      
      private function __onKeyDown(param1:KeyboardEvent) : void
      {
         if(this.isFullForbid)
         {
            return;
         }
         if(this.isForbiddenSection)
         {
            this.getKeyboardShortcutsState();
         }
         if(param1.target is TextField && (param1.target as TextField).type == TextFieldType.INPUT)
         {
            return;
         }
         if(LayerManager.Instance.backGroundInParent)
         {
            this.closeCurrentFrame(param1.keyCode);
            return;
         }
         switch(param1.keyCode)
         {
            case KeyStroke.VK_B.getCode():
               if(this.isProhibit_B && this.isProhibitNewHand_B)
               {
                  SoundManager.instance.play("003");
                  StageReferance.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
                  BagAndInfoManager.Instance.showBagAndInfo();
               }
               break;
            case KeyStroke.VK_Q.getCode():
               if(this.isProhibit_Q)
               {
                  SoundManager.instance.play("003");
                  TaskManager.switchVisible();
               }
               break;
            case KeyStroke.VK_F.getCode():
               if(this.isProhibit_F && this.isProhibitNewHand_F)
               {
                  SoundManager.instance.play("003");
                  IMController.Instance.switchVisible();
               }
               break;
            case KeyStroke.VK_G.getCode():
               if(this.isProhibit_G)
               {
                  SoundManager.instance.play("003");
                  IMController.Instance.alertPrivateFrame();
               }
               break;
            case KeyStroke.VK_H.getCode():
               if(this.isProhibit_H && this.isProhibitNewHand_H)
               {
                  SoundManager.instance.play("003");
                  SettingController.Instance.switchVisible();
               }
               break;
            case KeyStroke.VK_T.getCode():
               if(this.isProhibit_T && this.isProhibitNewHand_T)
               {
                  SoundManager.instance.play("003");
                  GotoPageController.Instance.switchVisible();
               }
               break;
            case KeyStroke.VK_R.getCode():
               if(this.isProhibit_R && this.isProhibitNewHand_R)
               {
                  SoundManager.instance.play("003");
                  MailManager.Instance.switchVisible();
               }
               break;
            case KeyStroke.VK_S.getCode():
               if(this.isProhibit_S && this.isProhibitNewHand_S)
               {
                  SoundManager.instance.play("003");
                  CalendarManager.getInstance().open();
               }
			   break;
         }
      }
      
      private function closeCurrentFrame(param1:uint) : void
      {
         switch(param1)
         {
            case KeyStroke.VK_B.getCode():
               if(this.isProhibit_B && this.isProhibitNewHand_B && BagAndInfoManager.Instance.isShown)
               {
                  SoundManager.instance.play("003");
                  BagAndInfoManager.Instance.hideBagAndInfo();
               }
               break;
            case KeyStroke.VK_R.getCode():
               if(this.isProhibit_R && this.isProhibitNewHand_R && MailManager.Instance.isShow)
               {
                  SoundManager.instance.play("003");
                  MailManager.Instance.hide();
               }
               break;
            case KeyStroke.VK_H.getCode():
               if(this.isProhibit_H && SettingController.Instance.isShow)
               {
                  SoundManager.instance.play("003");
                  SettingController.Instance.hide();
               }
               break;
            case KeyStroke.VK_T.getCode():
               if(this.isProhibit_T && this.isProhibitNewHand_T && GotoPageController.Instance.isShow)
               {
                  SoundManager.instance.play("003");
                  GotoPageController.Instance.hide();
               }
               break;
            case KeyStroke.VK_Q.getCode():
               if(this.isProhibit_Q && TaskManager.isShow)
               {
                  SoundManager.instance.play("003");
                  TaskManager.switchVisible();
               }
               break;
            case KeyStroke.VK_S.getCode():
               if(this.isProhibit_S && this.isProhibitNewHand_S && CalendarManager.getInstance().isShow)
               {
                  SoundManager.instance.play("003");
                  CalendarManager.getInstance().close();
               }
               break;
            case KeyStroke.VK_Q.getCode():
               if(this.isProhibit_Q && TaskManager.isShow)
               {
                  SoundManager.instance.play("003");
                  TaskManager.switchVisible();
               }
			   break;
         }
      }
      
      private function getKeyboardShortcutsState() : void
      {
         var _loc1_:String = StateManager.currentStateType;
         switch(_loc1_)
         {
            case StateType.FIGHT_LIB_GAMEVIEW:
            case StateType.FIGHTING:
            case StateType.LODING_TRAINER:
            case StateType.LOGIN:
            case StateType.CHURCH_ROOM:
            case StateType.HOT_SPRING_ROOM:
               this.isProhibit_B = false;
               this.isProhibit_Q = false;
               this.isProhibit_F = false;
               this.isProhibit_H = false;
               this.isProhibit_T = false;
               this.isProhibit_R = false;
               this.isProhibit_S = false;
               this.isProhibit_G = true;
               this.isProhibit_P = false;
               break;
            case StateType.AUCTION:
            case StateType.SHOP:
               this.isProhibit_B = false;
               this.isProhibit_Q = true;
               this.isProhibit_F = true;
               this.isProhibit_H = true;
               this.isProhibit_T = true;
               this.isProhibit_R = true;
               this.isProhibit_S = true;
               this.isProhibit_G = true;
               this.isProhibit_P = true;
               break;
            case StateType.TRAINER:
               this.isProhibit_B = false;
               this.isProhibit_Q = false;
               this.isProhibit_F = false;
               this.isProhibit_H = true;
               this.isProhibit_T = false;
               this.isProhibit_R = false;
               this.isProhibit_S = false;
               this.isProhibit_G = false;
               this.isProhibit_P = false;
               break;
            default:
               this.isProhibit_B = true;
               this.isProhibit_Q = true;
               this.isProhibit_F = true;
               this.isProhibit_H = true;
               this.isProhibit_T = true;
               this.isProhibit_R = true;
               this.isProhibit_S = true;
               this.isProhibit_G = true;
               this.isProhibit_P = true;
			   break;
         }
      }
      
      public function forbiddenFull() : void
      {
         this.isFullForbid = true;
      }
      
      public function cancelForbidden() : void
      {
         this.isFullForbid = false;
      }
      
      public function forbiddenSection(param1:int, param2:Boolean) : void
      {
         this.isForbiddenSection = param2;
         switch(param1)
         {
            case GAME_PREPARE:
               this.isProhibit_B = false;
               this.isProhibit_Q = true;
               this.isProhibit_F = true;
               this.isProhibit_H = false;
               this.isProhibit_T = false;
               this.isProhibit_R = false;
               this.isProhibit_S = false;
               this.isProhibit_P = false;
               break;
            case GAME:
               this.isProhibit_B = false;
               this.isProhibit_Q = false;
               this.isProhibit_F = false;
               this.isProhibit_H = true;
               this.isProhibit_T = false;
               this.isProhibit_R = false;
               this.isProhibit_S = false;
               this.isProhibit_P = false;
               break;
            case GAME_WAIT:
               this.isProhibit_B = true;
               this.isProhibit_Q = true;
               this.isProhibit_F = true;
               this.isProhibit_H = true;
               this.isProhibit_T = true;
               this.isProhibit_R = true;
               this.isProhibit_S = true;
               this.isProhibit_P = true;
			   break;
         }
      }
      
      public function prohibitNewHandBag(param1:Boolean) : void
      {
         this.isProhibitNewHand_B = param1;
      }
      
      public function prohibitNewHandFriend(param1:Boolean) : void
      {
         this.isProhibitNewHand_F = param1;
      }
      
      public function prohibitNewHandChannel(param1:Boolean) : void
      {
         this.isProhibitNewHand_T = param1;
      }
      
      public function prohibitNewHandMail(param1:Boolean) : void
      {
         this.isProhibitNewHand_R = param1;
      }
      
      public function prohibitNewHandCalendar(param1:Boolean) : void
      {
         this.isProhibitNewHand_S = param1;
      }
      
      public function prohibitNewHandSeting(param1:Boolean) : void
      {
         this.isProhibitNewHand_H = param1;
      }
      
      public function prohibitNewHandPetsBag(param1:Boolean) : void
      {
         this.isProhibitNewHand_P = param1;
      }
   }
}
