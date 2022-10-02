package ddt.utils
{
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class HelpBtnEnable
   {
      
      private static var instance:HelpBtnEnable;
       
      
      private var _hasForbiddenDic:Dictionary;
      
      public function HelpBtnEnable(param1:inner)
      {
         this._hasForbiddenDic = new Dictionary();
         super();
      }
      
      public static function getInstance() : HelpBtnEnable
      {
         if(!instance)
         {
            instance = new HelpBtnEnable(new inner());
         }
         return instance;
      }
      
      public function showTipsByGrade(param1:int, param2:String, param3:Boolean = true) : Boolean
      {
         if(PlayerManager.Instance.Self.Grade < param1)
         {
            if(param3)
            {
               param2 = LanguageMgr.GetTranslation(param2,param1);
            }
            MessageTipManager.getInstance().show(param2);
            return false;
         }
         return true;
      }
      
      public function addMouseOverTips(param1:ITipedDisplay, param2:int, param3:String = "tips.open", param4:Boolean = true, param5:Boolean = true, param6:Boolean = true) : void
      {
         if(PlayerManager.Instance.Self.Grade < param2 && param6)
         {
            param5 && Helpers.grey(param1 as DisplayObject);
            this._hasForbiddenDic[param1.name] = true;
            if(param4)
            {
               param3 = LanguageMgr.GetTranslation(param3,param2);
            }
            param1.tipData = param3;
            param1.tipDirctions = "7,0";
            param1.tipStyle = "ddt.view.tips.OneLineTip";
            ShowTipManager.Instance.addTip(param1);
            (param1 as InteractiveObject).addEventListener(MouseEvent.CLICK,this.onClick,false,1);
            if(param1 is BaseButton)
            {
               (param1 as BaseButton).enable = false;
            }
            (param1 as InteractiveObject).mouseEnabled = true;
         }
         else
         {
            this.removeMouseOverTips(param1);
         }
      }
      
      public function removeMouseOverTips(param1:ITipedDisplay) : void
      {
         if(param1 == null)
         {
            return;
         }
         Helpers.colorful(param1 as DisplayObject);
         delete this._hasForbiddenDic[param1.name];
         ShowTipManager.Instance.removeTip(param1);
         (param1 as InteractiveObject).removeEventListener(MouseEvent.CLICK,this.onClick);
         if(param1 is BaseButton)
         {
            (param1 as BaseButton).enable = true;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      public function isForbidden(param1:ITipedDisplay) : Boolean
      {
         if(this._hasForbiddenDic[param1.name])
         {
            return true;
         }
         return false;
      }
   }
}

class inner
{
    
   
   function inner()
   {
      super();
   }
}
